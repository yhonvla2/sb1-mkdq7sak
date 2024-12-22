import { supabase } from '../supabase';
import type { Usuario, NuevoUsuario } from '../../types';

export const usuarioService = {
  async crear(usuario: NuevoUsuario): Promise<Usuario> {
    const { data, error } = await supabase
      .from('usuarios')
      .insert(usuario)
      .select()
      .single();
      
    if (error) throw error;
    return data;
  },

  async obtenerPorCorreo(correo: string): Promise<Usuario | null> {
    const { data, error } = await supabase
      .from('usuarios')
      .select()
      .eq('correo', correo)
      .single();
      
    if (error && error.code !== 'PGRST116') throw error;
    return data;
  },

  async obtenerTodos(): Promise<Usuario[]> {
    const { data, error } = await supabase
      .from('usuarios')
      .select()
      .order('fecha_registro', { ascending: false });
      
    if (error) throw error;
    return data;
  }
};