// src/controllers/aptidaoController.js

const pool = require('../config/db');

// Função para LISTAR todas as disciplinas que um professor está apto a ministrar
const getAptidoesPorProfessor = async (req, res) => {
  // O ID do professor é pego da URL
  const { professorId } = req.params;

  try {
    // Esta query faz um JOIN para buscar os dados das disciplinas (nome, código)
    // a partir dos IDs armazenados na tabela de aptidão.
    const [rows] = await pool.query(`
      SELECT d.id, d.codigo_disciplina, d.nome, d.carga_horaria
      FROM disciplinas d
      INNER JOIN professor_aptidao pa ON d.id = pa.disciplina_id
      WHERE pa.professor_id = ?
    `, [professorId]);

    res.status(200).json(rows);
  } catch (error) {
    res.status(500).json({ message: 'Erro ao buscar aptidões do professor', error: error.message });
  }
};


// Função para ADICIONAR uma nova aptidão a um professor
const adicionarAptidao = async (req, res) => {
  const { professorId } = req.params;
  // O ID da disciplina vem do corpo da requisição
  const { disciplina_id } = req.body;

  if (!disciplina_id) {
    return res.status(400).json({ message: 'O campo disciplina_id é obrigatório' });
  }

  try {
    // Insere o par (professor_id, disciplina_id) na tabela de associação
    await pool.query(
      'INSERT INTO professor_aptidao (professor_id, disciplina_id) VALUES (?, ?)',
      [professorId, disciplina_id]
    );
    res.status(201).json({ message: 'Aptidão registrada com sucesso' });
  } catch (error) {
    // O erro mais comum aqui será de "Duplicate entry" se a aptidão já existir,
    // ou erro de "Foreign Key" se o professor ou a disciplina não existirem.
    // O banco de dados já nos protege desses casos.
    res.status(500).json({ message: 'Erro ao registrar aptidão', error: error.message });
  }
};

// Função para REMOVER uma aptidão
const removerAptidao = async (req, res) => {
  // Pegamos ambos os IDs da URL para identificar a relação exata a ser removida
  const { professorId, disciplinaId } = req.params;

  try {
    const [result] = await pool.query(
      'DELETE FROM professor_aptidao WHERE professor_id = ? AND disciplina_id = ?',
      [professorId, disciplinaId]
    );

    if (result.affectedRows === 0) {
      return res.status(404).json({ message: 'Aptidão não encontrada para este professor e disciplina' });
    }
    res.status(200).json({ message: 'Aptidão removida com sucesso' });
  } catch (error) {
    res.status(500).json({ message: 'Erro ao remover aptidão', error: error.message });
  }
};

module.exports = {
  getAptidoesPorProfessor,
  adicionarAptidao,
  removerAptidao,
};
