import React from 'react';
import { Link } from 'react-router-dom';
import { LogIn } from 'lucide-react';
import { AuthForm } from '../components/auth/AuthForm';
import { useRedirectAuth } from '../lib/hooks/useRedirectAuth';

export default function Login() {
  const { loading } = useRedirectAuth('/bookings');

  if (loading) {
    return (
      <div className="flex items-center justify-center min-h-screen">
        <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-green-600"></div>
      </div>
    );
  }

  return (
    <div className="max-w-md mx-auto">
      <div className="bg-white rounded-lg shadow-xl p-8">
        <div className="flex items-center justify-center mb-6">
          <LogIn className="h-12 w-12 text-green-600" />
        </div>
        
        <h1 className="text-2xl font-bold text-center text-gray-800 mb-6">
          Iniciar Sesión
        </h1>
        
        <AuthForm />

        <div className="mt-6 text-center text-sm text-gray-600">
          ¿No tienes una cuenta?{' '}
          <Link to="/register" className="text-green-600 hover:text-green-700 font-medium">
            Regístrate aquí
          </Link>
        </div>
      </div>
    </div>
  );
}