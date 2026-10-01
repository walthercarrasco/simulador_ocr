# Es una sola página estática: nginx la sirve tal cual, sin Node.
FROM nginx:1.27-alpine
COPY public/ /usr/share/nginx/html/
EXPOSE 80
