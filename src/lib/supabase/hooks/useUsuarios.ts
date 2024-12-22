import { useState, useEffect } from 'react';
import { supabase } from '../lib/supabase/client';

export function useUsuarios() {
  const [usuarios, setUsuarios] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<Error | null>(null);

  useEffect(() => {
    const fetchUsuarios = async () => {
      const { data, error } = await supabase.from('usuarios').select('*');
      if (error) {
        setError(error);
      } else {
        setUsuarios(data);
      }
      setLoading(false);
    };

    fetchUsuarios();
  }, []);

  return { usuarios, loading, error };
}
