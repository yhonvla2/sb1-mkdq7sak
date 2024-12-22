import { useState, useEffect } from 'react';
import { supabase } from '../config/supabase';
import type { PostgrestError } from '@supabase/supabase-js';

export function useSupabaseQuery<T>(
  query: () => Promise<{ data: T | null; error: PostgrestError | null }>,
  deps: any[] = []
) {
  const [data, setData] = useState<T | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<Error | null>(null);

  useEffect(() => {
    const fetchData = async () => {
      try {
        setLoading(true);
        const { data, error } = await query();
        
        if (error) throw error;
        setData(data);
        setError(null);
      } catch (err) {
        console.error('Query error:', err);
        setError(err instanceof Error ? err : new Error('An error occurred'));
        setData(null);
      } finally {
        setLoading(false);
      }
    };

    fetchData();
  }, deps);

  return { data, loading, error };
}