-- ============================================================
-- Formação para Professores - Ética Editora
-- Script 02: Dados Mockados para Desenvolvimento e Testes
-- ============================================================

-- ============================================================
-- Escolas
-- ============================================================
INSERT INTO schools (nome, regiao) VALUES
    ('E.E. Prof. João Pessoa', 'Sudeste'),
    ('E.E. Maria Curie', 'Sul'),
    ('E.E. Santos Dumont', 'Nordeste')
ON CONFLICT DO NOTHING;

-- ============================================================
-- Codes de Acesso (10 códigos - 5 disponíveis, 5 usados)
-- ============================================================
INSERT INTO access_codes (code, school_id, nivel_acesso, used) VALUES
    ('ETICA2025A', 1, 'professor', FALSE),
    ('ETICA2025B', 1, 'professor', FALSE),
    ('ETICA2025C', 2, 'professor', FALSE),
    ('ETICA2025D', 2, 'coordenador', FALSE),
    ('ETICA2025E', 3, 'professor', FALSE),
    ('ETICA2025F', 1, 'professor', TRUE),
    ('ETICA2025G', 1, 'professor', TRUE),
    ('ETICA2025H', 2, 'professor', TRUE),
    ('ETICA2025I', 3, 'professor', TRUE),
    ('ETICA2025J', 3, 'diretor', TRUE)
ON CONFLICT DO NOTHING;

-- ============================================================
-- Usuários de Teste
-- Senha: teste123
-- Hash bcrypt gerado com: bcrypt.hash('teste123', 10)
-- ============================================================
INSERT INTO users (nome, email, senha_hash, school_id, nivel_acesso, access_code_id) VALUES
    ('Ana Silva', 'ana@escola.com', '$2b$10$IlUqKhmIvx8DVV5RcUpkx.2g8iUKtonGBteKpA/vV/D1uaexfsqPm', 1, 'professor', 6),
    ('Carlos Souza', 'carlos@escola.com', '$2b$10$IlUqKhmIvx8DVV5RcUpkx.2g8iUKtonGBteKpA/vV/D1uaexfsqPm', 2, 'coordenador', 7),
    ('Maria Santos', 'maria@escola.com', '$2b$10$IlUqKhmIvx8DVV5RcUpkx.2g8iUKtonGBteKpA/vV/D1uaexfsqPm', 3, 'professor', 8)
ON CONFLICT DO NOTHING;

-- Marcar os códigos como usados pelos usuários
UPDATE access_codes SET used_by = 1 WHERE code = 'ETICA2025F';
UPDATE access_codes SET used_by = 2 WHERE code = 'ETICA2025G';
UPDATE access_codes SET used_by = 3 WHERE code = 'ETICA2025H';

-- ============================================================
-- Formações (10 formações reais do design)
-- ============================================================
INSERT INTO formations (nome, descricao, thumb_url, ordem, ativo) VALUES
    ('Reforço Escolar Gamificado',
     'Aprenda técnicas de gamificação para tornar o reforço escolar mais eficaz e engajante.',
     'https://via.placeholder.com/400x300/FF6B00/FFFFFF?text=Gamificado', 1, TRUE),

    ('Paz nas Escolas',
     'Estratégias para promover uma cultura de paz e convivência harmoniosa no ambiente escolar.',
     'https://via.placeholder.com/400x300/00C853/FFFFFF?text=Paz', 2, TRUE),

    ('Basta! de Violência Contra a Mulher',
     'Formação para educadores sobre prevenção e combate à violência de gênero.',
     'https://via.placeholder.com/400x300/FF1744/FFFFFF?text=Basta', 3, TRUE),

    ('Feminicídio Zero',
     'Conscientização e ações práticas para prevenir o feminicídio através da educação.',
     'https://via.placeholder.com/400x300/E91E63/FFFFFF?text=Feminicidio', 4, TRUE),

    ('Vivenciando a Cultura Afro-Brasileira e Indígena',
     'Mergulhe na riqueza cultural afro-brasileira e indígena para enriquecer sua prática pedagógica.',
     'https://via.placeholder.com/400x300/795548/FFFFFF?text=Cultura', 5, TRUE),

    ('Educação no Trânsito',
     'Como ensinar educação para o trânsito de forma prática e contextualizada.',
     'https://via.placeholder.com/400x300/FF9800/FFFFFF?text=Transito', 6, TRUE),

    ('Energia Elétrica',
     'Fundamentos e práticas seguras sobre energia elétrica para o ambiente escolar.',
     'https://via.placeholder.com/400x300/FFEB3B/1A1A2E?text=Energia', 7, TRUE),

    ('Combate à Dengue',
     'Estratégias educativas para conscientizar alunos sobre prevenção da dengue.',
     'https://via.placeholder.com/400x300/4CAF50/FFFFFF?text=Dengue', 8, TRUE),

    ('Empreendedorismo na Adolescência',
     'Ferramentas para desenvolver o espírito empreendedor nos jovens estudantes.',
     'https://via.placeholder.com/400x300/2196F3/FFFFFF?text=Empreend', 9, TRUE),

    ('Educação Ambiental',
     'Práticas sustentáveis e conscientização ambiental para transformar sua escola.',
     'https://via.placeholder.com/400x300/009688/FFFFFF?text=Ambiental', 10, TRUE)
