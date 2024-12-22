-- Drop existing tables
DROP TABLE IF EXISTS public.administradores CASCADE;
DROP TABLE IF EXISTS public.reservas CASCADE;
DROP TABLE IF EXISTS public.canchas CASCADE;
DROP TABLE IF EXISTS public.usuarios CASCADE;

-- Create updated usuarios table with additional fields
CREATE TABLE public.usuarios (
  id uuid DEFAULT auth.uid() PRIMARY KEY,
  nombres varchar(255) NOT NULL,
  apellidos varchar(255) NOT NULL,
  correo varchar(255) UNIQUE NOT NULL,
  telefono varchar(50) NOT NULL,
  fecha_nacimiento date NOT NULL,
  rol varchar(20) NOT NULL DEFAULT 'usuario' CHECK (rol IN ('usuario', 'admin')),
  provider varchar(50) DEFAULT 'email' CHECK (provider IN ('email', 'facebook')),
  fecha_registro timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- Create updated canchas table
CREATE TABLE public.canchas (
  id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  nombre varchar(255) NOT NULL,
  tipo varchar(50) NOT NULL CHECK (tipo IN ('voley', 'futsal')),
  estado varchar(50) NOT NULL DEFAULT 'disponible' CHECK (estado IN ('disponible', 'mantenimiento')),
  fecha_registro timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- Create updated reservas table
CREATE TABLE public.reservas (
  id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  usuario_id uuid REFERENCES public.usuarios(id) NOT NULL,
  cancha_id uuid REFERENCES public.canchas(id) NOT NULL,
  fecha date NOT NULL,
  hora_inicio time NOT NULL,
  hora_fin time NOT NULL,
  estado varchar(50) NOT NULL DEFAULT 'pendiente' CHECK (estado IN ('pendiente', 'confirmada', 'cancelada')),
  fecha_registro timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
  CONSTRAINT reservas_sin_solapamiento UNIQUE (cancha_id, fecha, hora_inicio),
  CONSTRAINT rango_hora_valido CHECK (hora_fin > hora_inicio)
);

-- Insert default courts
INSERT INTO public.canchas (nombre, tipo) VALUES
  ('Cancha de Voley 1', 'voley'),
  ('Cancha de Voley 2', 'voley'),
  ('Cancha de Voley 3', 'voley'),
  ('Cancha de Futsal', 'futsal');

-- Enable RLS
ALTER TABLE public.usuarios ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.canchas ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.reservas ENABLE ROW LEVEL SECURITY;

-- Policies for usuarios
CREATE POLICY "Los usuarios pueden ver sus propios datos"
  ON public.usuarios FOR SELECT
  USING (auth.uid() = id OR rol = 'admin');

CREATE POLICY "Los usuarios pueden actualizar sus propios datos"
  ON public.usuarios FOR UPDATE
  USING (auth.uid() = id);

-- Policies for canchas
CREATE POLICY "Las canchas son visibles para todos"
  ON public.canchas FOR SELECT
  USING (true);

CREATE POLICY "Solo administradores pueden modificar canchas"
  ON public.canchas FOR ALL
  USING (EXISTS (
    SELECT 1 FROM public.usuarios 
    WHERE id = auth.uid() AND rol = 'admin'
  ));

-- Policies for reservas
CREATE POLICY "Los usuarios pueden ver sus propias reservas"
  ON public.reservas FOR SELECT
  USING (
    auth.uid() = usuario_id 
    OR EXISTS (
      SELECT 1 FROM public.usuarios 
      WHERE id = auth.uid() AND rol = 'admin'
    )
  );

CREATE POLICY "Los usuarios pueden crear reservas"
  ON public.reservas FOR INSERT
  WITH CHECK (auth.uid() = usuario_id);

CREATE POLICY "Los usuarios pueden modificar sus propias reservas"
  ON public.reservas FOR UPDATE
  USING (
    auth.uid() = usuario_id 
    OR EXISTS (
      SELECT 1 FROM public.usuarios 
      WHERE id = auth.uid() AND rol = 'admin'
    )
  );