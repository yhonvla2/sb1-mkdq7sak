import React from 'react';
import { CheckCircle } from 'lucide-react';

interface BookingConfirmationProps {
  onNewBooking: () => void;
}

export function BookingConfirmation({ onNewBooking }: BookingConfirmationProps) {
  return (
    <div className="text-center py-12">
      <div className="flex justify-center mb-6">
        <div className="bg-green-100 rounded-full p-3">
          <CheckCircle className="w-12 h-12 text-green-600" />
        </div>
      </div>

      <h2 className="text-2xl font-bold text-gray-900 mb-4">
        ¡Reserva Confirmada!
      </h2>
      
      <p className="text-gray-600 mb-8">
        Tu reserva ha sido registrada exitosamente. Recibirás un correo de confirmación
        con los detalles de tu reserva.
      </p>

      <div className="space-y-4">
        <button
          onClick={onNewBooking}
          className="bg-green-600 text-white px-6 py-3 rounded-lg hover:bg-green-700 
                   transition-colors inline-flex items-center gap-2"
        >
          <Calendar className="w-5 h-5" />
          Realizar otra reserva
        </button>

        <p className="text-sm text-gray-500">
          * Recuerda que puedes ver tus reservas en tu perfil
        </p>
      </div>
    </div>
  );
}