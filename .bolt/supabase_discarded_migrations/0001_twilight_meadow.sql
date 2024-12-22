/*
  # Initial Database Schema
  
  1. Tables
    - usuarios: User profiles and authentication
    - canchas: Sports courts management
    - reservas: Booking system
    
  2. Security
    - RLS enabled on all tables
    - Secure policies for data access
    - Proper constraints and validations
*/

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Drop existing tables if they exist
DROP TABLE IF EXISTS public.reservas;
DROP TABLE IF EXISTS public.canchas;
DROP TABLE IF EXISTS public.usuarios;

-- Create usuarios (users) table
CREATE TABLE public.usuarios (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    auth_id UUID UNIQUE NOT NULL,
    nombres TEXT NOT NULL,
    apellidos TEXT NOT NULL,
    correo TEXT UNIQUE NOT NULL,
    telefono TEXT,
    rol TEXT NOT NULL DEFAULT 'usuario' CHECK (rol IN ('usuario', 'admin')),
    fecha_registro TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Create canchas (courts) table
CREATE TABLE public.canchas (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    nombre TEXT NOT NULL,
    tipo TEXT NOT NULL CHECK (tipo IN ('voley', 'futsal')),
    estado TEXT NOT NULL DEFAULT 'disponible' CHECK (estado IN ('disponible', 'mantenimiento')),
    fecha_registro TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Create reservas (bookings) table
CREATE TABLE public.reservas (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    usuario_id UUID NOT NULL REFERENCES public.usuarios(id) ON DELETE CASCADE,
    cancha_id UUID NOT NULL REFERENCES public.canchas(id) ON DELETE CASCADE,
    fecha DATE NOT NULL,
    hora_inicio TIME NOT NULL,
    hora_fin TIME NOT NULL,
    estado TEXT NOT NULL DEFAULT 'pendiente' CHECK (estado IN ('pendiente', 'confirmada', 'cancelada')),
    fecha_registro TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT horario_valido CHECK (hora_fin > hora_inicio),
    CONSTRAINT fecha_futura CHECK (fecha >= CURRENT_DATE)
);

-- Enable Row Level Security
ALTER TABLE public.usuarios ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.canchas ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.reservas ENABLE ROW LEVEL SECURITY;

-- Create RLS Policies

-- Usuarios policies
CREATE POLICY "Usuarios pueden ver su propio perfil"
    ON public.usuarios
    FOR SELECT
    TO authenticated
    USING (auth_id = auth.uid());

CREATE POLICY "Usuarios pueden actualizar su propio perfil"
    ON public.usuarios
    FOR UPDATE
    TO authenticated
    USING (auth_id = auth.uid());

-- Canchas policies
CREATE POLICY "Cualquiera puede ver las canchas"
    ON public.canchas
    FOR SELECT
    TO authenticated
    USING (true);

CREATE POLICY "Solo admins pueden modificar canchas"
    ON public.canchas
    FOR ALL
    TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM public.usuarios
            WHERE auth_id = auth.uid()
            AND rol = 'admin'
        )
    );

-- Reservas policies
CREATE POLICY "Usuarios pueden ver sus propias reservas"
    ON public.reservas
    FOR SELECT
    TO authenticated
    USING (
        usuario_id IN (
            SELECT id FROM public.usuarios
            WHERE auth_id = auth.uid()
        )
    );

CREATE POLICY "Usuarios pueden crear reservas"
    ON public.reservas
    FOR INSERT
    TO authenticated
    WITH CHECK (
        usuario_id IN (
            SELECT id FROM public.usuarios
            WHERE auth_id = auth.uid()
        )
    );

CREATE POLICY "Usuarios pueden actualizar sus propias reservas"
    ON public.reservas
    FOR UPDATE
    TO authenticated
    USING (
        usuario_id IN (
            SELECT id FROM public.usuarios
            WHERE auth_id = auth.uid()
        )
    );

-- Create indexes for better performance
CREATE INDEX idx_usuarios_auth_id ON public.usuarios(auth_id);
CREATE INDEX idx_reservas_usuario_id ON public.reservas(usuario_id);
CREATE INDEX idx_reservas_cancha_id ON public.reservas(cancha_id);
CREATE INDEX idx_reservas_fecha ON public.reservas(fecha);

-- Insert initial courts data
INSERT INTO public.canchas (nombre, tipo) VALUES
    ('Cancha de Voley 1', 'voley'),
    ('Cancha de Voley 2', 'voley'),
    ('Cancha de Voley 3', 'voley'),
    ('Cancha de Futsal', 'futsal')
ON CONFLICT DO NOTHING;