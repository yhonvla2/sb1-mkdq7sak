/*
  # Initial Database Schema
  
  1. Tables
    - usuarios (users)
    - canchas (courts) 
    - reservas (bookings)
  
  2. Security
    - RLS enabled on all tables
    - Secure policies for data access
*/

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Create usuarios (users) table
CREATE TABLE IF NOT EXISTS public.usuarios (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    auth_id uuid UNIQUE NOT NULL,
    nombres text NOT NULL,
    apellidos text NOT NULL,
    correo text UNIQUE NOT NULL,
    telefono text,
    rol text NOT NULL DEFAULT 'usuario' CHECK (rol IN ('usuario', 'admin')),
    fecha_registro timestamptz NOT NULL DEFAULT now()
);

-- Create canchas (courts) table
CREATE TABLE IF NOT EXISTS public.canchas (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    nombre text NOT NULL,
    tipo text NOT NULL CHECK (tipo IN ('voley', 'futsal')),
    estado text NOT NULL DEFAULT 'disponible' CHECK (estado IN ('disponible', 'mantenimiento')),
    fecha_registro timestamptz NOT NULL DEFAULT now()
);

-- Create reservas (bookings) table
CREATE TABLE IF NOT EXISTS public.reservas (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    usuario_id uuid NOT NULL REFERENCES public.usuarios(id) ON DELETE CASCADE,
    cancha_id uuid NOT NULL REFERENCES public.canchas(id) ON DELETE CASCADE,
    fecha date NOT NULL,
    hora_inicio time NOT NULL,
    hora_fin time NOT NULL,
    estado text NOT NULL DEFAULT 'pendiente' CHECK (estado IN ('pendiente', 'confirmada', 'cancelada')),
    fecha_registro timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT horario_valido CHECK (hora_fin > hora_inicio),
    CONSTRAINT fecha_futura CHECK (fecha >= CURRENT_DATE)
);

-- Enable Row Level Security
ALTER TABLE public.usuarios ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.canchas ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.reservas ENABLE ROW LEVEL SECURITY;

-- Create RLS Policies
CREATE POLICY "Usuarios pueden ver su propio perfil"
    ON public.usuarios FOR SELECT
    TO authenticated
    USING (auth_id = auth.uid());

CREATE POLICY "Usuarios pueden actualizar su propio perfil"
    ON public.usuarios FOR UPDATE
    TO authenticated
    USING (auth_id = auth.uid());

CREATE POLICY "Cualquiera puede ver las canchas"
    ON public.canchas FOR SELECT
    TO authenticated
    USING (true);

CREATE POLICY "Solo admins pueden modificar canchas"
    ON public.canchas FOR ALL
    TO authenticated
    USING (EXISTS (
        SELECT 1 FROM public.usuarios
        WHERE auth_id = auth.uid()
        AND rol = 'admin'
    ));

CREATE POLICY "Usuarios pueden ver sus propias reservas"
    ON public.reservas FOR SELECT
    TO authenticated
    USING (usuario_id IN (
        SELECT id FROM public.usuarios
        WHERE auth_id = auth.uid()
    ));

CREATE POLICY "Usuarios pueden crear reservas"
    ON public.reservas FOR INSERT
    TO authenticated
    WITH CHECK (usuario_id IN (
        SELECT id FROM public.usuarios
        WHERE auth_id = auth.uid()
    ));

CREATE POLICY "Usuarios pueden actualizar sus propias reservas"
    ON public.reservas FOR UPDATE
    TO authenticated
    USING (usuario_id IN (
        SELECT id FROM public.usuarios
        WHERE auth_id = auth.uid()
    ));

-- Create indexes
CREATE INDEX IF NOT EXISTS idx_usuarios_auth_id ON public.usuarios(auth_id);
CREATE INDEX IF NOT EXISTS idx_reservas_usuario_id ON public.reservas(usuario_id);
CREATE INDEX IF NOT EXISTS idx_reservas_cancha_id ON public.reservas(cancha_id);
CREATE INDEX IF NOT EXISTS idx_reservas_fecha ON public.reservas(fecha);

-- Insert initial courts
INSERT INTO public.canchas (nombre, tipo) VALUES
    ('Cancha de Voley 1', 'voley'),
    ('Cancha de Voley 2', 'voley'),
    ('Cancha de Voley 3', 'voley'),
    ('Cancha de Futsal', 'futsal')
ON CONFLICT DO NOTHING;