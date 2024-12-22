import { supabase } from '../supabase/client';

export const authService = {
  async signUp(email: string, password: string, userData: { nombre: string }) {
    const { data: authData, error: authError } = await supabase.auth.signUp({
      email,
      password,
      options: {
        data: userData
      }
    });

    if (authError) throw authError;
    if (!authData.user) throw new Error('No se pudo crear el usuario');

    // Create profile in usuarios table
    const { error: profileError } = await supabase
      .from('usuarios')
      .insert({
        auth_id: authData.user.id,
        nombre: userData.nombre,
        correo: email
      });

    if (profileError) throw profileError;
    return authData;
  },

  async signIn(email: string, password: string) {
    const { data, error } = await supabase.auth.signInWithPassword({
      email,
      password
    });
    if (error) throw error;
    return data;
  },

  async signOut() {
    const { error } = await supabase.auth.signOut();
    if (error) throw error;
  },

  async getCurrentUser() {
    const { data: { user }, error } = await supabase.auth.getUser();
    if (error) throw error;
    return user;
  }
};