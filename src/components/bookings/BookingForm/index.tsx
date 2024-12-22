import React, { useState } from 'react';
import { format } from 'date-fns';
import { useAuth } from '../../../hooks/useAuth';
import { DateSelector } from './DateSelector';
import { TimeSelector } from './TimeSelector';
import { DurationSelector } from './DurationSelector';
import { BookingSummary } from './BookingSummary';
import { reservaService } from '../../../lib/services/reservas';
import { calculateEndTime, isValidTimeRange } from '../../../lib/utils/booking';
import type { Cancha } from '../../../types';

interface BookingFormProps {
  court: Cancha;
  onSuccess?: () => void;
  onCancel?: () => void;
}

export function BookingForm({ court, onSuccess, onCancel }: BookingFormProps) {
  const { user } = useAuth();
  const [date, setDate] = useState<Date>(new Date());
  const [startTime, setStartTime] = useState<string>('');
  const [duration, setDuration] = useState(1);
  const [loading, setLoading] = useState(false);

  const endTime = startTime ? calculateEndTime(startTime, duration) : '';
  const isValid = startTime && isValidTimeRange(startTime, endTime);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!user || !isValid) return;

    try {
      setLoading(true);
      await reservaService.crear({
        cancha_id: court.id,
        usuario_id: user.id,
        fecha: format(date, 'yyyy-MM-dd'),
        hora_inicio: startTime,
        hora_fin: endTime,
        estado: 'pendiente'
      });
      onSuccess?.();
    } catch (error) {
      console.error('Error al crear reserva:', error);
      alert('Error al crear la reserva');
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="bg-white rounded-lg shadow-md p-6">
      <h2 className="text-xl font-semibold mb-6">
        Reservar {court.nombre}
      </h2>

      <form onSubmit={handleSubmit} className="space-y-6">
        <DateSelector 
          selectedDate={date}
          onChange={setDate}
        />

        <div className="grid grid-cols-2 gap-4">
          <TimeSelector
            selectedTime={startTime}
            onChange={setStartTime}
            date={date}
            duration={duration}
          />

          <DurationSelector
            duration={duration}
            onChange={setDuration}
            startTime={startTime}
          />
        </div>

        {startTime && (
          <BookingSummary
            court={court}
            date={date}
            startTime={startTime}
            endTime={endTime}
            duration={duration}
          />
        )}

        <div className="flex justify-end space-x-4">
          <button
            type="button"
            onClick={onCancel}
            className="px-4 py-2 text-gray-600 hover:text-gray-800 transition-colors"
          >
            Cancelar
          </button>
          
          <button
            type="submit"
            disabled={loading || !isValid}
            className="px-6 py-2 bg-green-600 text-white rounded-md hover:bg-green-700 
                     transition-colors disabled:opacity-50 disabled:cursor-not-allowed"
          >
            {loading ? 'Confirmando...' : 'Confirmar Reserva'}
          </button>
        </div>
      </form>
    </div>
  );
}