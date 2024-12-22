import React from 'react';
import { Clock } from 'lucide-react';
import { getAvailableTimeSlots } from '../../../lib/utils/booking';
import { useBookings } from '../../../hooks/useBookings';

interface TimeSelectorProps {
  selectedTime: string;
  onChange: (time: string) => void;
  date: Date;
  duration: number;
}

export function TimeSelector({ selectedTime, onChange, date, duration }: TimeSelectorProps) {
  const { bookings } = useBookings(date);
  const availableSlots = getAvailableTimeSlots(date, bookings, duration);

  return (
    <div className="space-y-2">
      <label className="flex items-center gap-2 text-sm font-medium text-gray-700">
        <Clock className="w-5 h-5 text-green-600" />
        Hora de Inicio
      </label>
      
      <select
        value={selectedTime}
        onChange={(e) => onChange(e.target.value)}
        className="w-full px-3 py-2 border border-gray-300 rounded-md 
                 focus:ring-2 focus:ring-green-500 focus:border-transparent"
      >
        <option value="">Seleccionar hora</option>
        {availableSlots.map((time) => (
          <option key={time} value={time}>
            {time}
          </option>
        ))}
      </select>
    </div>
  );
}