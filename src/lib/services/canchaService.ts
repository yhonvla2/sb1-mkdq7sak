import { supabase } from '../supabase/client';
import type { Cancha } from '../../types/database';

export const canchaService = {
  async obtenerTodas() {
    const { data, error } = await supabase
      .from('canchas')
      .select('*')
      .order('nombre');

    if (error) throw error;
    return data;
  },

  async obtenerDisponibles() {
    const { data, error } = await supabase
      .from('canchas')
      .select('*')
      .eq('estado', 'disponible')
      .order('nombre');

    if (error) throw error;
    return data;
  }
};