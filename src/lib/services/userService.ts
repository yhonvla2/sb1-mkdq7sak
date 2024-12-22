import { supabase } from '../supabase';
import type { User, NewUser } from '../../types/user';

export const userService = {
  async getCurrentUser(): Promise<User | null> {
    const { data: { user: authUser } } = await supabase.auth.getUser();
    if (!authUser) return null;

    const { data, error } = await supabase
      .from('usuarios')
      .select('*')
      .eq('auth_id', authUser.id)
      .single();

    if (error) throw error;
    return data;
  },

  async createProfile(user: NewUser): Promise<User> {
    const { data, error } = await supabase
      .from('usuarios')
      .insert({
        auth_id: user.authId,
        nombres: user.firstName,
        apellidos: user.lastName,
        correo: user.email,
        telefono: user.phone
      })
      .select()
      .single();

    if (error) throw error;
    return data;
  }
};