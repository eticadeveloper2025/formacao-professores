-- ============================================================
-- Formação para Professores - Ética Editora
-- Script 03: Códigos de Acesso Pré-cadastrados
-- ============================================================
-- Este script adiciona códigos de acesso extras para distribuição
-- Use para gerar novos lotes de códigos para as escolas
-- ============================================================

-- Lote 2025 - Escola João Pessoa (school_id = 1)
INSERT INTO access_codes (code, school_id, nivel_acesso, used) VALUES
    ('JP2025-001', 1, 'professor', FALSE),
    ('JP2025-002', 1, 'professor', FALSE),
    ('JP2025-003', 1, 'professor', FALSE),
    ('JP2025-004', 1, 'professor', FALSE),
    ('JP2025-005', 1, 'professor', FALSE),
    ('JP2025-COORD', 1, 'coordenador', FALSE),
    ('JP2025-DIR', 1, 'diretor', FALSE)
ON CONFLICT DO NOTHING;

-- Lote 2025 - Escola Maria Curie (school_id = 2)
INSERT INTO access_codes (code, school_id, nivel_acesso, used) VALUES
    ('MC2025-001', 2, 'professor', FALSE),
    ('MC2025-002', 2, 'professor', FALSE),
    ('MC2025-003', 2, 'professor', FALSE),
    ('MC2025-004', 2, 'professor', FALSE),
    ('MC2025-005', 2, 'professor', FALSE),
    ('MC2025-COORD', 2, 'coordenador', FALSE)
ON CONFLICT DO NOTHING;

-- Lote 2025 - Escola Santos Dumont (school_id = 3)
INSERT INTO access_codes (code, school_id, nivel_acesso, used) VALUES
    ('SD2025-001', 3, 'professor', FALSE),
    ('SD2025-002', 3, 'professor', FALSE),
    ('SD2025-003', 3, 'professor', FALSE),
    ('SD2025-004', 3, 'professor', FALSE),
    ('SD2025-005', 3, 'professor', FALSE),
    ('SD2025-COORD', 3, 'coordenador', FALSE),
    ('SD2025-DIR', 3, 'diretor', FALSE)
ON CONFLICT DO NOTHING;

-- Códigos genéricos de demonstração
INSERT INTO access_codes (code, nivel_acesso, used) VALUES
    ('DEMO-PROF-01', 'professor', FALSE),
    ('DEMO-PROF-02', 'professor', FALSE),
    ('DEMO-PROF-03', 'professor', FALSE),
    ('DEMO-COORD-01', 'coordenador', FALSE),
    ('DEMO-DIR-01', 'diretor', FALSE)
ON CONFLICT DO NOTHING;

-- Consulta para verificar disponibilidade
-- SELECT code, nivel_acesso, used, school_id FROM access_codes WHERE used = FALSE ORDER BY school_id, nivel_acesso;
