/*************************************************************************************
 * Objetivo: Arquivo responsável por validar os dados recebidos
 * Data: 07/10/2026
 * Autor: Kayque Brenno Ferreira Almeida
 * Versão: 1.0
**************************************************************************************/

const JOI = require('joi')

const receitaMedicaSchema = JOI.object({
    id_usuario: JOI.number()
                .integer()
                .min(1)
                .required(),

    id_medicamento: JOI.number()
                    .integer()
                    .min(1)
                    .required(),

    dosagem: JOI.number()
                .greater(0)
                .max(999.99)
                .precision(2)
                .required(),

    id_unidade_medida: JOI.number()
                        .integer()
                        .min(1)
                        .required(),
    
    id_estoque: JOI.number()
                .integer()
                .min(1)
                .required(),

    descricao: JOI.string()
                .allow('', null)
                .optional()
})

module.exports = receitaMedicaSchema