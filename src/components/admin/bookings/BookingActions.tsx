import React from 'react';
import { Check, X, MoreVertical } from 'lucide-react';
import type { ReservaConUsuario } from '../../../types';
import { reservaService } from '../../../lib/services/reservas';

interface BookingActionsProps {
  booking: ReservaConUsuario;
}

export function BookingActions({ booking }: BookingActionsProps) {
  const handleConfirm = async () => {
    try {
      await reservaService.actualizarEstado(booking.id, 'confirmada');
      // Recargar la página o actualizar el estado
      window.location.reload();
    } catch (error) {
      console.error('Error al confirmar la reserva:', error);
      alert('Error al confirmar la reserva');
    }
  };

  const handleCancel = async () => {
    if (!confirm('¿Estás seguro de que deseas cancelar esta reserva?')) return;
    
    try {
      await reservaService.actualizarEstado(booking.id, 'cancelada');
      // Recargar la página o actualizar el estado
      window.location.reload();
    } catch (error) {
      console.error('Error al cancelar la reserva:', error);
      alert('Error al cancelar la reserva');
    }
  };

  if (booking.estado !== 'pendiente') {
    return (
      <button
        className="text-gray-400 hover:text-gray-500"
        title="Ver más opciones"
      >
        <MoreVertical className="h-5 w-5" />
      </button>
    );
  }

  return (
    <div className="flex space-x-2">
      <button
        onClick={handleConfirm}
        className="text-green-600 hover:text-green-700"
        title="Confirmar reserva"
      >
        <Check className="h-5 w-5" />
      </button>
      <button
        onClick={handleCancel}
        className="text-red-600 hover:text-red-700"
        title="Cancelar reserva"
      >
        <X className="h-5 w-5" />
      </button>
    </div>
  );
}