/*
  # Seed Default Courts
  
  1. Data Added:
    - Default courts (4 courts: 3 volleyball, 1 futsal)
  
  2. Notes:
    - Uses safe insert pattern with existence checks
    - Ensures no duplicate courts are created
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