ON CONFLICT DO NOTHING;

-- ============================================================
-- Módulos (3 por formação = 30 módulos total)
-- ============================================================
-- NOTA: As URLs de vídeo abaixo são placeholders para desenvolvimento.
-- Em produção, substituir pelas URLs reais do Firebase Storage:
-- Padrão: https://firebasestorage.googleapis.com/v0/b/midiasave-5c064.firebasestorage.app/o/formacao-professores%2Fformations%2Fvideos%2F{formationId}%2F{timestamp}_{uuid4hex}.mp4?alt=media

-- Módulos: Reforço Escolar Gamificado (formation_id = 1)
INSERT INTO formation_modules (formation_id, titulo, descricao, video_url, ordem) VALUES
    (1, 'Introdução à Gamificação', 'O que é gamificação e como ela transforma a aprendizagem', 'https://midiasave-5c064.web.app/videonovo.mp4', 1),
    (1, 'Mecânicas de Jogos na Educação', 'Pontos, badges e rankings aplicados ao reforço escolar', 'https://www.youtube.com/watch?v=dQw4w9WgXcQ', 2),
    (1, 'Implementando na Prática', 'Criando seu primeiro plano de aula gamificado', 'https://www.youtube.com/watch?v=dQw4w9WgXcQ', 3);

-- Módulos: Paz nas Escolas (formation_id = 2)
INSERT INTO formation_modules (formation_id, titulo, descricao, video_url, ordem) VALUES
    (2, 'Cultura de Paz: Fundamentos', 'Princípios e valores para uma escola pacífica', 'https://midiasave-5c064.web.app/videonovo.mp4', 1),
    (2, 'Mediação de Conflitos', 'Técnicas práticas para resolver conflitos no ambiente escolar', 'https://www.youtube.com/watch?v=dQw4w9WgXcQ', 2),
    (2, 'Projetos de Paz', 'Como criar e implementar projetos de paz na sua escola', 'https://www.youtube.com/watch?v=dQw4w9WgXcQ', 3);

-- Módulos: Basta! (formation_id = 3)
INSERT INTO formation_modules (formation_id, titulo, descricao, video_url, ordem) VALUES
    (3, 'Reconhecendo a Violência', 'Tipos de violência contra a mulher e como identificá-los', 'https://midiasave-5c064.web.app/videonovo.mp4', 1),
    (3, 'O Papel do Educador', 'Como professores podem atuar na prevenção', 'https://www.youtube.com/watch?v=dQw4w9WgXcQ', 2),
    (3, 'Rede de Proteção', 'Encaminhamentos e recursos disponíveis na comunidade', 'https://www.youtube.com/watch?v=dQw4w9WgXcQ', 3);

