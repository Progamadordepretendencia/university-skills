// src/routes/turmasRoutes.js

const express = require('express');
const router = express.Router();

const turmaController = require('../controllers/turmaController');

// Rotas para o CRUD de Turmas
router.get('/turmas', turmaController.getAllTurmas);
router.get('/turmas/:id', turmaController.getTurmaById);
router.post('/turmas', turmaController.createTurma);
router.put('/turmas/:id', turmaController.updateTurma);
router.delete('/turmas/:id', turmaController.deleteTurma);

module.exports = router;
