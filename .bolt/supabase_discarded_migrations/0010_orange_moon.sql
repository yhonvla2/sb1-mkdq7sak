/*
  # Admin Setup Migration
  
  1. Changes
    - Create administrators table
    - Set up admin user
    - Create admin-specific policies
  
  2. Security
    - Enable RLS on administrators table
    - Add policies for admin access
*/

-- Create administrators table if it doesn't exist
CREATE TABLE IF NOT EXISTS public.administradores (
    id UUID PRIMARY KEY REFERENCES public.usuarios(id),
    fecha_registro TIMESTAMPTZ DEFAULT NOW() NOT NULL
);

-- Enable RLS on administrators table
ALTER TABLE public.administradores ENABLE ROW LEVEL SECURITY;

-- Insert admin user if they exist in usuarios table
INSERT INTO public.administradores (id)
SELECT id FROM public.usuarios 
WHERE correo = 'yhonyv7@gmail.com'
ON CONFLICT (id) DO NOTHING;

-- Policies for administrators table
CREATE POLICY "Los administradores pueden gestionar otros administradores"
  ON public.administradores FOR ALL
  USING (auth.uid() IN (SELECT id FROM public.administradores));

-- Policies for usuarios table
CREATE POLICY "Los administradores pueden ver todos los datos"
  ON public.usuarios FOR ALL
  USING (auth.uid() IN (SELECT id FROM public.administradores));

-- Policies for reservas table
CREATE POLICY "Los administradores pueden gestionar todas las reservas"
  ON public.reservas FOR ALL
  USING (auth.uid() IN (SELECT id FROM public.administradores));

-- Policies for canchas table
CREATE POLICY "Los administradores pueden gestionar canchas"
  ON public.canchas FOR ALL
  USING (auth.uid() IN (SELECT id FROM public.administradores));