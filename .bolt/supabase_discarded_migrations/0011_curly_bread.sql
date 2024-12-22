/*
  # Clean Schema Setup
  
  1. Tables
    - usuarios (users)
    - canchas (courts) 
    - reservas (bookings)
  
  2. Security
    - Drop existing policies
    - Recreate tables if needed
    - Enable RLS
    - Add new policies
*/

-- Drop existing policies safely
DO $$ 
BEGIN
    -- Drop usuarios policies if they exist
    DROP POLICY IF EXISTS "Ver perfil propio" ON public.usuarios;
    DROP POLICY IF EXISTS "Actualizar perfil propio" ON public.usuarios;
    DROP POLICY IF EXISTS "Insertar perfil propio" ON public.usuarios;
    
    -- Drop canchas policies if they exist
    DROP POLICY IF EXISTS "Ver canchas" ON public.canchas;
    
    -- Drop reservas policies if they exist
    DROP POLICY IF EXISTS "Ver reservas propias" ON public.reservas;
    DROP POLICY IF EXISTS "Crear reservas propias" ON public.reservas;
END $$;

-- Create or update usuarios table
CREATE TABLE IF NOT EXISTS public.usuarios (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    auth_id UUID UNIQUE,
    nombres VARCHAR(255) NOT NULL,
    apellidos VARCHAR(255) NOT NULL,
    correo VARCHAR(255) UNIQUE NOT NULL,
    telefono VARCHAR(50) NOT NULL,
    fecha_nacimiento DATE NOT NULL,
    rol VARCHAR(20) NOT NULL DEFAULT 'usuario' CHECK (rol IN ('usuario', 'admin')),
    provider VARCHAR(50) DEFAULT 'email' CHECK (provider IN ('email', 'facebook')),
    fecha_registro TIMESTAMPTZ DEFAULT NOW() NOT NULL
);

-- Create or update canchas table
CREATE TABLE IF NOT EXISTS public.canchas (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nombre VARCHAR(255) NOT NULL,
    tipo VARCHAR(50) NOT NULL CHECK (tipo IN ('voley', 'futsal')),
    estado VARCHAR(50) NOT NULL DEFAULT 'disponible' CHECK (estado IN ('disponible', 'mantenimiento')),
    fecha_registro TIMESTAMPTZ DEFAULT NOW() NOT NULL
);

-- Create or update reservas table
CREATE TABLE IF NOT EXISTS public.reservas (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    usuario_id UUID REFERENCES public.usuarios(id) NOT NULL,
    cancha_id UUID REFERENCES public.canchas(id) NOT NULL,
    fecha DATE NOT NULL,
    hora_inicio TIME NOT NULL,
    hora_fin TIME NOT NULL,
    estado VARCHAR(50) NOT NULL DEFAULT 'pendiente' CHECK (estado IN ('pendiente', 'confirmada', 'cancelada')),
    fecha_registro TIMESTAMPTZ DEFAULT NOW() NOT NULL,
    CONSTRAINT reservas_sin_solapamiento UNIQUE (cancha_id, fecha, hora_inicio),
    CONSTRAINT rango_hora_valido CHECK (hora_fin > hora_inicio)
);

-- Enable RLS
ALTER TABLE public.usuarios ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.canchas ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.reservas ENABLE ROW LEVEL SECURITY;

-- Create new policies
-- Usuarios policies
CREATE POLICY "Ver perfil propio" ON public.usuarios
    FOR SELECT USING (auth.uid()::text = auth_id::text OR rol = 'admin');

CREATE POLICY "Actualizar perfil propio" ON public.usuarios
    FOR UPDATE USING (auth.uid()::text = auth_id::text);

CREATE POLICY "Insertar perfil propio" ON public.usuarios
    FOR INSERT WITH CHECK (auth.uid()::text = auth_id::text OR rol = 'admin');

-- Canchas policies
CREATE POLICY "Ver canchas" ON public.canchas
    FOR SELECT USING (true);

-- Reservas policies
CREATE POLICY "Ver reservas propias" ON public.reservas
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM public.usuarios 
            WHERE id = usuario_id 
            AND auth_id::text = auth.uid()::text
        ) OR EXISTS (
            SELECT 1 FROM public.usuarios 
            WHERE auth_id::text = auth.uid()::text 
            AND rol = 'admin'
        )
    );

CREATE POLICY "Crear reservas propias" ON public.reservas
    FOR INSERT WITH CHECK (
        EXISTS (
            SELECT 1 FROM public.usuarios 
            WHERE id = usuario_id 
            AND auth_id::text = auth.uid()::text
        )
    );

-- Insert default courts if they don't exist
INSERT INTO public.canchas (nombre, tipo) VALUES
    ('Cancha de Voley 1', 'voley'),
    ('Cancha de Voley 2', 'voley'),
    ('Cancha de Voley 3', 'voley'),
    ('Cancha de Futsal', 'futsal')
ON CONFLICT DO NOTHING;