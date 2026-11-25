/*******************************************************************************************
 * Objetivo: Arquivo responsável pelo CRUD de dados do MEDICAMENTO no banco de dados
 *          MySQL
 * Data: 06/10/2026
 * Autor: Kayque Brenno Ferreira Almeida
 * Versão: 1.0
********************************************************************************************/

const knexConection = require('../../global_knex/global_knex')

const insertMedicamento = async function (medicamentos, transaction = null) {
    try {
        let connection = transaction || knexConection

        let sql = `call procMedicamento(?, ?, ?, ?, ?, ?, ?, ?)`

        let result = await connection.raw(sql, [
            'INSERT',
            medicamentos.nome,
            medicamentos.imagem,
            medicamentos.concentracao,
            medicamentos.id_unidade_medida_embalagem,
            medicamentos.id_tipo_dosagem,
            medicamentos.id_usuario,
            null
        ])

        if (result && result[0][0][0].id)
            return result[0][0][0].id
        else
            return false

    } catch (error) {
        console.error('ERRO AO INSERIR MEDICAMENTO NO MODEL:', error)
        return false
    }

}

const updateMedicamento = async function (medicamentos, transaction = null) {
    try {
        let connection = transaction || knexConection

        let sql = `call procMedicamento(?, ?, ?, ?, ?, ?, ?, ?)`

        let result = await connection.raw(sql, [
            'UPDATE',
            medicamentos.nome,
            medicamentos.imagem,
            medicamentos.concentracao,
            medicamentos.id_unidade_medida_embalagem,
            medicamentos.id_tipo_dosagem,
            medicamentos.id_usuario,
            medicamentos.id
        ])

        if (result && result[0][0][0].affectedRows > 0)
            return true
        else
            return false
    } catch (error) {
        console.log('ERRO NA DAO UPDATE MEDICAMENTO:', error)
        return false
    }
}

const selectAllMedicamentos = async function (idUsuario, transaction = null) {
    try {
        let connection = transaction || knexConection

        let sql = `call procMedicamento(?, ?, ?, ?, ?, ?, ?, ?)`

        let result = await connection.raw(sql, [
            'SELECT_ALL',
            null,
            null,
            null,
            null,
            null,
            idUsuario,
            null
        ])

        if (Array.isArray(result[0][0]))
            return result[0][0]
        else
            return false
    } catch (error) {
        return false
    }
}

const selectByIdMedicamento = async function (id, idUsuario, transaction = null) {
    try {
        let connection = transaction || knexConection

        let sql = `call procMedicamento(?, ?, ?, ?, ?, ?, ?, ?)`

        let result = await connection.raw(sql, [
            'SELECT_BY_ID',
            null,
            null,
            null,
            null,
            null,
            idUsuario,
            id
        ])

        if (Array.isArray(result[0][0]))
            return result[0][0]
        else
            return false
    } catch (error) {
        console.log('ERRO NA DAO SELECT ID MEDICAMENTO:', error)
        return false
    }
}

const deleteMedicamento = async function (id, idUsuario, transaction = null) {
    try {
        let connection = transaction || knexConection

        let sql = `call procMedicamento(?, ?, ?, ?, ?, ?, ?, ?)`

        let result = await connection.raw(sql, [
            'DELETE',
            null,
            null,
            null,
            null,
            null,
            idUsuario,
            id
        ])

        if (result && result[0][0][0].affectedRows > 0)
            return true
        else
            return false
    } catch (error) {
        return false
    }
}

module.exports = {
    insertMedicamento,
    updateMedicamento,
    selectAllMedicamentos,
    selectByIdMedicamento,
    deleteMedicamento
}