-- Módulos: Feminicídio Zero (formation_id = 4)
INSERT INTO formation_modules (formation_id, titulo, descricao, video_url, ordem) VALUES
    (4, 'Contexto e Dados', 'Panorama do feminicídio no Brasil e no mundo', 'https://midiasave-5c064.web.app/videonovo.mp4', 1),
    (4, 'Legislação e Direitos', 'Lei Maria da Penha e outros marcos legais', 'https://www.youtube.com/watch?v=dQw4w9WgXcQ', 2),
    (4, 'Educação como Prevenção', 'Abordando o tema em sala de aula com responsabilidade', 'https://www.youtube.com/watch?v=dQw4w9WgXcQ', 3);

-- Módulos: Cultura Afro-Brasileira e Indígena (formation_id = 5)
INSERT INTO formation_modules (formation_id, titulo, descricao, video_url, ordem) VALUES
    (5, 'Raízes Africanas no Brasil', 'História e contribuições da cultura africana para o Brasil', 'https://midiasave-5c064.web.app/videonovo.mp4', 1),
    (5, 'Povos Indígenas Brasileiros', 'Diversidade e saberes dos povos originários', 'https://www.youtube.com/watch?v=dQw4w9WgXcQ', 2),
    (5, 'Lei 10.639/03 na Prática', 'Como aplicar a lei em seu plano pedagógico', 'https://www.youtube.com/watch?v=dQw4w9WgXcQ', 3);

-- Módulos: Educação no Trânsito (formation_id = 6)
INSERT INTO formation_modules (formation_id, titulo, descricao, video_url, ordem) VALUES
    (6, 'Segurança Viária nas Escolas', 'Fundamentos da educação para o trânsito seguro', 'https://midiasave-5c064.web.app/videonovo.mp4', 1),
    (6, 'Dinâmicas e Atividades', 'Jogos e simulações para aprender sobre trânsito', 'https://www.youtube.com/watch?v=dQw4w9WgXcQ', 2),
    (6, 'Projeto Escola Segura', 'Criando um projeto de educação no trânsito', 'https://www.youtube.com/watch?v=dQw4w9WgXcQ', 3);

-- Módulos: Energia Elétrica (formation_id = 7)
INSERT INTO formation_modules (formation_id, titulo, descricao, video_url, ordem) VALUES
    (7, 'Fundamentos da Eletricidade', 'Conceitos básicos para ensinar com segurança', 'https://www.youtube.com/watch?v=dQw4w9WgXcQ', 1),
    (7, 'Segurança Elétrica', 'Prevenção de acidentes elétricos no ambiente escolar', 'https://www.youtube.com/watch?v=dQw4w9WgXcQ', 2),
    (7, 'Experimentos Seguros', 'Experimentos práticos e seguros para a sala de aula', 'https://www.youtube.com/watch?v=dQw4w9WgXcQ', 3);

-- Módulos: Combate à Dengue (formation_id = 8)
INSERT INTO formation_modules (formation_id, titulo, descricao, video_url, ordem) VALUES
    (8, 'Conhecendo o Aedes Aegypti', 'Biologia e comportamento do mosquito transmissor', 'https://www.youtube.com/watch?v=dQw4w9WgXcQ', 1),
    (8, 'Prevenção na Prática', 'Como eliminar focos de mosquitos no cotidiano', 'https://www.youtube.com/watch?v=dQw4w9WgXcQ', 2),
    (8, 'Mobilizando a Comunidade', 'Projetos escolares de combate ao Aedes', 'https://www.youtube.com/watch?v=dQw4w9WgXcQ', 3);

-- Módulos: Empreendedorismo na Adolescência (formation_id = 9)
INSERT INTO formation_modules (formation_id, titulo, descricao, video_url, ordem) VALUES
    (9, 'Mentalidade Empreendedora', 'Desenvolvendo a criatividade e iniciativa nos jovens', 'https://www.youtube.com/watch?v=dQw4w9WgXcQ', 1),
    (9, 'Negócios na Escola', 'Mini-empresas e feiras de empreendedorismo', 'https://www.youtube.com/watch?v=dQw4w9WgXcQ', 2),
    (9, 'Projeto de Vida', 'Conectando empreendedorismo ao projeto de vida do aluno', 'https://www.youtube.com/watch?v=dQw4w9WgXcQ', 3);

