/*
  # Initial Schema Setup
  
  1. New Tables
    - users
      - id (uuid, primary key)
      - auth_id (uuid, link to Supabase auth)
      - name (text)
      - email (text, unique)
      - phone (text)
      - created_at (timestamp)
    - courts
      - id (uuid, primary key)
      - name (text)
      - type (text: voley/futsal)
      - status (text: available/maintenance)
    - bookings
      - id (uuid, primary key)
      - user_id (uuid, foreign key)
      - court_id (uuid, foreign key)
      - date (date)
      - start_time (time)
      - end_time (time)
      - status (text: pending/confirmed/cancelled)
      - created_at (timestamp)
  
  2. Security
    - RLS enabled on all tables
    - Policies for user access and booking management
*/

-- Drop existing tables if they exist
DROP TABLE IF EXISTS public.bookings;
DROP TABLE IF EXISTS public.courts;
DROP TABLE IF EXISTS public.users;

-- Users table
CREATE TABLE public.users (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    auth_id uuid UNIQUE,
    name text NOT NULL,
    email text UNIQUE NOT NULL,
    phone text,
    created_at timestamptz DEFAULT now()
);

-- Courts table
CREATE TABLE public.courts (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    name text NOT NULL,
    type text NOT NULL CHECK (type IN ('voley', 'futsal')),
    status text DEFAULT 'available' CHECK (status IN ('available', 'maintenance'))
);

-- Bookings table
CREATE TABLE public.bookings (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id uuid REFERENCES public.users(id) NOT NULL,
    court_id uuid REFERENCES public.courts(id) NOT NULL,
    date date NOT NULL,
    start_time time NOT NULL,
    end_time time NOT NULL,
    status text DEFAULT 'pending' CHECK (status IN ('pending', 'confirmed', 'cancelled')),
    created_at timestamptz DEFAULT now(),
    CONSTRAINT no_overlap UNIQUE (court_id, date, start_time)
);

-- Enable Row Level Security
ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.courts ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.bookings ENABLE ROW LEVEL SECURITY;

-- Drop existing policies if they exist
DROP POLICY IF EXISTS "Users can view their own data" ON public.users;
DROP POLICY IF EXISTS "Users can update their own data" ON public.users;
DROP POLICY IF EXISTS "Users can insert their own data" ON public.users;
DROP POLICY IF EXISTS "Anyone can view courts" ON public.courts;
DROP POLICY IF EXISTS "Users can view their bookings" ON public.bookings;
DROP POLICY IF EXISTS "Users can create bookings" ON public.bookings;

-- Create policies
CREATE POLICY "Users can view their own data"
    ON public.users FOR SELECT
    USING (auth.uid() = auth_id);

CREATE POLICY "Users can update their own data"
    ON public.users FOR UPDATE
    USING (auth.uid() = auth_id);

CREATE POLICY "Users can insert their own data"
    ON public.users FOR INSERT
    WITH CHECK (auth.uid() = auth_id);

CREATE POLICY "Anyone can view courts"
    ON public.courts FOR SELECT
    USING (true);

CREATE POLICY "Users can view their bookings"
    ON public.bookings FOR SELECT
    USING (auth.uid() IN (
        SELECT auth_id FROM public.users WHERE id = bookings.user_id
    ));

CREATE POLICY "Users can create bookings"
    ON public.bookings FOR INSERT
    WITH CHECK (auth.uid() IN (
        SELECT auth_id FROM public.users WHERE id = bookings.user_id
    ));

-- Insert default courts
INSERT INTO public.courts (name, type) VALUES
    ('Cancha de Voley 1', 'voley'),
    ('Cancha de Voley 2', 'voley'),
    ('Cancha de Voley 3', 'voley'),
    ('Cancha de Futsal', 'futsal');