// src/server.js

require('dotenv').config();
const express = require('express');
const cors = require('cors');

const professoresRoutes = require('./routes/professoresRoutes');
const disciplinasRoutes = require('./routes/disciplinasRoutes');
const aptidaoRoutes = require('./routes/aptidaoRoutes');
const turmasRoutes = require('./routes/turmasRoutes');

const app = express();
const PORT = process.env.PORT || 3000;

app.use(cors());
app.use(express.json());

app.get('/', (req, res) => {
  res.send('Bem-vindo à API da Universidade!');
});

// Rotas de recursos
app.use('/api/professores', professoresRoutes);
app.use('/api/disciplinas', disciplinasRoutes);
app.use('/api', aptidaoRoutes);
app.use('/api', turmasRoutes);

app.listen(PORT, () => {
  console.log(`Servidor rodando na porta ${PORT}`);
});
