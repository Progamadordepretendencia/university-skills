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
  const { nome, email, data_contratacao } = req.body;

  if (!nome || !email || !data_contratacao) {
    return res.status(400).json({ message: 'Todos os campos (nome, email, data_contratacao) são obrigatórios' });
  }

  try {
    // Primeiro, insere o novo professor
    const [result] = await pool.query(
      'INSERT INTO professores (nome, email, data_contratacao) VALUES (?, ?, ?)',
      [nome, email, data_contratacao]
    );

    const insertId = result.insertId;

    // Agora, busca o professor que acabamos de criar para retorná-lo por completo
    const [newProfessorRows] = await pool.query('SELECT * FROM professores WHERE id = ?', [insertId]);

    // Retorna o status 201 (Criado) e o objeto completo do novo professor
    res.status(201).json(newProfessorRows[0]);

  } catch (error) {
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


const getProfessorHistorico = async (req, res) => {
  const { id } = req.params;

  try {
    // Esta query é a mais complexa até agora:
    // 1. Faz um JOIN entre turmas_ministradas e disciplinas.
    // 2. Filtra os resultados para um professor específico (pelo ID).
    // 3. Agrupa os resultados por disciplina.
    // 4. Usa funções de agregação (SUM, COUNT) para calcular os totais para cada grupo.
    const [rows] = await pool.query(`
      SELECT
        d.id AS disciplina_id,
        d.nome AS disciplina_nome,
        d.codigo_disciplina,
        SUM(t.carga_horaria_efetiva) AS total_carga_horaria,
        SUM(t.numero_alunos) AS total_alunos,
        COUNT(t.id) AS quantidade_turmas
      FROM
        turmas_ministradas t
      INNER JOIN
        disciplinas d ON t.disciplina_id = d.id
      WHERE
        t.professor_id = ?
      GROUP BY
        d.id, d.nome, d.codigo_disciplina
      ORDER BY
        disciplina_nome;
    `, [id]);

    // É possível que um professor nunca tenha ministrado uma turma,
    // então o resultado pode ser um array vazio, o que não é um erro.
    res.status(200).json(rows);

  } catch (error) {
    res.status(500).json({ message: 'Erro ao buscar histórico do professor', error: error.message });
  }
};


// Atualize a sua linha module.exports para ficar assim:
module.exports = {
  getAllProfessores,
  getProfessorById,
  createProfessor,
  updateProfessor,
  deleteProfessor,
  getProfessorHistorico,
};
