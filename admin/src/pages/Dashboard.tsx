import { useState, useEffect } from 'react';
import { format } from 'date-fns';
import { es } from 'date-fns/locale';
import { Users, Calendar } from 'lucide-react';
import { supabase } from '../lib/supabase';

export function Dashboard() {
  const [stats, setStats] = useState({
    totalUsers: 0,
    todayBookings: 0,
    pendingBookings: 0,
    confirmedBookings: 0
  });

  useEffect(() => {
    async function loadStats() {
      const today = format(new Date(), 'yyyy-MM-dd');
      
      // Get users count
      const { count: usersCount } = await supabase
        .from('usuarios')
        .select('*', { count: 'exact', head: true });

      // Get today's bookings
      const { data: todayBookings } = await supabase
        .from('reservas')
        .select('*')
        .eq('fecha', today);

      // Get pending bookings
      const { data: pendingBookings } = await supabase
        .from('reservas')
        .select('*')
        .eq('estado', 'pendiente');

      setStats({
        totalUsers: usersCount || 0,
        todayBookings: todayBookings?.length || 0,
        pendingBookings: pendingBookings?.length || 0,
        confirmedBookings: todayBookings?.filter(b => b.estado === 'confirmada').length || 0
      });
    }

    loadStats();
  }, []);

  return (
    <div className="p-6">
      <h1 className="text-2xl font-bold mb-6">Panel de Control</h1>
      
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
        <StatCard
          title="Usuarios Registrados"
          value={stats.totalUsers}
          icon={<Users className="w-6 h-6" />}
        />
        <StatCard
          title="Reservas Hoy"
          value={stats.todayBookings}
          icon={<Calendar className="w-6 h-6" />}
        />
        <StatCard
          title="Reservas Pendientes"
          value={stats.pendingBookings}
          icon={<Calendar className="w-6 h-6" />}
        />
        <StatCard
          title="Reservas Confirmadas"
          value={stats.confirmedBookings}
          icon={<Calendar className="w-6 h-6" />}
        />
      </div>
    </div>
  );
}

function StatCard({ title, value, icon }: { title: string; value: number; icon: React.ReactNode }) {
  return (
    <div className="bg-white p-6 rounded-lg shadow-md">
      <div className="flex items-center gap-3">
        <div className="p-3 bg-green-100 rounded-full text-green-600">
          {icon}
        </div>
        <div>
          <p className="text-gray-600 text-sm">{title}</p>
          <p className="text-2xl font-bold">{value}</p>
        </div>
      </div>
    </div>
  );
}