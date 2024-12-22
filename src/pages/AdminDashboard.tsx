import React, { useState, useEffect } from 'react';
import { Calendar, Users } from 'lucide-react';
import { adminService } from '../lib/services/adminService';
import { DashboardHeader } from '../components/admin/dashboard/DashboardHeader';
import { DashboardStats } from '../components/admin/dashboard/DashboardStats';
import { AdminBookingList } from '../components/admin/bookings/AdminBookingList';
import type { ReservaConUsuario } from '../types';

export default function AdminDashboard() {
  const [reservas, setReservas] = useState<ReservaConUsuario[]>([]);
  const [loading, setLoading] = useState(true);
  const [searchTerm, setSearchTerm] = useState('');

  useEffect(() => {
    loadReservas();
  }, []);

  const loadReservas = async () => {
    try {
      setLoading(true);
      const data = await adminService.obtenerReservas();
      setReservas(data);
    } catch (error) {
      console.error('Error al cargar reservas:', error);
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="min-h-screen bg-gray-50">
      <DashboardHeader />
      
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <DashboardStats />

        <div className="bg-white rounded-lg shadow-lg p-6">
          <div className="flex items-center justify-between mb-6">
            <div className="flex items-center gap-2">
              <Calendar className="h-6 w-6 text-green-600" />
              <h2 className="text-xl font-semibold text-gray-900">
                Gestión de Reservas
              </h2>
            </div>
            <input
              type="text"
              placeholder="Buscar por nombre..."
              value={searchTerm}
              onChange={(e) => setSearchTerm(e.target.value)}
              className="px-4 py-2 border border-gray-300 rounded-md focus:ring-2 focus:ring-green-500"
            />
          </div>

          <AdminBookingList
            bookings={reservas}
            loading={loading}
            searchTerm={searchTerm}
          />
        </div>
      </div>
    </div>
  );
}