/*
  # Fix Row Level Security Policies

  1. Changes
    - Enable RLS on all tables
    - Add policies for authenticated users to manage their own reservations
    - Add policies for public access to courts information
    
  2. Security
    - Users can only see and manage their own reservations
    - Courts information is publicly readable
    - Admins have full access to all tables
*/

-- Enable RLS
ALTER TABLE canchas ENABLE ROW LEVEL SECURITY;
ALTER TABLE usuarios ENABLE ROW LEVEL SECURITY;
ALTER TABLE reservas ENABLE ROW LEVEL SECURITY;

-- Public policies for courts
CREATE POLICY "Courts are publicly readable"
ON canchas FOR SELECT
TO PUBLIC
USING (true);

-- Authenticated user policies for reservations
CREATE POLICY "Users can view their own reservations"
ON reservas FOR SELECT
TO authenticated
USING (
  auth.uid()::text = (
    SELECT auth_id::text 
    FROM usuarios 
    WHERE id = usuario_id
  )
);

CREATE POLICY "Users can create their own reservations"
ON reservas FOR INSERT
TO authenticated
WITH CHECK (
  auth.uid()::text = (
    SELECT auth_id::text 
    FROM usuarios 
    WHERE id = usuario_id
  )
);

CREATE POLICY "Users can update their own reservations"
ON reservas FOR UPDATE
TO authenticated
USING (
  auth.uid()::text = (
    SELECT auth_id::text 
    FROM usuarios 
    WHERE id = usuario_id
  )
)
WITH CHECK (
  auth.uid()::text = (
    SELECT auth_id::text 
    FROM usuarios 
    WHERE id = usuario_id
  )
);

-- User profile policies
CREATE POLICY "Users can view their own profile"
ON usuarios FOR SELECT
TO authenticated
USING (auth.uid()::text = auth_id::text);

CREATE POLICY "Users can update their own profile"
ON usuarios FOR UPDATE
TO authenticated
USING (auth.uid()::text = auth_id::text)
WITH CHECK (auth.uid()::text = auth_id::text);

-- Admin policies (using is_admin() function)
CREATE OR REPLACE FUNCTION is_admin()
RETURNS BOOLEAN AS $$
BEGIN
  RETURN EXISTS (
    SELECT 1 FROM usuarios
    WHERE auth_id = auth.uid()::uuid
    AND rol = 'admin'
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Admin policies for all tables
CREATE POLICY "Admins have full access to courts"
ON canchas FOR ALL
TO authenticated
USING (is_admin());

CREATE POLICY "Admins have full access to reservations"
ON reservas FOR ALL
TO authenticated
USING (is_admin());

CREATE POLICY "Admins have full access to users"
ON usuarios FOR ALL
TO authenticated
USING (is_admin());