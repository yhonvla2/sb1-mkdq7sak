import { useState, useEffect } from 'react';
import { supabase } from '../lib/supabase';
import type { Cancha } from '../types';

export function useCourts() {
  const [courts, setCourts] = useState<Cancha[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<Error | null>(null);

  useEffect(() => {
    async function loadCourts() {
      try {
        setLoading(true);
        const { data, error } = await supabase
          .from('canchas')
          .select('*')
          .order('nombre');

        if (error) throw error;
        setCourts(data || []);
      } catch (err) {
        setError(err instanceof Error ? err : new Error('Error al cargar las canchas'));
        console.error('Error al cargar las canchas:', err);
      } finally {
        setLoading(false);
      }
    }

    loadCourts();
  }, []);

  return { courts, loading, error };
}