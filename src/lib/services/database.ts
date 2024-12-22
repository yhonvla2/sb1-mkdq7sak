import { supabase } from '../supabase';

export async function initializeDatabase() {
  try {
    // Test connection
    const { error: connectionError } = await supabase.from('canchas').select('count');
    if (connectionError) {
      console.error('Database connection error:', connectionError);
      return false;
    }

    // Check if initial data exists
    const { data: existingCourts, error: checkError } = await supabase
      .from('canchas')
      .select('count');

    if (checkError) {
      console.error('Error checking database:', checkError);
      return false;
    }

    // If no courts exist, create initial data
    if (!existingCourts?.length) {
      const { error: insertError } = await supabase
        .from('canchas')
        .insert([
          { nombre: 'Cancha de Voley 1', tipo: 'voley' },
          { nombre: 'Cancha de Voley 2', tipo: 'voley' },
          { nombre: 'Cancha de Voley 3', tipo: 'voley' },
          { nombre: 'Cancha de Futsal', tipo: 'futsal' }
        ]);

      if (insertError) {
        console.error('Error inserting initial data:', insertError);
        return false;
      }
    }

    return true;
  } catch (error) {
    console.error('Database initialization error:', error);
    return false;
  }
}