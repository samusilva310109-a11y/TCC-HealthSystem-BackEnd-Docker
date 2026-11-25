/************************************************
    Objetivo: Arquivo responsável pela ROTA
    data: 16/11/2026
    Autor: Kayque Brenno Ferreira Almeida
    Versão: 1.1
*************************************************/

const express = require('express')
const multer = require('multer')

const router = express.Router()

const controllerOCR = require('../controllers/ocr/controller_ocr.js')

const verificarToken = require('../middleware/auth.js')
const authorization = require('../middleware/authorization.js')

const upload = multer({
    storage: multer.memoryStorage(),
    limits: {
        fileSize: 10 * 1024 * 1024
    }
})

//                          ENDPOINTS OCR
router.post('/:idUsuario', verificarToken.verificarToken,
    authorization.verficarPermissao('CADASTRAR_MEDICAMENTOS'),
    authorization.verificarRelacao(), upload.single('receita'),
    async function (request, response) {

        let idUsuario = request.idPacienteAutorizado
        let imagem = request.file

        let result = await controllerOCR.processarReceitaMedica(imagem)

        response.status(result.status_code)
        response.json(result)
    }
)

router.post('/:idUsuario/cadastrar', verificarToken.verificarToken,
    authorization.verficarPermissao('CADASTRAR_MEDICAMENTOS'),
    authorization.verificarRelacao(),
    async function (request, response) {

        let idUsuario = request.idPacienteAutorizado
        let contentType = request.headers['content-type']
        let medicamentos = request.body?.medicamentos

        let result = await controllerOCR.cadastrarMedicamentosOcr(
            idUsuario,
            medicamentos,
            contentType
        )

        response.status(result.status_code)
        response.json(result)
    }
)

module.exports = router