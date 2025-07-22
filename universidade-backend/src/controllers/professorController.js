// src/controllers/professorController.js

// Importa a conexão com o banco de dados (o pool que criamos)
const pool = require('../config/db');

// Função para obter todos os professores
// O 'async' permite usar 'await' para esperar a resposta do banco de dados
const getAllProfessores = async (req, res) => {
  try {
    // Executa a query no banco de dados
    const [rows] = await pool.query('SELECT * FROM professores');
    // Retorna os resultados como JSON com status 200 (OK)
    res.status(200).json(rows);
  } catch (error) {
    // Em caso de erro, retorna uma mensagem de erro com status 500
    res.status(500).json({ message: 'Erro ao buscar professores', error: error.message });
  }
};

// Aqui você adicionaria outras funções: getProfessorById, createProfessor, etc.

// Exporta as funções para que possam ser usadas nas rotas
module.exports = {
  getAllProfessores,
};
