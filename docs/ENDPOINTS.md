# 📡 Documentação dos Endpoints — Formação para Professores API

> Base URL: `http://localhost:3000`
> Swagger UI: `http://localhost:3000/api/docs`

---

## Autenticação

Todas as rotas protegidas requerem o header:
```
Authorization: Bearer <access_token>
```

---

## 🔐 Auth

### POST /auth/login
Login do professor.

**Body:**
```json
{
  "email": "ana@escola.com",
  "senha": "teste123"
}
```

**Response 200:**
```json
{
  "data": {
    "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "user": {
      "id": 1,
      "nome": "Ana Silva",
      "email": "ana@escola.com",
      "nivel_acesso": "professor",
      "avatar_url": null,
      "school": { "id": 1, "nome": "E.E. Prof. João Pessoa", "regiao": "Sudeste" }
    }
  },
  "message": "Login realizado com sucesso"
}
```

**Status codes:** `200`, `401`

---

### POST /auth/register
Cadastro de novo professor.

**Body:**
```json
{
  "nome": "João Silva",
  "email": "joao@escola.com",
  "senha": "minhasenha123",
  "codigoAcesso": "ETICA2025A",
  "schoolId": 1,
  "nivelAcesso": "professor"
}
```

**Response 201:**
```json
{
  "data": {
    "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "user": {
      "id": 4,
      "nome": "João Silva",
      "email": "joao@escola.com",
      "nivel_acesso": "professor"
    }
  },
  "message": "Professor cadastrado com sucesso"
}
```

**Status codes:** `201`, `400`, `409`

---

### POST /auth/refresh
Renova o access token usando o refresh token.

