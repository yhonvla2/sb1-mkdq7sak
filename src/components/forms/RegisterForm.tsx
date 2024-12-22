import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { AlertCircle } from 'lucide-react';
import { supabase } from '../../lib/supabase';
import type { NuevoUsuario } from '../../types';

export function RegisterForm() {
  const navigate = useNavigate();
  const [loading, setLoading] = useState(false);
  const [errors, setErrors] = useState<{[key: string]: string}>({});
  const [formData, setFormData] = useState({
    nombres: '',
    apellidos: '',
    correo: '',
    telefono: '',
    password: '',
    passwordConfirmation: ''
  });

  const validateForm = async () => {
    const newErrors: {[key: string]: string} = {};

    // Validate email format
    if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(formData.correo)) {
      newErrors.correo = 'El formato del correo electrónico no es válido';
    }

    // Validate phone format (assuming Peruvian phone numbers)
    if (!/^9\d{8}$/.test(formData.telefono)) {
      newErrors.telefono = 'El número de teléfono debe tener 9 dígitos y empezar con 9';
    }

    // Check if email exists
    const { data: emailExists } = await supabase
      .from('usuarios')
      .select('correo')
      .eq('correo', formData.correo)
      .single();

    if (emailExists) {
      newErrors.correo = 'Este correo electrónico ya está registrado';
    }

    // Check if phone exists
    const { data: phoneExists } = await supabase
      .from('usuarios')
      .select('telefono')
      .eq('telefono', formData.telefono)
      .single();

    if (phoneExists) {
      newErrors.telefono = 'Este número de teléfono ya está registrado';
    }

    // Validate password
    if (formData.password.length < 6) {
      newErrors.password = 'La contraseña debe tener al menos 6 caracteres';
    }

    if (formData.password !== formData.passwordConfirmation) {
      newErrors.passwordConfirmation = 'Las contraseñas no coinciden';
    }

    setErrors(newErrors);
    return Object.keys(newErrors).length === 0;
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);
    setErrors({});

    try {
      const isValid = await validateForm();
      if (!isValid) {
        setLoading(false);
        return;
      }

      // Create auth user
      const { data: authData, error: authError } = await supabase.auth.signUp({
        email: formData.correo,
        password: formData.password,
      });

      if (authError) throw authError;
      if (!authData.user) throw new Error('No se pudo crear el usuario');

      // Create user profile
      const { error: profileError } = await supabase
        .from('usuarios')
        .insert({
          auth_id: authData.user.id,
          nombres: formData.nombres,
          apellidos: formData.apellidos,
          correo: formData.correo,
          telefono: formData.telefono,
          provider: 'email'
        });

      if (profileError) throw profileError;

      navigate('/login');
    } catch (err) {
      console.error('Registration error:', err);
      setErrors({
        general: err instanceof Error ? err.message : 'Error al registrar usuario'
      });
    } finally {
      setLoading(false);
    }
  };

  const renderError = (field: string) => {
    if (errors[field]) {
      return (
        <div className="mt-1 text-sm text-red-600 flex items-center gap-1">
          <AlertCircle className="w-4 h-4" />
          <span>{errors[field]}</span>
        </div>
      );
    }
    return null;
  };

  return (
    <div className="space-y-6">
      <form onSubmit={handleSubmit} className="space-y-4">
        <div className="grid grid-cols-2 gap-4">
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">
              Nombres
            </label>
            <input
              type="text"
              required
              className="w-full px-3 py-2 border border-gray-300 rounded-md focus:ring-2 focus:ring-green-500"
              value={formData.nombres}
              onChange={(e) => setFormData({ ...formData, nombres: e.target.value })}
            />
            {renderError('nombres')}
          </div>
          
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">
              Apellidos
            </label>
            <input
              type="text"
              required
              className="w-full px-3 py-2 border border-gray-300 rounded-md focus:ring-2 focus:ring-green-500"
              value={formData.apellidos}
              onChange={(e) => setFormData({ ...formData, apellidos: e.target.value })}
            />
            {renderError('apellidos')}
          </div>
        </div>
        
        <div>
          <label className="block text-sm font-medium text-gray-700 mb-1">
            Correo Electrónico
          </label>
          <input
            type="email"
            required
            className="w-full px-3 py-2 border border-gray-300 rounded-md focus:ring-2 focus:ring-green-500"
            value={formData.correo}
            onChange={(e) => setFormData({ ...formData, correo: e.target.value })}
          />
          {renderError('correo')}
        </div>
        
        <div>
          <label className="block text-sm font-medium text-gray-700 mb-1">
            Contraseña
          </label>
          <input
            type="password"
            required
            minLength={6}
            className="w-full px-3 py-2 border border-gray-300 rounded-md focus:ring-2 focus:ring-green-500"
            value={formData.password}
            onChange={(e) => setFormData({ ...formData, password: e.target.value })}
          />
          {renderError('password')}
        </div>

        <div>
          <label className="block text-sm font-medium text-gray-700 mb-1">
            Confirmar Contraseña
          </label>
          <input
            type="password"
            required
            minLength={6}
            className="w-full px-3 py-2 border border-gray-300 rounded-md focus:ring-2 focus:ring-green-500"
            value={formData.passwordConfirmation}
            onChange={(e) => setFormData({ ...formData, passwordConfirmation: e.target.value })}
          />
          {renderError('passwordConfirmation')}
        </div>
        
        <div>
          <label className="block text-sm font-medium text-gray-700 mb-1">
            Teléfono
          </label>
          <input
            type="tel"
            required
            pattern="9[0-9]{8}"
            placeholder="9XXXXXXXX"
            className="w-full px-3 py-2 border border-gray-300 rounded-md focus:ring-2 focus:ring-green-500"
            value={formData.telefono}
            onChange={(e) => setFormData({ ...formData, telefono: e.target.value })}
          />
          {renderError('telefono')}
        </div>

        {errors.general && (
          <div className="rounded-md bg-red-50 p-4">
            <div className="flex">
              <AlertCircle className="h-5 w-5 text-red-400" />
              <div className="ml-3">
                <h3 className="text-sm font-medium text-red-800">{errors.general}</h3>
              </div>
            </div>
          </div>
        )}
        
        <button
          type="submit"
          disabled={loading}
          className="w-full bg-green-600 text-white py-2 px-4 rounded-md hover:bg-green-700 
                   transition duration-200 disabled:opacity-50"
        >
          {loading ? 'Registrando...' : 'Registrar'}
        </button>
      </form>
    </div>
  );
}