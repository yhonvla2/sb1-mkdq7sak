export type UserRole = 'user' | 'admin';

export interface User {
  id: string;
  authId: string;
  firstName: string;
  lastName: string;
  email: string;
  phone?: string;
  role: UserRole;
  createdAt: string;
}

export type NewUser = Omit<User, 'id' | 'createdAt' | 'role'>;