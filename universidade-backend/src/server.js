require('dotenv').config();
const express = require('express');
const cors = require('cors');

// Importa as rotas de professores
const professoresRoutes = require('./routes/professoresRoutes');
// 1. IMPORTE AS NOVAS ROTAS DE DISCIPLINAS
const disciplinasRoutes = require('./routes/disciplinasRoutes');


const app = express();
const PORT = process.env.PORT || 3000;

app.use(cors());
app.use(express.json());

app.get('/', (req, res) => {
  res.send('Bem-vindo à API da Universidade!');
});

// Usa as rotas de professores
app.use('/api/professores', professoresRoutes);
// 2. USE AS NOVAS ROTAS DE DISCIPLINAS
app.use('/api/disciplinas', disciplinasRoutes);


app.listen(PORT, () => {
  console.log(`Servidor rodando na porta ${PORT}`);
});
