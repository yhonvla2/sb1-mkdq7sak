import React from 'react';
import { Clock } from 'lucide-react';

interface TimeSlotProps {
  time: string;
  isAvailable: boolean;
  isSelected: boolean;
  onClick: () => void;
}

export function TimeSlot({ time, isAvailable, isSelected, onClick }: TimeSlotProps) {
  return (
    <button
      onClick={onClick}
      disabled={!isAvailable}
      className={`
        flex items-center justify-center gap-2 p-4 rounded-lg transition-colors
        ${isSelected && isAvailable ? 'bg-green-100 text-green-800 ring-2 ring-green-500' : ''}
        ${!isAvailable 
          ? 'bg-gray-100 text-gray-400 cursor-not-allowed' 
          : 'bg-white hover:bg-green-50 border border-gray-200'
        }
      `}
    >
      <Clock className="w-4 h-4" />
      <span>{time}</span>
    </button>
  );
}