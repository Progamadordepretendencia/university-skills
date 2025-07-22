// src/routes/professoresRoutes.js

const express = require('express');
const router = express.Router();

// Importa o controlador de professores
const professorController = require('../controllers/professorController');

// Define a rota GET para a raiz ('/').
// Quando alguém acessar GET /api/professores/, esta rota será acionada.
router.get('/', professorController.getAllProfessores);

// Aqui você adicionaria outras rotas: router.post('/', ...), router.put('/:id', ...)

module.exports = router;
