import jwt from "jsonwebtoken";

const ACCESS_SECRET = process.env.JWT_ACCESS_SECRET ?? "dev-access-secret";
const REFRESH_SECRET = process.env.JWT_REFRESH_SECRET ?? "dev-refresh-secret";
const ACCESS_TTL = "15m";
const REFRESH_TTL = "7d";

export interface TokenPayload {
  sub: string;
  iat?: number;
  exp?: number;
}

export function signAccessToken(payload: Pick<TokenPayload, "sub">): string {
  return jwt.sign(payload, ACCESS_SECRET, { expiresIn: ACCESS_TTL });
}

export function signRefreshToken(payload: Pick<TokenPayload, "sub">): string {
  return jwt.sign(payload, REFRESH_SECRET, { expiresIn: REFRESH_TTL });
}

export function verifyAccessToken(token: string): TokenPayload {
  return jwt.verify(token, ACCESS_SECRET) as TokenPayload;
}

export function verifyRefreshToken(token: string): TokenPayload {
  return jwt.verify(token, REFRESH_SECRET) as TokenPayload;
}
