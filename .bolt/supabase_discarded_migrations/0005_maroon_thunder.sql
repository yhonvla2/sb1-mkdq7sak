/*
  # Reservas (Bookings) Schema Setup

  1. New Tables
    - `reservas` (bookings)
      - `id` (uuid, primary key)
      - `usuario_id` (uuid, foreign key to usuarios)
      - `cancha_id` (uuid, foreign key to canchas)
      - `fecha` (date)
      - `hora_inicio` (text)
      - `hora_fin` (text)
      - `estado` (text: pendiente/confirmada/cancelada)
      - `fecha_registro` (timestamptz)

  2. Security
    - Enable RLS
    - Add policies for:
      - Users viewing their own bookings
      - Users creating bookings
*/

CREATE TABLE IF NOT EXISTS reservas (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  usuario_id uuid REFERENCES usuarios(id) ON DELETE CASCADE,
  cancha_id uuid REFERENCES canchas(id) ON DELETE CASCADE,
  fecha date NOT NULL,
  hora_inicio text NOT NULL,
  hora_fin text NOT NULL,
  estado text DEFAULT 'pendiente' CHECK (estado IN ('pendiente', 'confirmada', 'cancelada')),
  fecha_registro timestamptz DEFAULT now()
);

ALTER TABLE reservas ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Users can view their own bookings" ON reservas;
DROP POLICY IF EXISTS "Users can create bookings" ON reservas;

CREATE POLICY "Users can view their own bookings"
  ON reservas
  FOR SELECT
  TO authenticated
  USING (usuario_id IN (
    SELECT id FROM usuarios WHERE auth_id = auth.uid()
  ));

CREATE POLICY "Users can create bookings"
  ON reservas
  FOR INSERT
  TO authenticated
  WITH CHECK (usuario_id IN (
    SELECT id FROM usuarios WHERE auth_id = auth.uid()
  ));