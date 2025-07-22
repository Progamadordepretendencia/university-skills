// Importa o driver mysql2, especificamente a versão com Promises
const mysql = require('mysql2/promise');
// Importa o dotenv para carregar as variáveis de ambiente
require('dotenv').config();

// Cria um "pool" de conexões. É mais eficiente que criar uma nova conexão para cada consulta.
const pool = mysql.createPool({
  host: process.env.DB_HOST,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME,
  waitForConnections: true,
  connectionLimit: 10,
  queueLimit: 0
});

console.log('Pool de conexões com o MySQL criado com sucesso.');

// Exporta o pool para que possa ser usado em outras partes da aplicação
module.exports = pool;