-- Módulos: Educação Ambiental (formation_id = 10)
INSERT INTO formation_modules (formation_id, titulo, descricao, video_url, ordem) VALUES
    (10, 'Crise Climática e Escola', 'O papel da escola na conscientização ambiental', 'https://www.youtube.com/watch?v=dQw4w9WgXcQ', 1),
    (10, 'Práticas Sustentáveis', '3Rs, horta escolar e energia limpa na prática', 'https://www.youtube.com/watch?v=dQw4w9WgXcQ', 2),
    (10, 'Agenda 2030 na Educação', 'Conectando os ODS ao currículo escolar', 'https://www.youtube.com/watch?v=dQw4w9WgXcQ', 3);

-- ============================================================
-- Progresso variado dos 3 professores de teste
-- ============================================================

-- Ana Silva (user_id = 1): completou formações 1 e 2 inteiras, progresso parcial em 3 e 4
INSERT INTO user_progress (user_id, module_id, completed, completed_at) VALUES
    -- Formação 1 completa
    (1, 1, TRUE, NOW() - INTERVAL '15 days'),
    (1, 2, TRUE, NOW() - INTERVAL '14 days'),
    (1, 3, TRUE, NOW() - INTERVAL '13 days'),
    -- Formação 2 completa
    (1, 4, TRUE, NOW() - INTERVAL '12 days'),
    (1, 5, TRUE, NOW() - INTERVAL '11 days'),
    (1, 6, TRUE, NOW() - INTERVAL '10 days'),
    -- Formação 3 parcial (1 de 3)
    (1, 7, TRUE, NOW() - INTERVAL '5 days'),
    -- Formação 4 parcial (2 de 3)
    (1, 10, TRUE, NOW() - INTERVAL '3 days'),
    (1, 11, TRUE, NOW() - INTERVAL '2 days')
ON CONFLICT DO NOTHING;

-- Carlos Souza (user_id = 2): progresso em formações 5, 6 e 7
INSERT INTO user_progress (user_id, module_id, completed, completed_at) VALUES
    -- Formação 5 completa
    (2, 13, TRUE, NOW() - INTERVAL '20 days'),
    (2, 14, TRUE, NOW() - INTERVAL '19 days'),
    (2, 15, TRUE, NOW() - INTERVAL '18 days'),
    -- Formação 6 parcial (2 de 3)
    (2, 16, TRUE, NOW() - INTERVAL '10 days'),
    (2, 17, TRUE, NOW() - INTERVAL '9 days'),
    -- Formação 7 parcial (1 de 3)
    (2, 19, TRUE, NOW() - INTERVAL '3 days')
ON CONFLICT DO NOTHING;

-- Maria Santos (user_id = 3): progresso em formações 8, 9 e 10
INSERT INTO user_progress (user_id, module_id, completed, completed_at) VALUES
    -- Formação 8 completa
    (3, 22, TRUE, NOW() - INTERVAL '8 days'),
    (3, 23, TRUE, NOW() - INTERVAL '7 days'),
    (3, 24, TRUE, NOW() - INTERVAL '6 days'),
    -- Formação 9 parcial (1 de 3)
    (3, 25, TRUE, NOW() - INTERVAL '2 days'),
    -- Formação 10 completa
    (3, 28, TRUE, NOW() - INTERVAL '5 days'),
    (3, 29, TRUE, NOW() - INTERVAL '4 days'),
    (3, 30, TRUE, NOW() - INTERVAL '3 days')
ON CONFLICT DO NOTHING;

