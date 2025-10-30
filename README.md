# NGINX Load Balancer

Este projeto configura um balanceador de carga utilizando o NGINX, Docker e docker-compose.

## Objetivo
O objetivo é gerenciar múltiplas instâncias de aplicações web por meio de um balanceador de carga reverso, facilitando a escalabilidade e alta disponibilidade.

## Arquivos principais
- `nginx.conf` / `load-balancer.conf`: Configuração do NGINX
- `Dockerfile`: Build da imagem do NGINX
- `docker-compose.yml`: Orquestração dos containers

## Como usar
1. Clone o repositório.
2. Rode `docker-compose up -d` para subir a stack.
3. Edite as configurações conforme necessário para novos serviços.

## Observações
Consulte o arquivo `ROADMAP_INSTALACAO.md` para detalhes completos da instalação e uso do sistema.
