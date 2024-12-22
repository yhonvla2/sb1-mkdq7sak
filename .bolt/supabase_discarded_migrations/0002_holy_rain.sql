/*
  # Todos Schema

  1. Tables
    - todos
      - id (uuid, primary key)
      - name (text)
      - completed (boolean)
      - created_at (timestamp)

  2. Security
    - Enable RLS on todos table
    - Add policy for public read access
*/

-- Create todos table
CREATE TABLE IF NOT EXISTS todos (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  completed boolean DEFAULT false,
  created_at timestamptz DEFAULT now()
);

-- Enable RLS
ALTER TABLE todos ENABLE ROW LEVEL SECURITY;

-- Drop existing policy if it exists
DROP POLICY IF EXISTS "Allow public read access" ON todos;

-- Create policy for public read access
CREATE POLICY "Allow public read access"
  ON todos
  FOR SELECT
  USING (true);

-- Insert some sample data
INSERT INTO todos (name) VALUES
  ('Learn Supabase'),
  ('Build awesome app'),
  ('Write tests');