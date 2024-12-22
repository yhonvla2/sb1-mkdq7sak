import { supabase } from '../lib/supabase';
import type { Cancha } from '../types';

export const courtService = {
  async getAll() {
    const { data, error } = await supabase
      .from('canchas')
      .select('*')
      .order('nombre');

    if (error) throw error;
    return data || [];
  },

  async getAvailable() {
    const { data, error } = await supabase
      .from('canchas')
      .select('*')
      .eq('estado', 'disponible')
      .order('nombre');

    if (error) throw error;
    return data || [];
  },

  async getById(id: string) {
    const { data, error } = await supabase
      .from('canchas')
      .select('*')
      .eq('id', id)
      .single();

    if (error) throw error;
    return data;
  }
};