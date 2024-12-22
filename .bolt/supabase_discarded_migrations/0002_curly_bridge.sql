/*
  # Fix Database Permissions

  1. Security Setup
    - Grant schema usage permissions
    - Grant table access permissions
    - Enable RLS on all tables
    - Set up access policies

  2. Changes
    - Grants schema usage to anon and authenticated roles
    - Grants table permissions for read/write operations
    - Enables RLS on all existing tables
    - Creates policies for public and authenticated access
*/

-- Grant usage on schema
GRANT USAGE ON SCHEMA public TO anon, authenticated;

-- Grant necessary table permissions
GRANT SELECT ON ALL TABLES IN SCHEMA public TO anon, authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO authenticated;

-- Ensure RLS is enabled on all tables
ALTER TABLE IF EXISTS todos ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS canchas ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS usuarios ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS reservas ENABLE ROW LEVEL SECURITY;

-- Drop existing policies if they exist
DROP POLICY IF EXISTS "Enable read access for all users" ON todos;
DROP POLICY IF EXISTS "Enable read access for all users" ON canchas;
DROP POLICY IF EXISTS "Enable read access for authenticated users" ON usuarios;
DROP POLICY IF EXISTS "Enable read access for authenticated users" ON reservas;

-- Create policies
CREATE POLICY "Enable read access for all users"
  ON todos FOR SELECT
  USING (true);

CREATE POLICY "Enable read access for all users"
  ON canchas FOR SELECT
  USING (true);

CREATE POLICY "Enable read access for authenticated users"
  ON usuarios FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Enable read access for authenticated users"
  ON reservas FOR SELECT
  TO authenticated
  USING (true);

-- Add insert/update policies for authenticated users
CREATE POLICY "Enable insert for authenticated users"
  ON reservas FOR INSERT
  TO authenticated
  WITH CHECK (true);

CREATE POLICY "Enable update for authenticated users"
  ON reservas FOR UPDATE
  TO authenticated
  USING (true);