# 🚀 Roadmap de Instalação/Replicação - Load Balancer NGINX Docker (Versão Final)

Guia para instalar, replicar e manter o load balancer NGINX em ambiente Docker, incluindo balanceamento por peso, failover de backup e integração Cloudflare.

---

## 1. Pré-requisitos
- VPS Linux com acesso SSH
- Docker e Docker Compose instalados
- Domínio(s) configurado(s) e, opcionalmente, Cloudflare
- Pastas e arquivos (deste repositório):
  - `nginx.conf`
  - `load-balancer.conf`
  - `docker-compose.yml`

---

## 2. Objetivo
- Balancear tráfego entre múltiplos backends com pesos distintos
- Failover automático para backup somente quando primários estiverem realmente off
- Integração nativa com Cloudflare SSL (Frontend HTTPS, backend HTTP/HTTPS)
- Log de chamadas por backend para validação e troubleshooting

---

## 3. Estrutura dos arquivos

- **nginx.conf:** config global do NGINX
- **load-balancer.conf:** lógica do upstream/leasts_conn/pesos/failover
- **docker-compose.yml:** orquestração do serviço em container Docker

#### Exemplo de bloco upstream (final):
```nginx
upstream backend_servers {
    least_conn;
    server site.movaa.com.br:443 max_fails=12 fail_timeout=30s weight=3;
    server site2.movaa.com.br:443 max_fails=6 fail_timeout=60s weight=1;
    server app-movaa-v2.fly.dev:443 max_fails=3 fail_timeout=120s backup;
}
```
---

## 4. Passo a passo

### a) Envie os arquivos para o VPS
```
scp -i VPS_key.pem -r lb3/ duzaq@IP_VPS:~/nginx-load-balancer
```

### b) Inicie o serviço
```
cd ~/nginx-load-balancer
sudo docker compose up -d
```

### c) No Cloudflare (opcional, recomendado)
- Aponte domínio para IP do VPS
- Ative modo proxy (nuvem laranja) e SSL Full (recomendado)
- Redirecione HTTP→HTTPS via regra ou painel

### d) Teste e monitore logs
- Acesse: http://dominio-ou-ip/health
- Veja logs (exemplo):
  ```
  docker exec nginx-load-balancer cat /var/log/nginx/access.log | grep 'upstream:' | awk -F 'upstream: ' '{print $2}' | sort | uniq -c
  ```

---

## 5. Recomendações
- NÃO utilize HTTPS local, deixe Cloudflare ou outro proxy edge cuidar do certificado!
- Ajuste weights/fail_timeout/max_fails para adaptar a sensibilidade e distribuição ideal (documentadas no bloco upstream acima)
- Sempre mantenha o backup marcado como `backup` para failover seguro
- Use versionamento (Git) para manter histórico exato de alterações

---

## 6. Troubleshooting
- 502/504: Verifique portas, DNS dos backends, SSL backend e logs
- Backup acionado? Confirme downtime real dos primários e tolerância configurada
- Logs ajudam a validar distribuição e failover de requests

---

## 7. Restore/Réplica rápida
Basta copiar estes arquivos para um VPS Docker, editar domínios e rodar o `docker compose up -d`. Todo o balanceamento estará operacional.

---

Qualquer dev poderá replicar, manter e evoluir o ambiente usando este roadmap e os arquivos incluídos nesta pasta.
