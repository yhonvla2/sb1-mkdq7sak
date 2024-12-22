/*
  # Fix Database Permissions

  1. Changes
    - Enable RLS on all tables
    - Add policies for public access to courts
    - Add policies for authenticated users
    - Fix user registration flow

  2. Security
    - Enable RLS on all tables
    - Add appropriate policies for each table
*/

-- Enable RLS on all tables
ALTER TABLE usuarios ENABLE ROW LEVEL SECURITY;
ALTER TABLE canchas ENABLE ROW LEVEL SECURITY;
ALTER TABLE reservas ENABLE ROW LEVEL SECURITY;
ALTER TABLE pagos ENABLE ROW LEVEL SECURITY;

-- Allow public access to view courts
CREATE POLICY "Permitir ver canchas a todos"
ON canchas FOR SELECT
TO public
USING (true);

-- Users can view their own data
CREATE POLICY "Usuarios pueden ver sus datos"
ON usuarios FOR SELECT
TO authenticated
USING (id = auth.uid());

-- Users can insert their own data during registration
CREATE POLICY "Usuarios pueden registrarse"
ON usuarios FOR INSERT
TO authenticated
WITH CHECK (id = auth.uid());

-- Users can view their own reservations
CREATE POLICY "Usuarios pueden ver sus reservas"
ON reservas FOR SELECT
TO authenticated
USING (usuario_id = auth.uid());

-- Users can create their own reservations
CREATE POLICY "Usuarios pueden crear reservas"
ON reservas FOR INSERT
TO authenticated
WITH CHECK (usuario_id = auth.uid());

-- Users can view their own payments
CREATE POLICY "Usuarios pueden ver sus pagos"
ON pagos FOR SELECT
TO authenticated
USING (
  reserva_id IN (
    SELECT id FROM reservas 
    WHERE usuario_id = auth.uid()
  )
);