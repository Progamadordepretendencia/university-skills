const pool = require('../config/db');

const getAllTurmas = async (req, res) => {
  try {
    const [rows] = await pool.query(`
      SELECT
        t.id, t.ano, t.semestre, t.numero_alunos, t.carga_horaria_efetiva,
        p.nome AS professor_nome,
        d.nome AS disciplina_nome,
        d.codigo_disciplina
      FROM turmas_ministradas t
      LEFT JOIN professores p ON t.professor_id = p.id
      JOIN disciplinas d ON t.disciplina_id = d.id
      ORDER BY t.ano DESC, t.semestre DESC
    `);
    // Usamos LEFT JOIN para professores porque o professor_id pode ser NULL

    res.status(200).json(rows);
  } catch (error) {
    res.status(500).json({ message: 'Erro ao buscar turmas', error: error.message });
  }
};

// Função para obter UMA turma pelo seu ID
const getTurmaById = async (req, res) => {
  const { id } = req.params;
  try {
    const [rows] = await pool.query(`
      SELECT
        t.*,
        p.nome AS professor_nome,
        d.nome AS disciplina_nome
      FROM turmas_ministradas t
      LEFT JOIN professores p ON t.professor_id = p.id
      JOIN disciplinas d ON t.disciplina_id = d.id
      WHERE t.id = ?
    `, [id]);

    if (rows.length === 0) {
      return res.status(404).json({ message: 'Turma não encontrada' });
    }
    res.status(200).json(rows[0]);
  } catch (error) {
    res.status(500).json({ message: 'Erro ao buscar turma', error: error.message });
  }
};

// Função para CRIAR um novo registro de turma ministrada
const createTurma = async (req, res) => {
  const { professor_id, disciplina_id, ano, semestre, numero_alunos, carga_horaria_efetiva } = req.body;

  // Validação
  if (!disciplina_id || !ano || !semestre || !numero_alunos || !carga_horaria_efetiva) {
    return res.status(400).json({ message: 'Campos obrigatórios faltando' });
  }

  try {
    const [result] = await pool.query(
      'INSERT INTO turmas_ministradas (professor_id, disciplina_id, ano, semestre, numero_alunos, carga_horaria_efetiva) VALUES (?, ?, ?, ?, ?, ?)',
      [professor_id, disciplina_id, ano, semestre, numero_alunos, carga_horaria_efetiva]
    );
    res.status(201).json({
      message: 'Turma registrada com sucesso',
      id: result.insertId,
    });
  } catch (error) {
    res.status(500).json({ message: 'Erro ao registrar turma', error: error.message });
  }
};

// Função para ATUALIZAR um registro de turma
const updateTurma = async (req, res) => {
  const { id } = req.params;
  const { professor_id, disciplina_id, ano, semestre, numero_alunos, carga_horaria_efetiva } = req.body;

  if (!disciplina_id || !ano || !semestre || !numero_alunos || !carga_horaria_efetiva) {
    return res.status(400).json({ message: 'Campos obrigatórios faltando' });
  }

  try {
    const [result] = await pool.query(
      'UPDATE turmas_ministradas SET professor_id = ?, disciplina_id = ?, ano = ?, semestre = ?, numero_alunos = ?, carga_horaria_efetiva = ? WHERE id = ?',
      [professor_id, disciplina_id, ano, semestre, numero_alunos, carga_horaria_efetiva, id]
    );

    if (result.affectedRows === 0) {
      return res.status(404).json({ message: 'Turma não encontrada' });
    }
    res.status(200).json({ message: 'Registro de turma atualizado com sucesso' });
  } catch (error) {
    res.status(500).json({ message: 'Erro ao atualizar turma', error: error.message });
  }
};

// Função para DELETAR um registro de turma
const deleteTurma = async (req, res) => {
  const { id } = req.params;
  try {
    const [result] = await pool.query('DELETE FROM turmas_ministradas WHERE id = ?', [id]);
    if (result.affectedRows === 0) {
      return res.status(404).json({ message: 'Turma não encontrada' });
    }
    res.status(200).json({ message: 'Registro de turma deletado com sucesso' });
  } catch (error) {
    res.status(500).json({ message: 'Erro ao deletar turma', error: error.message });
  }
};

module.exports = {
  getAllTurmas,
  getTurmaById,
  createTurma,
  updateTurma,
  deleteTurma,
};
