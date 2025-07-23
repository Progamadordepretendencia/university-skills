// src/server.js

require('dotenv').config();
const express = require('express');
const cors = require('cors');

const professoresRoutes = require('./routes/professoresRoutes');
const disciplinasRoutes = require('./routes/disciplinasRoutes');
// 1. IMPORTE AS NOVAS ROTAS DE APTIDÃO
const aptidaoRoutes = require('./routes/aptidaoRoutes');

const app = express();
const PORT = process.env.PORT || 3000;

app.use(cors());
app.use(express.json());

app.get('/', (req, res) => {
  res.send('Bem-vindo à API da Universidade!');
});

// Rotas de recursos principais
app.use('/api/professores', professoresRoutes);
app.use('/api/disciplinas', disciplinasRoutes);
// 2. USE AS NOVAS ROTAS DE APTIDÃO (note o prefixo /api)
// As rotas dentro de aptidaoRoutes já contêm /professores/...
app.use('/api', aptidaoRoutes);

app.listen(PORT, () => {
  console.log(`Servidor rodando na porta ${PORT}`);
});
