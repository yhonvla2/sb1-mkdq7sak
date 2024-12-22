/*
  # Initial Schema Setup
  
  1. Tables
    - usuarios (users)
      - Basic user information
      - Auth integration
      - Role management
    - canchas (courts)
      - Court information
      - Type and status
    - reservas (bookings)
      - Booking management
      - Time slots
      - Status tracking
  
  2. Security
    - Row Level Security (RLS) enabled
    - Policies for data access
    - Auth integration
*/

-- Create usuarios (users) table
CREATE TABLE IF NOT EXISTS public.usuarios (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    auth_id UUID UNIQUE,
    nombres VARCHAR(255) NOT NULL,
    apellidos VARCHAR(255) NOT NULL,
    correo VARCHAR(255) UNIQUE NOT NULL,
    telefono VARCHAR(50) NOT NULL,
    rol VARCHAR(20) NOT NULL DEFAULT 'usuario' CHECK (rol IN ('usuario', 'admin')),
    fecha_registro TIMESTAMPTZ DEFAULT NOW() NOT NULL
);

-- Create canchas (courts) table
CREATE TABLE IF NOT EXISTS public.canchas (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nombre VARCHAR(255) NOT NULL,
    tipo VARCHAR(50) NOT NULL CHECK (tipo IN ('voley', 'futsal')),
    estado VARCHAR(50) NOT NULL DEFAULT 'disponible' CHECK (estado IN ('disponible', 'mantenimiento')),
    fecha_registro TIMESTAMPTZ DEFAULT NOW() NOT NULL
);

-- Create reservas (bookings) table
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

-- Enable Row Level Security
ALTER TABLE public.usuarios ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.canchas ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.reservas ENABLE ROW LEVEL SECURITY;

-- Create security policies
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

-- Insert default courts
INSERT INTO public.canchas (nombre, tipo) VALUES
    ('Cancha de Voley 1', 'voley'),
    ('Cancha de Voley 2', 'voley'),
    ('Cancha de Voley 3', 'voley'),
    ('Cancha de Futsal', 'futsal')
ON CONFLICT DO NOTHING;