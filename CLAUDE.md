# CLAUDE.md — Formação para Professores

> Regras e convenções do projeto para geração de código assistido por IA.

## Stack do Projeto

| Camada | Tecnologia | Versão |
|---|---|---|
| Mobile | Flutter + Dart | 3.x |
| State Management | Riverpod | 2.x |
| HTTP Client | Dio | 5.x |
| Backend | NestJS | 10.x |
| ORM | TypeORM | 0.3.x |
| Banco de Dados | PostgreSQL | 15 |
| Auth | JWT + bcrypt | - |
| Deploy | Render.com | - |
| Vídeos | YouTube embed | - |

## Estrutura de Pastas

```
app/lib/
├── core/           → config, theme, network
├── shared/         → widgets e models reutilizáveis
├── features/       → separado por domínio
│   ├── auth/
│   ├── home/
│   ├── formations/
│   ├── progress/
│   └── badges/
└── router/

backend/src/
├── common/         → guards, decorators, filters
├── config/
└── modules/        → auth, users, schools, formations, progress, badges, notifications
```

## Convenções de Código

### Dart / Flutter
- Arquivos: `snake_case` (ex: `login_screen.dart`)
- Classes: `PascalCase` (ex: `LoginScreen`)
- Variáveis e métodos: `camelCase`
- Widgets: `ConsumerWidget` para telas com estado global
- Providers: usar `FutureProvider` para dados async, `StateNotifierProvider` para estado complexo
- NUNCA fazer fetch de dados no método `build()`
- Sempre usar `ref.watch()` dentro do build e `ref.read()` nos handlers

### TypeScript / NestJS
- Sem uso de `any` — sempre tipar
- DTOs com `class-validator` decorators
- Entities com todos os decorators TypeORM (`@Entity`, `@Column`, `@PrimaryGeneratedColumn`, etc.)
- Controllers com decorators Swagger (`@ApiTags`, `@ApiOperation`, `@ApiResponse`, `@ApiBearerAuth`)
- Services sem regras de negócio nos controllers
- Erros: usar `HttpException` ou as exceções do NestJS (`NotFoundException`, `UnauthorizedException`, etc.)

## Paleta de Cores

```dart
background  = Color(0xFF1A1A2E)  // Fundo principal
secondary   = Color(0xFF16213E)  // Fundo secundário / cards
orange      = Color(0xFFFF6B00)  // Cor primária / botões CTA
green       = Color(0xFF00C853)  // Sucesso / progresso
error       = Color(0xFFFF1744)  // Erros
textPrimary = Color(0xFFFFFFFF)  // Texto principal
textSec     = Color(0xFFB0BEC5)  // Texto secundário
```

## Padrão de Resposta da API

```typescript
interface ApiResponse<T> {
  data: T;
  message: string;
}
```

## Regras Críticas

- ❌ NUNCA expor `senha_hash` nas respostas da API
- ❌ NUNCA fazer `fetch` dentro do método `build()` no Flutter
- ❌ NUNCA usar `any` no TypeScript
- ❌ NUNCA commitar `.env` com segredos reais
- ✅ SEMPRE validar código de acesso no cadastro
- ✅ SEMPRE proteger rotas com `JwtAuthGuard` (exceto `/auth/login`, `/auth/register`, `/schools`)
- ✅ SEMPRE adicionar decorators Swagger nos controllers
- ✅ SEMPRE usar `ON CONFLICT DO NOTHING` nos INSERTs de seed data
- ✅ SEMPRE tratar erros com `try/catch` no Flutter

## Limites do MVP

O MVP atual inclui:
- ✅ Login e cadastro com código de acesso
- ✅ Home com notificações e coleções
- ✅ Formações com módulos e vídeos (YouTube embed)
- ✅ Histórico de progresso por formação
- ✅ Badges/insígnias desbloqueáveis
- ✅ Notificações in-app

Fora do escopo MVP (Fase 2):
- ❌ Notificações push (FCM)
- ❌ Painel administrativo
- ❌ Upload de imagens/vídeos próprios
- ❌ iOS (App Store)

## Comandos de Dev

```bash
# Backend
cd backend && npm run start:dev

# Flutter
cd app && flutter run

# Docker (banco + api)
docker-compose up -d

# Swagger UI
open http://localhost:3000/api/docs
```
