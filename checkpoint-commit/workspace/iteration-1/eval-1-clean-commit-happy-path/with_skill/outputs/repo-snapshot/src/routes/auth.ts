import type { Request, Response } from "express";
import { verifyJwt } from "../middleware/jwt";

export async function loginHandler(req: Request, res: Response) {
  const { email, password } = req.body ?? {};

  if (!email || !password) {
    return res.status(400).json({ error: "email and password required" });
  }

  // TODO: look up user, verify password, issue token
  return res.status(501).json({ error: "not implemented" });
}

export async function refreshHandler(req: Request, res: Response) {
  const header = req.headers.authorization ?? "";
  const token = header.startsWith("Bearer ") ? header.slice(7) : null;

  if (!token) {
    return res.status(401).json({ error: "missing bearer token" });
  }

  const payload = verifyJwt(token);
  if (!payload) {
    return res.status(401).json({ error: "invalid or expired token" });
  }

  // TODO: issue a fresh access token tied to payload.sub
  return res.status(200).json({ sub: payload.sub, refreshed: true });
}
