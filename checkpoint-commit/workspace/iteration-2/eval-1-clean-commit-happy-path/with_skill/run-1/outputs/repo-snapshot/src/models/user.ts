export interface User {
  id: string;
  email: string;
  passwordHash: string;
  createdAt: Date;
}

export function isUser(value: unknown): value is User {
  if (!value || typeof value !== "object") return false;
  const v = value as Record<string, unknown>;
  return (
    typeof v.id === "string" &&
    typeof v.email === "string" &&
    typeof v.passwordHash === "string" &&
    v.createdAt instanceof Date
  );
}
