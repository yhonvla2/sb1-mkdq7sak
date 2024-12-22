import { supabase } from '../supabase';

export async function setUserAsAdmin(email: string) {
  try {
    const { data: user, error: userError } = await supabase
      .from('usuarios')
      .select('id')
      .eq('correo', email)
      .single();

    if (userError) throw userError;
    if (!user) throw new Error('Usuario no encontrado');

    const { error: updateError } = await supabase
      .from('usuarios')
      .update({ rol: 'admin' })
      .eq('id', user.id);

    if (updateError) throw updateError;

    return true;
  } catch (error) {
    console.error('Error setting user as admin:', error);
    return false;
  }
}