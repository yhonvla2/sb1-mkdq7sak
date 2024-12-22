/*
  # Initial Database Schema Setup

  1. Tables
    - usuarios (users)
    - canchas (courts) 
    - reservas (bookings)
    - pagos (payments)

  2. Security
    - Enable RLS on all tables
    - Public read access for courts
    - Authenticated user policies
    - Admin role and policies
*/

-- Drop existing tables if they exist
DROP TABLE IF EXISTS pagos CASCADE;
DROP TABLE IF EXISTS reservas CASCADE;
DROP TABLE IF EXISTS canchas CASCADE;
DROP TABLE IF EXISTS usuarios CASCADE;

-- Create usuarios table
CREATE TABLE usuarios (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    auth_id uuid REFERENCES auth.users(id),
    nombres TEXT NOT NULL,
    apellidos TEXT NOT NULL,
    correo TEXT NOT NULL UNIQUE,
    telefono TEXT,
    rol TEXT NOT NULL DEFAULT 'usuario' CHECK (rol IN ('usuario', 'admin')),
    fecha_registro TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW())
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
    fecha DATE NOT NULL,
    hora_inicio TIME NOT NULL,
    hora_fin TIME NOT NULL,
    estado TEXT NOT NULL DEFAULT 'pendiente' CHECK (estado IN ('pendiente', 'confirmada', 'cancelada')),
    fecha_registro TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW())
);

-- Create pagos table
CREATE TABLE pagos (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    reserva_id uuid REFERENCES reservas(id) ON DELETE CASCADE,
    monto NUMERIC(10,2) NOT NULL,
    metodo TEXT NOT NULL CHECK (metodo IN ('efectivo', 'tarjeta', 'yape')),
    estado TEXT NOT NULL DEFAULT 'pendiente' CHECK (estado IN ('pendiente', 'completado')),
    fecha_registro TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW())
);

-- Enable Row Level Security
ALTER TABLE usuarios ENABLE ROW LEVEL SECURITY;
ALTER TABLE canchas ENABLE ROW LEVEL SECURITY;
ALTER TABLE reservas ENABLE ROW LEVEL SECURITY;
ALTER TABLE pagos ENABLE ROW LEVEL SECURITY;

-- Anonymous access policies
CREATE POLICY "Permitir lectura anónima de canchas"
    ON canchas FOR SELECT
    TO anon
    USING (true);

CREATE POLICY "Permitir lectura autenticada de canchas"
    ON canchas FOR SELECT
    TO authenticated
    USING (true);

-- Authenticated user policies
CREATE POLICY "Usuarios pueden ver su propio perfil"
    ON usuarios FOR SELECT
    TO authenticated
    USING (auth_id = auth.uid());

CREATE POLICY "Usuarios pueden actualizar su propio perfil"
    ON usuarios FOR UPDATE
    TO authenticated
    USING (auth_id = auth.uid())
    WITH CHECK (auth_id = auth.uid());

CREATE POLICY "Usuarios pueden insertar su perfil"
    ON usuarios FOR INSERT
    TO authenticated
    WITH CHECK (auth_id = auth.uid());

-- Admin policies
CREATE POLICY "Admins pueden ver todos los usuarios"
    ON usuarios FOR SELECT
    TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM usuarios u
            WHERE u.auth_id = auth.uid() AND u.rol = 'admin'
        )
    );

-- Booking policies
CREATE POLICY "Usuarios pueden ver sus reservas"
    ON reservas FOR SELECT
    TO authenticated
    USING (
        usuario_id IN (
            SELECT id FROM usuarios WHERE auth_id = auth.uid()
        )
        OR 
        EXISTS (
            SELECT 1 FROM usuarios u
            WHERE u.auth_id = auth.uid() AND u.rol = 'admin'
        )
    );

CREATE POLICY "Usuarios pueden crear reservas"
    ON reservas FOR INSERT
    TO authenticated
    WITH CHECK (
        usuario_id IN (
            SELECT id FROM usuarios WHERE auth_id = auth.uid()
        )
    );

CREATE POLICY "Usuarios pueden actualizar sus reservas"
    ON reservas FOR UPDATE
    TO authenticated
    USING (
        usuario_id IN (
            SELECT id FROM usuarios WHERE auth_id = auth.uid()
        )
        OR 
        EXISTS (
            SELECT 1 FROM usuarios u
            WHERE u.auth_id = auth.uid() AND u.rol = 'admin'
        )
    );

-- Payment policies
CREATE POLICY "Usuarios pueden ver sus pagos"
    ON pagos FOR SELECT
    TO authenticated
    USING (
        reserva_id IN (
            SELECT id FROM reservas 
            WHERE usuario_id IN (
                SELECT id FROM usuarios WHERE auth_id = auth.uid()
            )
        )
        OR 
        EXISTS (
            SELECT 1 FROM usuarios u
            WHERE u.auth_id = auth.uid() AND u.rol = 'admin'
        )
    );

CREATE POLICY "Usuarios pueden crear pagos"
    ON pagos FOR INSERT
    TO authenticated
    WITH CHECK (
        reserva_id IN (
            SELECT id FROM reservas 
            WHERE usuario_id IN (
                SELECT id FROM usuarios WHERE auth_id = auth.uid()
            )
        )
    );

-- Insert initial courts
INSERT INTO canchas (nombre, tipo) VALUES
    ('Cancha de Voley 1', 'voley'),
    ('Cancha de Voley 2', 'voley'),
    ('Cancha de Voley 3', 'voley'),
    ('Cancha de Futsal', 'futsal');