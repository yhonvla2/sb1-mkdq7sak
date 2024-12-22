-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Create usuarios table
CREATE TABLE IF NOT EXISTS public.usuarios (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    nombres VARCHAR(255) NOT NULL,
    apellidos VARCHAR(255) NOT NULL,
    correo VARCHAR(255) UNIQUE NOT NULL,
    telefono VARCHAR(50) NOT NULL,
    fecha_nacimiento DATE NOT NULL,
    rol VARCHAR(20) NOT NULL DEFAULT 'usuario' CHECK (rol IN ('usuario', 'admin')),
    provider VARCHAR(50) DEFAULT 'email' CHECK (provider IN ('email', 'facebook')),
    fecha_registro TIMESTAMPTZ DEFAULT NOW() NOT NULL
);

-- Create canchas table
CREATE TABLE IF NOT EXISTS public.canchas (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    nombre VARCHAR(255) NOT NULL,
    tipo VARCHAR(50) NOT NULL CHECK (tipo IN ('voley', 'futsal')),
    estado VARCHAR(50) NOT NULL DEFAULT 'disponible' CHECK (estado IN ('disponible', 'mantenimiento')),
    fecha_registro TIMESTAMPTZ DEFAULT NOW() NOT NULL
);

-- Create reservas table
CREATE TABLE IF NOT EXISTS public.reservas (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
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

-- Insert initial data
INSERT INTO public.canchas (nombre, tipo, estado) VALUES
    ('Cancha de Voley 1', 'voley', 'disponible'),
    ('Cancha de Voley 2', 'voley', 'disponible'),
    ('Cancha de Voley 3', 'voley', 'disponible'),
    ('Cancha de Futsal', 'futsal', 'disponible')
ON CONFLICT DO NOTHING;

-- Set up RLS policies
ALTER TABLE public.usuarios ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.canchas ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.reservas ENABLE ROW LEVEL SECURITY;

-- Policies for usuarios
CREATE POLICY "Usuarios pueden ver sus propios datos"
    ON public.usuarios FOR SELECT
    USING (auth.uid() = id OR rol = 'admin');

CREATE POLICY "Usuarios pueden actualizar sus propios datos"
    ON public.usuarios FOR UPDATE
    USING (auth.uid() = id);

-- Policies for canchas
CREATE POLICY "Canchas visibles para todos"
    ON public.canchas FOR SELECT
    USING (true);

-- Policies for reservas
CREATE POLICY "Usuarios pueden ver sus propias reservas"
    ON public.reservas FOR SELECT
    USING (auth.uid() = usuario_id OR EXISTS (
        SELECT 1 FROM public.usuarios 
        WHERE id = auth.uid() AND rol = 'admin'
    ));

CREATE POLICY "Usuarios pueden crear reservas"
    ON public.reservas FOR INSERT
    WITH CHECK (auth.uid() = usuario_id);

CREATE POLICY "Usuarios pueden modificar sus propias reservas"
    ON public.reservas FOR UPDATE
    USING (auth.uid() = usuario_id OR EXISTS (
        SELECT 1 FROM public.usuarios 
        WHERE id = auth.uid() AND rol = 'admin'
    ));

-- Set admin user
INSERT INTO public.usuarios (correo, nombres, apellidos, telefono, fecha_nacimiento, rol)
VALUES ('yhonyv7@gmail.com', 'Admin', 'Usuario', '000000000', '2000-01-01', 'admin')
ON CONFLICT (correo) 
DO UPDATE SET rol = 'admin';