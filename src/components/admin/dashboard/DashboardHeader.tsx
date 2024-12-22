import React from 'react';
import { Calendar, LogOut } from 'lucide-react';
import { useNavigate } from 'react-router-dom';
import { supabase } from '../../../lib/supabase';

export function DashboardHeader() {
  const navigate = useNavigate();

  const handleLogout = async () => {
    await supabase.auth.signOut();
    navigate('/admin/login');
  };

  return (
    <div className="bg-white shadow-md">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="flex justify-between items-center py-4">
          <div className="flex items-center">
            <Calendar className="h-8 w-8 text-green-600" />
            <h1 className="ml-2 text-2xl font-bold text-gray-900">
              Balón de Oro - Panel Administrativo
            </h1>
          </div>
          <button
            onClick={handleLogout}
            className="flex items-center px-4 py-2 text-sm font-medium text-gray-700 hover:text-gray-900"
          >
            <LogOut className="h-5 w-5 mr-2" />
            Cerrar Sesión
          </button>
        </div>
      </div>
    </div>
  );
}