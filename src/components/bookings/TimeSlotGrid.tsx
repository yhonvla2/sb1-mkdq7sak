import React from 'react';
import { format } from 'date-fns';
import type { Reserva } from '../../types';

const TIME_SLOTS = [
  '08:00', '09:00', '10:00', '11:00', '12:00', '13:00', '14:00',
  '15:00', '16:00', '17:00', '18:00', '19:00', '20:00'
];

interface TimeSlotGridProps {
  selectedCourt: string | null;
  selectedDate: Date;
  bookings: Reserva[];
  onTimeSelect: (time: string) => void;
}

export function TimeSlotGrid({ selectedCourt, selectedDate, bookings, onTimeSelect }: TimeSlotGridProps) {
  const isTimeSlotAvailable = (time: string) => {
    return !bookings.some(booking => 
      booking.cancha_id === selectedCourt &&
      format(new Date(booking.fecha), 'yyyy-MM-dd') === format(selectedDate, 'yyyy-MM-dd') &&
      booking.hora_inicio === time
    );
  };

  return (
    <div className="grid grid-cols-4 gap-2">
      {TIME_SLOTS.map((time) => {
        const isAvailable = isTimeSlotAvailable(time);
        return (
          <button
            key={time}
            onClick={() => isAvailable && onTimeSelect(time)}
            disabled={!isAvailable}
            className={`
              p-3 rounded-lg text-center transition-colors
              ${isAvailable 
                ? 'bg-white hover:bg-green-50 border border-gray-200 text-gray-900' 
                : 'bg-gray-100 text-gray-400 cursor-not-allowed'
              }
            `}
          >
            {time}
          </button>
        );
      })}
    </div>
  );
}