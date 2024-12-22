/*
  # Payments Schema Setup

  1. New Tables
    - `pagos` (payments)
      - `id` (uuid, primary key)
      - `reserva_id` (uuid, foreign key)
      - `monto` (decimal)
      - `metodo` (text: efectivo/yape)
      - `estado` (text: pendiente/completado)
      - `fecha_registro` (timestamptz)

  2. Security
    - Enable RLS
    - Add policies for:
      - Users viewing their own payments
      - Users creating payments
*/

DO $$ 
BEGIN
  -- Create payments table
  CREATE TABLE IF NOT EXISTS pagos (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    reserva_id uuid REFERENCES reservas(id) ON DELETE CASCADE,
    monto decimal(10,2) NOT NULL,
    metodo text NOT NULL CHECK (metodo IN ('efectivo', 'yape')),
    estado text DEFAULT 'pendiente' CHECK (estado IN ('pendiente', 'completado')),
    fecha_registro timestamptz DEFAULT now()
  );

  -- Enable RLS
  ALTER TABLE pagos ENABLE ROW LEVEL SECURITY;

  -- Drop existing policies if they exist
  DROP POLICY IF EXISTS "Ver pagos propios" ON pagos;
  DROP POLICY IF EXISTS "Crear pagos propios" ON pagos;

  -- Create policies
  CREATE POLICY "Ver pagos propios"
    ON pagos
    FOR SELECT
    TO authenticated
    USING (
      reserva_id IN (
        SELECT id FROM reservas WHERE usuario_id IN (
          SELECT id FROM usuarios WHERE auth_id = auth.uid()
        )
      )
    );

  CREATE POLICY "Crear pagos propios"
    ON pagos
    FOR INSERT
    TO authenticated
    WITH CHECK (
      reserva_id IN (
        SELECT id FROM reservas WHERE usuario_id IN (
          SELECT id FROM usuarios WHERE auth_id = auth.uid()
        )
      )
    );
END $$;