/*
  # Courts Management Schema

  1. Tables
    - canchas: Sports courts information
    - court_maintenance: Maintenance records

  2. Security
    - RLS policies for court data
    - Admin-only maintenance management
*/

-- Create canchas table
CREATE TABLE IF NOT EXISTS canchas (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  nombre TEXT NOT NULL UNIQUE,
  tipo TEXT NOT NULL CHECK (tipo IN ('voley', 'futsal')),
  estado TEXT DEFAULT 'disponible' CHECK (estado IN ('disponible', 'mantenimiento')),
  creado_en TIMESTAMPTZ DEFAULT NOW()
);

-- Enable RLS
ALTER TABLE canchas ENABLE ROW LEVEL SECURITY;

-- Everyone can read courts
CREATE POLICY "Anyone can view courts"
ON canchas FOR SELECT
TO authenticated
USING (true);

-- Only admins can modify courts
CREATE POLICY "Admins can modify courts"
ON canchas FOR ALL
TO authenticated
USING (
  EXISTS (
    SELECT 1 FROM usuarios
    WHERE auth_id = auth.uid()
    AND rol = 'admin'
  )
);