-- ============================================================
-- Badges (2 por formação = 20 badges)
-- ============================================================
INSERT INTO badges (formation_id, nome, descricao, criterio_percentual) VALUES
    -- Formação 1
    (1, 'Mestre da Gamificação', 'Concluiu 50% da formação Reforço Escolar Gamificado', 50),
    (1, 'Educador Inovador', 'Concluiu 100% da formação Reforço Escolar Gamificado', 100),
    -- Formação 2
    (2, 'Embaixador da Paz', 'Concluiu 50% da formação Paz nas Escolas', 50),
    (2, 'Construtor de Paz', 'Concluiu 100% da formação Paz nas Escolas', 100),
    -- Formação 3
    (3, 'Voz Ativa', 'Concluiu 50% da formação Basta! de Violência', 50),
    (3, 'Defensor dos Direitos', 'Concluiu 100% da formação Basta! de Violência', 100),
    -- Formação 4
    (4, 'Consciência de Gênero', 'Concluiu 50% da formação Feminicídio Zero', 50),
    (4, 'Agente de Mudança', 'Concluiu 100% da formação Feminicídio Zero', 100),
    -- Formação 5
    (5, 'Raízes Culturais', 'Concluiu 50% da formação Cultura Afro-Brasileira e Indígena', 50),
    (5, 'Guardião da Memória', 'Concluiu 100% da formação Cultura Afro-Brasileira e Indígena', 100),
    -- Formação 6
    (6, 'Pedestre Consciente', 'Concluiu 50% da formação Educação no Trânsito', 50),
    (6, 'Agente de Trânsito', 'Concluiu 100% da formação Educação no Trânsito', 100),
    -- Formação 7
    (7, 'Faísca do Saber', 'Concluiu 50% da formação Energia Elétrica', 50),
    (7, 'Eletrizante', 'Concluiu 100% da formação Energia Elétrica', 100),
    -- Formação 8
    (8, 'Caçador do Aedes', 'Concluiu 50% da formação Combate à Dengue', 50),
    (8, 'Guardião da Saúde', 'Concluiu 100% da formação Combate à Dengue', 100),
    -- Formação 9
    (9, 'Espírito Empreendedor', 'Concluiu 50% da formação Empreendedorismo', 50),
    (9, 'Mentor de Talentos', 'Concluiu 100% da formação Empreendedorismo', 100),
    -- Formação 10
    (10, 'Eco Educador', 'Concluiu 50% da formação Educação Ambiental', 50),
    (10, 'Guardião do Planeta', 'Concluiu 100% da formação Educação Ambiental', 100)
ON CONFLICT DO NOTHING;

-- ============================================================
-- Conquistas desbloqueadas pelos professores de teste
-- ============================================================
INSERT INTO user_badges (user_id, badge_id, conquistado_em) VALUES
    -- Ana Silva: completou formações 1 e 2 → 4 badges
    (1, 1, NOW() - INTERVAL '13 days'),  -- Mestre da Gamificação (50%)
    (1, 2, NOW() - INTERVAL '13 days'),  -- Educador Inovador (100%)
    (1, 3, NOW() - INTERVAL '10 days'),  -- Embaixador da Paz (50%)
    (1, 4, NOW() - INTERVAL '10 days'),  -- Construtor de Paz (100%)
    -- Carlos Souza: completou formação 5 → 2 badges
    (2, 9, NOW() - INTERVAL '18 days'),   -- Raízes Culturais (50%)
    (2, 10, NOW() - INTERVAL '18 days'),  -- Guardião da Memória (100%)
    -- Maria Santos: completou formações 8 e 10 → 4 badges
    (3, 15, NOW() - INTERVAL '6 days'),   -- Caçador do Aedes (50%)
    (3, 16, NOW() - INTERVAL '6 days'),   -- Guardião da Saúde (100%)
    (3, 19, NOW() - INTERVAL '3 days'),   -- Eco Educador (50%)
    (3, 20, NOW() - INTERVAL '3 days')    -- Guardião do Planeta (100%)
ON CONFLICT DO NOTHING;

-- ============================================================
-- Notificações de exemplo
-- ============================================================
INSERT INTO notifications (user_id, formation_id, titulo, mensagem, lida) VALUES
    (1, 3, 'Nova formação disponível!', 'A formação "Basta! de Violência Contra a Mulher" está esperando por você. Comece agora!', FALSE),
    (1, NULL, 'Parabéns pela conquista!', 'Você desbloqueou o badge "Construtor de Paz". Continue sua jornada!', TRUE),
    (2, 6, 'Continue de onde parou', 'Você está com 67% na formação "Educação no Trânsito". Falta pouco para concluir!', FALSE),
    (3, 9, 'Novo módulo disponível', 'O módulo "Negócios na Escola" já está disponível na formação de Empreendedorismo.', FALSE),
    (3, NULL, 'Dica de estudo', 'Que tal continuar a formação de Empreendedorismo hoje? Invista no seu desenvolvimento!', TRUE)
ON CONFLICT DO NOTHING;
