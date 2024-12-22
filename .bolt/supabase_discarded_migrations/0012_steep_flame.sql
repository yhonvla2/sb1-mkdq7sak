/*
  # Payment System
  
  1. New Tables
    - `pagos` (payments)
      - `id` (UUID, primary key)
      - `reserva_id` (UUID, foreign key to reservas)
      - `monto` (decimal, payment amount)
      - `metodo` (varchar, payment method: efectivo/yape/plin)
      - `estado` (varchar, status: pendiente/completado/cancelado)
      - `referencia` (varchar, payment reference)
      - `fecha_pago` (timestamp, payment date)
      - `fecha_registro` (timestamp, creation date)
  
  2. Security
    - Enable RLS on payments table
    - Add policy for viewing own payments and admin access
    - Add policy for creating payments for own reservations
*/

-- Create payment table
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

-- Enable RLS
ALTER TABLE public.pagos ENABLE ROW LEVEL SECURITY;

-- Create policies
DO $$ 
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_policies WHERE policyname = 'Ver pagos propios' AND tablename = 'pagos'
    ) THEN
        CREATE POLICY "Ver pagos propios" ON public.pagos
            FOR SELECT USING (
                EXISTS (
                    SELECT 1 FROM public.reservas r 
                    WHERE r.id = pagos.reserva_id 
                    AND (r.usuario_id = auth.uid() OR EXISTS (
                        SELECT 1 FROM public.usuarios u 
                        WHERE u.id = auth.uid() AND u.rol = 'admin'
                    ))
                )
            );
    END IF;

    IF NOT EXISTS (
        SELECT 1 FROM pg_policies WHERE policyname = 'Crear pagos propios' AND tablename = 'pagos'
    ) THEN
        CREATE POLICY "Crear pagos propios" ON public.pagos
            FOR INSERT WITH CHECK (
                EXISTS (
                    SELECT 1 FROM public.reservas r 
                    WHERE r.id = reserva_id 
                    AND r.usuario_id = auth.uid()
                )
            );
    END IF;
END $$;