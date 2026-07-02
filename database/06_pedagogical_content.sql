-- ============================================================
-- Script 06: Conteúdos pedagógicos extras
-- Ementa, calendário, planos de aula e vídeos lembrete
-- ============================================================

CREATE TABLE IF NOT EXISTS page_reminders (
    id                  SERIAL PRIMARY KEY,
    page_key            VARCHAR(100) UNIQUE NOT NULL,
    title               VARCHAR(200) NOT NULL,
    description         TEXT NOT NULL,
    media_url           VARCHAR(500) NOT NULL,
    thumbnail_url       VARCHAR(500),
    transcript          TEXT NOT NULL,
    duration_seconds    INT DEFAULT 0,
    active              BOOLEAN DEFAULT TRUE,
    "order"             INT DEFAULT 0,
    created_at          TIMESTAMP DEFAULT NOW(),
    updated_at          TIMESTAMP DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_page_reminders_active ON page_reminders(active);
CREATE INDEX IF NOT EXISTS idx_page_reminders_order ON page_reminders("order");

CREATE TABLE IF NOT EXISTS syllabus_sections (
    id              SERIAL PRIMARY KEY,
    title           VARCHAR(200) NOT NULL,
    content         TEXT NOT NULL,
    section_type    VARCHAR(80) UNIQUE NOT NULL,
    "order"         INT DEFAULT 0,
    active          BOOLEAN DEFAULT TRUE,
    created_at      TIMESTAMP DEFAULT NOW(),
    updated_at      TIMESTAMP DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_syllabus_sections_active ON syllabus_sections(active);
CREATE INDEX IF NOT EXISTS idx_syllabus_sections_order ON syllabus_sections("order");

CREATE TABLE IF NOT EXISTS lesson_plans (
    id                      SERIAL PRIMARY KEY,
    title                   VARCHAR(200) NOT NULL,
    chapter                 VARCHAR(80) NOT NULL,
    theme                   VARCHAR(200) NOT NULL,
    week_number             INT NOT NULL,
    lesson_number           INT NOT NULL,
    duration_minutes        INT DEFAULT 50,
    general_objective       TEXT NOT NULL,
    specific_objectives     JSONB DEFAULT '[]'::jsonb,
    main_activity           TEXT NOT NULL,
    methodology             TEXT NOT NULL,
    required_resources      JSONB DEFAULT '[]'::jsonb,
    bncc_skills             JSONB DEFAULT '[]'::jsonb,
    bncc_competencies       JSONB DEFAULT '[]'::jsonb,
    teacher_guidance        TEXT NOT NULL,
    assessment              TEXT NOT NULL,
    complementary_materials JSONB DEFAULT '[]'::jsonb,
    attachment_url          VARCHAR(500),
    reminder_id             INT REFERENCES page_reminders(id) ON DELETE SET NULL,
    active                  BOOLEAN DEFAULT TRUE,
    "order"                 INT DEFAULT 0,
    created_at              TIMESTAMP DEFAULT NOW(),
    updated_at              TIMESTAMP DEFAULT NOW(),
    UNIQUE(title, week_number, lesson_number)
);

CREATE INDEX IF NOT EXISTS idx_lesson_plans_week ON lesson_plans(week_number);
CREATE INDEX IF NOT EXISTS idx_lesson_plans_chapter ON lesson_plans(chapter);
CREATE INDEX IF NOT EXISTS idx_lesson_plans_active ON lesson_plans(active);
CREATE INDEX IF NOT EXISTS idx_lesson_plans_bncc_skills ON lesson_plans USING GIN (bncc_skills);

CREATE TABLE IF NOT EXISTS calendar_entries (
    id                      SERIAL PRIMARY KEY,
    date                    DATE NOT NULL,
    week_number             INT NOT NULL,
    lesson_number           INT NOT NULL,
    chapter                 VARCHAR(80) NOT NULL,
    theme                   VARCHAR(200) NOT NULL,
    objective               TEXT NOT NULL,
    activity                TEXT NOT NULL,
    activity_type           VARCHAR(80) NOT NULL,
    bncc_skills             JSONB DEFAULT '[]'::jsonb,
    bncc_competency         TEXT NOT NULL,
    status                  VARCHAR(80) DEFAULT 'planejado',
    complementary_material  VARCHAR(500),
    video_url               VARCHAR(500),
    lesson_plan_id          INT REFERENCES lesson_plans(id) ON DELETE SET NULL,
    reminder_id             INT REFERENCES page_reminders(id) ON DELETE SET NULL,
    active                  BOOLEAN DEFAULT TRUE,
    created_at              TIMESTAMP DEFAULT NOW(),
    updated_at              TIMESTAMP DEFAULT NOW(),
    UNIQUE(week_number, lesson_number, chapter, activity_type)
);

CREATE INDEX IF NOT EXISTS idx_calendar_entries_date ON calendar_entries(date);
CREATE INDEX IF NOT EXISTS idx_calendar_entries_week ON calendar_entries(week_number);
CREATE INDEX IF NOT EXISTS idx_calendar_entries_chapter ON calendar_entries(chapter);
CREATE INDEX IF NOT EXISTS idx_calendar_entries_type ON calendar_entries(activity_type);
CREATE INDEX IF NOT EXISTS idx_calendar_entries_active ON calendar_entries(active);

DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_trigger WHERE tgname = 'update_page_reminders_updated_at') THEN
        CREATE TRIGGER update_page_reminders_updated_at
            BEFORE UPDATE ON page_reminders
            FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_trigger WHERE tgname = 'update_syllabus_sections_updated_at') THEN
        CREATE TRIGGER update_syllabus_sections_updated_at
            BEFORE UPDATE ON syllabus_sections
            FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_trigger WHERE tgname = 'update_lesson_plans_updated_at') THEN
        CREATE TRIGGER update_lesson_plans_updated_at
            BEFORE UPDATE ON lesson_plans
            FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_trigger WHERE tgname = 'update_calendar_entries_updated_at') THEN
        CREATE TRIGGER update_calendar_entries_updated_at
            BEFORE UPDATE ON calendar_entries
            FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
    END IF;
