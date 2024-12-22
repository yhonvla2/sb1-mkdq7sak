import { useState, useEffect } from 'react';
import { PostgrestError } from '@supabase/supabase-js';

export function useSupabaseQuery<T>(
  query: () => Promise<{ data: T | null; error: PostgrestError | null }>,
  deps: any[] = [] // Dependencias para reejecutar
) {
  const [data, setData] = useState<T | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<Error | null>(null);

  useEffect(() => {
    const fetchData = async () => {
      try {
        setLoading(true); // Mostrando "cargando..."
        const { data, error } = await query();

        if (error) throw error; // Si hay error, lo lanza
        setData(data); // Guarda los datos
        setError(null); // Limpia errores
      } catch (err) {
        console.error('Error en la consulta:', err);
        setError(err instanceof Error ? err : new Error('Ocurrió un error'));
        setData(null); // Limpia datos si hay error
      } finally {
        setLoading(false); // Termina "cargando"
      }
    };

    fetchData();
  }, deps);

  return { data, loading, error }; // Retorna datos, cargando y errores
}
