import { supabase } from '../supabase/client';
import type { Reserva } from '../../types/database';

export const reservaService = {
  async crear(reserva: Omit<Reserva, 'id' | 'creado_en'>) {
    const { data, error } = await supabase
      .from('reservas')
      .insert(reserva)
      .select()
      .single();

    if (error) throw error;
    return data;
  },

  async obtenerPorUsuario(usuarioId: string) {
    const { data, error } = await supabase
      .from('reservas')
      .select(`
        *,
        canchas (
          nombre,
          tipo
        )
      `)
      .eq('usuario_id', usuarioId)
      .order('fecha_reserva', { ascending: false });

    if (error) throw error;
    return data;
  },

  async actualizarEstado(id: string, estado: 'confirmada' | 'cancelada') {
    const { error } = await supabase
      .from('reservas')
      .update({ estado })
      .eq('id', id);

    if (error) throw error;
  }
};