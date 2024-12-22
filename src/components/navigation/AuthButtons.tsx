import React from 'react';
import { Link } from 'react-router-dom';
import { LogIn, UserPlus } from 'lucide-react';
import { useAuth } from '../../lib/hooks/useAuth';

export function AuthButtons() {
  const { user } = useAuth();

  if (user) {
    return (
      <Link
        to="/bookings"
        className="bg-white text-green-600 px-4 py-2 rounded-lg hover:bg-green-50 transition"
      >
        Mis Reservas
      </Link>
    );
  }

  return (
    <div className="flex items-center space-x-4">
      <Link
        to="/login"
        className="flex items-center space-x-1 text-white hover:text-green-200 transition"
      >
        <LogIn className="h-5 w-5" />
        <span>Iniciar Sesión</span>
      </Link>
      <Link
        to="/register"
        className="flex items-center space-x-1 bg-white text-green-600 px-4 py-2 rounded-lg hover:bg-green-50 transition"
      >
        <UserPlus className="h-5 w-5" />
        <span>Registrarse</span>
      </Link>
    </div>
  );
}