import React, { useState } from 'react';
import { supabase } from '../lib/supabase/client';

const CrearUsuario: React.FC = () => {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [message, setMessage] = useState<string | null>(null);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setMessage(null);

    try {
      const { error } = await supabase.auth.signUp({
        email,
        password,
      });

      if (error) {
        console.error('Error al registrar usuario:', error);
        setMessage(`Error: ${error.message}`);
        return;
      }

      setMessage('Usuario creado exitosamente');
      setEmail('');
      setPassword('');
    } catch (err: any) {
      console.error('Error inesperado:', err);
      setMessage('Error inesperado al registrar usuario');
    }
  };

  return (
    <div className="max-w-md mx-auto">
      <h2 className="text-2xl font-bold mb-4">Crear Usuario</h2>
      {message && <p className="mb-4">{message}</p>}
      <form onSubmit={handleSubmit} className="space-y-4">
        <div>
          <label className="block font-medium">Email</label>
          <input
            type="email"
            value={email}
            onChange={(e) => setEmail(e.target.value)}
            className="w-full border px-4 py-2"
            required
          />
        </div>
        <div>
          <label className="block font-medium">Contraseña</label>
          <input
            type="password"
            value={password}
            onChange={(e) => setPassword(e.target.value)}
            className="w-full border px-4 py-2"
            required
          />
        </div>
        <button type="submit" className="bg-blue-500 text-white px-4 py-2">
          Crear Usuario
        </button>
      </form>
    </div>
  );
};

export default CrearUsuario;
