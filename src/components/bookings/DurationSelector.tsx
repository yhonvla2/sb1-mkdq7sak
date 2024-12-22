import React from 'react';
import { Clock } from 'lucide-react';

interface DurationSelectorProps {
  duration: number;
  onDurationChange: (duration: number) => void;
}

export function DurationSelector({ duration, onDurationChange }: DurationSelectorProps) {
  const durations = [1, 2];

  return (
    <div className="mb-6">
      <label className="block text-sm font-medium text-gray-700 mb-2">
        Duración de la Reserva
      </label>
      <div className="grid grid-cols-2 gap-4">
        {durations.map((hours) => (
          <button
            key={hours}
            onClick={() => onDurationChange(hours)}
            className={`flex items-center justify-center p-4 rounded-lg border-2 transition-colors ${
              duration === hours
                ? 'border-green-500 bg-green-50 text-green-700'
                : 'border-gray-200 hover:border-green-200'
            }`}
          >
            <Clock className="w-5 h-5 mr-2" />
            <span>{hours} {hours === 1 ? 'hora' : 'horas'}</span>
          </button>
        ))}
      </div>
    </div>
  );
}