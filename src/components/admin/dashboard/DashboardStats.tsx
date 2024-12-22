import React from 'react';
import { Users, Calendar, Clock, CheckCircle } from 'lucide-react';

interface StatsCardProps {
  icon: React.ReactNode;
  title: string;
  value: string;
  description: string;
}

function StatsCard({ icon, title, value, description }: StatsCardProps) {
  return (
    <div className="bg-white rounded-lg shadow-md p-6">
      <div className="flex items-center">
        <div className="p-3 rounded-full bg-green-100 text-green-600">
          {icon}
        </div>
        <div className="ml-4">
          <h3 className="text-lg font-medium text-gray-900">{title}</h3>
          <div className="mt-1">
            <p className="text-2xl font-semibold text-green-600">{value}</p>
            <p className="text-sm text-gray-500">{description}</p>
          </div>
        </div>
      </div>
    </div>
  );
}

export function DashboardStats() {
  return (
    <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
      <StatsCard
        icon={<Calendar className="h-6 w-6" />}
        title="Reservas Hoy"
        value="12"
        description="Total de reservas del día"
      />
      <StatsCard
        icon={<Clock className="h-6 w-6" />}
        title="Próximas"
        value="8"
        description="Reservas pendientes"
      />
      <StatsCard
        icon={<CheckCircle className="h-6 w-6" />}
        title="Completadas"
        value="4"
        description="Reservas finalizadas"
      />
      <StatsCard
        icon={<Users className="h-6 w-6" />}
        title="Clientes"
        value="45"
        description="Clientes registrados"
      />
    </div>
  );
}