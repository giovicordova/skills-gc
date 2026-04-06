export interface User {
  id: string;
  email: string;
  passwordHash: string;
  createdAt: Date;
  updatedAt: Date;
}

export type PublicUser = Omit<User, "passwordHash">;
