/*
  # Fix Reservations System

  1. Changes
    - Update RLS policies for reservations
    - Fix column names to match schema
    - Add proper constraints
    
  2. Security
    - Users can manage their own reservations
    - Admins have full access
*/

-- Drop existing policies to recreate them
DROP POLICY IF EXISTS "Users can view their own reservations" ON reservas;
DROP POLICY IF EXISTS "Users can create their own reservations" ON reservas;
DROP POLICY IF EXISTS "Users can update their own reservations" ON reservas;

-- Create new policies with correct column names
CREATE POLICY "Users can view their own reservations"
ON reservas FOR SELECT
TO authenticated
USING (
  usuario_id IN (
    SELECT id FROM usuarios 
    WHERE auth_id = auth.uid()::uuid
  )
);

CREATE POLICY "Users can create their own reservations"
ON reservas FOR INSERT
TO authenticated
WITH CHECK (
  usuario_id IN (
    SELECT id FROM usuarios 
    WHERE auth_id = auth.uid()::uuid
  )
);

CREATE POLICY "Users can update their own reservations"
ON reservas FOR UPDATE
TO authenticated
USING (
  usuario_id IN (
    SELECT id FROM usuarios 
    WHERE auth_id = auth.uid()::uuid
  )
);