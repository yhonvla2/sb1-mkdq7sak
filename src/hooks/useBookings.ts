import { useState, useEffect } from 'react';
import { format } from 'date-fns';
import { reservaService } from '../lib/services/reservas';
import type { Reserva } from '../types';

export function useBookings(date: Date) {
  const [bookings, setBookings] = useState<Reserva[]>([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<Error | null>(null);

  useEffect(() => {
    const loadBookings = async () => {
      try {
        setLoading(true);
        setError(null);
        const dateStr = format(date, 'yyyy-MM-dd');
        const results = await reservaService.obtenerPorFecha(dateStr);
        setBookings(results);
      } catch (err) {
        setError(err instanceof Error ? err : new Error('Error loading bookings'));
        console.error('Error loading bookings:', err);
      } finally {
        setLoading(false);
      }
    };

    loadBookings();
  }, [date]);

  return { bookings, loading, error };
}