END $$;

INSERT INTO page_reminders
    (page_key, title, description, media_url, thumbnail_url, transcript, duration_seconds, "order")
VALUES
    (
        'syllabus',
        'Como consultar a ementa',
        'Explicação em voz sobre a proposta pedagógica do projeto.',
        'https://midiasave-5c064.web.app/videonovo.mp4',
        'https://via.placeholder.com/800x450/F37127/FFFFFF?text=Ementa',
        'Nesta página você encontra a proposta pedagógica do projeto, incluindo objetivos, metodologia, carga horária, avaliação, competências gerais e habilidades da BNCC trabalhadas.',
        95,
        1
    ),
    (
        'calendar',
        'Como utilizar o calendário',
        'Orientação rápida sobre semanas, aulas, filtros e atividades.',
        'https://midiasave-5c064.web.app/videonovo.mp4',
        'https://via.placeholder.com/800x450/F37127/FFFFFF?text=Calendario',
        'O calendário organiza as aulas por semana, capítulo e tipo de atividade. Use os filtros para localizar debates, quizzes, vídeos e materiais complementares.',
        88,
        2
    ),
    (
        'lesson-plans',
        'Como acessar os planos de aula',
        'Explicação para consultar objetivos, BNCC, recursos e avaliação.',
        'https://midiasave-5c064.web.app/videonovo.mp4',
        'https://via.placeholder.com/800x450/F37127/FFFFFF?text=Planos',
        'Os planos de aula detalham objetivos, preparação, desenvolvimento, atividades, competências BNCC, avaliação e orientações ao professor.',
        102,
        3
    ),
    (
        'activities',
        'Como acompanhar atividades',
        'Guia sobre aulas, atividades no app, debates, quizzes e vídeos.',
        'https://midiasave-5c064.web.app/videonovo.mp4',
        'https://via.placeholder.com/800x450/F37127/FFFFFF?text=Atividades',
        'Cada atividade possui um tipo e um status. Abra os cards para ver objetivo, atividade proposta, habilidade BNCC e o plano relacionado.',
        76,
        4
    ),
    (
        'bncc',
        'Como consultar BNCC',
        'Explicação sobre habilidades e competências nos conteúdos.',
        'https://midiasave-5c064.web.app/videonovo.mp4',
        'https://via.placeholder.com/800x450/F37127/FFFFFF?text=BNCC',
        'As habilidades BNCC aparecem como códigos e as competências indicam as dimensões gerais trabalhadas em cada aula ou plano.',
        82,
        5
    )
