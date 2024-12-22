import { useState, useEffect } from 'react';
import { format } from 'date-fns';
import { es } from 'date-fns/locale';
import { supabase } from '../lib/supabase';

export function Bookings() {
  const [bookings, setBookings] = useState([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    async function loadBookings() {
      const { data } = await supabase
        .from('reservas')
        .select(`
          *,
          usuarios (nombres, apellidos, telefono),
          canchas (nombre)
        `)
        .order('fecha', { ascending: false });
      
      setBookings(data || []);
      setLoading(false);
    }

    loadBookings();
  }, []);

  if (loading) {
    return <div className="p-6">Cargando...</div>;
  }

  return (
    <div className="p-6">
      <h1 className="text-2xl font-bold mb-6">Reservas</h1>
      
      <div className="bg-white rounded-lg shadow-md overflow-hidden">
        <table className="min-w-full divide-y divide-gray-200">
          <thead className="bg-gray-50">
            <tr>
              <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Cliente</th>
              <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Cancha</th>
              <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Fecha</th>
              <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Horario</th>
              <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Estado</th>
            </tr>
          </thead>
          <tbody className="bg-white divide-y divide-gray-200">
            {bookings.map((booking: any) => (
              <tr key={booking.id}>
                <td className="px-6 py-4 whitespace-nowrap">
                  {booking.usuarios.nombres} {booking.usuarios.apellidos}
                </td>
                <td className="px-6 py-4 whitespace-nowrap">
                  {booking.canchas.nombre}
                </td>
                <td className="px-6 py-4 whitespace-nowrap">
                  {format(new Date(booking.fecha), 'dd/MM/yyyy')}
                </td>
                <td className="px-6 py-4 whitespace-nowrap">
                  {booking.hora_inicio} - {booking.hora_fin}
                </td>
                <td className="px-6 py-4 whitespace-nowrap">
                  <span className={`px-2 py-1 rounded-full text-xs font-medium ${
                    booking.estado === 'confirmada' 
                      ? 'bg-green-100 text-green-800'
                      : booking.estado === 'pendiente'
                      ? 'bg-yellow-100 text-yellow-800'
                      : 'bg-red-100 text-red-800'
                  }`}>
                    {booking.estado}
                  </span>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
}