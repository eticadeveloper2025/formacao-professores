-- ============================================================
-- Script 04: Atualizar vídeo de teste (Firebase Storage)
-- Aplica a URL real do Firebase no primeiro módulo de 6 formações
-- para testar o player, progresso (assistido / concluído)
-- ============================================================

-- Formação 1 (Reforço Escolar Gamificado) — módulo ordem 1
UPDATE formation_modules
SET video_url = 'https://midiasave-5c064.web.app/videonovo.mp4'
WHERE formation_id = 1 AND ordem = 1;

-- Formação 2 (Paz nas Escolas) — módulo ordem 1
UPDATE formation_modules
SET video_url = 'https://midiasave-5c064.web.app/videonovo.mp4'
WHERE formation_id = 2 AND ordem = 1;

-- Formação 3 (Basta! de Violência Contra a Mulher) — módulo ordem 1
UPDATE formation_modules
SET video_url = 'https://midiasave-5c064.web.app/videonovo.mp4'
WHERE formation_id = 3 AND ordem = 1;

-- Formação 4 (Feminicídio Zero) — módulo ordem 1
UPDATE formation_modules
SET video_url = 'https://midiasave-5c064.web.app/videonovo.mp4'
WHERE formation_id = 4 AND ordem = 1;

-- Formação 5 (Cultura Afro-Brasileira e Indígena) — módulo ordem 1
UPDATE formation_modules
SET video_url = 'https://midiasave-5c064.web.app/videonovo.mp4'
WHERE formation_id = 5 AND ordem = 1;

-- Formação 6 (Educação no Trânsito) — módulo ordem 1
UPDATE formation_modules
SET video_url = 'https://midiasave-5c064.web.app/videonovo.mp4'
WHERE formation_id = 6 AND ordem = 1;

-- Verificar resultado
SELECT fm.id, fm.formation_id, f.nome AS formacao, fm.titulo, fm.video_url, fm.ordem
FROM formation_modules fm
JOIN formations f ON f.id = fm.formation_id
WHERE fm.video_url = 'https://midiasave-5c064.web.app/videonovo.mp4'
ORDER BY fm.formation_id, fm.ordem;
