// src/controllers/professorController.js

const pool = require('../config/db');

// Função para obter todos os professores (Já existente)
const getAllProfessores = async (req, res) => {
  try {
    const [rows] = await pool.query('SELECT * FROM professores');
    res.status(200).json(rows);
  } catch (error) {
    res.status(500).json({ message: 'Erro ao buscar professores', error: error.message });
  }
};

// --- NOVAS FUNÇÕES ---

// 1. Função para obter UM professor pelo seu ID
const getProfessorById = async (req, res) => {
  // O ID é pego dos parâmetros da URL (ex: /api/professores/1)
  const { id } = req.params;
  try {
    // Query que busca o professor com o ID correspondente
    // O '?' é um placeholder para prevenir SQL Injection. O valor de 'id' é passado em um array.
    const [rows] = await pool.query('SELECT * FROM professores WHERE id = ?', [id]);

    // Verifica se algum professor foi encontrado
    if (rows.length === 0) {
      // Se o array de resultado estiver vazio, retorna erro 404 (Não Encontrado)
      return res.status(404).json({ message: 'Professor não encontrado' });
    }
    // Se encontrou, retorna o professor encontrado
    res.status(200).json(rows[0]);
  } catch (error) {
    res.status(500).json({ message: 'Erro ao buscar professor', error: error.message });
  }
};

// 2. Função para CRIAR um novo professor
const createProfessor = async (req, res) => {
  // Os dados do novo professor são pegos do corpo (body) da requisição
  const { nome, email, data_contratacao } = req.body;

  // Validação simples para garantir que os campos necessários foram enviados
  if (!nome || !email || !data_contratacao) {
    return res.status(400).json({ message: 'Todos os campos (nome, email, data_contratacao) são obrigatórios' });
  }

  try {
    // Query para inserir os novos dados na tabela
    const [result] = await pool.query(
      'INSERT INTO professores (nome, email, data_contratacao) VALUES (?, ?, ?)',
      [nome, email, data_contratacao]
    );

    // Se a inserção for bem-sucedida, retorna o status 201 (Criado)
    // e um JSON com uma mensagem de sucesso e o ID do novo professor
    res.status(201).json({
      message: 'Professor criado com sucesso',
      id: result.insertId, // 'insertId' é o ID gerado pelo banco de dados
    });
  } catch (error) {
    // Erro comum aqui é violação de chave única (email duplicado)
    res.status(500).json({ message: 'Erro ao criar professor', error: error.message });
  }
};

// 3. Função para ATUALIZAR um professor existente
const updateProfessor = async (req, res) => {
  const { id } = req.params;
  const { nome, email, data_contratacao } = req.body;

  if (!nome || !email || !data_contratacao) {
    return res.status(400).json({ message: 'Todos os campos (nome, email, data_contratacao) são obrigatórios' });
  }

  try {
    // Query para atualizar o registro com o ID correspondente
    const [result] = await pool.query(
      'UPDATE professores SET nome = ?, email = ?, data_contratacao = ? WHERE id = ?',
      [nome, email, data_contratacao, id]
    );

    // O resultado de um UPDATE contém a propriedade 'affectedRows'
    if (result.affectedRows === 0) {
      // Se nenhuma linha foi afetada, significa que o professor com aquele ID não existe
      return res.status(404).json({ message: 'Professor não encontrado' });
    }

    res.status(200).json({ message: 'Professor atualizado com sucesso' });
  } catch (error) {
    res.status(500).json({ message: 'Erro ao atualizar professor', error: error.message });
  }
};

// 4. Função para DELETAR um professor
const deleteProfessor = async (req, res) => {
  const { id } = req.params;

  try {
    // Query para deletar o registro com o ID correspondente
    const [result] = await pool.query('DELETE FROM professores WHERE id = ?', [id]);

    if (result.affectedRows === 0) {
      return res.status(404).json({ message: 'Professor não encontrado' });
    }

    res.status(200).json({ message: 'Professor deletado com sucesso' });
  } catch (error) {
    res.status(500).json({ message: 'Erro ao deletar professor', error: error.message });
  }
};


// Exporta todas as funções para serem usadas nas rotas
module.exports = {
  getAllProfessores,
  getProfessorById,
  createProfessor,
  updateProfessor,
  deleteProfessor,
};
