import React, { useState } from 'react';
import { format } from 'date-fns';
import { useAuth } from '../../hooks/useAuth';
import { DatePicker } from './DatePicker';
import { TimePicker } from './TimePicker';
import { reservaService } from '../../lib/services/reservas';
import type { Cancha } from '../../types';

interface BookingFormProps {
  court: Cancha;
  onSuccess?: () => void;
  onCancel?: () => void;
}

export function BookingForm({ court, onSuccess, onCancel }: BookingFormProps) {
  const { user } = useAuth();
  const [date, setDate] = useState<Date>(new Date());
  const [startTime, setStartTime] = useState<string>('');
  const [endTime, setEndTime] = useState<string>('');
  const [loading, setLoading] = useState(false);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!user) return;

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
        <DatePicker
          selectedDate={date}
          onChange={setDate}
          label="Fecha"
        />

        <div className="grid grid-cols-2 gap-4">
          <TimePicker
            value={startTime}
            onChange={setStartTime}
            label="Hora Inicio"
          />

          <TimePicker
            value={endTime}
            onChange={setEndTime}
            label="Hora Fin"
            minTime={startTime}
          />
        </div>

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
            disabled={loading || !startTime || !endTime}
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