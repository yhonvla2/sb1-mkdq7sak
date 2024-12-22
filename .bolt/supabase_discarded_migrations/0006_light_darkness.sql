/*
  # Core Database Schema
  
  1. Tables Created:
    - usuarios (users)
    - canchas (courts)
    - reservas (bookings)
    - horarios (schedules)
    - pagos (payments)
  
  2. Security:
    - RLS policies for each table
    - Appropriate constraints and validations
*/

-- Create usuarios (users) table
CREATE TABLE IF NOT EXISTS public.usuarios (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    email TEXT UNIQUE NOT NULL,
    nombre TEXT NOT NULL,
    apellidos TEXT NOT NULL,
    telefono TEXT,
    rol TEXT NOT NULL DEFAULT 'usuario' CHECK (rol IN ('usuario', 'admin')),
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create canchas (courts) table
CREATE TABLE IF NOT EXISTS public.canchas (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nombre TEXT NOT NULL,
    tipo TEXT NOT NULL CHECK (tipo IN ('voley', 'futsal')),
    precio_hora DECIMAL(10,2) NOT NULL,
    estado TEXT NOT NULL DEFAULT 'disponible' CHECK (estado IN ('disponible', 'mantenimiento')),
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create reservas (bookings) table
CREATE TABLE IF NOT EXISTS public.reservas (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    usuario_id UUID REFERENCES usuarios(id) NOT NULL,
    cancha_id UUID REFERENCES canchas(id) NOT NULL,
    fecha DATE NOT NULL,
    hora_inicio TIME NOT NULL,
    hora_fin TIME NOT NULL,
    estado TEXT NOT NULL DEFAULT 'pendiente' CHECK (estado IN ('pendiente', 'confirmada', 'cancelada')),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    CONSTRAINT no_overlap UNIQUE (cancha_id, fecha, hora_inicio)
);

-- Create horarios (schedules) table
CREATE TABLE IF NOT EXISTS public.horarios (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    cancha_id UUID REFERENCES canchas(id) NOT NULL,
    dia_semana INTEGER CHECK (dia_semana BETWEEN 0 AND 6),
    hora_apertura TIME NOT NULL,
    hora_cierre TIME NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create pagos (payments) table
CREATE TABLE IF NOT EXISTS public.pagos (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    reserva_id UUID REFERENCES reservas(id) NOT NULL,
    monto DECIMAL(10,2) NOT NULL,
    metodo TEXT NOT NULL CHECK (metodo IN ('efectivo', 'yape')),
    estado TEXT NOT NULL DEFAULT 'pendiente' CHECK (estado IN ('pendiente', 'completado', 'cancelado')),
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Enable Row Level Security
ALTER TABLE usuarios ENABLE ROW LEVEL SECURITY;
ALTER TABLE canchas ENABLE ROW LEVEL SECURITY;
ALTER TABLE reservas ENABLE ROW LEVEL SECURITY;
ALTER TABLE horarios ENABLE ROW LEVEL SECURITY;
ALTER TABLE pagos ENABLE ROW LEVEL SECURITY;

-- Create RLS Policies
CREATE POLICY "Usuarios pueden ver su propia información"
    ON usuarios FOR SELECT
    USING (auth.uid() = id OR EXISTS (
        SELECT 1 FROM usuarios WHERE id = auth.uid() AND rol = 'admin'
    ));

CREATE POLICY "Ver canchas disponibles"
    ON canchas FOR SELECT
    USING (true);

CREATE POLICY "Ver reservas propias"
    ON reservas FOR SELECT
    USING (
        usuario_id = auth.uid() 
        OR EXISTS (
            SELECT 1 FROM usuarios WHERE id = auth.uid() AND rol = 'admin'
        )
    );

CREATE POLICY "Crear reservas propias"
    ON reservas FOR INSERT
    WITH CHECK (usuario_id = auth.uid());

CREATE POLICY "Ver horarios"
    ON horarios FOR SELECT
    USING (true);

CREATE POLICY "Ver pagos propios"
    ON pagos FOR SELECT
    USING (
        EXISTS (
            SELECT 1 FROM reservas 
            WHERE reservas.id = pagos.reserva_id 
            AND reservas.usuario_id = auth.uid()
        )
        OR EXISTS (
            SELECT 1 FROM usuarios WHERE id = auth.uid() AND rol = 'admin'
        )
    );