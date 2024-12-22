import React from 'react';
import { format } from 'date-fns';
import { es } from 'date-fns/locale';
import { Calendar, Clock } from 'lucide-react';
import type { Cancha } from '../../../types';

interface BookingSummaryProps {
  court: Cancha;
  date: Date;
  startTime: string;
  endTime: string;
  duration: number;
}

export function BookingSummary({ 
  court, 
  date, 
  startTime, 
  endTime,
  duration 
}: BookingSummaryProps) {
  return (
    <div className="bg-gray-50 p-4 rounded-lg space-y-3">
      <h3 className="font-medium text-gray-900">Resumen de la Reserva</h3>
      
      <div className="space-y-2 text-sm text-gray-600">
        <div className="flex items-center gap-2">
          <Calendar className="w-4 h-4" />
          <span>{format(date, "EEEE d 'de' MMMM", { locale: es })}</span>
        </div>
        
        <div className="flex items-center gap-2">
          <Clock className="w-4 h-4" />
          <span>
            {startTime} - {endTime} ({duration} {duration === 1 ? 'hora' : 'horas'})
          </span>
        </div>
      </div>
    </div>
  );
}