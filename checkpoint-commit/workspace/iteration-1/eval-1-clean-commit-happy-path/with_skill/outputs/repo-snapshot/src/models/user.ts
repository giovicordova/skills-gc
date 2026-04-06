export interface User {
  id: string;
  email: string;
  passwordHash: string;
  createdAt: Date;
  updatedAt: Date;
}

export type NewUser = Omit<User, "id" | "createdAt" | "updatedAt">;