ON CONFLICT (page_key) DO NOTHING;

INSERT INTO syllabus_sections (title, content, section_type, "order") VALUES
    ('Formação para Professores', 'Projeto de formação continuada para apoiar educadores na mediação de temas sensíveis, no uso de recursos digitais e na promoção de relações respeitosas no ambiente escolar.', 'overview', 1),
    ('Público-alvo', 'Professores e coordenadores pedagógicos parceiros da Ética Editora, especialmente profissionais dos anos finais do Ensino Fundamental.', 'targetAudience', 2),
    ('Objetivo geral', 'Fortalecer práticas pedagógicas voltadas à convivência ética, ao diálogo, à prevenção de violências e à construção de uma cultura de respeito.', 'generalObjective', 3),
    ('Objetivos específicos', 'Identificar relações saudáveis e abusivas; propor estratégias de empatia e diálogo; relacionar atividades pedagógicas às habilidades BNCC; utilizar recursos digitais como apoio à formação.', 'specificObjectives', 4),
    ('Metodologia', 'A metodologia combina leitura orientada, atividades no app, debates, quizzes, vídeos, análise de situações-problema e propostas de aplicação em sala.', 'methodology', 5),
    ('Carga horária', 'Carga horária sugerida de 20 horas, distribuídas em encontros, atividades assíncronas e momentos de reflexão pedagógica.', 'workload', 6),
    ('Organização dos conteúdos', 'Os conteúdos são organizados por capítulos, semanas, aulas e atividades. Cada item possui objetivo, atividade principal, habilidades BNCC e competência geral relacionada.', 'contents', 7),
    ('Recursos pedagógicos', 'Vídeos, livros PDF, planos de aula, calendário pedagógico, quizzes, debates, materiais complementares e vídeos lembrete com narração explicativa.', 'resources', 8),
    ('Formas de avaliação', 'A avaliação considera participação, realização das atividades propostas, reflexão pedagógica, registro de progresso e aplicação das estratégias no contexto escolar.', 'assessment', 9),
    ('Competências gerais trabalhadas', 'Competência Geral 6, relacionada à valorização da diversidade de saberes e vivências culturais, e Competência Geral 9, relacionada à empatia, diálogo, resolução de conflitos e cooperação.', 'competencies', 10),
    ('Habilidades da BNCC', 'Exemplos iniciais: EF06ER09, EF07ER08 e EF07LP10, trabalhadas por meio de debates, atividades interativas, análise de textos e práticas de convivência.', 'bnccSkills', 11),
    ('Materiais complementares', 'Materiais de apoio podem incluir PDFs da coleção Basta!, roteiros de discussão, links de vídeo e arquivos anexos indicados nos planos de aula.', 'complementaryMaterials', 12)
ON CONFLICT (section_type) DO NOTHING;

INSERT INTO lesson_plans
    (title, chapter, theme, week_number, lesson_number, duration_minutes, general_objective, specific_objectives, main_activity, methodology, required_resources, bncc_skills, bncc_competencies, teacher_guidance, assessment, complementary_materials, attachment_url, reminder_id, "order")
