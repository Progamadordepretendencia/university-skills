const pool = require('../config/db');

// Função para LISTAR todas as disciplinas que um professor está apto a ministrar
const getAptidoesPorProfessor = async (req, res) => {
    // Código existente...
    const { professorId } = req.params;
    try {
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
    // Código existente...
    const { professorId } = req.params;
    const { disciplina_id } = req.body;
    if (!disciplina_id) {
        return res.status(400).json({ message: 'O campo disciplina_id é obrigatório' });
    }
    try {
        await pool.query(
            'INSERT INTO professor_aptidao (professor_id, disciplina_id) VALUES (?, ?)',
            [professorId, disciplina_id]
        );
        res.status(201).json({ message: 'Aptidão registrada com sucesso' });
    } catch (error) {
        res.status(500).json({ message: 'Erro ao registrar aptidão', error: error.message });
    }
};

// Função para REMOVER uma aptidão
const removerAptidao = async (req, res) => {
    // Código existente...
    const { professorId, disciplinaId } = req.params;
    try {
        const [result] = await pool.query(
            'DELETE FROM professor_aptidao WHERE professor_id = ? AND disciplina_id = ?',
            [professorId, disciplinaId]
        );
        if (result.affectedRows === 0) {
            return res.status(404).json({ message: 'Aptidão não encontrada' });
        }
        res.status(200).json({ message: 'Aptidão removida com sucesso' });
    } catch (error) {
        res.status(500).json({ message: 'Erro ao remover aptidão', error: error.message });
    }
};

// --- NOVA FUNÇÃO ---
// Função para obter todos os professores aptos para uma determinada disciplina
const getProfessoresAptosPorDisciplina = async (req, res) => {
  const { disciplinaId } = req.params;

  try {
    // Esta query SQL faz um JOIN da tabela de professores com a tabela de aptidão
    // e filtra pelo ID da disciplina fornecido na URL.
    const [rows] = await pool.query(`
      SELECT p.id, p.nome, p.email, p.data_contratacao
      FROM professores p
      INNER JOIN professor_aptidao pa ON p.id = pa.professor_id
      WHERE pa.disciplina_id = ?
      ORDER BY p.nome
    `, [disciplinaId]);

    res.status(200).json(rows);
  } catch (error) {
    res.status(500).json({ message: 'Erro ao buscar professores aptos', error: error.message });
  }
};


module.exports = {
  getAptidoesPorProfessor,
  adicionarAptidao,
  removerAptidao,
  getProfessoresAptosPorDisciplina,
};
