/*
  # Simple Schema Setup
  
  1. Tables
    - users
      - Basic user information
    - courts
      - Simple court information
    - bookings
      - Basic booking management
*/

-- Create users table
CREATE TABLE public.users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    phone VARCHAR(50),
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create courts table
CREATE TABLE public.courts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255) NOT NULL,
    type VARCHAR(50) NOT NULL CHECK (type IN ('voley', 'futsal')),
    status VARCHAR(50) DEFAULT 'available' CHECK (status IN ('available', 'maintenance'))
);

-- Create bookings table
CREATE TABLE public.bookings (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES public.users(id) NOT NULL,
    court_id UUID REFERENCES public.courts(id) NOT NULL,
    date DATE NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    status VARCHAR(50) DEFAULT 'pending' CHECK (status IN ('pending', 'confirmed', 'cancelled')),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    CONSTRAINT no_overlap UNIQUE (court_id, date, start_time)
);

-- Enable RLS
ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.courts ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.bookings ENABLE ROW LEVEL SECURITY;

-- Basic policies
CREATE POLICY "Users can view their own data" ON public.users
    FOR SELECT USING (auth.uid() = id);

CREATE POLICY "Anyone can view courts" ON public.courts
    FOR SELECT USING (true);

CREATE POLICY "Users can view their bookings" ON public.bookings
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can create bookings" ON public.bookings
    FOR INSERT WITH CHECK (auth.uid() = user_id);

-- Insert default courts
INSERT INTO public.courts (name, type) VALUES
    ('Voley Court 1', 'voley'),
    ('Voley Court 2', 'voley'),
    ('Futsal Court', 'futsal')
ON CONFLICT DO NOTHING;