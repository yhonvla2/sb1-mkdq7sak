/*
  # Clean Database Schema Setup
  
  1. Tables
    - usuarios (users)
    - canchas (courts)
    - reservas (bookings)
    - pagos (payments)
  
  2. Security
    - RLS policies for each table
    - Auth integration
*/

-- Create usuarios (users) table
CREATE TABLE IF NOT EXISTS public.usuarios (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    auth_id UUID UNIQUE,
    nombres VARCHAR(255) NOT NULL,
    apellidos VARCHAR(255) NOT NULL,
    correo VARCHAR(255) UNIQUE NOT NULL,
    telefono VARCHAR(50) NOT NULL,
    fecha_nacimiento DATE NOT NULL,
    rol VARCHAR(20) NOT NULL DEFAULT 'usuario' CHECK (rol IN ('usuario', 'admin')),
    provider VARCHAR(50) DEFAULT 'email' CHECK (provider IN ('email', 'facebook')),
    fecha_registro TIMESTAMPTZ DEFAULT NOW() NOT NULL
);

-- Create canchas (courts) table
CREATE TABLE IF NOT EXISTS public.canchas (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nombre VARCHAR(255) NOT NULL,
    tipo VARCHAR(50) NOT NULL CHECK (tipo IN ('voley', 'futsal')),
    estado VARCHAR(50) NOT NULL DEFAULT 'disponible' CHECK (estado IN ('disponible', 'mantenimiento')),
    fecha_registro TIMESTAMPTZ DEFAULT NOW() NOT NULL
);

-- Create reservas (bookings) table
CREATE TABLE IF NOT EXISTS public.reservas (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    usuario_id UUID REFERENCES public.usuarios(id) NOT NULL,
    cancha_id UUID REFERENCES public.canchas(id) NOT NULL,
    fecha DATE NOT NULL,
    hora_inicio TIME NOT NULL,
    hora_fin TIME NOT NULL,
    estado VARCHAR(50) NOT NULL DEFAULT 'pendiente' CHECK (estado IN ('pendiente', 'confirmada', 'cancelada')),
    fecha_registro TIMESTAMPTZ DEFAULT NOW() NOT NULL,
    CONSTRAINT reservas_sin_solapamiento UNIQUE (cancha_id, fecha, hora_inicio),
    CONSTRAINT rango_hora_valido CHECK (hora_fin > hora_inicio)
);

-- Create pagos (payments) table
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

-- Enable Row Level Security
ALTER TABLE public.usuarios ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.canchas ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.reservas ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.pagos ENABLE ROW LEVEL SECURITY;

-- Usuarios (Users) policies
CREATE POLICY "Ver perfil propio" ON public.usuarios
    FOR SELECT USING (auth.uid()::text = auth_id::text OR rol = 'admin');

CREATE POLICY "Actualizar perfil propio" ON public.usuarios
    FOR UPDATE USING (auth.uid()::text = auth_id::text);

CREATE POLICY "Insertar perfil propio" ON public.usuarios
    FOR INSERT WITH CHECK (auth.uid()::text = auth_id::text OR rol = 'admin');

-- Canchas (Courts) policies
CREATE POLICY "Ver canchas" ON public.canchas
    FOR SELECT USING (true);

CREATE POLICY "Administrar canchas" ON public.canchas
    FOR ALL USING (
        EXISTS (
            SELECT 1 FROM public.usuarios 
            WHERE auth_id::text = auth.uid()::text 
            AND rol = 'admin'
        )
    );

-- Reservas (Bookings) policies
CREATE POLICY "Ver reservas propias" ON public.reservas
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM public.usuarios 
            WHERE auth_id::text = auth.uid()::text 
            AND (id = usuario_id OR rol = 'admin')
        )
    );

CREATE POLICY "Crear reservas propias" ON public.reservas
    FOR INSERT WITH CHECK (
        EXISTS (
            SELECT 1 FROM public.usuarios 
            WHERE auth_id::text = auth.uid()::text 
            AND id = usuario_id
        )
    );

CREATE POLICY "Actualizar reservas propias" ON public.reservas
    FOR UPDATE USING (
        EXISTS (
            SELECT 1 FROM public.usuarios 
            WHERE auth_id::text = auth.uid()::text 
            AND (id = usuario_id OR rol = 'admin')
        )
    );

-- Pagos (Payments) policies
CREATE POLICY "Ver pagos propios" ON public.pagos
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM public.reservas r
            JOIN public.usuarios u ON u.id = r.usuario_id
            WHERE r.id = reserva_id 
            AND (u.auth_id::text = auth.uid()::text OR u.rol = 'admin')
        )
    );

CREATE POLICY "Crear pagos propios" ON public.pagos
    FOR INSERT WITH CHECK (
        EXISTS (
            SELECT 1 FROM public.reservas r
            JOIN public.usuarios u ON u.id = r.usuario_id
            WHERE r.id = reserva_id 
            AND u.auth_id::text = auth.uid()::text
        )
    );

-- Insert default courts
INSERT INTO public.canchas (nombre, tipo) VALUES
    ('Cancha de Voley 1', 'voley'),
    ('Cancha de Voley 2', 'voley'),
    ('Cancha de Voley 3', 'voley'),
    ('Cancha de Futsal', 'futsal')
ON CONFLICT (id) DO NOTHING;