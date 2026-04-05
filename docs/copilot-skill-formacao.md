# Copilot Skill — Formação para Professores

## Descrição da Skill

Esta skill ensina o GitHub Copilot a gerar código para o projeto "Formação para Professores" da Ética Editora, seguindo os padrões definidos para Flutter + NestJS.

---

## Estrutura de Pastas

```
app/lib/
├── core/
│   ├── config/app_config.dart
│   ├── theme/app_theme.dart
│   └── network/
│       ├── dio_client.dart
│       └── auth_interceptor.dart
├── shared/
│   └── widgets/
│       ├── app_button.dart
│       ├── app_text_field.dart
│       ├── circular_progress_widget.dart
│       ├── badge_card.dart
│       ├── formation_card.dart
│       └── loading_overlay.dart
└── features/
    ├── auth/
    ├── home/
    ├── formations/
    ├── progress/
    └── badges/

backend/src/modules/
├── auth/
├── users/
├── schools/
├── formations/
├── progress/
├── badges/
└── notifications/
```

---

## Design System

### Cores
- Fundo: `#1A1A2E` (AppTheme.background)
- Secundário: `#16213E` (AppTheme.secondary)
- Primária/CTA: `#FF6B00` (AppTheme.orange)
- Sucesso: `#00C853` (AppTheme.green)
- Erro: `#FF1744` (AppTheme.error)
- Texto: `#FFFFFF` (AppTheme.textPrimary)

### Componentes Reutilizáveis
- `AppButton` → botão laranja padrão com loading state
- `AppTextField` → campo com toggle de senha embutido
- `CircularProgressWidget` → anel de progresso circular
- `BadgeCard` → card de insígnia (locked/unlocked)
- `FormationCard` → card da formação no grid
- `NotificationTile` → item de notificação

---

## Regras de Geração

### Flutter
- Use `ConsumerWidget` para telas com estado global
- Use `FutureProvider` para dados carregados da API
- Use `StateNotifierProvider` para estado com mutações
- SEMPRE trate `loading`, `data` e `error` nos providers
- NUNCA faça chamadas de rede no `build()`
- Use `go_router` para navegação: `context.push('/rota')` e `context.go('/rota')`

### NestJS
- Controller: `@ApiTags`, `@ApiOperation`, `@ApiResponse`, `@ApiBearerAuth`
- Todas as rotas (exceto `/auth/*` e `/schools`) devem ter `@UseGuards(JwtAuthGuard)`
- Padrão de retorno: `{ data: T, message: string }`
- Use `@CurrentUser()` para obter o usuário do JWT
- DTOs com `class-validator`: `@IsString()`, `@IsEmail()`, `@IsNumber()`, etc.

### SQL
- snake_case em tabelas e colunas
- `SERIAL PRIMARY KEY`
- `ON DELETE CASCADE` para dependentes diretos
- `ON DELETE SET NULL` para referências opcionais
- `ON CONFLICT DO NOTHING` em INSERTs de seed

---

## Endpoints Resumidos

| Método | URL | Auth | Descrição |
|---|---|---|---|
| POST | /auth/login | ❌ | Login |
| POST | /auth/register | ❌ | Cadastro |
| POST | /auth/refresh | ❌ | Refresh token |
| GET | /users/me | ✅ | Perfil |
| PUT | /users/me | ✅ | Atualizar perfil |
| GET | /schools | ❌ | Lista escolas |
| GET | /formations | ✅ | Lista formações |
| GET | /formations/:id | ✅ | Detalhe formação |
| GET | /formations/:id/modules | ✅ | Módulos |
| GET | /progress/me | ✅ | Progresso geral |
| POST | /progress | ✅ | Marcar módulo concluído |
| GET | /progress/formation/:id | ✅ | Progresso por formação |
| GET | /badges/me | ✅ | Minhas conquistas |
| GET | /badges/formation/:id | ✅ | Badges da formação |
| GET | /notifications/me | ✅ | Notificações |
| PATCH | /notifications/:id/read | ✅ | Marcar lida |
