/*
  # Add Initial Data
  
  1. Purpose:
    - Insert default courts if not exists
    - Create admin user if not exists
  
  2. Changes:
    - Safe inserts with existence checks for courts and admin user
    - No schema modifications
*/

DO $$ 
BEGIN
    -- Insert default courts if they don't exist
    IF NOT EXISTS (SELECT 1 FROM public.canchas LIMIT 1) THEN
        INSERT INTO public.canchas (nombre, tipo, estado) VALUES
            ('Cancha de Voley 1', 'voley', 'disponible'),
            ('Cancha de Voley 2', 'voley', 'disponible'),
            ('Cancha de Voley 3', 'voley', 'disponible'),
            ('Cancha de Futsal', 'futsal', 'disponible');
    END IF;

    -- Insert admin user if doesn't exist
    IF NOT EXISTS (SELECT 1 FROM public.usuarios WHERE correo = 'admin@balondeoro.com') THEN
        INSERT INTO public.usuarios (
            correo,
            nombres,
            apellidos,
            telefono,
            fecha_nacimiento,
            rol,
            provider
        ) VALUES (
            'admin@balondeoro.com',
            'Administrador',
            'Sistema',
            '950008353',
            '2000-01-01',
            'admin',
            'email'
        );
    END IF;
END $$;