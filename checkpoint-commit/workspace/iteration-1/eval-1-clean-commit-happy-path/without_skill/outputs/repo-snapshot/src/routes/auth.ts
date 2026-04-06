import { Router, Request, Response } from "express";
import { verifyRefreshToken, signAccessToken } from "../middleware/jwt";

const router = Router();

router.post("/login", async (req: Request, res: Response) => {
  const { email, password } = req.body ?? {};
  if (!email || !password) {
    return res.status(400).json({ error: "email and password required" });
  }
  // TODO: verify credentials, issue access + refresh tokens
  return res.status(501).json({ error: "not implemented" });
});

router.post("/refresh", async (req: Request, res: Response) => {
  const { refreshToken } = req.body ?? {};
  if (!refreshToken) {
    return res.status(400).json({ error: "refreshToken required" });
  }
  try {
    const payload = verifyRefreshToken(refreshToken);
    const accessToken = signAccessToken({ sub: payload.sub });
    return res.status(200).json({ accessToken });
  } catch (err) {
    return res.status(401).json({ error: "invalid refresh token" });
  }
});

export default router;
