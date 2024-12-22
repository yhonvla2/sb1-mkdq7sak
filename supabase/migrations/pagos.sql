/*
  # Payments (Pagos) Table Setup

  1. New Tables
    - `pagos` table for storing payment information
      - `id` (uuid, primary key)
      - `reserva_id` (uuid, foreign key to reservas)
      - `monto` (numeric) - Payment amount
      - `metodo` (text) - Payment method (efectivo/tarjeta)
      - `estado` (text) - Payment status (pendiente/completado)
      - `fecha_registro` (timestamptz) - Payment timestamp

  2. Security
    - Enable RLS
    - Add policy for users to view their own payments
    - Add policies for admin access
*/

-- Create payments table
CREATE TABLE IF NOT EXISTS pagos (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  reserva_id uuid REFERENCES reservas(id) ON DELETE CASCADE,
  monto NUMERIC(12, 2) NOT NULL,
  metodo TEXT NOT NULL CHECK (metodo IN ('efectivo', 'tarjeta')),
  estado TEXT DEFAULT 'pendiente' CHECK (estado IN ('pendiente', 'completado')),
  fecha_registro TIMESTAMPTZ DEFAULT NOW()
);

-- Enable RLS
ALTER TABLE pagos ENABLE ROW LEVEL SECURITY;

-- Users can view their own payments
CREATE POLICY "Users can view own payments"
ON pagos FOR SELECT
TO authenticated
USING (
  reserva_id IN (
    SELECT id FROM reservas
    WHERE usuario_id IN (
      SELECT id FROM usuarios
      WHERE auth_id = auth.uid()
    )
  )
);

-- Admins can view all payments
CREATE POLICY "Admins can view all payments"
ON pagos FOR SELECT
TO authenticated
USING (
  EXISTS (
    SELECT 1 FROM auth.users
    WHERE id = auth.uid()
    AND raw_user_meta_data->>'role' = 'admin'
  )
);

-- Admins can manage payments
CREATE POLICY "Admins can manage payments"
ON pagos FOR ALL
TO authenticated
USING (
  EXISTS (
    SELECT 1 FROM auth.users
    WHERE id = auth.uid()
    AND raw_user_meta_data->>'role' = 'admin'
  )
);