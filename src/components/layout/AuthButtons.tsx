import React from 'react';
import { Link, useNavigate } from 'react-router-dom';
import { LogIn, UserPlus, LogOut } from 'lucide-react';
import { useAuth } from '../../hooks/useAuth';
import { supabase } from '../../lib/supabase';

export function AuthButtons() {
  const { user } = useAuth();
  const navigate = useNavigate();

  const handleLogout = async () => {
    try {
      await supabase.auth.signOut();
      navigate('/');
    } catch (error) {
      console.error('Error al cerrar sesión:', error);
    }
  };

  if (user) {
    return (
      <div className="flex items-center space-x-4">
        <Link
          to="/reservas"
          className="text-white hover:text-green-200 transition"
        >
          Mis Reservas
        </Link>
        <button
          onClick={handleLogout}
          className="flex items-center space-x-1 bg-white text-green-600 px-4 py-2 rounded-lg hover:bg-green-50 transition"
        >
          <LogOut className="h-5 w-5" />
          <span>Cerrar Sesión</span>
        </button>
      </div>
    );
  }

  return (
    <div className="flex items-center space-x-4">
      <Link
        to="/login"
        className="text-white hover:text-green-200 transition flex items-center space-x-1"
      >
        <LogIn className="h-5 w-5" />
        <span>Iniciar Sesión</span>
      </Link>
      <Link
        to="/register"
        className="bg-white text-green-600 px-4 py-2 rounded-lg hover:bg-green-50 transition flex items-center space-x-1"
      >
        <UserPlus className="h-5 w-5" />
        <span>Registrarse</span>
      </Link>
    </div>
  );
}