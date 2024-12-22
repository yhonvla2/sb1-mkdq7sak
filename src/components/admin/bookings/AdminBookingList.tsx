import React from 'react';
import { Clock, User } from 'lucide-react';
import { format } from 'date-fns';
import { es } from 'date-fns/locale';
import type { ReservaConUsuario } from '../../../types';
import { BookingStatusBadge } from './BookingStatusBadge';
import { BookingActions } from './BookingActions';

interface AdminBookingListProps {
  bookings: ReservaConUsuario[];
  loading: boolean;
  searchTerm: string;
}

export function AdminBookingList({ bookings, loading, searchTerm }: AdminBookingListProps) {
  const filteredBookings = bookings.filter(booking => {
    const searchString = `${booking.usuarios?.nombres} ${booking.usuarios?.apellidos}`.toLowerCase();
    return searchString.includes(searchTerm.toLowerCase());
  });

  if (loading) {
    return (
      <div className="flex justify-center py-8">
        <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-green-600"></div>
      </div>
    );
  }

  if (filteredBookings.length === 0) {
    return (
      <div className="text-center py-8 text-gray-500">
        No hay reservas para mostrar
      </div>
    );
  }

  return (
    <div className="overflow-x-auto">
      <table className="min-w-full divide-y divide-gray-200">
        <thead className="bg-gray-50">
          <tr>
            <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
              Cliente
            </th>
            <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
              Fecha
            </th>
            <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
              Horario
            </th>
            <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
              Estado
            </th>
            <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
              Acciones
            </th>
          </tr>
        </thead>
        <tbody className="bg-white divide-y divide-gray-200">
          {filteredBookings.map((booking) => (
            <tr key={booking.id}>
              <td className="px-6 py-4 whitespace-nowrap">
                <div className="flex items-center">
                  <User className="h-5 w-5 text-gray-400 mr-2" />
                  <div className="text-sm font-medium text-gray-900">
                    {booking.usuarios?.nombres} {booking.usuarios?.apellidos}
                  </div>
                </div>
              </td>
              <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                {format(new Date(booking.fecha), "d 'de' MMMM", { locale: es })}
              </td>
              <td className="px-6 py-4 whitespace-nowrap">
                <div className="flex items-center">
                  <Clock className="h-5 w-5 text-gray-400 mr-2" />
                  <span className="text-sm text-gray-900">
                    {booking.hora_inicio} - {booking.hora_fin}
                  </span>
                </div>
              </td>
              <td className="px-6 py-4 whitespace-nowrap">
                <BookingStatusBadge status={booking.estado} />
              </td>
              <td className="px-6 py-4 whitespace-nowrap">
                <BookingActions booking={booking} />
              </td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}