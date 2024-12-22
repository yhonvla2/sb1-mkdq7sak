import React, { useEffect, useState } from 'react';
import { supabase } from '../lib/supabase/client';

export function TestConnection() {
  const [status, setStatus] = useState<'loading' | 'success' | 'error'>('loading');
  const [message, setMessage] = useState('');

  useEffect(() => {
    async function testConnection() {
      try {
        const { data, error } = await supabase
          .from('canchas')
          .select('count')
          .single();

        if (error) throw error;
        
        setStatus('success');
        setMessage('Conexión exitosa con Supabase');
      } catch (err) {
        console.error('Error:', err);
        setStatus('error');
        setMessage('Error al conectar con Supabase');
      }
    }

    testConnection();
  }, []);

  return (
    <div className="p-4 rounded-lg border">
      <p className={`
        ${status === 'loading' && 'text-gray-600'}
        ${status === 'success' && 'text-green-600'}
        ${status === 'error' && 'text-red-600'}
      `}>
        {message}
      </p>
    </div>
  );
}