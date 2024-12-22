CREATE TABLE IF NOT EXISTS usuarios (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  nombre TEXT NOT NULL,
  apellido TEXT NOT NULL,
  correo TEXT NOT NULL UNIQUE,
  telefono TEXT,
  auth_id uuid UNIQUE
);

-- Crear tabla de canchas
CREATE TABLE IF NOT EXISTS canchas (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  nombre TEXT NOT NULL UNIQUE,
  tipo TEXT NOT NULL CHECK (tipo IN ('voley', 'futsal')),
  estado TEXT DEFAULT 'disponible' CHECK (estado IN ('disponible', 'no disponible'))
);

-- Crear tabla de reservas
CREATE TABLE IF NOT EXISTS reservas (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  usuario_id uuid REFERENCES usuarios(id) ON DELETE CASCADE,
  cancha_id uuid REFERENCES canchas(id) ON DELETE CASCADE,
  fecha_reserva DATE NOT NULL,
  hora_inicio TIME NOT NULL,
  hora_fin TIME NOT NULL,
  estado TEXT DEFAULT 'pendiente' CHECK (estado IN ('pendiente', 'confirmada', 'cancelada')),
  fecha_creacion TIMESTAMP DEFAULT NOW()
);

-- Crear tabla de pagos
CREATE TABLE IF NOT EXISTS pagos (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  reserva_id uuid REFERENCES reservas(id) ON DELETE CASCADE,
  monto NUMERIC(12, 2) NOT NULL,
  metodo TEXT NOT NULL CHECK (metodo IN ('efectivo', 'tarjeta')),
  estado TEXT DEFAULT 'pendiente' CHECK (estado IN ('pendiente', 'completado')),
  fecha_registro TIMESTAMP DEFAULT NOW()
);

-- Habilitar Row Level Security (RLS) para las tablas
ALTER TABLE usuarios ENABLE ROW LEVEL SECURITY;
ALTER TABLE reservas ENABLE ROW LEVEL SECURITY;
ALTER TABLE pagos ENABLE ROW LEVEL SECURITY;

-- Crear políticas de seguridad para usuarios
CREATE POLICY "Usuarios pueden ver sus propios datos"
ON usuarios
FOR SELECT
TO authenticated
USING (auth_id = auth.uid()::uuid);

-- Crear políticas de seguridad para reservas
CREATE POLICY "Usuarios pueden ver sus reservas"
ON reservas
FOR SELECT
TO authenticated
USING (usuario_id = (SELECT id FROM usuarios WHERE auth_id = auth.uid()::uuid));

CREATE POLICY "Usuarios pueden crear sus reservas"
ON reservas
FOR INSERT
TO authenticated
WITH CHECK (usuario_id = (SELECT id FROM usuarios WHERE auth_id = auth.uid()::uuid));

CREATE POLICY "Usuarios pueden actualizar sus reservas"
ON reservas
FOR UPDATE
TO authenticated
USING (usuario_id = (SELECT id FROM usuarios WHERE auth_id = auth.uid()::uuid))
WITH CHECK (usuario_id = (SELECT id FROM usuarios WHERE auth_id = auth.uid()::uuid));

CREATE POLICY "Usuarios pueden eliminar sus reservas"
ON reservas
FOR DELETE
TO authenticated
USING (usuario_id = (SELECT id FROM usuarios WHERE auth_id = auth.uid()::uuid));

-- Crear políticas de seguridad para pagos
CREATE POLICY "Usuarios pueden ver sus pagos"
ON pagos
FOR SELECT
TO authenticated
USING (reserva_id IN (
  SELECT id FROM reservas WHERE usuario_id = (SELECT id FROM usuarios WHERE auth_id = auth.uid()::uuid)
));

CREATE POLICY "Usuarios pueden crear sus pagos"
ON pagos
FOR INSERT
TO authenticated
WITH CHECK (reserva_id IN (
  SELECT id FROM reservas WHERE usuario_id = (SELECT id FROM usuarios WHERE auth_id = auth.uid()::uuid)
));
