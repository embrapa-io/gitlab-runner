# GitLab Runner for Embrapa I/O

Configuração de deploy de um [GitLab Runner](https://docs.gitlab.com/runner/install/) no ecossistema do Embrapa I/O.

## Deploy

Para instanciar o _Runner_, primeiramente copie o `.env.example` para `.env`. Você precisará [cadastrar o _runner_ no GitLab](https://git.embrapa.io/admin/runners) para obter o _token_ de autenticação (formato `glrt-...` — os _registration tokens_ legados foram removidos no GitLab 18+). É importante que a opção "_Run untagged jobs_" esteja selecionada.

> **Requisito:** Docker Compose ≥ 2.30 (o `docker-compose.yaml` usa o hook `post_start`). Verifique com `docker compose version`.
>
> O registro só é executado se o `config/config.toml` ainda não tiver um _runner_ registrado — a configuração persiste no diretório `config/` entre recriações do container.

Em seguida, faça:

```
docker compose up --force-recreate --build --remove-orphans --wait
```

## Update

⚠️ **O _runner_ deve ser mantido na MESMA versão do GitLab** (`major.minor.patch` — a versão do GitLab aparece em https://git.embrapa.io/help). Toda atualização do GitLab (`git.embrapa.io`) deve incluir este repositório no planejamento: ajustar a _tag_ da imagem no `docker-compose.yaml` (ex.: `gitlab/gitlab-runner:alpine-v19.0.2`) para a mesma versão e recriar os containers. Com base na [documentação oficial](https://docs.gitlab.com/runner/install/docker/#upgrade-runner-version).

Atualize tudo no SO:

```
apt update && apt upgrade -y && apt dist-upgrade -y && apt autoremove -y && apt autoclean
```

Ajuste a _tag_ da imagem no `docker-compose.yaml` para a nova versão do GitLab e suba a _build_ novamente:

```
git fetch --all && git pull

docker compose up --force-recreate --build --remove-orphans --wait
```