**Body:**
```json
{
  "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

**Response 200:**
```json
{
  "data": { "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..." },
  "message": "Token renovado com sucesso"
}
```

**Status codes:** `200`, `401`

---

## 👤 Users

### GET /users/me
🔒 _Requer autenticação_

Retorna o perfil do professor logado.

**Response 200:**
```json
{
  "data": {
    "id": 1,
    "nome": "Ana Silva",
    "email": "ana@escola.com",
    "nivel_acesso": "professor",
    "avatar_url": null,
    "school": { "id": 1, "nome": "E.E. Prof. João Pessoa", "regiao": "Sudeste" },
    "created_at": "2025-01-01T00:00:00.000Z"
  },
  "message": "Perfil retornado com sucesso"
}
```

---

### PUT /users/me
🔒 _Requer autenticação_

Atualiza o perfil do professor logado.

**Body (todos opcionais):**
```json
{
  "nome": "Ana Silva Souza",
  "email": "ana.nova@escola.com",
  "avatar_url": "https://exemplo.com/foto.jpg"
}
```

**Response 200:** Mesmo formato do GET /users/me

---

## 🏫 Schools

### GET /schools
Lista todas as escolas cadastradas (usado no dropdown do cadastro).

**Response 200:**
```json
{
  "data": [
    { "id": 1, "nome": "E.E. Prof. João Pessoa", "regiao": "Sudeste" },
    { "id": 2, "nome": "E.E. Maria Curie", "regiao": "Sul" },
    { "id": 3, "nome": "E.E. Santos Dumont", "regiao": "Nordeste" }
  ],
  "message": "Escolas retornadas com sucesso"
}
```

---

## 📚 Formations

### GET /formations
🔒 _Requer autenticação_

Lista todas as formações ativas.

**Response 200:**
```json
{
  "data": [
    {
      "id": 1,
      "nome": "Reforço Escolar Gamificado",
      "descricao": "Aprenda técnicas de gamificação...",
      "thumb_url": "https://...",
      "ordem": 1,
      "ativo": true
    }
  ],
  "message": "Formações retornadas com sucesso"
}
```

---

### GET /formations/:id
🔒 _Requer autenticação_

Retorna detalhes de uma formação com seus módulos.

**Response 200:**
```json
{
  "data": {
    "id": 1,
    "nome": "Reforço Escolar Gamificado",
    "descricao": "...",
    "modules": [
      { "id": 1, "titulo": "Introdução à Gamificação", "ordem": 1, "video_url": "..." }
    ]
  },
  "message": "Formação retornada com sucesso"
}
```

**Status codes:** `200`, `404`

---

### GET /formations/:id/modules
🔒 _Requer autenticação_

Lista os módulos de uma formação.

**Response 200:**
```json
{
  "data": [
    {
      "id": 1,
      "titulo": "Introdução à Gamificação",
      "descricao": "O que é gamificação...",
      "video_url": "https://www.youtube.com/watch?v=...",
      "ordem": 1
    }
  ],
  "message": "Módulos retornados com sucesso"
}
```

---

## 📊 Progress

### GET /progress/me
🔒 _Requer autenticação_

Retorna o progresso geral do professor em todas as formações.

**Response 200:**
```json
{
  "data": [
    {
      "formation_id": 1,
      "formation_nome": "Reforço Escolar Gamificado",
      "total_modulos": 3,
      "modulos_concluidos": 3,
      "percentual": 100
    },
    {
      "formation_id": 2,
      "formation_nome": "Paz nas Escolas",
      "total_modulos": 3,
      "modulos_concluidos": 0,
      "percentual": 0
    }
  ],
  "message": "Progresso retornado com sucesso"
}
```

---

### POST /progress
🔒 _Requer autenticação_

Marca um módulo como concluído e verifica desbloqueio de badges.

**Body:**
```json
{
  "moduleId": 1
}
```

**Response 201:**
```json
{
  "data": {
    "id": 1,
    "completed": true,
    "completed_at": "2025-04-04T12:00:00.000Z"
  },
  "message": "Módulo marcado como concluído"
}
```

---

### GET /progress/formation/:id
🔒 _Requer autenticação_

Retorna o progresso detalhado do professor em uma formação específica.

**Response 200:**
```json
{
  "data": {
    "formation_id": 1,
    "percentual": 67,
    "total": 3,
    "concluidos": 2,
    "modulos": [
      { "module_id": 1, "titulo": "Introdução", "completed": true, "completed_at": "..." },
      { "module_id": 2, "titulo": "Mecânicas", "completed": true, "completed_at": "..." },
      { "module_id": 3, "titulo": "Na Prática", "completed": false, "completed_at": null }
    ]
  },
  "message": "Progresso da formação retornado com sucesso"
}
```

---

## 🏆 Badges

### GET /badges/me
🔒 _Requer autenticação_

Retorna todas as conquistas do professor (bloqueadas e desbloqueadas).

**Response 200:**
```json
{
  "data": [
    {
      "id": 1,
      "nome": "Mestre da Gamificação",
      "descricao": "Concluiu 50% da formação...",
      "criterio_percentual": 50,
      "conquistado": true,
      "conquistado_em": "2025-03-20T00:00:00.000Z",
      "formation": { "id": 1, "nome": "Reforço Escolar Gamificado" }
    },
    {
      "id": 3,
      "nome": "Embaixador da Paz",
      "conquistado": false,
      "conquistado_em": null
    }
  ],
  "message": "Conquistas retornadas com sucesso"
}
```

---

### GET /badges/formation/:id
🔒 _Requer autenticação_

Retorna os badges de uma formação específica com status do professor.

**Response 200:** Mesmo formato do GET /badges/me, filtrado pela formação.

---

## 🔔 Notifications

### GET /notifications/me
🔒 _Requer autenticação_

Retorna as notificações do professor, ordenadas da mais recente para a mais antiga.

**Response 200:**
```json
{
  "data": [
    {
      "id": 1,
      "titulo": "Nova formação disponível!",
      "mensagem": "A formação 'Basta!' está esperando por você.",
      "lida": false,
      "created_at": "2025-04-01T10:00:00.000Z",
      "formation": { "id": 3, "nome": "Basta! de Violência..." }
    }
  ],
  "message": "Notificações retornadas com sucesso"
}
```

---

### PATCH /notifications/:id/read
🔒 _Requer autenticação_

Marca uma notificação como lida.

**Response 200:**
```json
{
  "data": { "id": 1, "lida": true },
  "message": "Notificação marcada como lida"
}
```

**Status codes:** `200`, `403`, `404`

---

## 🧭 Ementa do Projeto

### GET /syllabus
🔒 _Requer autenticação_

Retorna todas as seções ativas da ementa, ordenadas para exibição no app.

**Response 200:**
```json
{
  "data": [
    {
      "id": 1,
      "title": "Formação para Professores",
      "content": "Projeto de formação continuada...",
      "sectionType": "overview",
      "order": 1,
      "active": true
    }
  ],
  "message": "Ementa retornada com sucesso"
}
```

---

## 🗓️ Calendário

### GET /calendar
🔒 _Requer autenticação_

Lista entradas do calendário pedagógico.

**Query params opcionais:** `startDate`, `endDate`, `month`, `year`, `type`, `week`, `chapter`, `search`.

**Response 200:**
```json
{
  "data": [
    {
      "id": 1,
      "date": "2026-08-03",
      "weekNumber": 1,
      "lessonNumber": 1,
      "chapter": "1",
      "theme": "O que são Relações Tóxicas ou Abusivas?",
      "objective": "Definir e distinguir relações saudáveis...",
      "activity": "Discussão em grupo...",
      "activityType": "Aula",
      "bnccSkills": ["EF06ER09"],
      "bnccCompetency": "Competência Geral 9...",
      "status": "planejado",
      "lessonPlanId": 1,
      "reminderId": 2
    }
  ],
  "message": "Calendário retornado com sucesso"
}
```

### GET /calendar/:id
🔒 _Requer autenticação_

Retorna detalhes de uma entrada do calendário, incluindo plano de aula e lembrete relacionados quando existirem.

**Status codes:** `200`, `404`

---

## 📝 Planos de Aula

### GET /lesson-plans
🔒 _Requer autenticação_

Lista planos de aula ativos.

**Query params opcionais:** `chapter`, `week`, `bnccSkill`, `search`.

**Response 200:**
```json
{
  "data": [
    {
      "id": 1,
      "title": "Relações tóxicas ou abusivas",
      "chapter": "1",
      "theme": "O que são Relações Tóxicas ou Abusivas?",
      "weekNumber": 1,
      "lessonNumber": 1,
      "durationMinutes": 50,
      "generalObjective": "Definir e distinguir relações saudáveis...",
      "bnccSkills": ["EF06ER09"],
      "bnccCompetencies": ["Competência Geral 9"]
    }
  ],
  "message": "Planos de aula retornados com sucesso"
}
```

### GET /lesson-plans/:id
🔒 _Requer autenticação_

Retorna o plano completo com objetivos, preparação, metodologia, atividade, BNCC, avaliação, materiais e orientações.

**Status codes:** `200`, `404`

---

## 🎙️ Vídeos Lembrete

### GET /page-reminders
🔒 _Requer autenticação_

Lista todos os vídeos lembrete ativos.

### GET /page-reminders/page/:pageKey
🔒 _Requer autenticação_

Retorna o lembrete contextual de uma página. Exemplos de `pageKey`: `syllabus`, `calendar`, `lesson-plans`, `activities`, `bncc`.

### GET /page-reminders/:id
🔒 _Requer autenticação_

Retorna um vídeo lembrete pelo ID.

**Response 200:**
```json
{
  "data": {
    "id": 1,
    "pageKey": "syllabus",
    "title": "Como consultar a ementa",
    "description": "Explicação em voz sobre a proposta pedagógica...",
    "mediaUrl": "https://midiasave-5c064.web.app/videonovo.mp4",
    "thumbnailUrl": "https://...",
    "transcript": "Nesta página você encontra...",
    "durationSeconds": 95,
    "active": true,
    "order": 1
  },
  "message": "Vídeo lembrete retornado com sucesso"
}
```

**Status codes:** `200`, `404`

---

## ❗ Padrão de Erros

```json
{
  "data": null,
  "message": "Email ou senha inválidos",
  "statusCode": 401,
  "timestamp": "2025-04-04T12:00:00.000Z"
}
```
