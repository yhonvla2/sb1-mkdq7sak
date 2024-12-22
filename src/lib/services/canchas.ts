import { supabase } from '../supabase';
import type { Cancha } from '../../types';

export const canchaService = {
  async obtenerTodas(): Promise<Cancha[]> {
    const { data, error } = await supabase
      .from('canchas')
      .select()
      .order('nombre');
      
    if (error) throw error;
    return data;
  },

  async obtenerDisponibles(): Promise<Cancha[]> {
    const { data, error } = await supabase
      .from('canchas')
      .select()
      .eq('estado', 'disponible')
      .order('nombre');
      
    if (error) throw error;
    return data;
  },

  async inicializarCanchas() {
    const canchas = [
      {
        nombre: 'Cancha de Voley 1',
        tipo: 'voley',
        estado: 'disponible'
      },
      {
        nombre: 'Cancha de Voley 2',
        tipo: 'voley',
        estado: 'disponible'
      },
      {
        nombre: 'Cancha de Voley 3',
        tipo: 'voley',
        estado: 'disponible'
      },
      {
        nombre: 'Cancha de Futsal',
        tipo: 'futsal',
        estado: 'disponible'
      }
    ];

    const { error } = await supabase
      .from('canchas')
      .insert(canchas);

    if (error) throw error;
  }
};