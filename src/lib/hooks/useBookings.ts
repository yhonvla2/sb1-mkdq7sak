import { useState, useEffect } from 'react';
import { format, addHours } from 'date-fns';
import { reservaService } from '../services/reservas';
import type { Reserva, ReservaConUsuario } from '../../types';

export function useBookings(date: Date, courtId: string | null) {
  const [bookings, setBookings] = useState<ReservaConUsuario[]>([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<Error | null>(null);

  useEffect(() => {
    if (!courtId) return;

    const loadBookings = async () => {
      try {
        setLoading(true);
        setError(null);
        const dateStr = format(date, 'yyyy-MM-dd');
        const results = await reservaService.obtenerPorFecha(dateStr);
        setBookings(results);
      } catch (err) {
        setError(err instanceof Error ? err : new Error('Error loading bookings'));
      } finally {
        setLoading(false);
      }
    };

    loadBookings();
  }, [date, courtId]);

  const createBooking = async (startTime: string) => {
    if (!courtId) throw new Error('No court selected');

    const [hours, minutes] = startTime.split(':').map(Number);
    const startDate = new Date(2000, 0, 1, hours, minutes);
    const endDate = addHours(startDate, 1);
    const endTime = format(endDate, 'HH:mm');
    const dateStr = format(date, 'yyyy-MM-dd');

    const newBooking = await reservaService.crear({
      cancha_id: courtId,
      fecha: dateStr,
      hora_inicio: startTime,
      hora_fin: endTime,
    });

    setBookings(prev => [...prev, newBooking]);
    return newBooking;
  };

  return { bookings, loading, error, createBooking };
}