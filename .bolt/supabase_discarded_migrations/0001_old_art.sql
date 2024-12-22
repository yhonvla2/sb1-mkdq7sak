/*
  # Remove Birth Date Column
  
  1. Changes
    - Remove fecha_nacimiento column from users table
  
  2. Notes
    - Password confirmation is handled in frontend validation
    - Supabase auth handles password storage
*/

DO $$ 
BEGIN
  -- Check if the column exists before trying to drop it
  IF EXISTS (
    SELECT 1 
    FROM information_schema.columns 
    WHERE table_name = 'users' 
    AND column_name = 'fecha_nacimiento'
  ) THEN
    ALTER TABLE public.users DROP COLUMN fecha_nacimiento;
  END IF;
END $$;