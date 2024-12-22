/*
  # Database Schema Update
  
  1. Tables
    - usuarios (users table with auth integration)
    - canchas (sports courts)
    - reservas (bookings)
    - pagos (payments)
  
  2. Security
    - RLS enabled on all tables
    - Public read access for courts
    - User-specific policies
*/

-- Drop existing policies if they exist
DO $$ 
BEGIN
    DROP POLICY IF EXISTS "Permitir lectura pública de canchas" ON canchas;
    DROP POLICY IF EXISTS "Usuarios pueden ver su propio perfil" ON usuarios;
    DROP POLICY IF EXISTS "Usuarios pueden crear su perfil" ON usuarios;
    DROP POLICY IF EXISTS "Usuarios pueden ver sus reservas" ON reservas;
    DROP POLICY IF EXISTS "Usuarios pueden crear reservas" ON reservas;
    DROP POLICY IF EXISTS "Usuarios pueden ver sus pagos" ON pagos;
EXCEPTION
    WHEN undefined_table THEN
        NULL;
END $$;

-- Create usuarios table
CREATE TABLE IF NOT EXISTS usuarios (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    auth_id uuid REFERENCES auth.users(id),
    nombre TEXT NOT NULL,
    correo TEXT NOT NULL UNIQUE,
    telefono TEXT,
    creado_en TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW())
);

-- Create canchas table
CREATE TABLE IF NOT EXISTS canchas (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    nombre TEXT NOT NULL UNIQUE,
    tipo TEXT NOT NULL CHECK (tipo IN ('voley', 'futsal')),
    estado TEXT NOT NULL DEFAULT 'disponible' CHECK (estado IN ('disponible', 'mantenimiento'))
);

-- Create reservas table
CREATE TABLE IF NOT EXISTS reservas (
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
CREATE TABLE IF NOT EXISTS pagos (
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

-- Create new policies
CREATE POLICY "Permitir lectura pública de canchas"
    ON canchas FOR SELECT
    USING (true);

CREATE POLICY "Usuarios pueden ver su propio perfil"
    ON usuarios FOR SELECT
    USING (auth_id = auth.uid());

CREATE POLICY "Usuarios pueden crear su perfil"
    ON usuarios FOR INSERT
    WITH CHECK (auth_id = auth.uid());

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

CREATE POLICY "Usuarios pueden ver sus pagos"
    ON pagos FOR SELECT
    USING (reserva_id IN (
        SELECT id FROM reservas WHERE usuario_id IN (
            SELECT id FROM usuarios WHERE auth_id = auth.uid()
        )
    ));

-- Insert initial courts safely
DO $$ 
BEGIN
    IF NOT EXISTS (SELECT 1 FROM canchas WHERE nombre = 'Cancha de Voley 1') THEN
        INSERT INTO canchas (nombre, tipo) VALUES ('Cancha de Voley 1', 'voley');
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM canchas WHERE nombre = 'Cancha de Voley 2') THEN
        INSERT INTO canchas (nombre, tipo) VALUES ('Cancha de Voley 2', 'voley');
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM canchas WHERE nombre = 'Cancha de Voley 3') THEN
        INSERT INTO canchas (nombre, tipo) VALUES ('Cancha de Voley 3', 'voley');
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM canchas WHERE nombre = 'Cancha de Futsal') THEN
        INSERT INTO canchas (nombre, tipo) VALUES ('Cancha de Futsal', 'futsal');
    END IF;
END $$;