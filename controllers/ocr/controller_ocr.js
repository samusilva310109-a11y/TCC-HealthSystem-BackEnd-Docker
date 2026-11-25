/*************************************************************************************************************************
- Objetivo: Controller responsável pela regra de negócio do OCR e integração com o cadastro de medicamentos
- Autor: Kayque Brenno Ferreira Almeida
- Data: 16/11/2026
- Versão: 2.2
**************************************************************************************************************************/

const configMessages = require('../../utils/messages/configMessages.js')
const iaService = require('../../services/ocr/service_ia.js')

const tipoDosagemService = require('../../services/tipo_dosagem/service_tipo_dosagem.js')
const unidadeMedidaService = require('../../services/unidade_medida/service_unidade_medida.js')
const tipoIntervaloService = require('../../services/tipo_intervalo/service_tipo_intervalo.js')

const cadastroMedicamentoController = require('../cadastro_medicamento_usuario/controller_cadastro_medicamento_usuario.js')

const CACHE_TTL_MS = 10 * 60 * 1000
let cacheCatalogos = null
let cacheExpiraEm = 0

const obterCatalogosEmCache = async function () {
    const agora = Date.now()
    if (cacheCatalogos && agora < cacheExpiraEm) {
        return cacheCatalogos
    }

    const [resultadoTipoDosagem, resultadoUnidadeMedida, resultadoTipoIntervalo] = await Promise.all([
        tipoDosagemService.listarTipoDosagemService(),
        unidadeMedidaService.listarUnidadeMedidaService(),
        tipoIntervaloService.listarTipoIntervaloService()
    ])

    if (!resultadoTipoDosagem.status ||
        !resultadoUnidadeMedida.status ||
        !resultadoTipoIntervalo.status) {
        return null
    }

    const tiposDosagem = resultadoTipoDosagem.response.tipo_dosagem
    const unidadesMedida = resultadoUnidadeMedida.response.unidade_medida
    const tiposIntervalo = resultadoTipoIntervalo.response.tipoIntervalo

    if (!Array.isArray(tiposDosagem) ||
        !Array.isArray(unidadesMedida) ||
        !Array.isArray(tiposIntervalo)) {
        return null
    }

    cacheCatalogos = {
        tipos_dosagem: tiposDosagem,
        unidades_medida: unidadesMedida,
        tipos_intervalo: tiposIntervalo
    }
    cacheExpiraEm = agora + CACHE_TTL_MS

    return cacheCatalogos
}

const validarIdCatalogo = function (id, registros) {
    if (!Array.isArray(registros) || id == null)
        return null

    for (let registro of registros) {
        if (Number(registro.id) == Number(id))
            return Number(registro.id)
    }

    return null
}

const processarReceitaMedica = async function (imagem) {
    let customMessages = JSON.parse(JSON.stringify(configMessages))

    try {
        if (!imagem || !imagem.buffer) {
            customMessages.ERROR_BAD_REQUEST.field = ['IMAGEM']
            return customMessages.ERROR_BAD_REQUEST
        }

        const tiposPermitidos = ['image/jpeg', 'image/png', 'image/webp']
        if (!tiposPermitidos.includes(imagem.mimetype)) {
            customMessages.ERROR_BAD_REQUEST.field = ['TIPO_IMAGEM']
            return customMessages.ERROR_BAD_REQUEST
        }

        const catalogos = await obterCatalogosEmCache()
        if (!catalogos)
            return customMessages.ERROR_INTERNAL_SERVER_CONTROLLER

        const dadosReceita = await iaService.interpretarReceitaService(
            imagem,
            catalogos
        )

        if (!dadosReceita || !Array.isArray(dadosReceita.medicamentos))
            return customMessages.ERROR_INTERNAL_SERVER_CONTROLLER

        const medicamentos = []

        for (let dados of dadosReceita.medicamentos) {
            let med = dados.medicamento || {}
            let rec = dados.receita_medica || {}
            let prog = dados.programacao_medicamento || {}

            let idTipoDosagem = validarIdCatalogo(med.id_tipo_dosagem, catalogos.tipos_dosagem)
            let idUnidadeEmbalagem = validarIdCatalogo(med.id_unidade_medida_embalagem, catalogos.unidades_medida)
            let idUnidadeDosagem = validarIdCatalogo(rec.id_unidade_medida, catalogos.unidades_medida)
            let idTipoIntervalo = validarIdCatalogo(prog.id_tipo_intervalo, catalogos.tipos_intervalo)

            let itemCadastro = {
                medicamento: {
                    nome: med.nome ?? null,
                    imagem: null,
                    concentracao: med.concentracao ?? null,
                    id_unidade_medida_embalagem: idUnidadeEmbalagem,
                    id_tipo_dosagem: idTipoDosagem
                },
                estoque: {
                    quantidade_em_estoque: null
                },
                receita_medica: {
                    dosagem: rec.dosagem ?? null,
                    id_unidade_medida: idUnidadeDosagem,
                    descricao: rec.descricao ?? null
                },
                programacao_medicamento: {
                    frequencia: prog.frequencia ?? null,
                    id_tipo_intervalo: idTipoIntervalo,
                    data_hora_inicio: null
                }
            }

            medicamentos.push(itemCadastro)
        }

        customMessages.DEFAULT_MESSAGE.status = true
        customMessages.DEFAULT_MESSAGE.status_code = 200
        customMessages.DEFAULT_MESSAGE.message = 'Receita médica processada com sucesso.'
        customMessages.DEFAULT_MESSAGE.response = {
            medicamentos: medicamentos
        }

        return customMessages.DEFAULT_MESSAGE

    } catch (error) {
        console.log(error)
        return customMessages.ERROR_INTERNAL_SERVER_CONTROLLER
    }
}

const cadastrarMedicamentosOcr = async function (idUsuario, listaMedicamentos, contentType = 'application/json') {
    let customMessages = JSON.parse(JSON.stringify(configMessages))

    try {
        if (!idUsuario || isNaN(idUsuario)) {
            customMessages.ERROR_BAD_REQUEST.field = ['ID_USUARIO']
            return customMessages.ERROR_BAD_REQUEST
        }

        if (!Array.isArray(listaMedicamentos) || listaMedicamentos.length === 0) {
            customMessages.ERROR_BAD_REQUEST.field = ['MEDICAMENTOS']
            return customMessages.ERROR_BAD_REQUEST
        }

        let medicamentosCadastrados = []

        for (let dadosMedicamento of listaMedicamentos) {
            let resultadoCadastro = await cadastroMedicamentoController.cadastrarMedicamentoUsuario(
                Number(idUsuario),
                dadosMedicamento,
                contentType
            )

            if (!resultadoCadastro || !resultadoCadastro.status) {
                return resultadoCadastro || customMessages.ERROR_INTERNAL_SERVER_CONTROLLER
            }

            medicamentosCadastrados.push(resultadoCadastro.response)
        }

        customMessages.DEFAULT_MESSAGE.status = customMessages.SUCCESS_CREATED_ITEM.status
        customMessages.DEFAULT_MESSAGE.status_code = customMessages.SUCCESS_CREATED_ITEM.status_code
        customMessages.DEFAULT_MESSAGE.message = customMessages.SUCCESS_CREATED_ITEM.message
        customMessages.DEFAULT_MESSAGE.response = {
            medicamentos: medicamentosCadastrados
        }

        return customMessages.DEFAULT_MESSAGE

    } catch (error) {
        console.log(error)
        return customMessages.ERROR_INTERNAL_SERVER_CONTROLLER
    }
}

module.exports = {
    processarReceitaMedica,
    cadastrarMedicamentosOcr
}