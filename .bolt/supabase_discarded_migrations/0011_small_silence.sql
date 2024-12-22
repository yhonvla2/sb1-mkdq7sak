/*
  # Auth and Payment System Update

  1. Changes
    - Add auth columns to usuarios table
    - Add payment handling system
    - Update security policies

  2. Security
    - Updated RLS policies for auth integration
    - Payment access control
*/

-- Update usuarios table with auth columns
DO $$ 
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'usuarios' AND column_name = 'auth_id'
    ) THEN
        ALTER TABLE public.usuarios 
        ADD COLUMN auth_id UUID UNIQUE,
        ADD COLUMN email_verified BOOLEAN DEFAULT false;
    END IF;
END $$;

-- Create payments table if not exists
CREATE TABLE IF NOT EXISTS public.pagos (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    reserva_id UUID REFERENCES public.reservas(id) NOT NULL,
    monto DECIMAL(10,2) NOT NULL,
    metodo VARCHAR(50) NOT NULL CHECK (metodo IN ('efectivo', 'yape', 'plin')),
    estado VARCHAR(50) NOT NULL DEFAULT 'pendiente' CHECK (estado IN ('pendiente', 'completado', 'cancelado')),
    referencia VARCHAR(100),
    fecha_pago TIMESTAMPTZ,
    fecha_registro TIMESTAMPTZ DEFAULT NOW() NOT NULL
);

-- Enable RLS on pagos if not already enabled
ALTER TABLE public.pagos ENABLE ROW LEVEL SECURITY;

-- Safely update usuarios policies
DO $$ 
BEGIN
    -- Drop existing policies if they exist
    DROP POLICY IF EXISTS "Ver perfil propio" ON public.usuarios;
    DROP POLICY IF EXISTS "Actualizar perfil propio" ON public.usuarios;
    DROP POLICY IF EXISTS "Insertar perfil propio" ON public.usuarios;
    
    -- Create new policies
    CREATE POLICY "Ver perfil propio"
        ON public.usuarios FOR SELECT
        USING (auth.uid()::text = auth_id::text OR rol = 'admin');

    CREATE POLICY "Actualizar perfil propio"
        ON public.usuarios FOR UPDATE
        USING (auth.uid()::text = auth_id::text);

    CREATE POLICY "Insertar perfil propio"
        ON public.usuarios FOR INSERT
        WITH CHECK (auth.uid()::text = auth_id::text OR rol = 'admin');
END $$;

-- Safely create payment policies
DO $$ 
BEGIN
    -- Drop existing policies if they exist
    DROP POLICY IF EXISTS "Ver pagos propios" ON public.pagos;
    DROP POLICY IF EXISTS "Crear pagos propios" ON public.pagos;
    
    -- Create new policies
    CREATE POLICY "Ver pagos propios"
        ON public.pagos FOR SELECT
        USING (
            EXISTS (
                SELECT 1 FROM public.reservas r 
                WHERE r.id = pagos.reserva_id 
                AND (
                    EXISTS (
                        SELECT 1 FROM public.usuarios u 
                        WHERE u.auth_id::text = auth.uid()::text 
                        AND u.id = r.usuario_id
                    )
                    OR EXISTS (
                        SELECT 1 FROM public.usuarios u 
                        WHERE u.auth_id::text = auth.uid()::text 
                        AND u.rol = 'admin'
                    )
                )
            )
        );

    CREATE POLICY "Crear pagos propios"
        ON public.pagos FOR INSERT
        WITH CHECK (
            EXISTS (
                SELECT 1 FROM public.reservas r 
                JOIN public.usuarios u ON u.id = r.usuario_id
                WHERE r.id = reserva_id 
                AND u.auth_id::text = auth.uid()::text
            )
        );
END $$;