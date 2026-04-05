# Revisão & Próximos Passos — App Formação para Professores

> Estado da revisão: **Abril de 2026**  
> Revisando: todas as telas do `app/lib/` e a estrutura geral do projeto.

---

## Contexto do Produto

O **Formação para Professores** é uma plataforma de formação continuada para professores parceiros da Ética Editora. Os professores são usuários com **tempo escasso**, contexto pedagógico exigente, e a necessidade de sentir que o tempo investido **gera progresso visível e reconhecimento**. Cada decisão de UX deve ser avaliada com essa lente.

---

## 1. Estado Atual — O Que Já Funciona

| Área | Status | Observação |
|---|---|---|
| Login / Cadastro | ✅ Visual renovado | Brand palette v2 aplicada com fidelidade |
| Conquistas (Badges) | ✅ Redesenhado | 3 colunas por formação, paleta vívida, sem stat counters |
| Histórico | ✅ Redesenhado | 2 colunas com progress ring, % colorido abaixo |
| Autenticação JWT | ✅ Funcional | Token salvo em FlutterSecureStorage |
| Roteamento | ✅ Funcional | go_router com redirect por token |
| Progresso / Módulos | ✅ Funcional | `markCompleted` conectado ao backend |
| Notificações in-app | ✅ Básico | Carrega e marca como lida |
| Firebase Storage | ✅ Configurado | Bucket pronto para imagens reais |

---

## 2. Problemas Prioritários — Resolver Agora

### 🔴 P1 — Inconsistência de AppBar entre as telas

**O que está acontecendo:**
- Login / Register: faixa laranja no topo (Status Bar)
- Badges / Histórico: `AppBar` com `backgroundColor: AppTheme.brandOrange`
- Home / Detalhe da formação / Módulo / Perfil: AppBar escuro padrão `AppTheme.background`

**Por que importa:** O professor navega por várias telas num mesmo fluxo. A troca de cor da AppBar entre `brandOrange` e `background` é visualmente inconsistente e quebra a identidade da marca.

**Sugestão:** Adotar um padrão único para todas as AppBars internas (pós-login). Duas opções:
- **Opção A (recomendada):** AppBar dark (`background`) com um acento laranja sutil — linha de 3px na base ou ícone colorido.
- **Opção B:** `brandOrange` em todas as AppBars internas, como nas telas de Conquistas e Histórico.

**Arquivos afetados:**
- `home_screen.dart`
- `formation_detail_screen.dart`
- `module_screen.dart`
- `profile_screen.dart`

---

### 🔴 P2 — `AppTheme.orange` vs `AppTheme.brandOrange` misturados

**O que está acontecendo:** O `AppTheme` tem dois laranjas:
- `orange = Color(0xFFFF6B00)` — cor original do MVP
- `brandOrange = Color(0xFFF37127)` — cor nova da marca Ética

Widgets como `NotificationTile`, `HomeScreen` (avatar), `CircularProgressWidget`, `FormationCard`, `ModuleCard` e `CircularProgressIndicator` ainda usam `AppTheme.orange`. As telas redesenhadas (Badges, Histórico, Login, Register) usam `brandOrange`.

**Sugestão:** Fazer uma passagem única para padronizar:
1. Renomear `orange` → `orangeLegacy` temporariamente para localizar todos os usos
2. Substituir por `brandOrange` onde for cor de ação/destaque
3. Remover `orangeLegacy` ao final

---

### 🟠 P3 — Ícone de voltar inconsistente

Telas redesenhadas usam `Icons.arrow_back_ios_new_rounded`.  
Telas antigas usam `Icons.arrow_back`.

**Arquivos a corrigir:** `formation_detail_screen.dart`, `module_screen.dart`, `profile_screen.dart`.

---

### 🟠 P4 — Ícone de chat na Home sem função

```dart
// home_screen.dart — linha ~43
IconButton(
  icon: const Icon(Icons.chat_bubble_outline_rounded, ...),
  onPressed: () {}, // ← dead button
),
```

**Sugestão:** Remover até implementar (Fase 2) ou redirecionar para a tela de notificações completas.

---

## 3. Melhorias de UX — Alto Impacto para Professores

### 🟡 UX-1 — Barra de navegação inferior (Bottom Navigation Bar)

**Situação atual:** O acesso a Histórico e Conquistas só é possível pelos dois botões rápidos no meio da Home. Não há como acessá-los de dentro de outras telas.

