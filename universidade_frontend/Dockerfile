# Estágio 1: Build da Aplicação Flutter
FROM instrumentisto/flutter:3.32.7 AS builder

# Define o diretório de trabalho inicial
WORKDIR /app

# Copia a pasta inteira do frontend para dentro do container
COPY universidade_frontend/ .

# CORREÇÃO: Entra na pasta do projeto Flutter antes de executar os comandos
RUN flutter pub get
RUN flutter build web

# Estágio 2: Servidor Nginx de Produção
FROM nginx:stable-alpine

# Copia o nginx.conf da raiz do contexto do build
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copia os arquivos construídos
COPY --from=builder /app/build/web /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
