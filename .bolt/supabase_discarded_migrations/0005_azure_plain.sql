/*
  # Authentication and Users Schema

  1. Tables
    - usuarios: Core user table with profile information
    - Added auth roles and user management
    - Automatic user profile creation

  2. Security
    - RLS policies for user data protection
    - Authentication-based access control
*/

-- Create auth roles enum if not exists
DO $$ BEGIN
    CREATE TYPE auth_role AS ENUM ('user', 'admin');
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

-- Create usuarios table
CREATE TABLE IF NOT EXISTS usuarios (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  auth_id uuid UNIQUE REFERENCES auth.users(id) ON DELETE CASCADE,
  nombres TEXT NOT NULL,
  apellidos TEXT NOT NULL,
  correo TEXT NOT NULL UNIQUE,
  telefono TEXT UNIQUE,
  rol auth_role DEFAULT 'user',
  provider TEXT DEFAULT 'email',
  fecha_registro TIMESTAMPTZ DEFAULT NOW()
);

-- Enable RLS
ALTER TABLE usuarios ENABLE ROW LEVEL SECURITY;

-- Drop existing policies if they exist
DROP POLICY IF EXISTS "Users can read own profile" ON usuarios;
DROP POLICY IF EXISTS "Users can update own profile" ON usuarios;

-- Users can read their own profile
CREATE POLICY "Users can read own profile"
ON usuarios FOR SELECT
TO authenticated
USING (auth_id = auth.uid());

-- Users can update their own profile
CREATE POLICY "Users can update own profile"
ON usuarios FOR UPDATE
TO authenticated
USING (auth_id = auth.uid())
WITH CHECK (auth_id = auth.uid());

-- Drop existing function and trigger if they exist
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
DROP FUNCTION IF EXISTS handle_new_user();

-- Create function to handle new user registration
CREATE OR REPLACE FUNCTION handle_new_user()
RETURNS trigger AS $$
BEGIN
  INSERT INTO usuarios (auth_id, nombres, apellidos, correo)
  VALUES (
    new.id,
    COALESCE(new.raw_user_meta_data->>'nombres', ''),
    COALESCE(new.raw_user_meta_data->>'apellidos', ''),
    new.email
  );
  RETURN new;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger for new user registration
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION handle_new_user();