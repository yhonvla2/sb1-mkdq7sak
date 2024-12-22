/*
  # Database Schema Fix

  1. Tables
    - usuarios (users)
    - canchas (courts)
    - reservas (bookings)
    - pagos (payments)

  2. Security
    - Enable RLS on all tables
    - Public access policies for courts
    - Authenticated user policies for all tables
*/

-- Drop existing tables if they exist
DROP TABLE IF EXISTS pagos CASCADE;
DROP TABLE IF EXISTS reservas CASCADE;
DROP TABLE IF EXISTS canchas CASCADE;
DROP TABLE IF EXISTS usuarios CASCADE;

-- Create usuarios table
CREATE TABLE usuarios (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    auth_id uuid UNIQUE REFERENCES auth.users(id),
    nombre TEXT NOT NULL,
    correo TEXT NOT NULL UNIQUE,
    telefono TEXT,
    creado_en TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW())
);

-- Create canchas table
CREATE TABLE canchas (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    nombre TEXT NOT NULL UNIQUE,
    tipo TEXT NOT NULL CHECK (tipo IN ('voley', 'futsal')),
    estado TEXT NOT NULL DEFAULT 'disponible' CHECK (estado IN ('disponible', 'mantenimiento'))
);

-- Create reservas table
CREATE TABLE reservas (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    usuario_id uuid REFERENCES usuarios(id) ON DELETE CASCADE,
    cancha_id uuid REFERENCES canchas(id) ON DELETE CASCADE,
    fecha_reserva DATE NOT NULL,
    hora_inicio TIME NOT NULL,
    hora_fin TIME NOT NULL,
    estado TEXT NOT NULL DEFAULT 'pendiente' CHECK (estado IN ('pendiente', 'confirmada', 'cancelada')),
    creado_en TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW())
);

-- Create pagos table
CREATE TABLE pagos (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    reserva_id uuid REFERENCES reservas(id) ON DELETE CASCADE,
    monto NUMERIC(10,2) NOT NULL,
    metodo TEXT NOT NULL CHECK (metodo IN ('efectivo', 'tarjeta')),
    estado TEXT NOT NULL DEFAULT 'pendiente' CHECK (estado IN ('pendiente', 'completado')),
    creado_en TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW())
);

-- Enable RLS
ALTER TABLE usuarios ENABLE ROW LEVEL SECURITY;
ALTER TABLE canchas ENABLE ROW LEVEL SECURITY;
ALTER TABLE reservas ENABLE ROW LEVEL SECURITY;
ALTER TABLE pagos ENABLE ROW LEVEL SECURITY;

-- Policies for canchas (public access)
CREATE POLICY "Permitir lectura pública de canchas"
    ON canchas FOR SELECT
    USING (true);

-- Policies for usuarios
CREATE POLICY "Usuarios pueden ver su propio perfil"
    ON usuarios FOR SELECT
    USING (auth_id = auth.uid());

CREATE POLICY "Usuarios pueden actualizar su propio perfil"
    ON usuarios FOR UPDATE
    USING (auth_id = auth.uid())
    WITH CHECK (auth_id = auth.uid());

-- Policies for reservas
CREATE POLICY "Usuarios pueden ver sus reservas"
    ON reservas FOR SELECT
    USING (usuario_id IN (
        SELECT id FROM usuarios WHERE auth_id = auth.uid()
    ));

CREATE POLICY "Usuarios pueden crear reservas"
    ON reservas FOR INSERT
    WITH CHECK (usuario_id IN (
        SELECT id FROM usuarios WHERE auth_id = auth.uid()
    ));

CREATE POLICY "Usuarios pueden actualizar sus reservas"
    ON reservas FOR UPDATE
    USING (usuario_id IN (
        SELECT id FROM usuarios WHERE auth_id = auth.uid()
    ));

-- Policies for pagos
CREATE POLICY "Usuarios pueden ver sus pagos"
    ON pagos FOR SELECT
    USING (reserva_id IN (
        SELECT id FROM reservas WHERE usuario_id IN (
            SELECT id FROM usuarios WHERE auth_id = auth.uid()
        )
    ));

CREATE POLICY "Usuarios pueden crear pagos"
    ON pagos FOR INSERT
    WITH CHECK (reserva_id IN (
        SELECT id FROM reservas WHERE usuario_id IN (
            SELECT id FROM usuarios WHERE auth_id = auth.uid()
        )
    ));

-- Insert initial data for canchas
INSERT INTO canchas (nombre, tipo) VALUES
    ('Cancha de Voley 1', 'voley'),
    ('Cancha de Voley 2', 'voley'),
    ('Cancha de Voley 3', 'voley'),
    ('Cancha de Futsal', 'futsal');