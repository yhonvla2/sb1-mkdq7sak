import { useSupabaseQuery } from './useSupabaseQuery';
import { supabase } from '../config/supabase';
import type { Cancha } from '../../types';

export function useCourts() {
  return useSupabaseQuery<Cancha[]>(() => 
    supabase
      .from('canchas')
      .select('*')
      .order('nombre')
  );
}