**Por que importa:** Professores usam o app rapidamente entre aulas. A navigação deve ser sempre de 1 toque a partir de qualquer tela.

**Sugestão:** Adicionar `NavigationBar` (Material 3) com 4 destinos:
```
[🏠 Home]  [📚 Formações]  [📊 Histórico]  [🏆 Conquistas]
```

Mover `FormationGrid` para uma aba dedicada e usar `ShellRoute` no go_router para manter estado.

---

### 🟡 UX-2 — "Continue de onde parou" na Home

**Situação atual:** A Home exibe a saudação + notificações + grid de todas as formações.

**Por que importa:** O professor que abre o app durante o intervalo quer **continuar imediatamente**. Procurar a formação certa no grid custa tempo.

**Sugestão:** Adicionar um card fixo no topo da Home que mostre a última formação em progresso:
```
┌───────────────────────────────────────┐
│  📖  Continuação                      │
│  Gestão de Sala de Aula               │
│  Módulo 3 de 5 · 60% concluído        │
│                    [CONTINUAR →]      │
└───────────────────────────────────────┘
```
O backend já retorna `percentual` e `modulosConcluidos` via `myProgressProvider`. Basta usar o item com maior `percentual` que não seja 100%.

---

### 🟡 UX-3 — Indicador de progresso nos cards de formação

**Situação atual:** `FormationCard` mostra só o círculo com thumb + nome. Não há nenhum indicador de estado.

**Sugestão:** Adicionar uma mini barra de progresso ou badge de estado em cada card:
- Não iniciado: sutil, sem destaque
- Em progresso: mini `LinearProgressIndicator` abaixo do círculo
- Concluído: ícone de `check_circle_rounded` verde sobreposto ao círculo

Isso requer cruzar `formationsProvider` com `myProgressProvider` na `FormationGrid`.

---

### 🟡 UX-4 — Tela do Módulo mais rica

**Situação atual:** Módulo exibe vídeo + título + descrição + botão "Marcar como concluído". Isso é tudo.

**Sugestões para o contexto pedagógico:**
- Mostrar "Módulo X de Y" como subtítulo (ex: "Módulo 3 de 5")
- Botão **"Próximo módulo →"** após marcar como concluído, em vez de voltar para a lista
- Estimativa de tempo ("~15 min de vídeo") — requer campo `duracao_minutos` na entidade `FormationModule`
- Ícone de status no topo: ✅ se já concluído

---

### 🟡 UX-5 — Celebração ao concluir uma formação (100%)

**Situação atual:** Marcar o último módulo = SnackBar verde e pop. Nada especial.

**Por que importa:** Formação completa é uma conquista real para o professor. Deve ser celebrada.

**Sugestão:**
1. Detectar no `_completeModule()` quando `percentual` do progresso atinge 100%
2. Exibir uma `Dialog` ou rota `/formation-complete/:id` com animação (confetti, badge desbloqueada)
3. Link para baixar o certificado (mesmo que seja PDF gerado no backend — Fase 2)

---

### 🟡 UX-6 — Empty states com ilustração e CTA

**Situação atual:** Histórico e Conquistas exibem apenas texto quando vazios.

**Sugestão:** Criar um widget `EmptyStateWidget(icon, title, subtitle, actionLabel, onAction)` e usar nas telas:

| Tela | Mensagem | Ação |
|---|---|---|
| Histórico | "Sua jornada começa aqui" | `[Ver Formações]` → `/home` |
| Conquistas | "Complete módulos para desbloquear insígnias" | `[Explorar Formações]` → `/home` |
| Notificações | "Nenhuma notificação por enquanto" | — |

---

### 🟢 UX-7 — Tela de Perfil com estatísticas

**Situação atual:** Perfil mostra nome, email, nível de acesso e escola.

**Sugestão:** Adicionar uma seção de estatísticas no perfil:
```
┌──────────────────────────────────┐
│  12   módulos concluídos         │
│   3   formações em andamento     │
│   5   insígnias conquistadas     │
└──────────────────────────────────┘
```
Usar `myProgressProvider` e `myBadgesProvider` (já disponíveis) para calcular os números.

---

### 🟢 UX-8 — Página de notificações completa

**Situação atual:** apenas top 3 na Home, sem "ver todas".

