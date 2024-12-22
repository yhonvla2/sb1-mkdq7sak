import React from 'react';
import type { Cancha } from '../../types';

interface CourtSelectorProps {
  courts: Cancha[];
  selectedCourt: string | null;
  onSelectCourt: (courtId: string) => void;
}

export function CourtSelector({ courts, selectedCourt, onSelectCourt }: CourtSelectorProps) {
  const getCourtImage = (tipo: string) => {
    switch (tipo) {
      case 'voley':
        return 'https://images.unsplash.com/photo-1612872087720-bb876e2e67d1?auto=format&fit=crop&q=80&w=600';
      case 'futsal':
        return 'https://images.unsplash.com/photo-1577223625816-7546f13df25d?auto=format&fit=crop&q=80&w=600';
      default:
        return '';
    }
  };

  return (
    <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
      {courts.map((court) => (
        <button
          key={court.id}
          onClick={() => onSelectCourt(court.id)}
          className={`relative overflow-hidden rounded-lg transition-all ${
            selectedCourt === court.id
              ? 'ring-4 ring-green-500 ring-offset-2'
              : 'hover:ring-2 hover:ring-green-300 hover:ring-offset-1'
          }`}
        >
          <div className="aspect-video relative">
            <img
              src={getCourtImage(court.tipo)}
              alt={court.nombre}
              className="w-full h-full object-cover"
            />
            <div className="absolute inset-0 bg-gradient-to-t from-black/60 to-transparent" />
            <div className="absolute bottom-0 left-0 right-0 p-4 text-white">
              <h3 className="font-semibold text-lg">{court.nombre}</h3>
              <p className="text-sm opacity-90 capitalize">
                Cancha de {court.tipo}
              </p>
              <span className={`inline-block mt-2 px-2 py-1 rounded-full text-xs ${
                court.estado === 'disponible' 
                  ? 'bg-green-500/80' 
                  : 'bg-red-500/80'
              }`}>
                {court.estado === 'disponible' ? 'Disponible' : 'En mantenimiento'}
              </span>
            </div>
          </div>
        </button>
      ))}
    </div>
  );
}