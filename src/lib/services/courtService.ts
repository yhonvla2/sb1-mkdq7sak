import { supabase } from '../supabase';
import type { Court } from '../../types/court';

export const courtService = {
  async getAll(): Promise<Court[]> {
    const { data, error } = await supabase
      .from('canchas')
      .select('*')
      .order('nombre');

    if (error) throw error;
    return data || [];
  },

  async getAvailable(): Promise<Court[]> {
    const { data, error } = await supabase
      .from('canchas')
      .select('*')
      .eq('estado', 'disponible')
      .order('nombre');

    if (error) throw error;
    return data || [];
  },

  async getById(id: string): Promise<Court | null> {
    const { data, error } = await supabase
      .from('canchas')
      .select('*')
      .eq('id', id)
      .single();

    if (error) throw error;
    return data;
  }
};