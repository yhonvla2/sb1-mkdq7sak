import React from 'react';
import { Calendar, Clock, MapPin } from 'lucide-react';
import { format } from 'date-fns';
import { es } from 'date-fns/locale';
import type { Cancha } from '../../types';
import { COURT_IMAGES, BUSINESS_INFO } from '../../constants/business';

interface BookingSummaryProps {
  court: Cancha;
  date: Date;
  time: string;
  duration: number;
  onConfirm: () => void;
  isLoading: boolean;
}

export function BookingSummary({
  court,
  date,
  time,
  duration,
  onConfirm,
  isLoading
}: BookingSummaryProps) {
  const endTime = `${parseInt(time) + duration}:00`;

  return (
    <div className="bg-white rounded-lg shadow-lg overflow-hidden">
      <img
        src={COURT_IMAGES[court.nombre]}
        alt={court.nombre}
        className="w-full h-48 object-cover"
      />
      
      <div className="p-6 space-y-6">
        <div>
          <h3 className="text-xl font-semibold text-gray-900 mb-2">
            {court.nombre}
          </h3>
          <p className="text-gray-600">
            Cancha de {court.tipo.charAt(0).toUpperCase() + court.tipo.slice(1)}
          </p>
        </div>

        <div className="space-y-4">
          <h4 className="font-medium text-gray-900">Detalles de la Reserva:</h4>
          
          <div className="flex items-center text-gray-600">
            <Calendar className="w-5 h-5 mr-2" />
            <span>{format(date, "EEEE d 'de' MMMM", { locale: es })}</span>
          </div>
          
          <div className="flex items-center text-gray-600">
            <Clock className="w-5 h-5 mr-2" />
            <span>{time} - {endTime} ({duration} {duration === 1 ? 'hora' : 'horas'})</span>
          </div>

          <div className="flex items-center text-gray-600">
            <MapPin className="w-5 h-5 mr-2" />
            <span>{BUSINESS_INFO.address}</span>
          </div>
        </div>

        <button
          onClick={onConfirm}
          disabled={isLoading}
          className="w-full bg-green-600 text-white py-3 px-4 rounded-lg hover:bg-green-700 
                   transition duration-200 disabled:opacity-50 disabled:cursor-not-allowed"
        >
          {isLoading ? 'Confirmando...' : 'Confirmar Reserva'}
        </button>

        <p className="text-sm text-gray-500 text-center">
          * Puedes pagar por Yape al {BUSINESS_INFO.payments.yape} o en efectivo
        </p>
      </div>
    </div>
  );
}