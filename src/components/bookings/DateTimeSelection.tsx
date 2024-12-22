import React from 'react';
import { Clock } from 'lucide-react';
import { format } from 'date-fns';
import { es } from 'date-fns/locale';
import type { Reserva } from '../../types';

interface DateTimeSelectionProps {
  selectedDate: string;
  selectedTime: string | null;
  duration: number;
  bookings: Reserva[];
  onDateChange: (date: string) => void;
  onTimeSelect: (time: string) => void;
  onDurationChange: (duration: number) => void;
}

const TIME_SLOTS = [
  '08:00', '09:00', '10:00', '11:00', '12:00', '13:00', '14:00',
  '15:00', '16:00', '17:00', '18:00', '19:00', '20:00'
];

export function DateTimeSelection({
  selectedDate,
  selectedTime,
  duration,
  bookings,
  onDateChange,
  onTimeSelect,
  onDurationChange
}: DateTimeSelectionProps) {
  const isTimeAvailable = (time: string) => {
    const startHour = parseInt(time.split(':')[0]);
    // Verificar disponibilidad para la duración seleccionada
    for (let i = 0; i < duration; i++) {
      const checkTime = `${startHour + i}:00`;
      if (bookings.some(booking => booking.hora_inicio === checkTime)) {
        return false;
      }
    }
    return true;
  };

  return (
    <div className="space-y-8 bg-white p-6 rounded-lg shadow-lg">
      {/* Duración */}
      <div>
        <h3 className="text-lg font-medium text-gray-900 mb-4">Duración de la Reserva</h3>
        <div className="grid grid-cols-2 gap-4">
          {[1, 2].map((hours) => (
            <button
              key={hours}
              onClick={() => onDurationChange(hours)}
              className={`p-4 rounded-lg border-2 transition-colors flex items-center justify-center gap-2
                ${duration === hours
                  ? 'border-green-500 bg-green-50 text-green-700'
                  : 'border-gray-200 hover:border-green-200'
                }`}
            >
              <Clock className="w-5 h-5" />
              {hours} {hours === 1 ? 'hora' : 'horas'}
            </button>
          ))}
        </div>
      </div>

      {/* Fecha */}
      <div>
        <h3 className="text-lg font-medium text-gray-900 mb-4">Selecciona la Fecha</h3>
        <input
          type="date"
          min={new Date().toISOString().split('T')[0]}
          value={selectedDate}
          onChange={(e) => onDateChange(e.target.value)}
          className="w-full p-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-green-500 focus:border-transparent"
        />
        <p className="mt-2 text-sm text-gray-600">
          {format(new Date(selectedDate), "EEEE d 'de' MMMM", { locale: es })}
        </p>
      </div>

      {/* Horarios */}
      <div>
        <h3 className="text-lg font-medium text-gray-900 mb-4">Horarios Disponibles</h3>
        <div className="grid grid-cols-4 gap-3">
          {TIME_SLOTS.map((time) => {
            const available = isTimeAvailable(time);
            return (
              <button
                key={time}
                onClick={() => available && onTimeSelect(time)}
                disabled={!available}
                className={`
                  p-3 rounded-lg text-sm font-medium transition-colors relative
                  ${selectedTime === time
                    ? 'bg-green-100 text-green-800 ring-2 ring-green-500'
                    : available
                      ? 'bg-white hover:bg-green-50 text-gray-900 border border-gray-200'
                      : 'bg-red-50 text-red-300 cursor-not-allowed border border-red-100'
                  }
                `}
              >
                {time}
                {!available && (
                  <span className="absolute -top-2 -right-2 bg-red-500 text-white text-xs px-1.5 py-0.5 rounded-full">
                    Ocupado
                  </span>
                )}
              </button>
            );
          })}
        </div>
      </div>
    </div>
  );
}