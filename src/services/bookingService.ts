import { supabase } from '../lib/supabase';
import type { Reserva, NuevaReserva } from '../types';

export const bookingService = {
  async create(booking: NuevaReserva): Promise<Reserva> {
    const { data, error } = await supabase
      .from('reservas')
      .insert(booking)
      .select()
      .single();

    if (error) throw error;
    return data;
  },

  async getByDate(date: string): Promise<Reserva[]> {
    const { data, error } = await supabase
      .from('reservas')
      .select('*')
      .eq('fecha', date)
      .order('hora_inicio');

    if (error) throw error;
    return data || [];
  },

  async getByCourtAndDate(courtId: string, date: string): Promise<Reserva[]> {
    const { data, error } = await supabase
      .from('reservas')
      .select('*')
      .eq('cancha_id', courtId)
      .eq('fecha', date)
      .order('hora_inicio');

    if (error) throw error;
    return data || [];
  },

  async cancel(id: string): Promise<void> {
    const { error } = await supabase
      .from('reservas')
      .update({ estado: 'cancelada' })
      .eq('id', id);

    if (error) throw error;
  }
};