import React from 'react';
import { Clock } from 'lucide-react';

interface DurationSelectorProps {
  duration: number;
  onChange: (duration: number) => void;
  startTime: string;
}

export function DurationSelector({ duration, onChange, startTime }: DurationSelectorProps) {
  const startHour = startTime ? parseInt(startTime.split(':')[0]) : 0;
  const maxDuration = startHour > 0 ? Math.min(3, 22 - startHour) : 3;

  return (
    <div className="space-y-2">
      <label className="flex items-center gap-2 text-sm font-medium text-gray-700">
        <Clock className="w-5 h-5 text-green-600" />
        Duración
      </label>

      <div className="grid grid-cols-3 gap-2">
        {[1, 2, 3].map((hours) => (
          <button
            key={hours}
            type="button"
            disabled={hours > maxDuration}
            onClick={() => onChange(hours)}
            className={`
              p-2 rounded-lg border-2 transition-colors text-sm
              ${duration === hours
                ? 'border-green-500 bg-green-50 text-green-700'
                : 'border-gray-200 hover:border-green-200'
              }
              ${hours > maxDuration ? 'opacity-50 cursor-not-allowed' : ''}
            `}
          >
            {hours} {hours === 1 ? 'hora' : 'horas'}
          </button>
        ))}
      </div>
    </div>
  );
}