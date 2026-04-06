import { Router, Request, Response } from "express";
import { verifyJwt } from "../middleware/jwt";

export const authRouter = Router();

authRouter.post("/login", async (req: Request, res: Response) => {
  const { email, password } = req.body ?? {};
  if (!email || !password) {
    return res.status(400).json({ error: "email and password required" });
  }

  // TODO: look up user, verify password hash, issue session token
  return res.status(501).json({ error: "not implemented" });
});

authRouter.post("/refresh", async (req: Request, res: Response) => {
  const token = req.body?.refreshToken;
  if (!token) {
    return res.status(400).json({ error: "refreshToken required" });
  }

  const payload = verifyJwt(token);
  if (!payload) {
    return res.status(401).json({ error: "invalid or expired token" });
  }

  // TODO: issue a fresh access token bound to payload.sub
  return res.status(200).json({ sub: payload.sub, accessToken: "stub" });
});
