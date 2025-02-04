# GitLab Runner for Embrapa I/O

Configuração de deploy de um [GitLab Runner](https://docs.gitlab.com/runner/install/) no ecossistema do Embrapa I/O.

## Deploy

Para instanciar o _Runner_, primeiramente copie o `.env.example` para `.env`. Você precisará [cadastrar o _runner_ no GitLab](https://git.embrapa.io/admin/runners) para obter o _token_. É importante que a opção "_Run untagged jobs_" esteja selecionada.

Em seguida, faça:

```
docker compose up --force-recreate --build --remove-orphans --wait
```
