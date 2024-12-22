/*
  # Seed Courts and Admin User
  
  1. Data Added:
    - Default courts (4 courts: 3 volleyball, 1 futsal)
    - Admin user with email yhonyv7@gmail.com
  
  2. Notes:
    - Uses safe insert patterns with existence checks
    - Updates admin role if user already exists
*/

-- Insert default courts if they don't exist
INSERT INTO public.canchas (nombre, tipo)
SELECT * FROM (VALUES
    ('Cancha de Voley 1', 'voley'),
    ('Cancha de Voley 2', 'voley'),
    ('Cancha de Voley 3', 'voley'),
    ('Cancha de Futsal', 'futsal')
) AS new_courts(nombre, tipo)
WHERE NOT EXISTS (
    SELECT 1 FROM public.canchas 
    WHERE nombre = new_courts.nombre
);

-- Create admin user if it doesn't exist
INSERT INTO public.usuarios (
    correo,
    nombres,
    apellidos,
    telefono,
    fecha_nacimiento,
    rol,
    provider
) VALUES (
    'yhonyv7@gmail.com',
    'Admin',
    'Usuario',
    '950008353',
    '2000-01-01',
    'admin',
    'email'
) ON CONFLICT (correo) 
DO UPDATE SET rol = 'admin';