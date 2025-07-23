// src/routes/aptidaoRoutes.js

const express = require('express');
const router = express.Router();

const aptidaoController = require('../controllers/aptidaoController');

// Rota para listar todas as aptidões de um professor específico
// Ex: GET /api/professores/1/aptidoes
router.get('/professores/:professorId/aptidoes', aptidaoController.getAptidoesPorProfessor);

// Rota para adicionar uma nova aptidão a um professor
// Ex: POST /api/professores/1/aptidoes
router.post('/professores/:professorId/aptidoes', aptidaoController.adicionarAptidao);

// Rota para remover uma aptidão específica
// Ex: DELETE /api/professores/1/aptidoes/3
router.delete('/professores/:professorId/aptidoes/:disciplinaId', aptidaoController.removerAptidao);


module.exports = router;
