/*
  # Insert Initial Data

  1. Data Insertion
    - Default courts with their types and prices
    - Admin user for system management
    - Default business hours for each court

  2. Changes
    - Inserts initial records into canchas table
    - Creates admin user in usuarios table
    - Sets up default horarios for each court
*/

-- Insert courts if they don't exist
INSERT INTO public.canchas (nombre, tipo, precio_hora, estado)
SELECT * FROM (VALUES
    ('Cancha de Voley 1', 'voley', 20.00, 'disponible'),
    ('Cancha de Voley 2', 'voley', 20.00, 'disponible'),
    ('Cancha de Voley 3', 'voley', 20.00, 'disponible'),
    ('Cancha de Futsal', 'futsal', 25.00, 'disponible')
) AS new_courts(nombre, tipo, precio_hora, estado)
WHERE NOT EXISTS (
    SELECT 1 FROM public.canchas 
    WHERE nombre = new_courts.nombre
);

-- Insert admin user if doesn't exist
INSERT INTO public.usuarios (email, nombre, apellidos, telefono, rol)
VALUES (
    'admin@balondeoro.com',
    'Administrador',
    'Sistema',
    '950008353',
    'admin'
) ON CONFLICT (email) DO UPDATE SET rol = 'admin';

-- Insert default business hours for each court
INSERT INTO public.horarios (cancha_id, dia_semana, hora_apertura, hora_cierre)
SELECT 
    c.id,
    d.dia,
    CASE 
        WHEN d.dia BETWEEN 1 AND 5 THEN '08:00'::TIME  -- Lun-Vie
        ELSE '09:00'::TIME                             -- Sáb-Dom
    END as hora_apertura,
    '22:00'::TIME as hora_cierre
FROM public.canchas c
CROSS JOIN (SELECT generate_series(0,6) as dia) d
WHERE NOT EXISTS (
    SELECT 1 FROM public.horarios h 
    WHERE h.cancha_id = c.id AND h.dia_semana = d.dia
);