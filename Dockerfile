FROM nginx:alpine

COPY nginx.conf /etc/nginx/nginx.conf
COPY load-balancer.conf /etc/nginx/conf.d/default.conf

# Cria diretório para logs do nginx se não existir
RUN mkdir -p /var/log/nginx

EXPOSE 80 443

HEALTHCHECK CMD wget --quiet --tries=1 --spider http://localhost/health || exit 1
