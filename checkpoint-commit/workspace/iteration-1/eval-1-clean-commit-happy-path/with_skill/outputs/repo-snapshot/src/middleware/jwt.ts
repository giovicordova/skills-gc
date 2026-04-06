import crypto from "node:crypto";

export interface JwtPayload {
  sub: string;
  iat: number;
  exp: number;
}

const SECRET = process.env.JWT_SECRET ?? "dev-secret-change-me";

function base64UrlDecode(input: string): Buffer {
  const pad = 4 - (input.length % 4 || 4);
  const b64 = input.replace(/-/g, "+").replace(/_/g, "/") + "=".repeat(pad);
  return Buffer.from(b64, "base64");
}

export function verifyJwt(token: string): JwtPayload | null {
  const parts = token.split(".");
  if (parts.length !== 3) return null;

  const [headerB64, payloadB64, signatureB64] = parts;
  const signingInput = `${headerB64}.${payloadB64}`;
  const expected = crypto
    .createHmac("sha256", SECRET)
    .update(signingInput)
    .digest();
  const provided = base64UrlDecode(signatureB64);

  if (expected.length !== provided.length) return null;
  if (!crypto.timingSafeEqual(expected, provided)) return null;

  const payload = JSON.parse(base64UrlDecode(payloadB64).toString("utf8")) as JwtPayload;
  const now = Math.floor(Date.now() / 1000);
  if (typeof payload.exp !== "number" || payload.exp < now) return null;

  return payload;
}
