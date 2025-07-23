// src/routes/professoresRoutes.js

const express = require('express');
const router = express.Router();

// Importa o controlador de professores atualizado
const professorController = require('../controllers/professorController');

// Mapeia cada endpoint HTTP para a função correspondente no controlador

// Rota para listar TODOS os professores
router.get('/', professorController.getAllProfessores);

// Rota para buscar UM professor pelo ID
// O ':id' na URL se torna um parâmetro acessível em req.params.id
router.get('/:id', professorController.getProfessorById);

// Rota para CRIAR um novo professor
router.post('/', professorController.createProfessor);

// Rota para ATUALIZAR um professor pelo ID
router.put('/:id', professorController.updateProfessor);

// Rota para DELETAR um professor pelo ID
router.delete('/:id', professorController.deleteProfessor);


module.exports = router;
