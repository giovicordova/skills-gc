import jwt from "jsonwebtoken";

export interface JwtPayload {
  sub: string;
  iat: number;
  exp: number;
  [key: string]: unknown;
}

const SECRET = process.env.JWT_SECRET ?? "dev-secret-change-me";

/**
 * Verify a JWT: checks the signature with our secret and rejects
 * tokens whose `exp` claim is in the past. Returns the decoded
 * payload on success, or null if the token is invalid/expired.
 */
export function verifyJwt(token: string): JwtPayload | null {
  try {
    const decoded = jwt.verify(token, SECRET) as JwtPayload;

    if (typeof decoded.exp !== "number") {
      return null;
    }
    const nowSeconds = Math.floor(Date.now() / 1000);
    if (decoded.exp < nowSeconds) {
      return null;
    }

    return decoded;
  } catch {
    return null;
  }
}
