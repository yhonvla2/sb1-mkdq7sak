/*
  # Users Schema Setup

  1. New Tables
    - `usuarios` (users)
      - `id` (uuid, primary key)
      - `auth_id` (uuid, unique)
      - `nombres` (text)
      - `apellidos` (text) 
      - `correo` (text, unique)
      - `telefono` (text)
      - `rol` (text: usuario/admin)
      - `fecha_registro` (timestamptz)

  2. Security
    - Enable RLS
    - Add policy for users to read their own data
*/

DO $$ 
BEGIN
  -- Create users table if it doesn't exist
  CREATE TABLE IF NOT EXISTS usuarios (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    auth_id uuid UNIQUE,
    nombres text NOT NULL,
    apellidos text NOT NULL,
    correo text UNIQUE NOT NULL,
    telefono text,
    rol text DEFAULT 'usuario' CHECK (rol IN ('usuario', 'admin')),
    fecha_registro timestamptz DEFAULT now()
  );

  -- Enable RLS
  ALTER TABLE usuarios ENABLE ROW LEVEL SECURITY;

  -- Drop existing policy if exists
  DROP POLICY IF EXISTS "Users can read their own data" ON usuarios;

  -- Create policy for user data access
  CREATE POLICY "Users can read their own data"
    ON usuarios
    FOR SELECT
    TO authenticated
    USING (auth.uid() = auth_id);
END $$;