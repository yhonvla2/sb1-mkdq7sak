/*
  # Bookings (Reservas) Table Setup

  1. New Tables
    - `reservas` table for storing booking information
      - `id` (uuid, primary key)
      - `usuario_id` (uuid, foreign key to usuarios)
      - `cancha_id` (uuid, foreign key to canchas)
      - `fecha` (date) - Booking date
      - `hora_inicio` (time) - Start time
      - `hora_fin` (time) - End time
      - `estado` (text) - Booking status (pendiente/confirmada/cancelada)
      - `creado_en` (timestamptz) - Creation timestamp

  2. Security
    - Enable RLS
    - Add policies for users to manage their own bookings
    - Add policies for admin access
*/

-- Create bookings table
CREATE TABLE IF NOT EXISTS reservas (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  usuario_id uuid REFERENCES usuarios(id) ON DELETE CASCADE,
  cancha_id uuid REFERENCES canchas(id) ON DELETE CASCADE,
  fecha DATE NOT NULL,
  hora_inicio TIME NOT NULL,
  hora_fin TIME NOT NULL,
  estado TEXT DEFAULT 'pendiente' CHECK (estado IN ('pendiente', 'confirmada', 'cancelada')),
  creado_en TIMESTAMPTZ DEFAULT NOW()
);

-- Enable RLS
ALTER TABLE reservas ENABLE ROW LEVEL SECURITY;

-- Drop existing policies if they exist
DO $$ BEGIN
    DROP POLICY IF EXISTS "Users can view own bookings" ON reservas;
    DROP POLICY IF EXISTS "Users can create own bookings" ON reservas;
    DROP POLICY IF EXISTS "Users can update own bookings" ON reservas;
    DROP POLICY IF EXISTS "Admins can view all bookings" ON reservas;
    DROP POLICY IF EXISTS "Admins can manage all bookings" ON reservas;
EXCEPTION
    WHEN undefined_object THEN null;
END $$;

-- Users can view their own bookings
CREATE POLICY "Users can view own bookings"
ON reservas FOR SELECT
TO authenticated
USING (
  usuario_id IN (
    SELECT id FROM usuarios
    WHERE auth_id = auth.uid()
  )
);

-- Users can create their own bookings
CREATE POLICY "Users can create own bookings"
ON reservas FOR INSERT
TO authenticated
WITH CHECK (
  usuario_id IN (
    SELECT id FROM usuarios
    WHERE auth_id = auth.uid()
  )
);

-- Users can update their own bookings
CREATE POLICY "Users can update own bookings"
ON reservas FOR UPDATE
TO authenticated
USING (
  usuario_id IN (
    SELECT id FROM usuarios
    WHERE auth_id = auth.uid()
  )
);

-- Admins can view all bookings
CREATE POLICY "Admins can view all bookings"
ON reservas FOR SELECT
TO authenticated
USING (
  EXISTS (
    SELECT 1 FROM auth.users
    WHERE id = auth.uid()
    AND raw_user_meta_data->>'role' = 'admin'
  )
);

-- Admins can manage all bookings
CREATE POLICY "Admins can manage all bookings"
ON reservas FOR ALL
TO authenticated
USING (
  EXISTS (
    SELECT 1 FROM auth.users
    WHERE id = auth.uid()
    AND raw_user_meta_data->>'role' = 'admin'
  )
);