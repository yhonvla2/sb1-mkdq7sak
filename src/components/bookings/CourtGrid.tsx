import React from 'react';
import { Calendar } from 'lucide-react';
import type { Cancha } from '../../types';
import { COURT_IMAGES } from '../../constants/business';

interface CourtGridProps {
  courts: Cancha[];
  selectedCourt: string | null;
  onSelectCourt: (courtId: string) => void;
}

export function CourtGrid({ courts, selectedCourt, onSelectCourt }: CourtGridProps) {
  return (
    <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
      {courts.map((court) => (
        <div
          key={court.id}
          onClick={() => onSelectCourt(court.id)}
          className={`
            relative overflow-hidden rounded-lg cursor-pointer transition-all
            ${selectedCourt === court.id 
              ? 'ring-4 ring-green-500 ring-offset-2 transform scale-[1.02]' 
              : 'hover:ring-2 hover:ring-green-300 hover:ring-offset-1 hover:transform hover:scale-[1.01]'
            }
          `}
        >
          <div className="aspect-video relative">
            <img
              src={COURT_IMAGES[court.nombre]}
              alt={court.nombre}
              className="w-full h-full object-cover"
            />
            <div className="absolute inset-0 bg-gradient-to-t from-black/60 to-transparent" />
            <div className="absolute bottom-0 left-0 right-0 p-6 text-white">
              <h3 className="text-xl font-semibold mb-2">{court.nombre}</h3>
              <p className="text-sm opacity-90 mb-4">
                Cancha de {court.tipo.charAt(0).toUpperCase() + court.tipo.slice(1)}
              </p>
              <div className="flex items-center justify-between">
                <span className={`px-3 py-1 rounded-full text-sm ${
                  court.estado === 'disponible' 
                    ? 'bg-green-500/80' 
                    : 'bg-red-500/80'
                }`}>
                  {court.estado === 'disponible' ? 'Disponible' : 'En mantenimiento'}
                </span>
                <button 
                  className={`
                    flex items-center gap-2 px-4 py-2 rounded-lg transition-colors
                    ${selectedCourt === court.id
                      ? 'bg-green-500 text-white'
                      : 'bg-white text-green-600 hover:bg-green-50'
                    }
                  `}
                  onClick={(e) => {
                    e.stopPropagation();
                    onSelectCourt(court.id);
                  }}
                >
                  <Calendar className="w-5 h-5" />
                  {selectedCourt === court.id ? 'Seleccionada' : 'Seleccionar'}
                </button>
              </div>
            </div>
          </div>
        </div>
      ))}
    </div>
  );
}