import { supabase } from './lib/supabase/client'; // Asegúrate de que la ruta sea correcta

const testConnection = async () => {
  const { data, error } = await supabase.from('usuarios').select('*'); // Cambia 'usuarios' por el nombre de tu tabla
  if (error) {
    console.error('Error al conectar con Supabase:', error.message);
  } else {
    console.log('Datos obtenidos desde Supabase:', data);
  }
};

testConnection();
