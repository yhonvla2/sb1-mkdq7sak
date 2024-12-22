import { supabase } from '../supabase';
import type { Reserva, NuevaReserva, ReservaConUsuario } from '../../types/reserva';

export const reservaService = {
  async crear(reserva: NuevaReserva): Promise<Reserva> {
    const { data, error } = await supabase
      .from('reservas')
      .insert(reserva)
      .select()
      .single();
      
    if (error) throw error;
    return data;
  },

  async obtenerPorFecha(fecha: string): Promise<ReservaConUsuario[]> {
    const { data, error } = await supabase
      .from('reservas')
      .select(`
        *,
        usuarios (
          nombres,
          apellidos
        )
      `)
      .eq('fecha_reserva', fecha)
      .order('hora_inicio');
      
    if (error) throw error;
    return data;
  },

  async obtenerPorUsuario(usuarioId: string): Promise<ReservaConUsuario[]> {
    const { data, error } = await supabase
      .from('reservas')
      .select(`
        *,
        usuarios (
          nombres,
          apellidos
        )
      `)
      .eq('usuario_id', usuarioId)
      .order('fecha_reserva', { ascending: false });
      
    if (error) throw error;
    return data;
  },

  async actualizarEstado(id: string, estado: 'confirmada' | 'cancelada'): Promise<void> {
    const { error } = await supabase
      .from('reservas')
      .update({ estado })
      .eq('id', id);
      
    if (error) throw error;
  }
};