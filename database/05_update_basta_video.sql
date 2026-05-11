-- ============================================================
-- Script 05: Atualizar vídeo da formação BASTA (bastamovie.mp4)
-- Aplica a URL do vídeo real no primeiro módulo da formação BASTA
-- ============================================================

-- Formação 3 (Basta! de Violência Contra a Mulher) — módulo ordem 1
UPDATE formation_modules
SET video_url = 'https://midiasave-5c064.web.app/bastamovie.mp4'
WHERE formation_id = 3 AND ordem = 1;

-- Verificar resultado
SELECT fm.id, fm.formation_id, f.nome AS formacao, fm.titulo, fm.video_url, fm.ordem
FROM formation_modules fm
JOIN formations f ON f.id = fm.formation_id
WHERE fm.formation_id = 3 AND fm.ordem = 1;