VALUES
    (
        'Relações tóxicas ou abusivas',
        '1',
        'O que são Relações Tóxicas ou Abusivas?',
        1,
        1,
        50,
        'Definir e distinguir relações saudáveis de relações tóxicas ou abusivas.',
        '["Reconhecer sinais de relações abusivas", "Construir critérios de convivência respeitosa", "Relacionar o tema à empatia e ao diálogo"]'::jsonb,
        'Discussão em grupo para identificar comportamentos tóxicos e propor novas regras de convivência.',
        'Aula dialogada com levantamento de conhecimentos prévios, discussão orientada e registro coletivo de combinados.',
        '["Quadro ou projetor", "Cartões de situações-problema", "Caderno de registro"]'::jsonb,
        '["EF06ER09"]'::jsonb,
        '["Competência Geral 9"]'::jsonb,
        'Conduza a conversa com cuidado, evitando exposição pessoal dos alunos e privilegiando exemplos fictícios.',
        'Participação no debate e qualidade das propostas de convivência elaboradas pelo grupo.',
        '["Roteiro de discussão", "PDF da coleção Basta!"]'::jsonb,
        NULL,
        (SELECT id FROM page_reminders WHERE page_key = 'lesson-plans'),
        1
    ),
    (
        'Quiz de relações saudáveis',
        '1',
        'O que são Relações Tóxicas ou Abusivas?',
        2,
        2,
        40,
        'Fixar a diferença entre relações saudáveis e tóxicas por meio de feedback imediato.',
        '["Distinguir comportamentos saudáveis e tóxicos", "Justificar respostas", "Revisar combinados de convivência"]'::jsonb,
        'Quiz interativo de verdadeiro ou falso, com feedback imediato.',
        'Atividade gamificada no app, seguida de breve discussão sobre as respostas mais desafiadoras.',
        '["Celular com o app", "Projetor opcional", "Registro de pontuação formativa"]'::jsonb,
        '["EF06ER09"]'::jsonb,
        '["Competência Geral 9"]'::jsonb,
        'Use os erros do quiz como oportunidade de conversa, sem ranquear alunos publicamente.',
        'Acompanhamento das respostas e justificativas dadas pelos estudantes.',
        '["Quiz no app", "Resumo dos sinais de alerta"]'::jsonb,
        NULL,
        (SELECT id FROM page_reminders WHERE page_key = 'activities'),
        2
    ),
    (
        'Harmonia nas relações',
        '3',
        'Harmonia nas Relações: Estratégias',
        5,
        5,
        50,
        'Conhecer e aplicar estratégias de empatia, diálogo e estabelecimento de limites.',
        '["Identificar estratégias de diálogo", "Analisar representações de masculinidade", "Valorizar diversidade de vivências"]'::jsonb,
        'Sessão de cinema e debate utilizando o documentário The Mask You Live, seguida da aplicação dos parâmetros de uma relação saudável.',
        'Exibição orientada, debate mediado e produção de síntese em pequenos grupos.',
        '["Trecho de vídeo", "Roteiro de debate", "Cartaz ou mural de síntese"]'::jsonb,
        '["EF07ER08", "EF07LP10"]'::jsonb,
        '["Competência Geral 6"]'::jsonb,
        'Contextualize o vídeo antes da exibição e estabeleça combinados de escuta para o debate.',
        'Síntese do grupo e participação respeitosa na discussão.',
        '["Roteiro Cine-debate", "Parâmetros de relação saudável"]'::jsonb,
        NULL,
        (SELECT id FROM page_reminders WHERE page_key = 'bncc'),
        3
    ),
    (
        'Simulador de diálogo',
        '3',
        'Harmonia nas Relações: Estratégias',
        6,
        3,
        45,
        'Aplicar estratégias de empatia e diálogo em situações simuladas.',
        '["Escolher respostas adequadas", "Avaliar consequências de falas", "Praticar escuta ativa"]'::jsonb,
        'Recurso de role-playing em que o aluno escolhe entre diferentes respostas para uma situação de conflito.',
        'Simulação guiada com discussão posterior sobre escolhas, consequências e alternativas.',
        '["Celular com o app", "Situações de conflito", "Ficha de observação"]'::jsonb,
        '["EF07LP10"]'::jsonb,
        '["Competência Geral 7"]'::jsonb,
        'Reforce que o objetivo é aprender possibilidades de diálogo, não encontrar uma única frase perfeita.',
        'Justificativa das escolhas feitas e reflexão sobre alternativas de resposta.',
        '["Simulador no app", "Ficha de reflexão"]'::jsonb,
        NULL,
        (SELECT id FROM page_reminders WHERE page_key = 'activities'),
        4
    )
