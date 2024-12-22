import { supabase } from '../supabase';
import type { Booking, NewBooking, BookingWithDetails } from '../../types/booking';

export const bookingService = {
  async create(booking: NewBooking): Promise<Booking> {
    const { data, error } = await supabase
      .from('reservas')
      .insert({
        usuario_id: booking.userId,
        cancha_id: booking.courtId,
        fecha: booking.date,
        hora_inicio: booking.startTime,
        hora_fin: booking.endTime,
        estado: 'pending'
      })
      .select()
      .single();

    if (error) throw error;
    return data;
  },

  async getByDate(date: string): Promise<BookingWithDetails[]> {
    const { data, error } = await supabase
      .from('reservas')
      .select(`
        *,
        usuarios (
          nombres,
          apellidos,
          correo,
          telefono
        ),
        canchas (
          nombre,
          tipo,
          estado
        )
      `)
      .eq('fecha', date)
      .order('hora_inicio');

    if (error) throw error;
    return data || [];
  },

  async getUserBookings(userId: string): Promise<BookingWithDetails[]> {
    const { data, error } = await supabase
      .from('reservas')
      .select(`
        *,
        usuarios (
          nombres,
          apellidos,
          correo,
          telefono
        ),
        canchas (
          nombre,
          tipo,
          estado
        )
      `)
      .eq('usuario_id', userId)
      .order('fecha', { ascending: false });

    if (error) throw error;
    return data || [];
  },

  async updateStatus(
    id: string, 
    status: 'confirmed' | 'cancelled'
  ): Promise<void> {
    const { error } = await supabase
      .from('reservas')
      .update({ estado: status })
      .eq('id', id);

    if (error) throw error;
  }
};