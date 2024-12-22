import { supabase } from '../lib/supabase';
import type { Booking, NewBooking, BookingWithUser } from '../types';

export const bookingService = {
  async create(booking: NewBooking): Promise<Booking> {
    const { data, error } = await supabase
      .from('bookings')
      .insert(booking)
      .select()
      .single();
      
    if (error) throw error;
    return data;
  },

  async getByDate(date: string): Promise<BookingWithUser[]> {
    const { data, error } = await supabase
      .from('bookings')
      .select(`
        *,
        users (
          name
        )
      `)
      .eq('date', date)
      .order('start_time');
      
    if (error) throw error;
    return data;
  },

  async getAll(): Promise<BookingWithUser[]> {
    const { data, error } = await supabase
      .from('bookings')
      .select(`
        *,
        users (
          name
        )
      `)
      .order('date', { ascending: false });
      
    if (error) throw error;
    return data;
  }
};