ON CONFLICT (title, week_number, lesson_number) DO NOTHING;

INSERT INTO calendar_entries
    (date, week_number, lesson_number, chapter, theme, objective, activity, activity_type, bncc_skills, bncc_competency, status, complementary_material, video_url, lesson_plan_id, reminder_id)
VALUES
    (
        '2026-08-03',
        1,
        1,
        '1',
        'O que são Relações Tóxicas ou Abusivas?',
        'Definir e distinguir relações saudáveis de relações tóxicas ou abusivas.',
        'Discussão em grupo para identificar comportamentos tóxicos e propor novas regras de convivência.',
        'Aula',
        '["EF06ER09"]'::jsonb,
        'Competência Geral 9 - exercitar a empatia, o diálogo, a resolução de conflitos e a cooperação.',
        'planejado',
        'Roteiro de discussão',
        NULL,
        (SELECT id FROM lesson_plans WHERE title = 'Relações tóxicas ou abusivas'),
        (SELECT id FROM page_reminders WHERE page_key = 'calendar')
    ),
    (
        '2026-08-10',
        2,
        2,
        '1',
        'O que são Relações Tóxicas ou Abusivas?',
        'Definir e distinguir relações saudáveis de relações tóxicas ou abusivas.',
        'Quiz interativo de verdadeiro ou falso para fixar a diferença entre relações saudáveis e tóxicas.',
        'Atividade no app',
        '["EF06ER09"]'::jsonb,
        'Competência Geral 9.',
        'planejado',
        'Quiz no app',
        NULL,
        (SELECT id FROM lesson_plans WHERE title = 'Quiz de relações saudáveis'),
        (SELECT id FROM page_reminders WHERE page_key = 'activities')
    ),
    (
        '2026-08-31',
        5,
        5,
        '3',
        'Harmonia nas Relações: Estratégias',
        'Conhecer e aplicar estratégias de empatia, diálogo e estabelecimento de limites.',
        'Sessão Cine-debate com o documentário The Mask You Live e aplicação dos parâmetros de uma relação saudável.',
        'Debate',
        '["EF07ER08", "EF07LP10"]'::jsonb,
        'Competência Geral 6 - valorizar a diversidade de saberes e vivências culturais.',
        'planejado',
        'Roteiro Cine-debate',
        'https://midiasave-5c064.web.app/videonovo.mp4',
        (SELECT id FROM lesson_plans WHERE title = 'Harmonia nas relações'),
        (SELECT id FROM page_reminders WHERE page_key = 'bncc')
    ),
    (
        '2026-09-08',
        6,
        3,
        '3',
        'Harmonia nas Relações: Estratégias',
        'Aplicar estratégias de empatia e diálogo em situações simuladas.',
        'Simulador de diálogo com escolha de respostas para uma situação de conflito.',
        'Quiz',
        '["EF07LP10"]'::jsonb,
        'Competência Geral 7 - argumentação e posicionamento responsável.',
        'planejado',
        'Simulador no app',
        NULL,
        (SELECT id FROM lesson_plans WHERE title = 'Simulador de diálogo'),
        (SELECT id FROM page_reminders WHERE page_key = 'activities')
    ),
    (
        '2026-09-15',
        7,
        4,
        '3',
        'Harmonia nas Relações: Estratégias',
        'Retomar conceitos centrais por meio de vídeo curto.',
        'Vídeo lembrete com síntese das estratégias de escuta, limites e diálogo.',
        'Vídeo',
        '["EF07LP10"]'::jsonb,
        'Competência Geral 9.',
        'planejado',
        NULL,
        'https://midiasave-5c064.web.app/videonovo.mp4',
        NULL,
        (SELECT id FROM page_reminders WHERE page_key = 'calendar')
    )
ON CONFLICT (week_number, lesson_number, chapter, activity_type) DO NOTHING;
