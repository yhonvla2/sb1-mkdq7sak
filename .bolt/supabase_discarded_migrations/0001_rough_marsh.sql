/*
  # Initial Database Schema Setup
  
  1. Tables
    - user_profiles: User information and roles
    - courts: Sports facilities management  
    - bookings: Reservation system

  2. Security
    - RLS enabled on all tables
    - Role-based access policies
    - Secure indexes for performance
*/

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Drop existing policies if they exist
DO $$ 
BEGIN
    DROP POLICY IF EXISTS "Users can view own profile" ON public.user_profiles;
    DROP POLICY IF EXISTS "Users can update own profile" ON public.user_profiles;
    DROP POLICY IF EXISTS "Anyone can view courts" ON public.courts;
    DROP POLICY IF EXISTS "Only admins can modify courts" ON public.courts;
    DROP POLICY IF EXISTS "Users can view own bookings" ON public.bookings;
    DROP POLICY IF EXISTS "Users can create bookings" ON public.bookings;
    DROP POLICY IF EXISTS "Users can update own bookings" ON public.bookings;
EXCEPTION WHEN undefined_table THEN
    NULL;
END $$;

-- Create user profiles table
CREATE TABLE IF NOT EXISTS public.user_profiles (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    auth_id UUID UNIQUE NOT NULL,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    phone TEXT,
    role TEXT NOT NULL DEFAULT 'user' CHECK (role IN ('user', 'admin')),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Create courts table
CREATE TABLE IF NOT EXISTS public.courts (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT NOT NULL,
    type TEXT NOT NULL CHECK (type IN ('voley', 'futsal')),
    status TEXT NOT NULL DEFAULT 'available' CHECK (status IN ('available', 'maintenance', 'occupied')),
    maintenance_notes TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Create bookings table
CREATE TABLE IF NOT EXISTS public.bookings (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES public.user_profiles(id) ON DELETE CASCADE,
    court_id UUID NOT NULL REFERENCES public.courts(id) ON DELETE CASCADE,
    date DATE NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    status TEXT NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'confirmed', 'cancelled')),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT valid_booking_time CHECK (end_time > start_time),
    CONSTRAINT future_date CHECK (date >= CURRENT_DATE)
);

-- Enable Row Level Security
ALTER TABLE public.user_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.courts ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.bookings ENABLE ROW LEVEL SECURITY;

-- Create RLS Policies
-- User Profiles policies
CREATE POLICY "Users can view own profile"
    ON public.user_profiles
    FOR SELECT
    TO authenticated
    USING (auth_id = auth.uid());

CREATE POLICY "Users can update own profile"
    ON public.user_profiles
    FOR UPDATE
    TO authenticated
    USING (auth_id = auth.uid());

-- Courts policies
CREATE POLICY "Anyone can view courts"
    ON public.courts
    FOR SELECT
    TO authenticated
    USING (true);

CREATE POLICY "Only admins can modify courts"
    ON public.courts
    FOR ALL
    TO authenticated
    USING (EXISTS (
        SELECT 1 FROM public.user_profiles
        WHERE auth_id = auth.uid()
        AND role = 'admin'
    ));

-- Bookings policies
CREATE POLICY "Users can view own bookings"
    ON public.bookings
    FOR SELECT
    TO authenticated
    USING (user_id IN (
        SELECT id FROM public.user_profiles
        WHERE auth_id = auth.uid()
    ));

CREATE POLICY "Users can create bookings"
    ON public.bookings
    FOR INSERT
    TO authenticated
    WITH CHECK (user_id IN (
        SELECT id FROM public.user_profiles
        WHERE auth_id = auth.uid()
    ));

CREATE POLICY "Users can update own bookings"
    ON public.bookings
    FOR UPDATE
    TO authenticated
    USING (user_id IN (
        SELECT id FROM public.user_profiles
        WHERE auth_id = auth.uid()
    ));

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_user_profiles_auth_id ON public.user_profiles(auth_id);
CREATE INDEX IF NOT EXISTS idx_bookings_user_id ON public.bookings(user_id);
CREATE INDEX IF NOT EXISTS idx_bookings_court_id ON public.bookings(court_id);
CREATE INDEX IF NOT EXISTS idx_bookings_date ON public.bookings(date);

-- Insert initial court data
INSERT INTO public.courts (name, type) VALUES
    ('Cancha de Voley 1', 'voley'),
    ('Cancha de Voley 2', 'voley'),
    ('Cancha de Voley 3', 'voley'),
    ('Cancha de Futsal', 'futsal')
ON CONFLICT DO NOTHING;