**Sugestão:** Criar `/notifications` com `ListView` de todas as notificações, separadas por "Novas" / "Lidas", com opção "Marcar todas como lidas".

---

## 4. Melhorias para o Contexto de Formação Pedagógica

Além de UX técnica, o papel do app é **apoiar o desenvolvimento profissional do professor**. Algumas sugestões que respondem a esse propósito com mais profundidade:

### 📚 FM-1 — Categorias de formação

Com 10 formações no MVP, já faz sentido organizar por eixo temático:
- Gestão de Sala
- Avaliação e Aprendizagem
- Desenvolvimento Socioemocional
- Recursos Pedagógicos

Adicionar campo `categoria` na entidade `Formation` e filtros horizontais (chips) na tela de formações.

---

### 📚 FM-2 — Quadro de destaques / ranking de escola

Para gestores / coordenadores (nível de acesso `coordenador`):
- Mostrar quantos professores da escola concluíram cada formação
- Percentual de engajamento da escola

Isso conecta o app ao objetivo institucional da Ética Editora e valoriza o papel do coordenador.

---

### 📚 FM-3 — Certificado de conclusão

Quando `percentual == 100` para uma formação:
- Backend gera PDF com nome do professor, nome da formação, data de conclusão e assinatura digital da Ética Editora
- App oferece botão "Baixar Certificado" → `firebase_storage` ou PDF dinâmico via NestJS

---

### 📚 FM-4 — Anotações por módulo

Campo de texto opcional em cada módulo para o professor anotar reflexões, dúvidas ou insights. Salvo localmente com `sqflite` (já no pubspec). Não precisa sincronizar com o backend no MVP.

---

## 5. Dívidas Técnicas

| Item | Impacto | Esforço |
|---|---|---|
| Padronizar `AppTheme.orange` → `brandOrange` | Baixo | Baixo (busca/substituição) |
| Padronizar ícone de voltar (`arrow_back_ios_new_rounded`) | Baixo | Baixo |
| Remover `Icons.chat_bubble` noop da Home | Baixo | Trivial |
| `colorScheme.primary` ainda aponta para `orange` antigo | Médio | Baixo |
| `goRouter` redirect usa `FlutterSecureStorage` direto — deveria usar `authProvider` | Médio | Médio |
| `FormationDetailScreen`: `AppTheme.orange` no loading indicator | Baixo | Trivial |
| `duration_minutos` ausente em `FormationModule` | Médio | Médio (backend + frontend) |

---

## 6. Roadmap Sugerido

### Sprint imediata — Consistência Visual

1. Escolher e aplicar padrão único de AppBar em todas as telas
2. Substituir `AppTheme.orange` → `AppTheme.brandOrange` em toda a base
3. Padronizar ícone de voltar
4. Remover botão de chat sem função

### Sprint 2 — Engajamento e Navegação

5. Implementar `NavigationBar` inferior com ShellRoute
6. Card "continue de onde parou" na Home
7. Indicador de progresso nos cards de formação
8. Empty states com ilustração + CTA

### Sprint 3 — Riqueza Pedagógica

9. "Módulo X de Y" + botão "Próximo módulo" no `ModuleScreen`
10. Celebração ao completar 100% de uma formação
11. Estatísticas no Perfil (módulos, insígnias, formações)
12. Página de notificações completa

### Fase 2 — Além do MVP

13. Certificado de conclusão (PDF via backend)
14. Categorias de formação + filtros
15. Anotações por módulo (sqflite local)
16. Quadro de destaques por escola (coordenadores)
17. Notificações push (FCM)
18. Painel administrativo

---

## 7. Resumo Visual do App Hoje

```
Login ──→ Cadastro ──→ Sucesso ──→ Boas-vindas ──→ Home
                                                     │
                     ┌───────────────────────────────┤
                     │                               │
               [Notificações]              [Grid de Formações]
                     │                               │
              (top 3, sem rota)          Formação → Módulos
                                                     │
                     ┌───────────────────────────────┤
               [Histórico]                    [Conquistas]
               (progress rings)            (3 cols/formação)
                     
                 [Perfil] ← via avatar no AppBar
```

**Pontos cegos de navegação:** Sem bottom nav, o usuário precisa sempre voltar à Home para trocar de seção. Histórico não é acessível de dentro de uma formação. Conquistas só via Home.

---

*Documento gerado com base na revisão de 51 arquivos Dart do projeto em Abril/2026.*
