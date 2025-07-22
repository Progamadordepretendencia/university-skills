// src/server.js

require('dotenv').config();
const express = require('express');
const cors = require('cors'); // 1. Importe o pacote cors

const professoresRoutes = require('./routes/professoresRoutes');

const app = express();
const PORT = process.env.PORT || 3000;

// 2. Use o middleware do cors ANTES de todas as suas rotas
// Isso permitirá requisições de qualquer origem. Para produção, você pode configurar origens específicas.
app.use(cors());

app.use(express.json());

app.get('/', (req, res) => {
  res.send('Bem-vindo à API da Universidade!');
});

app.use('/api/professores', professoresRoutes);

app.listen(PORT, () => {
  console.log(`Servidor rodando na porta ${PORT}`);
});
