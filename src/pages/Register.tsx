import React from 'react';
import { UserPlus } from 'lucide-react';
import { RegisterForm } from '../components/forms/RegisterForm';

export default function Register() {
  return (
    <div className="max-w-md mx-auto">
      <div className="bg-white rounded-lg shadow-xl p-8">
        <div className="flex items-center justify-center mb-6">
          <UserPlus className="h-12 w-12 text-green-600" />
        </div>
        
        <h1 className="text-2xl font-bold text-center text-gray-800 mb-6">
          Registro de Usuario
        </h1>
        
        <RegisterForm />
      </div>
    </div>
  );
}