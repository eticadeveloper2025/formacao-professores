#!/usr/bin/env node
// scripts/init-db.js
// Runs SQL initialization files against the database on first startup.
// Safe to run multiple times — all INSERTs use ON CONFLICT DO NOTHING.

'use strict';

const { Client } = require('pg');
const fs = require('fs');
const path = require('path');

const SQL_DIR = path.join(__dirname, '..', '..', 'database');

const SQL_FILES = [
  '01_create_tables.sql',
  '02_seed_data.sql',
  '03_access_codes.sql',
  '04_update_video_firebase.sql',
  '05_update_basta_video.sql',
];

const ALWAYS_RUN_SQL_FILES = [
  '06_pedagogical_content.sql',
];

async function initDb() {
  const connectionString = process.env.DATABASE_URL;
  if (!connectionString) {
    console.error('❌ DATABASE_URL não definida. Abortando init-db.');
    process.exit(1);
  }

  const client = new Client({
    connectionString,
    ssl: process.env.NODE_ENV === 'production' ? { rejectUnauthorized: false } : false,
  });

  try {
    await client.connect();
    console.log('✅ Conectado ao banco de dados.');

    // Check if tables already exist to skip re-seeding
    const { rows } = await client.query(`
      SELECT COUNT(*) AS count
      FROM information_schema.tables
      WHERE table_schema = 'public' AND table_name = 'users'
    `);

    if (parseInt(rows[0].count, 10) === 0) {
      console.log('🗄️  Inicializando banco de dados...');

      for (const file of SQL_FILES) {
        const filePath = path.join(SQL_DIR, file);
        if (!fs.existsSync(filePath)) {
          console.warn(`⚠️  Arquivo não encontrado, pulando: ${file}`);
          continue;
        }
        const sql = fs.readFileSync(filePath, 'utf8');
        console.log(`▶  Executando ${file}...`);
        await client.query(sql);
        console.log(`✅  ${file} concluído.`);
      }
    } else {
      console.log('ℹ️  Tabelas base já existem. Aplicando scripts incrementais.');
    }

    for (const file of ALWAYS_RUN_SQL_FILES) {
      const filePath = path.join(SQL_DIR, file);
      if (!fs.existsSync(filePath)) {
        console.warn(`⚠️  Arquivo incremental não encontrado, pulando: ${file}`);
        continue;
      }
      const sql = fs.readFileSync(filePath, 'utf8');
      console.log(`▶  Executando incremental ${file}...`);
      await client.query(sql);
      console.log(`✅  ${file} concluído.`);
    }

    console.log('🎉 Banco de dados inicializado com sucesso!');
  } catch (err) {
    console.error('❌ Erro ao inicializar banco de dados:', err.message);
    // Don't crash the server if init fails — tables may already exist
    // but the schema check missed it (e.g., partial init)
    console.error('⚠️  Continuando inicialização do servidor mesmo com erro de DB init...');
  } finally {
    await client.end().catch(() => {});
  }
}

initDb();
