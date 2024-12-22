import { supabase } from '../supabase';
import type { User, NewUser } from '../../types';

export const userService = {
  async create(user: NewUser): Promise<User> {
    const { data, error } = await supabase
      .from('users')
      .insert(user)
      .select()
      .single();
      
    if (error) throw error;
    return data;
  },

  async getByEmail(email: string): Promise<User | null> {
    const { data, error } = await supabase
      .from('users')
      .select()
      .eq('email', email)
      .single();
      
    if (error && error.code !== 'PGRST116') throw error;
    return data;
  },

  async getAll(): Promise<User[]> {
    const { data, error } = await supabase
      .from('users')
      .select()
      .order('created_at', { ascending: false });
      
    if (error) throw error;
    return data;
  }
};