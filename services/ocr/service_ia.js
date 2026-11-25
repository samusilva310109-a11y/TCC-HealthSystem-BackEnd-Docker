/*******************************************************************************************
- Objetivo: Realizar a interpretação da receita médica utilizando IA no formato do cadastro
- Autor: Kayque Brenno Ferreira Almeida
- Data: 16/11/2026
- Versão: 2.6
********************************************************************************************/

const { GoogleGenAI } = require('@google/genai')

const ai = new GoogleGenAI({
    apiKey: process.env.GEMINI_API_KEY
})

const aguardar = (ms) => new Promise((resolve) => setTimeout(resolve, ms))

let cacheModelosDisponiveis = null
let promessaCarregamentoModelos = null

function isCotaDiariaEsgotada(erro) {
    const mensagem = JSON.stringify(erro || '')
    return mensagem.includes('PerDay') || mensagem.includes('GenerateRequestsPerDay')
}

function prioridadeVelocidadeModelo(nome) {
    if (nome.includes('flash-lite')) return 1
    if (nome.includes('flash')) return 2
    if (nome.includes('pro')) return 3
    return 4
}

async function obterModelosDisponiveis(aiClient) {
    if (cacheModelosDisponiveis && cacheModelosDisponiveis.length > 0) {
        return cacheModelosDisponiveis
    }

    if (promessaCarregamentoModelos) {
        return promessaCarregamentoModelos
    }

    const preferidos = [
        process.env.GEMINI_MODEL,
        process.env.GEMINI_FALLBACK_MODEL,
        'gemini-3.5-flash-lite',
        'gemini-3.5-flash'
    ].filter((m, idx, arr) => Boolean(m) && arr.indexOf(m) === idx)

    promessaCarregamentoModelos = (async () => {
        try {
            const pager = await aiClient.models.list()
            const encontrados = []

            for await (const modelo of pager) {
                const nomeLimpo = String(modelo.name || '').replace(/^models\//, '')
                const acoes = modelo.supportedActions || modelo.supportedGenerationMethods || []
                const suportaGeracao = acoes.length === 0 || acoes.includes('generateContent')
                const especializadoNaoTexto = /(embedding|imagen|veo|tts|aqa|lyria|robotics|computer-use|deep-research|image|audio)/i.test(nomeLimpo)

                if (nomeLimpo.startsWith('gemini-') && suportaGeracao && !especializadoNaoTexto) {
                    encontrados.push(nomeLimpo)
                }
            }

            const ordenados = [
                ...preferidos.filter((p) => encontrados.includes(p)),
                ...encontrados
                    .filter((n) => !preferidos.includes(n) && /(flash|pro)/i.test(n))
                    .sort((a, b) => {
                        const diffPrioridade = prioridadeVelocidadeModelo(a) - prioridadeVelocidadeModelo(b)
                        if (diffPrioridade !== 0) return diffPrioridade
                        return b.localeCompare(a)
                    })
            ]

            if (ordenados.length > 0) {
                cacheModelosDisponiveis = ordenados
                console.log('Modelos Gemini disponíveis nesta chave:', cacheModelosDisponiveis)
                return cacheModelosDisponiveis
            }
        } catch (erro) {
            console.warn('Falha ao listar modelos Gemini:', erro.message)
        } finally {
            promessaCarregamentoModelos = null
        }

        cacheModelosDisponiveis = preferidos
        return cacheModelosDisponiveis
    })()

    return promessaCarregamentoModelos
}

// Pré-carrega a lista ao subir o servidor para não atrasar a 1ª requisição de OCR
obterModelosDisponiveis(ai).catch(() => {})

async function gerarConteudoComFallback(aiClient, params) {
    const modelos = [...(await obterModelosDisponiveis(aiClient))]
    let ultimoErro = null

    for (const modeloAtual of modelos) {
        let configAtual = { ...params.config }

        for (let tentativa = 1; tentativa <= 2; tentativa++) {
            try {
                return await aiClient.models.generateContent({
                    ...params,
                    config: configAtual,
                    model: modeloAtual
                })
            } catch (erro) {
                ultimoErro = erro
                const status = erro?.status || erro?.error?.code

                if (status === 400 && configAtual.thinkingConfig) {
                    const { thinkingConfig, ...semThinking } = configAtual
                    configAtual = semThinking
                    continue
                }

                if (status === 404) {
                    console.warn(`Modelo ${modeloAtual} indisponível (HTTP 404). Removendo do cache e trocando...`)
                    if (Array.isArray(cacheModelosDisponiveis)) {
                        cacheModelosDisponiveis = cacheModelosDisponiveis.filter((m) => m !== modeloAtual)
                    }
                    break
                }

                if (status === 429 && isCotaDiariaEsgotada(erro)) {
                    console.warn(`Cota diária esgotada em ${modeloAtual} (HTTP 429). Trocando de modelo...`)
                    break
                }

                if ((status === 503 || status === 429) && tentativa < 2) {
                    const tempoEspera = 1500 + Math.floor(Math.random() * 500)
                    console.warn(`Gemini (${modeloAtual}) ocupado (HTTP ${status}). Nova tentativa em ${tempoEspera}ms...`)
                    await aguardar(tempoEspera)
                    continue
                }

                break
            }
        }
    }

    throw ultimoErro
}

const interpretarReceitaService = async function (imagem, catalogos) {
    try {
        if (!imagem || !imagem.buffer || !catalogos)
            return false

        const tiposDosagemResumo = catalogos.tipos_dosagem.map(({ id, tipo_dosagem }) => ({ id, tipo_dosagem }))
        const unidadesMedidaResumo = catalogos.unidades_medida.map(({ id, unidade_medida, sigla }) => ({ id, unidade_medida, sigla }))
        const tiposIntervaloResumo = catalogos.tipos_intervalo.map(({ id, tipo_intervalo }) => ({ id, tipo_intervalo }))

        const prompt = `
Você é responsável por interpretar receitas médicas (impressas ou manuscritas) para o aplicativo MedTime,
utilizado também por pessoas idosas.

Sua tarefa é analisar a imagem da receita, identificar os medicamentos, extrair as informações prescritas
e montar cada item exatamente na estrutura JSON de cadastro do sistema, relacionando os IDs dos catálogos fornecidos.

REGRAS ESPECÍFICAS PARA RECEITAS MANUSCRITAS:
- Analise cuidadosamente a caligrafia médica, considerando abreviações clínicas comuns no Brasil:
  - Vias: "VO" (via oral), "SL" (sublingual), "IM", "EV", "tópico".
  - Formas: "cp" / "comp" (comprimido), "caps" (cápsula), "gts" (gotas), "fr" (frasco), "cx" (caixa), "amp" (ampola), "env" (envelope).
  - Posologia: "8/8h" (frequencia = 8, intervalo = hora), "12/12h" (12 horas), "6/6h" (6 horas), "1x/dia" ou "1x ao dia" (1 dia), "2x/dia" (12 horas), "3x/dia" (8 horas).
- Se uma palavra manuscrita estiver borrada, ilegível ou ambígua (ex.: dúvida entre dois medicamentos diferentes), NÃO adivinhe: retorne null no campo correspondente.

REGRAS OBRIGATÓRIAS:
1. Extraia somente informações relacionadas aos medicamentos.
2. Nunca invente medicamentos, concentrações, doses, frequências ou durações.
3. Se uma informação não puder ser identificada com segurança, retorne null no campo correspondente.
4. Utilize exclusivamente os IDs existentes nos catálogos fornecidos. Nunca invente IDs.
5. Em "medicamento":
   - "nome": nome do princípio ativo ou comercial (ou null).
   - "imagem": sempre null.
   - "concentracao": valor numérico da concentração (ex.: "500 mg" -> 500).
   - "id_unidade_medida_embalagem": ID correspondente à unidade da concentração (ex.: "mg").
   - "id_tipo_dosagem": ID correspondente à forma farmacêutica (ex.: Comprimido, Gotas, Cápsula).
6. Em "estoque":
   - "quantidade_em_estoque": sempre null (será informado pelo usuário no aplicativo).
7. Em "receita_medica":
   - "dosagem": quantidade tomada por vez (não confunda com concentração; ex.: "Amoxicilina 500 mg, tomar 1 comprimido" -> concentracao = 500, dosagem = 1). Se informar "1 a 2 comprimidos", retorne null.
   - "id_unidade_medida": ID correspondente à unidade da dose administrada (comprimido/cápsula -> ID de "un", mL -> ID de "ml", gotas -> ID de "gt").
   - "descricao": orientações complementares (via, duração como "por 7 dias", condições de uso) ou null se não houver.
8. Em "programacao_medicamento":
   - "frequencia": intervalo numérico entre doses.
   - "id_tipo_intervalo": ID correspondente ao intervalo (ex.: hora, dia). Expressões vagas como "pela manhã", "à noite" ou "se necessário" sem intervalo exato devem retornar null em frequencia e id_tipo_intervalo.
   - "data_hora_inicio": sempre null (será escolhido pelo usuário no aplicativo).
9. Ignore dados administrativos (paciente, endereço, CRM, hospital, data).
10. A segurança do paciente tem prioridade sobre o preenchimento automático. Em caso de dúvida, retorne null.

CATÁLOGOS DISPONÍVEIS NO MEDTIME:
Tipos de dosagem: ${JSON.stringify(tiposDosagemResumo)}
Unidades de medida: ${JSON.stringify(unidadesMedidaResumo)}
Tipos de intervalo: ${JSON.stringify(tiposIntervaloResumo)}
`

        const resposta = await gerarConteudoComFallback(ai, {
            contents: [
                {
                    inlineData: {
                        data: imagem.buffer.toString('base64'),
                        mimeType: imagem.mimetype
                    }
                },
                prompt
            ],
            config: {
                temperature: 0.1,
                maxOutputTokens: 1024,
                thinkingConfig: {
                    thinkingLevel: 'MINIMAL'
                },
                responseMimeType: 'application/json',
                responseSchema: {
                    type: 'object',
                    properties: {
                        medicamentos: {
                            type: 'array',
                            items: {
                                type: 'object',
                                properties: {
                                    medicamento: {
                                        type: 'object',
                                        properties: {
                                            nome: { type: 'string', nullable: true },
                                            imagem: { type: 'string', nullable: true },
                                            concentracao: { type: 'number', nullable: true },
                                            id_unidade_medida_embalagem: { type: 'integer', nullable: true },
                                            id_tipo_dosagem: { type: 'integer', nullable: true }
                                        },
                                        required: [
                                            'nome',
                                            'imagem',
                                            'concentracao',
                                            'id_unidade_medida_embalagem',
                                            'id_tipo_dosagem'
                                        ]
                                    },
                                    estoque: {
                                        type: 'object',
                                        properties: {
                                            quantidade_em_estoque: { type: 'integer', nullable: true }
                                        },
                                        required: ['quantidade_em_estoque']
                                    },
                                    receita_medica: {
                                        type: 'object',
                                        properties: {
                                            dosagem: { type: 'number', nullable: true },
                                            id_unidade_medida: { type: 'integer', nullable: true },
                                            descricao: { type: 'string', nullable: true }
                                        },
                                        required: [
                                            'dosagem',
                                            'id_unidade_medida',
                                            'descricao'
                                        ]
                                    },
                                    programacao_medicamento: {
                                        type: 'object',
                                        properties: {
                                            frequencia: { type: 'number', nullable: true },
                                            id_tipo_intervalo: { type: 'integer', nullable: true },
                                            data_hora_inicio: { type: 'string', nullable: true }
                                        },
                                        required: [
                                            'frequencia',
                                            'id_tipo_intervalo',
                                            'data_hora_inicio'
                                        ]
                                    }
                                },
                                required: [
                                    'medicamento',
                                    'estoque',
                                    'receita_medica',
                                    'programacao_medicamento'
                                ]
                            }
                        }
                    },
                    required: ['medicamentos']
                }
            }
        })

        if (!resposta || !resposta.text)
            return false

        const medicamentos = JSON.parse(resposta.text)

        if (medicamentos && Array.isArray(medicamentos.medicamentos))
            return medicamentos
        else
            return false

    } catch (error) {
        console.log('Erro no interpretarReceitaService:', error)
        return false
    }
}

module.exports = {
    interpretarReceitaService
}