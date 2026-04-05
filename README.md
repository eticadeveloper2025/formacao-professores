# 📱 Formação para Professores — Ética Editora

> Plataforma de formação continuada para professores parceiros da Ética Editora.

[![Flutter](https://img.shields.io/badge/Flutter-3.x-blue?logo=flutter)](https://flutter.dev)
[![NestJS](https://img.shields.io/badge/NestJS-10.x-red?logo=nestjs)](https://nestjs.com)
[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-15-blue?logo=postgresql)](https://postgresql.org)
[![Docker](https://img.shields.io/badge/Docker-Compose-blue?logo=docker)](https://docker.com)

---

## 📌 Descrição

O **Formação para Professores** é um aplicativo mobile desenvolvido exclusivamente para professores parceiros da Ética Editora. Ele centraliza todas as formações pedagógicas em um único lugar, permitindo que cada professor acompanhe seu progresso, receba notificações e colecione conquistas (badges/insígnias) ao longo de sua jornada de desenvolvimento profissional.

### Funcionalidades
- 🔐 Login e cadastro com código de acesso exclusivo
- 🏠 Home com notificações, grid de coleções e card de formação em andamento
- 📚 10 formações pedagógicas com módulos e vídeos
- 📊 Histórico de progresso com percentual por formação
- 🏆 Sistema de conquistas (badges desbloqueáveis)
- 🔔 Notificações de atualizações e lembretes
- ☰ Menu de navegação lateral (hambúrguer) em todas as telas autenticadas

---

## 🛠️ Pré-requisitos

| Ferramenta | Versão mínima |
|---|---|
| Flutter | 3.x |
| Dart | 3.x |
| Node.js | 18.x |
| Docker | 24.x |
| Docker Compose | 2.x |

---

## 🚀 Como rodar localmente

### 1. Clone o repositório

```bash
git clone https://github.com/eticadeveloper2025/formacao-professores.git
cd formacao-professores
```

---

## 🗂️ Opção A — Backend via Docker + Flutter Web no Chrome

> Use esta opção se não tiver Android Studio ou dispositivo físico.

### Passo 1 — Subir o banco de dados (Docker)

> ⚠️ **Se você já tem PostgreSQL instalado localmente** rodando na porta 5432, o Docker vai conflitar.
> Nesse caso, edite o `docker-compose.yml` e troque `"5432:5432"` por `"5433:5432"`,
> e no `backend/.env` troque a porta na `DATABASE_URL` para `5433`.

```powershell
# Na raiz do projeto
docker-compose up -d db

# Aguarde ~10s e verifique se está pronto:
docker-compose logs db | Select-String "ready to accept"
```

### Passo 2 — Rodar o Backend (Terminal 1)

```powershell
cd backend

# Primeira vez: copie o .env
copy .env.example .env

npm install
npm run start:dev
```

Aguarde a mensagem:
```
🚀 Servidor rodando em http://localhost:3000
📚 Swagger disponível em http://localhost:3000/api/docs
```

### Passo 3 — Rodar o Flutter Web (Terminal 2 — novo terminal)

```bash
cd app
flutter pub get
flutter run -d chrome --web-browser-flag="--disable-web-security" --web-browser-flag="--user-data-dir=/tmp/chrome_dev_test"
```

> As flags `--disable-web-security` são necessárias para o Flutter Web conseguir chamar a API em `localhost:3000` sem bloqueio de CORS.

---

## 🗂️ Opção B — Testar só o Backend com Swagger

> Use esta opção para testar endpoints sem precisar rodar o Flutter.

### Passo 1 — Subir banco e backend

```powershell
# Terminal 1 — raiz do projeto
docker-compose up -d db

# Terminal 1 — backend
cd backend
npm run start:dev
```

### Passo 2 — Acessar o Swagger UI

Abra no navegador: **http://localhost:3000/api/docs**

### Passo 3 — Fazer login e autenticar

1. Clique em `POST /auth/login` → **Try it out** → cole o body:
```json
{
  "email": "ana@escola.com",
  "senha": "teste123"
}
```
2. Copie o `accessToken` da resposta
3. Clique em **Authorize 🔒** no topo → cole `Bearer {seu_token}` → **Authorize**
4. Todos os endpoints protegidos agora estão disponíveis

---

## 🧪 Usuários de Teste

| Nome | Email | Senha | Nível |
|---|---|---|---|
| Ana Silva | ana@escola.com | teste123 | professor |
| Carlos Souza | carlos@escola.com | teste123 | coordenador |
| Maria Santos | maria@escola.com | teste123 | professor |

---

## 🔑 Códigos de Acesso Disponíveis

Para testar o cadastro, use um dos códigos abaixo:

| Código | Escola | Nível |
|---|---|---|
| ETICA2025A | E.E. Prof. João Pessoa | professor |
| ETICA2025B | E.E. Prof. João Pessoa | professor |
| ETICA2025C | E.E. Maria Curie | professor |
| ETICA2025D | E.E. Maria Curie | coordenador |
| ETICA2025E | E.E. Santos Dumont | professor |
| DEMO-PROF-01 | (sem escola) | professor |
| DEMO-PROF-02 | (sem escola) | professor |

---

## 🌐 Variáveis de Ambiente

Copie o arquivo de exemplo e configure:

```bash
cp backend/.env.example backend/.env
```

| Variável | Descrição | Padrão |
|---|---|---|
| `DATABASE_URL` | URL de conexão PostgreSQL | `postgresql://postgres:postgres123@localhost:5433/formacao_professores` ¹ |
| `JWT_SECRET` | Segredo para assinar os tokens JWT | `formacao-professores-secret-key-2025` |
| `JWT_EXPIRES_IN` | Expiração do access token | `1h` |
| `JWT_REFRESH_EXPIRES_IN` | Expiração do refresh token | `7d` |
| `PORT` | Porta do servidor | `3000` |

> ¹ Porta `5433` é usada quando já existe um PostgreSQL local rodando na `5432`. Ajuste conforme seu ambiente.

---

## 📁 Estrutura de Pastas

```
formacao-professores/
├── app/                          ← Flutter (Android/iOS)
│   └── lib/
│       ├── core/                 ← Tema, config, network
│       ├── shared/               ← Widgets e models reutilizáveis
│       │   └── widgets/
│       │       ├── app_end_drawer.dart    ← Menu hambúrguer pós-login
│       │       └── empty_state_widget.dart ← Estado vazio com CTA
│       ├── features/             ← Funcionalidades por domínio
│       │   ├── auth/             ← Login, Cadastro
│       │   ├── home/             ← Home, Boas-vindas
│       │   ├── formations/       ← Formações e módulos
│       │   ├── progress/         ← Histórico de progresso
│       │   └── badges/           ← Conquistas
│       └── router/               ← Navegação (go_router)
├── backend/                      ← NestJS API
│   └── src/
│       ├── common/               ← Guards, decorators, filters
│       ├── config/               ← Configs do banco e JWT
│       └── modules/              ← Módulos da API
│           ├── auth/             ← Autenticação JWT
│           ├── users/            ← Perfil do professor
│           ├── schools/          ← Escolas
│           ├── formations/       ← Formações e módulos
│           ├── progress/         ← Progresso
│           ├── badges/           ← Insígnias
│           └── notifications/    ← Notificações
├── database/                     ← Scripts SQL
│   ├── 01_create_tables.sql      ← Criação das tabelas
│   ├── 02_seed_data.sql          ← Dados mockados
│   └── 03_access_codes.sql       ← Códigos de acesso
├── docs/                         ← Documentação
│   ├── ENDPOINTS.md              ← Todos os endpoints documentados
│   └── postman/                  ← Collection importável
├── docker-compose.yml            ← PostgreSQL + Backend
└── README.md
```

---

## 📡 Endpoints da API

A documentação completa dos endpoints está em:
- **Swagger UI** (interativo): http://localhost:3000/api/docs
- **Markdown**: [docs/ENDPOINTS.md](docs/ENDPOINTS.md)
- **Postman**: [docs/postman/Formacao_Professores.postman_collection.json](docs/postman/Formacao_Professores.postman_collection.json)

---

## 🎨 Paleta de Cores

| Nome | HEX | Uso |
|---|---|---|
| Background | `#1A1A2E` | Fundo principal |
| Secondary | `#16213E` | Fundo secundário |
| **brandOrange** | `#F37127` | **Primária oficial (Design System v2)** |
| ~~orange~~ | ~~`#FF6B00`~~ | ~~Legado — não usar em código novo~~ |
| Green | `#00C853` | Sucesso / progresso |
| Error | `#FF1744` | Erros |

---

## 📋 Comandos Úteis

```bash
# Backend
cd backend
npm run start:dev        # Modo desenvolvimento com watch
npm run build            # Build de produção
npm run test             # Testes

# Flutter
cd app
flutter pub get          # Instalar dependências
flutter run              # Rodar no dispositivo/emulador
flutter build apk        # Build APK Android

# Docker
docker-compose up -d     # Subir todos os serviços
docker-compose down      # Parar todos os serviços
docker-compose logs -f   # Ver logs em tempo real
```

---

## 🔥 Configuração do Firebase

Este app usa o Firebase Storage do projeto `midiasave-5c064` (mesmo do app BASTA) para hospedar vídeos e imagens das formações.

### Passo a passo:
1. Acesse o [Firebase Console](https://console.firebase.google.com/)
2. Abra o projeto **midiasave-5c064**
3. Vá em **Configurações do Projeto** → **Seus Apps**
4. Clique em **Adicionar App** → **Android**
5. Package name: `br.com.eticatec.formacaoprofessores`
6. Baixe o `google-services.json`
7. Copie para `app/android/app/google-services.json`

> ⚠️ O arquivo `google-services.json` contém credenciais e NÃO deve ser commitado no Git.

---

## 🔜 Roadmap — Fase 2

- [ ] Notificações push (Firebase Cloud Messaging)
- [ ] Painel administrativo para a Ética Editora
- [ ] Versão iOS (App Store)
- [ ] Relatórios de progresso por escola
- [ ] Modo offline para conteúdos baixados

---

*Desenvolvido para a Ética Editora — 2025*
