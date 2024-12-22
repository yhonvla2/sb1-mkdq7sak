import { format } from 'date-fns';
import type { Reserva } from '../../types';

// Validar disponibilidad de horario
export function isTimeSlotAvailable(
  time: string,
  date: Date,
  bookings: Reserva[],
  duration: number = 1
): boolean {
  const dateStr = format(date, 'yyyy-MM-dd');
  const startHour = parseInt(time.split(':')[0]);

  // Verificar si hay reservas que se solapan
  for (let i = 0; i < duration; i++) {
    const checkTime = `${startHour + i}:00`;
    if (bookings.some(booking => 
      booking.fecha === dateStr && 
      booking.hora_inicio === checkTime
    )) {
      return false;
    }
  }

  return true;
}

// Obtener horarios disponibles
export function getAvailableTimeSlots(
  date: Date,
  bookings: Reserva[],
  duration: number = 1
): string[] {
  const timeSlots = [];
  for (let hour = 8; hour <= 20; hour++) {
    const time = `${hour.toString().padStart(2, '0')}:00`;
    if (isTimeSlotAvailable(time, date, bookings, duration)) {
      timeSlots.push(time);
    }
  }
  return timeSlots;
}

// Calcular hora de fin basada en duración
export function calculateEndTime(startTime: string, duration: number): string {
  const startHour = parseInt(startTime.split(':')[0]);
  return `${startHour + duration}:00`;
}

// Validar rango de horario
export function isValidTimeRange(startTime: string, endTime: string): boolean {
  const start = parseInt(startTime.split(':')[0]);
  const end = parseInt(endTime.split(':')[0]);
  return end > start && end <= 22;
}