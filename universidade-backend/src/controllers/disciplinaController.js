const pool = require('../config/db');

// Listar todas as disciplinas
const getAllDisciplinas = async (req, res) => {
  try {
    const [rows] = await pool.query('SELECT * FROM disciplinas');
    res.status(200).json(rows);
  } catch (error) {
    res.status(500).json({ message: 'Erro ao buscar disciplinas', error: error.message });
  }
};

// Obter uma disciplina por ID
const getDisciplinaById = async (req, res) => {
  const { id } = req.params;
  try {
    const [rows] = await pool.query('SELECT * FROM disciplinas WHERE id = ?', [id]);
    if (rows.length === 0) {
      return res.status(404).json({ message: 'Disciplina não encontrada' });
    }
    res.status(200).json(rows[0]);
  } catch (error) {
    res.status(500).json({ message: 'Erro ao buscar disciplina', error: error.message });
  }
};

// Criar uma nova disciplina
const createDisciplina = async (req, res) => {
  const { codigo_disciplina, nome, carga_horaria } = req.body;

  if (!codigo_disciplina || !nome || !carga_horaria) {
    return res.status(400).json({ message: 'Todos os campos (codigo_disciplina, nome, carga_horaria) são obrigatórios' });
  }

  try {
    const [result] = await pool.query(
      'INSERT INTO disciplinas (codigo_disciplina, nome, carga_horaria) VALUES (?, ?, ?)',
      [codigo_disciplina, nome, carga_horaria]
    );
    res.status(201).json({
      message: 'Disciplina criada com sucesso',
      id: result.insertId,
    });
  } catch (error) {
    res.status(500).json({ message: 'Erro ao criar disciplina', error: error.message });
  }
};

// Atualizar uma disciplina
const updateDisciplina = async (req, res) => {
  const { id } = req.params;
  const { codigo_disciplina, nome, carga_horaria } = req.body;

  if (!codigo_disciplina || !nome || !carga_horaria) {
    return res.status(400).json({ message: 'Todos os campos são obrigatórios' });
  }

  try {
    const [result] = await pool.query(
      'UPDATE disciplinas SET codigo_disciplina = ?, nome = ?, carga_horaria = ? WHERE id = ?',
      [codigo_disciplina, nome, carga_horaria, id]
    );

    if (result.affectedRows === 0) {
      return res.status(404).json({ message: 'Disciplina não encontrada' });
    }
    res.status(200).json({ message: 'Disciplina atualizada com sucesso' });
  } catch (error) {
    res.status(500).json({ message: 'Erro ao atualizar disciplina', error: error.message });
  }
};

// Deletar uma disciplina
const deleteDisciplina = async (req, res) => {
  const { id } = req.params;
  try {
    const [result] = await pool.query('DELETE FROM disciplinas WHERE id = ?', [id]);
    if (result.affectedRows === 0) {
      return res.status(404).json({ message: 'Disciplina não encontrada' });
    }
    res.status(200).json({ message: 'Disciplina deletada com sucesso' });
  } catch (error) {
    res.status(500).json({ message: 'Erro ao deletar disciplina', error: error.message });
  }
};

module.exports = {
  getAllDisciplinas,
  getDisciplinaById,
  createDisciplina,
  updateDisciplina,
  deleteDisciplina,
};
