/*
  # Initial Database Schema

  1. Tables
    - users: User profiles and authentication
      - id: Primary key (UUID)
      - nombres: First name(s)
      - apellidos: Last name(s)
      - correo: Email (unique)
      - telefono: Phone number
      - rol: User role (usuario/admin)
      - provider: Auth provider (email/facebook)
      - created_at: Timestamp
    
    - courts: Sports courts
      - id: Primary key (UUID)
      - name: Court name
      - type: Court type (voley/futsal)
      - status: Court status (disponible/mantenimiento)
      - created_at: Timestamp
    
    - bookings: Court reservations
      - id: Primary key (UUID)
      - user_id: Foreign key to users
      - court_id: Foreign key to courts
      - fecha: Booking date
      - hora_inicio: Start time
      - hora_fin: End time
      - estado: Booking status (pendiente/confirmada/cancelada)
      - created_at: Timestamp

  2. Security
    - RLS enabled on all tables
    - Policies for authenticated users
*/

-- Drop existing policies if they exist
DO $$ BEGIN
  DROP POLICY IF EXISTS "Users can read own data" ON public.users;
  DROP POLICY IF EXISTS "Users can update own data" ON public.users;
  DROP POLICY IF EXISTS "Anyone can view courts" ON public.courts;
  DROP POLICY IF EXISTS "Users can view own bookings" ON public.bookings;
  DROP POLICY IF EXISTS "Users can create bookings" ON public.bookings;
  DROP POLICY IF EXISTS "Users can update own bookings" ON public.bookings;
EXCEPTION WHEN undefined_table THEN NULL;
END $$;

-- Create tables
CREATE TABLE IF NOT EXISTS public.users (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  nombres text NOT NULL,
  apellidos text NOT NULL,
  correo text UNIQUE NOT NULL,
  telefono text,
  rol text DEFAULT 'usuario' CHECK (rol IN ('usuario', 'admin')),
  provider text DEFAULT 'email' CHECK (provider IN ('email', 'facebook')),
  created_at timestamptz DEFAULT now()
);

CREATE TABLE IF NOT EXISTS public.courts (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  type text NOT NULL CHECK (type IN ('voley', 'futsal')),
  status text DEFAULT 'disponible' CHECK (status IN ('disponible', 'mantenimiento')),
  created_at timestamptz DEFAULT now()
);

CREATE TABLE IF NOT EXISTS public.bookings (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid REFERENCES public.users(id) ON DELETE CASCADE,
  court_id uuid REFERENCES public.courts(id) ON DELETE CASCADE,
  fecha date NOT NULL,
  hora_inicio time NOT NULL,
  hora_fin time NOT NULL,
  estado text DEFAULT 'pendiente' CHECK (estado IN ('pendiente', 'confirmada', 'cancelada')),
  created_at timestamptz DEFAULT now(),
  CONSTRAINT valid_time_range CHECK (hora_fin > hora_inicio)
);

-- Enable RLS
ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.courts ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.bookings ENABLE ROW LEVEL SECURITY;

-- Create policies
CREATE POLICY "Users can read own data" 
  ON public.users 
  FOR SELECT 
  TO authenticated 
  USING (auth.uid() = id);

CREATE POLICY "Users can update own data" 
  ON public.users 
  FOR UPDATE 
  TO authenticated 
  USING (auth.uid() = id);

CREATE POLICY "Anyone can view courts" 
  ON public.courts 
  FOR SELECT 
  TO authenticated 
  USING (true);

CREATE POLICY "Users can view own bookings" 
  ON public.bookings 
  FOR SELECT 
  TO authenticated 
  USING (auth.uid() = user_id);

CREATE POLICY "Users can create bookings" 
  ON public.bookings 
  FOR INSERT 
  TO authenticated 
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own bookings" 
  ON public.bookings 
  FOR UPDATE 
  TO authenticated 
  USING (auth.uid() = user_id);

-- Insert initial courts
INSERT INTO public.courts (name, type) VALUES
  ('Cancha de Voley 1', 'voley'),
  ('Cancha de Voley 2', 'voley'),
  ('Cancha de Voley 3', 'voley'),
  ('Cancha de Futsal', 'futsal')
ON CONFLICT DO NOTHING;