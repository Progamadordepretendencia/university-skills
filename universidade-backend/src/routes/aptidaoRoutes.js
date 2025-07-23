const express = require('express');
const router = express.Router();

const aptidaoController = require('../controllers/aptidaoController');

// Rotas existentes...
router.get('/professores/:professorId/aptidoes', aptidaoController.getAptidoesPorProfessor);
router.post('/professores/:professorId/aptidoes', aptidaoController.adicionarAptidao);
router.delete('/professores/:professorId/aptidoes/:disciplinaId', aptidaoController.removerAptidao);
router.get('/disciplinas/:disciplinaId/professores-aptos', aptidaoController.getProfessoresAptosPorDisciplina);


module.exports = router;
