import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { authService } from '../../lib/services/authService';

export function RegisterForm() {
  const navigate = useNavigate();
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [formData, setFormData] = useState({
    nombre: '',
    correo: '',
    contraseña: '',
  });

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);
    setError(null);

    try {
      await authService.signUp(
        formData.correo,
        formData.contraseña,
        { nombre: formData.nombre }
      );
      navigate('/login');
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Error al registrar usuario');
    } finally {
      setLoading(false);
    }
  };

  return (
    <form onSubmit={handleSubmit} className="space-y-4">
      <div>
        <label className="block text-sm font-medium text-gray-700">Nombre</label>
        <input
          type="text"
          required
          value={formData.nombre}
          onChange={(e) => setFormData({ ...formData, nombre: e.target.value })}
          className="w-full px-3 py-2 border rounded-md"
        />
      </div>

      <div>
        <label className="block text-sm font-medium text-gray-700">Correo</label>
        <input
          type="email"
          required
          value={formData.correo}
          onChange={(e) => setFormData({ ...formData, correo: e.target.value })}
          className="w-full px-3 py-2 border rounded-md"
        />
      </div>

      <div>
        <label className="block text-sm font-medium text-gray-700">Contraseña</label>
        <input
          type="password"
          required
          value={formData.contraseña}
          onChange={(e) => setFormData({ ...formData, contraseña: e.target.value })}
          className="w-full px-3 py-2 border rounded-md"
        />
      </div>

      {error && (
        <p className="text-red-600 text-sm">{error}</p>
      )}

      <button
        type="submit"
        disabled={loading}
        className="w-full bg-green-600 text-white py-2 px-4 rounded-md hover:bg-green-700 disabled:opacity-50"
      >
        {loading ? 'Registrando...' : 'Registrarse'}
      </button>
    </form>
  );
}