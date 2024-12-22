/*
  # Schedule Management System
  
  1. New Tables
    - `horarios` (schedules)
      - `id` (UUID, primary key)
      - `cancha_id` (UUID, foreign key to canchas)
      - `dia_semana` (integer, day of week 0-6)
      - `hora_apertura` (time, opening time)
      - `hora_cierre` (time, closing time)
      - `disponible` (boolean, availability)
      - `fecha_registro` (timestamp)
  
  2. Security
    - Enable RLS on schedules table
    - Add policy for viewing schedules (public)
    - Add policy for modifying schedules (admin only)
*/

-- Create schedule table
CREATE TABLE IF NOT EXISTS public.horarios (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    cancha_id UUID REFERENCES public.canchas(id) NOT NULL,
    dia_semana INTEGER NOT NULL CHECK (dia_semana BETWEEN 0 AND 6),
    hora_apertura TIME NOT NULL,
    hora_cierre TIME NOT NULL,
    disponible BOOLEAN DEFAULT true,
    fecha_registro TIMESTAMPTZ DEFAULT NOW() NOT NULL,
    CONSTRAINT horario_valido CHECK (hora_cierre > hora_apertura)
);

-- Enable RLS
ALTER TABLE public.horarios ENABLE ROW LEVEL SECURITY;

-- Create policies
DO $$ 
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_policies WHERE policyname = 'Ver horarios' AND tablename = 'horarios'
    ) THEN
        CREATE POLICY "Ver horarios" ON public.horarios
            FOR SELECT USING (true);
    END IF;

    IF NOT EXISTS (
        SELECT 1 FROM pg_policies WHERE policyname = 'Modificar horarios' AND tablename = 'horarios'
    ) THEN
        CREATE POLICY "Modificar horarios" ON public.horarios
            FOR ALL USING (
                EXISTS (
                    SELECT 1 FROM public.usuarios 
                    WHERE id = auth.uid() AND rol = 'admin'
                )
            );
    END IF;
END $$;