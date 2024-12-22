-- Reset tables
DROP TABLE IF EXISTS public.reservas CASCADE;
DROP TABLE IF EXISTS public.canchas CASCADE;
DROP TABLE IF EXISTS public.usuarios CASCADE;

-- Create usuarios table with all required fields
CREATE TABLE public.usuarios (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
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
CREATE TABLE public.canchas (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nombre VARCHAR(255) NOT NULL,
    tipo VARCHAR(50) NOT NULL CHECK (tipo IN ('voley', 'futsal')),
    estado VARCHAR(50) NOT NULL DEFAULT 'disponible' CHECK (estado IN ('disponible', 'mantenimiento')),
    fecha_registro TIMESTAMPTZ DEFAULT NOW() NOT NULL
);

-- Create reservas table
CREATE TABLE public.reservas (
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

-- Insert default courts
INSERT INTO public.canchas (nombre, tipo) VALUES
    ('Cancha de Voley 1', 'voley'),
    ('Cancha de Voley 2', 'voley'),
    ('Cancha de Voley 3', 'voley'),
    ('Cancha de Futsal', 'futsal');

-- Enable Row Level Security
ALTER TABLE public.usuarios ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.canchas ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.reservas ENABLE ROW LEVEL SECURITY;

-- Policies for usuarios
CREATE POLICY "Los usuarios pueden ver sus propios datos"
    ON public.usuarios FOR SELECT
    USING (auth.uid() = id OR rol = 'admin');

CREATE POLICY "Los usuarios pueden actualizar sus propios datos"
    ON public.usuarios FOR UPDATE
    USING (auth.uid() = id OR rol = 'admin');

CREATE POLICY "Los usuarios pueden insertar sus propios datos"
    ON public.usuarios FOR INSERT
    WITH CHECK (auth.uid() = id OR rol = 'admin');

-- Policies for canchas
CREATE POLICY "Las canchas son visibles para todos"
    ON public.canchas FOR SELECT
    USING (true);

-- Policies for reservas
CREATE POLICY "Ver reservas propias o todas si es admin"
    ON public.reservas FOR SELECT
    USING (
        auth.uid() = usuario_id 
        OR EXISTS (
            SELECT 1 FROM public.usuarios 
            WHERE id = auth.uid() AND rol = 'admin'
        )
    );

CREATE POLICY "Crear reservas"
    ON public.reservas FOR INSERT
    WITH CHECK (auth.uid() = usuario_id);

CREATE POLICY "Modificar reservas propias o todas si es admin"
    ON public.reservas FOR UPDATE
    USING (
        auth.uid() = usuario_id 
        OR EXISTS (
            SELECT 1 FROM public.usuarios 
            WHERE id = auth.uid() AND rol = 'admin'
        )
    );

-- Set initial admin user
INSERT INTO public.usuarios (
    id,
    correo,
    nombres,
    apellidos,
    telefono,
    fecha_nacimiento,
    rol,
    provider
) VALUES (
    '00000000-0000-0000-0000-000000000000',
    'yhonyv7@gmail.com',
    'Admin',
    'Usuario',
    '950008353',
    '2000-01-01',
    'admin',
    'email'
) ON CONFLICT (correo) 
DO UPDATE SET rol = 'admin';