import { test, expect } from '@playwright/test';

const BASE_URL = 'http://localhost:3000';

test.describe('Auth — /auth/login', () => {
  test('login com credenciais válidas retorna 200 + tokens', async ({ request }) => {
    const res = await request.post(`${BASE_URL}/auth/login`, {
      data: { email: 'ana@escola.com', senha: 'teste123' },
    });

    expect(res.status()).toBe(200);
    const body = await res.json();
    expect(body.data).toHaveProperty('accessToken');
    expect(body.data).toHaveProperty('refreshToken');
    expect(body.data.user.email).toBe('ana@escola.com');
    expect(body.data.user).not.toHaveProperty('senha_hash');
    expect(body.message).toBe('Login realizado com sucesso');
  });

  test('login com senha errada retorna 401', async ({ request }) => {
    const res = await request.post(`${BASE_URL}/auth/login`, {
      data: { email: 'ana@escola.com', senha: 'senha_errada' },
    });

    expect(res.status()).toBe(401);
    const body = await res.json();
    expect(body.message).toBe('Email ou senha inválidos');
  });

  test('login com email inexistente retorna 401', async ({ request }) => {
    const res = await request.post(`${BASE_URL}/auth/login`, {
      data: { email: 'naoexiste@escola.com', senha: 'teste123' },
    });

    expect(res.status()).toBe(401);
  });

  test('rota protegida sem token retorna 401', async ({ request }) => {
    const res = await request.get(`${BASE_URL}/users/me`);
    expect(res.status()).toBe(401);
  });

  test('rota protegida com token válido retorna 200', async ({ request }) => {
    const loginRes = await request.post(`${BASE_URL}/auth/login`, {
      data: { email: 'ana@escola.com', senha: 'teste123' },
    });
    const { data } = await loginRes.json();
    const token = data.accessToken;

    const meRes = await request.get(`${BASE_URL}/users/me`, {
      headers: { Authorization: `Bearer ${token}` },
    });

    expect(meRes.status()).toBe(200);
    const me = await meRes.json();
    expect(me.data.email).toBe('ana@escola.com');
    expect(me.data).not.toHaveProperty('senha_hash');
  });
});
