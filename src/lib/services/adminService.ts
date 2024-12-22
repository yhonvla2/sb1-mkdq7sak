import { supabase } from '../supabase';
import type { Usuario, Reserva, ReservaConUsuario } from '../../types';

export const adminService = {
  async isAdmin(userId: string): Promise<boolean> {
    const { data, error } = await supabase
      .from('usuarios')
      .select('rol')
      .eq('id', userId)
      .single();
      
    if (error) return false;
    return data?.rol === 'admin';
  },

  async obtenerReservas(): Promise<ReservaConUsuario[]> {
    const { data, error } = await supabase
      .from('reservas')
      .select(`
        *,
        usuarios (
          nombres,
          apellidos,
          telefono
        )
      `)
      .order('fecha', { ascending: false });
      
    if (error) throw error;
    return data;
  },

  async actualizarEstadoReserva(
    reservaId: string, 
    estado: 'confirmada' | 'cancelada'
  ): Promise<void> {
    const { error } = await supabase
      .from('reservas')
      .update({ estado })
      .eq('id', reservaId);
      
    if (error) throw error;
  },

  async obtenerUsuarios(): Promise<Usuario[]> {
    const { data, error } = await supabase
      .from('usuarios')
      .select('*')
      .order('fecha_registro', { ascending: false });
      
    if (error) throw error;
    return data;
  }
};