/*
  # Bookings Management Schema

  1. Tables
    - reservas: Court booking records
    - pagos: Payment records for bookings

  2. Security
    - RLS policies for bookings
    - User-specific booking access
*/

-- Create reservas table
CREATE TABLE IF NOT EXISTS reservas (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  usuario_id uuid REFERENCES usuarios(id) ON DELETE CASCADE,
  cancha_id uuid REFERENCES canchas(id) ON DELETE CASCADE,
  fecha DATE NOT NULL,
  hora_inicio TIME NOT NULL,
  hora_fin TIME NOT NULL,
  estado TEXT DEFAULT 'pendiente' CHECK (estado IN ('pendiente', 'confirmada', 'cancelada')),
  creado_en TIMESTAMPTZ DEFAULT NOW(),
  CONSTRAINT valid_time_range CHECK (hora_fin > hora_inicio)
);

-- Create pagos table
CREATE TABLE IF NOT EXISTS pagos (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  reserva_id uuid REFERENCES reservas(id) ON DELETE CASCADE,
  monto NUMERIC(10,2) NOT NULL CHECK (monto > 0),
  metodo TEXT NOT NULL CHECK (metodo IN ('efectivo', 'yape')),
  estado TEXT DEFAULT 'pendiente' CHECK (estado IN ('pendiente', 'completado')),
  creado_en TIMESTAMPTZ DEFAULT NOW()
);

-- Enable RLS
ALTER TABLE reservas ENABLE ROW LEVEL SECURITY;
ALTER TABLE pagos ENABLE ROW LEVEL SECURITY;

-- Booking policies
CREATE POLICY "Users can view own bookings"
ON reservas FOR SELECT
TO authenticated
USING (
  usuario_id IN (
    SELECT id FROM usuarios
    WHERE auth_id = auth.uid()
  )
);

CREATE POLICY "Users can create bookings"
ON reservas FOR INSERT
TO authenticated
WITH CHECK (
  usuario_id IN (
    SELECT id FROM usuarios
    WHERE auth_id = auth.uid()
  )
);

CREATE POLICY "Users can update own bookings"
ON reservas FOR UPDATE
TO authenticated
USING (
  usuario_id IN (
    SELECT id FROM usuarios
    WHERE auth_id = auth.uid()
  )
);

-- Payment policies
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

CREATE POLICY "Users can create payments for own bookings"
ON pagos FOR INSERT
TO authenticated
WITH CHECK (
  reserva_id IN (
    SELECT id FROM reservas
    WHERE usuario_id IN (
      SELECT id FROM usuarios
      WHERE auth_id = auth.uid()
    )
  )
);