/*
  # Authentication Improvements

  1. Changes
    - Add auth_id column to link usuarios table with Supabase Auth
    - Add email_verified flag for future email verification
    - Update RLS policies to use auth_id for authentication

  2. Security
    - Policies updated to use auth_id instead of id
    - Maintains admin access through rol column
*/

-- Add auth columns to usuarios table
ALTER TABLE public.usuarios 
ADD COLUMN IF NOT EXISTS auth_id UUID UNIQUE,
ADD COLUMN IF NOT EXISTS email_verified BOOLEAN DEFAULT false;

-- Update RLS policies
DROP POLICY IF EXISTS "Ver perfil propio" ON public.usuarios;
DROP POLICY IF EXISTS "Actualizar perfil propio" ON public.usuarios;
DROP POLICY IF EXISTS "Insertar perfil propio" ON public.usuarios;

CREATE POLICY "Ver perfil propio"
    ON public.usuarios FOR SELECT
    USING (auth.uid()::text = auth_id::text OR rol = 'admin');

CREATE POLICY "Actualizar perfil propio"
    ON public.usuarios FOR UPDATE
    USING (auth.uid()::text = auth_id::text);

CREATE POLICY "Insertar perfil propio"
    ON public.usuarios FOR INSERT
    WITH CHECK (auth.uid()::text = auth_id::text OR rol = 'admin');