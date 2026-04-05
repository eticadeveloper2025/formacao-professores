export const jwtConfig = () => ({
  secret: process.env.JWT_SECRET || 'formacao-professores-secret',
  expiresIn: process.env.JWT_EXPIRES_IN || '1h',
  refreshExpiresIn: process.env.JWT_REFRESH_EXPIRES_IN || '7d',
});
