#!/bin/bash
# ============================================
# Upgrade Script - GitLab Runner (Embrapa I/O)
# ============================================
# O runner deve ser mantido na MESMA versão do GitLab (git.embrapa.io/help).
# Este script ajusta a tag da imagem no docker-compose.yaml, atualiza o SO
# e recria os containers.
#
# Uso: sudo ./upgrade.sh <versão do GitLab>   (ex.: sudo ./upgrade.sh 19.1.0)
#
# Após rodar, commite e envie a mudança do docker-compose.yaml para o
# repositório, para que a versão em produção fique registrada no git.
# ============================================

set -e

if [ -z "$1" ]; then
    echo "Uso: $0 <versão do GitLab> (ex.: $0 19.1.0)"
    echo "Versão atual no compose: $(grep -oE 'alpine-v[0-9.]+' docker-compose.yaml)"
    exit 1
fi

VERSION="$1"

command -v docker >/dev/null 2>&1 || { echo "❌ Docker não encontrado!"; exit 1; }
docker compose version >/dev/null 2>&1 || { echo "❌ Docker Compose V2 não encontrado!"; exit 1; }
[ -f ".env" ] || { echo "❌ Arquivo .env não encontrado!"; exit 1; }

echo "ℹ️  Ajustando a imagem do runner para a versão v${VERSION}..."
sed -i "s|gitlab/gitlab-runner:alpine-v[0-9.]*|gitlab/gitlab-runner:alpine-v${VERSION}|" docker-compose.yaml
grep "image: gitlab/gitlab-runner" docker-compose.yaml

echo "ℹ️  Atualizando o SO..."
apt update && apt upgrade -y && apt dist-upgrade -y && apt autoremove -y && apt autoclean

echo "ℹ️  Recriando os containers..."
docker compose up --force-recreate --build --remove-orphans --pull always --wait

echo "ℹ️  Limpando imagens antigas..."
docker image prune -f >/dev/null

docker compose ps
echo ""
echo "🚀 Runner atualizado para v${VERSION}."
echo "⚠️  Lembre-se de commitar a mudança do docker-compose.yaml no repositório!"
