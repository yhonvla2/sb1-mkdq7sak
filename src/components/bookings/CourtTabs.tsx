import React from 'react';
import type { Cancha } from '../../types';

interface CourtTabsProps {
  courts: Cancha[];
  selectedCourt: string | null;
  onSelectCourt: (courtId: string) => void;
}

export function CourtTabs({ courts, selectedCourt, onSelectCourt }: CourtTabsProps) {
  return (
    <div className="flex space-x-2 mb-6">
      {courts.map((court) => (
        <button
          key={court.id}
          onClick={() => onSelectCourt(court.id)}
          className={`
            px-4 py-2 rounded-lg transition-colors
            ${selectedCourt === court.id
              ? 'bg-green-600 text-white'
              : 'bg-white text-gray-700 hover:bg-green-50'
            }
          `}
        >
          {court.nombre}
        </button>
      ))}
    </div>
  );
}