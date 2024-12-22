import React from 'react';
import { Link } from 'react-router-dom';
import { Calendar } from 'lucide-react';
import type { Cancha } from '../../types';
import { COURT_IMAGES } from '../../constants/courts';

interface CourtCardProps {
  court: Cancha;
}

export function CourtCard({ court }: CourtCardProps) {
  return (
    <div className="bg-white rounded-lg shadow-lg overflow-hidden">
      <div className="relative aspect-video">
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
            <Link
              to="/reservas"
              className="flex items-center gap-2 bg-white text-green-600 px-4 py-2 rounded-lg 
                       hover:bg-green-50 transition duration-200"
            >
              <Calendar className="w-5 h-5" />
              Reservar
            </Link>
          </div>
        </div>
      </div>
    </div>
  );
}