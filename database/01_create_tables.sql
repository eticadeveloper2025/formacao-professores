-- ============================================================
-- Formação para Professores - Ética Editora
-- Script 01: Criação de Todas as Tabelas
-- ============================================================

-- Extensão para geração de UUIDs (caso necessário no futuro)
-- CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ============================================================
-- Tabela: schools (Escolas)
-- ============================================================
CREATE TABLE IF NOT EXISTS schools (
    id          SERIAL PRIMARY KEY,
    nome        VARCHAR(200) NOT NULL,
    regiao      VARCHAR(100) NOT NULL,
    created_at  TIMESTAMP DEFAULT NOW(),
    updated_at  TIMESTAMP DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_schools_nome ON schools(nome);
CREATE INDEX IF NOT EXISTS idx_schools_regiao ON schools(regiao);

-- ============================================================
-- Tabela: access_codes (Códigos de Acesso)
-- ============================================================
CREATE TABLE IF NOT EXISTS access_codes (
    id          SERIAL PRIMARY KEY,
    code        VARCHAR(50) UNIQUE NOT NULL,
    school_id   INT REFERENCES schools(id) ON DELETE SET NULL,
    nivel_acesso VARCHAR(50) DEFAULT 'professor',
    used        BOOLEAN DEFAULT FALSE,
    used_by     INT,
    created_at  TIMESTAMP DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_access_codes_code ON access_codes(code);
CREATE INDEX IF NOT EXISTS idx_access_codes_school ON access_codes(school_id);

-- ============================================================
-- Tabela: users (Usuários / Professores)
-- ============================================================
CREATE TABLE IF NOT EXISTS users (
    id              SERIAL PRIMARY KEY,
    nome            VARCHAR(200) NOT NULL,
    email           VARCHAR(200) UNIQUE NOT NULL,
    senha_hash      VARCHAR(255) NOT NULL,
    school_id       INT REFERENCES schools(id) ON DELETE SET NULL,
    nivel_acesso    VARCHAR(50) DEFAULT 'professor',
    access_code_id  INT REFERENCES access_codes(id) ON DELETE SET NULL,
    avatar_url      VARCHAR(500),
    created_at      TIMESTAMP DEFAULT NOW(),
    updated_at      TIMESTAMP DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);
CREATE INDEX IF NOT EXISTS idx_users_school ON users(school_id);

-- ============================================================
-- Tabela: formations (Formações / Coleções)
-- ============================================================
CREATE TABLE IF NOT EXISTS formations (
    id          SERIAL PRIMARY KEY,
    nome        VARCHAR(200) NOT NULL,
    descricao   TEXT,
    thumb_url   VARCHAR(500),
    ordem       INT DEFAULT 0,
    ativo       BOOLEAN DEFAULT TRUE,
    created_at  TIMESTAMP DEFAULT NOW(),
    updated_at  TIMESTAMP DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_formations_ativo ON formations(ativo);
CREATE INDEX IF NOT EXISTS idx_formations_ordem ON formations(ordem);

-- ============================================================
-- Tabela: formation_modules (Módulos das Formações)
-- ============================================================
CREATE TABLE IF NOT EXISTS formation_modules (
    id              SERIAL PRIMARY KEY,
    formation_id    INT NOT NULL REFERENCES formations(id) ON DELETE CASCADE,
    titulo          VARCHAR(200) NOT NULL,
    descricao       TEXT,
    video_url       VARCHAR(500),
    ordem           INT DEFAULT 0,
    created_at      TIMESTAMP DEFAULT NOW(),
    updated_at      TIMESTAMP DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_modules_formation ON formation_modules(formation_id);
CREATE INDEX IF NOT EXISTS idx_modules_ordem ON formation_modules(ordem);

-- ============================================================
-- Tabela: user_progress (Progresso dos Professores)
-- ============================================================
CREATE TABLE IF NOT EXISTS user_progress (
    id              SERIAL PRIMARY KEY,
    user_id         INT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    module_id       INT NOT NULL REFERENCES formation_modules(id) ON DELETE CASCADE,
    completed       BOOLEAN DEFAULT FALSE,
    completed_at    TIMESTAMP,
    created_at      TIMESTAMP DEFAULT NOW(),
    UNIQUE(user_id, module_id)
);

CREATE INDEX IF NOT EXISTS idx_progress_user ON user_progress(user_id);
CREATE INDEX IF NOT EXISTS idx_progress_module ON user_progress(module_id);
CREATE INDEX IF NOT EXISTS idx_progress_completed ON user_progress(completed);

-- ============================================================
-- Tabela: badges (Insígnias / Conquistas)
-- ============================================================
CREATE TABLE IF NOT EXISTS badges (
    id                      SERIAL PRIMARY KEY,
    formation_id            INT NOT NULL REFERENCES formations(id) ON DELETE CASCADE,
    nome                    VARCHAR(200) NOT NULL,
    descricao               TEXT,
    imagem_url              VARCHAR(500),
    criterio_percentual     INT DEFAULT 100,
    created_at              TIMESTAMP DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_badges_formation ON badges(formation_id);

-- ============================================================
-- Tabela: user_badges (Conquistas dos Professores)
-- ============================================================
CREATE TABLE IF NOT EXISTS user_badges (
    id              SERIAL PRIMARY KEY,
    user_id         INT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    badge_id        INT NOT NULL REFERENCES badges(id) ON DELETE CASCADE,
    conquistado_em  TIMESTAMP DEFAULT NOW(),
    UNIQUE(user_id, badge_id)
);

CREATE INDEX IF NOT EXISTS idx_user_badges_user ON user_badges(user_id);
CREATE INDEX IF NOT EXISTS idx_user_badges_badge ON user_badges(badge_id);

-- ============================================================
-- Tabela: notifications (Notificações)
-- ============================================================
CREATE TABLE IF NOT EXISTS notifications (
    id              SERIAL PRIMARY KEY,
    user_id         INT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    formation_id    INT REFERENCES formations(id) ON DELETE SET NULL,
    titulo          VARCHAR(200) NOT NULL,
    mensagem        TEXT NOT NULL,
    lida            BOOLEAN DEFAULT FALSE,
    created_at      TIMESTAMP DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_notifications_user ON notifications(user_id);
CREATE INDEX IF NOT EXISTS idx_notifications_lida ON notifications(lida);
CREATE INDEX IF NOT EXISTS idx_notifications_created ON notifications(created_at);

-- Função para atualizar updated_at automaticamente
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Triggers de updated_at
CREATE TRIGGER update_schools_updated_at
    BEFORE UPDATE ON schools
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_users_updated_at
    BEFORE UPDATE ON users
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_formations_updated_at
    BEFORE UPDATE ON formations
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_formation_modules_updated_at
    BEFORE UPDATE ON formation_modules
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
