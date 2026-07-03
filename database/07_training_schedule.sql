-- ============================================================
-- Script 07: Cronograma Formativo
-- Índice pedagógico que abre PDFs em páginas específicas.
-- ============================================================

CREATE TABLE IF NOT EXISTS training_schedule_items (
    id              SERIAL PRIMARY KEY,
    title           VARCHAR(200) NOT NULL,
    subtitle        VARCHAR(240),
    chapter         VARCHAR(80),
    "order"         INT DEFAULT 0,
    document_id     INT NOT NULL,
    document_url    VARCHAR(500) NOT NULL,
    start_page      INT,
    thumbnail_url   VARCHAR(500),
    active          BOOLEAN DEFAULT TRUE,
    created_at      TIMESTAMP DEFAULT NOW(),
    updated_at      TIMESTAMP DEFAULT NOW(),
    UNIQUE(document_id, start_page, title)
);

CREATE INDEX IF NOT EXISTS idx_training_schedule_active
    ON training_schedule_items(active);

CREATE INDEX IF NOT EXISTS idx_training_schedule_order
    ON training_schedule_items("order");

DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_trigger WHERE tgname = 'update_training_schedule_items_updated_at') THEN
        CREATE TRIGGER update_training_schedule_items_updated_at
            BEFORE UPDATE ON training_schedule_items
            FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
    END IF;
END $$;

INSERT INTO training_schedule_items
    (title, subtitle, chapter, "order", document_id, document_url, start_page, thumbnail_url)
VALUES
    (
        'Fundamentos do projeto',
        NULL,
        NULL,
        1,
        10,
        'assets/pdfs/basta/anos_finais_professor.pdf',
        5,
        NULL
    ),
    (
        'Cronograma de aplicabilidade',
        NULL,
        NULL,
        2,
        10,
        'assets/pdfs/basta/anos_finais_professor.pdf',
        13,
        NULL
    ),
    (
        'Plano de trabalho',
        NULL,
        NULL,
        3,
        10,
        'assets/pdfs/basta/anos_finais_professor.pdf',
        30,
        NULL
    ),
    (
        'Capítulo 1',
        'O que são Relações Tóxicas ou Abusivas?',
        '1',
        4,
        10,
        'assets/pdfs/basta/anos_finais_professor.pdf',
        31,
        NULL
    ),
    (
        'Capítulo 2',
        'A Sombra do Abuso: Desvelando os Desafios',
        '2',
        5,
        10,
        'assets/pdfs/basta/anos_finais_professor.pdf',
        36,
        NULL
    ),
    (
        'Capítulo 3',
        'Harmonia nas Relações: Estratégias',
        '3',
        6,
        10,
        'assets/pdfs/basta/anos_finais_professor.pdf',
        41,
        NULL
    ),
    (
        'Capítulo 4',
        'A Jornada das Meninas Fragmentadas: Desafios e Resiliência',
        '4',
        7,
        10,
        'assets/pdfs/basta/anos_finais_professor.pdf',
        46,
        NULL
    ),
    (
        'Capítulo 5',
        'A Arte de se Amar: Autodescoberta e Aceitação',
        '5',
        8,
        10,
        'assets/pdfs/basta/anos_finais_professor.pdf',
        51,
        NULL
    ),
    (
        'Capítulo 6',
        'Desvendando os Padrões do Abusador: Uma Análise Crítica',
        '6',
        9,
        10,
        'assets/pdfs/basta/anos_finais_professor.pdf',
        56,
        NULL
    ),
    (
        'Capítulo 7',
        'Gênero e Sexo: Explorando Identidades',
        '7',
        10,
        10,
        'assets/pdfs/basta/anos_finais_professor.pdf',
        61,
        NULL
    ),
    (
        'Capítulo 8',
        'Consolidação e Avaliação Integrada',
        '8',
        11,
        10,
        'assets/pdfs/basta/anos_finais_professor.pdf',
        66,
        NULL
    ),
    (
        'Capítulo 9',
        'Encerramento do Projeto e Cidadania Ativa',
        '9',
        12,
        10,
        'assets/pdfs/basta/anos_finais_professor.pdf',
        71,
        NULL
    ),
    (
        'Referências',
        NULL,
        NULL,
        13,
        10,
        'assets/pdfs/basta/anos_finais_professor.pdf',
        76,
        NULL
    )
ON CONFLICT (document_id, start_page, title) DO NOTHING;
