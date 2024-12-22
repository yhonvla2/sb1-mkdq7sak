/*
  # Basic Registration and Booking Tables

  1. New Tables
    - `usuarios` - Store user information
      - `id` (uuid, primary key)
      - `email` (text, unique)
      - `nombre` (text)
      - `telefono` (text)
    
    - `reservas` - Store booking information
      - `id` (uuid, primary key)
      - `usuario_id` (uuid, foreign key)
      - `fecha` (date)
      - `hora` (text)
      - `estado` (text)

  2. Security
    - Enable RLS on both tables
    - Add policies for authenticated users
*/

-- Create usuarios table
CREATE TABLE IF NOT EXISTS usuarios (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    email text UNIQUE NOT NULL,
    nombre text NOT NULL,
    telefono text,
    created_at timestamptz DEFAULT now()
);

-- Create reservas table
CREATE TABLE IF NOT EXISTS reservas (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    usuario_id uuid REFERENCES usuarios(id),
    fecha date NOT NULL,
    hora text NOT NULL,
    estado text DEFAULT 'pendiente',
    created_at timestamptz DEFAULT now()
);

-- Enable RLS
ALTER TABLE usuarios ENABLE ROW LEVEL SECURITY;
ALTER TABLE reservas ENABLE ROW LEVEL SECURITY;

-- Policies for usuarios
CREATE POLICY "Users can view their own data"
    ON usuarios FOR SELECT
    TO authenticated
    USING (auth.uid() = id);

-- Policies for reservas
CREATE POLICY "Users can view their own reservations"
    ON reservas FOR SELECT
    TO authenticated
    USING (usuario_id = auth.uid());

CREATE POLICY "Users can create their own reservations"
    ON reservas FOR INSERT
    TO authenticated
    WITH CHECK (usuario_id = auth.uid());