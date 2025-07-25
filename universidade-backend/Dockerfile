# Usar uma imagem base oficial do Node.js. A versão 18 é uma LTS (Long-Term Support) e 'alpine' é uma versão leve.
FROM node:18-alpine

# Definir o diretório de trabalho dentro do container.
WORKDIR /usr/src/app

# Copiar os arquivos de manifesto do projeto. O '*' garante que tanto o package.json quanto o package-lock.json sejam copiados.
# Fazemos isso em um passo separado para aproveitar o cache do Docker. Se esses arquivos não mudarem, o 'npm install' não será executado novamente.
COPY package*.json ./

# Instalar as dependências do projeto.
RUN npm install

# Copiar o restante dos arquivos do projeto para o diretório de trabalho no container.
COPY . .

# Expor a porta que a nossa aplicação usa dentro do container.
EXPOSE 3000

# O comando padrão para executar quando o container iniciar.
# Usamos "npm run dev" para que o nodemon funcione dentro do container.
CMD [ "node", "src/server.js" ]
