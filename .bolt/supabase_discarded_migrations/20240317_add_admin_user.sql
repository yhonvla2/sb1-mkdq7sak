-- Asegurarse de que el usuario exista en la tabla usuarios
INSERT INTO public.usuarios (correo, nombres, apellidos, telefono)
VALUES ('yhonyv7@gmail.com', 'Admin', 'Usuario', '000000000')
ON CONFLICT (correo) DO NOTHING;

-- Obtener el ID del usuario
DO $$ 
DECLARE
    user_id uuid;
BEGIN
    -- Obtener el ID del usuario
    SELECT id INTO user_id
    FROM public.usuarios
    WHERE correo = 'yhonyv7@gmail.com';

    -- Agregar el usuario como administrador si no existe
    INSERT INTO public.administradores (id)
    VALUES (user_id)
    ON CONFLICT (id) DO NOTHING;
END $$;

-- Asegurar que las políticas permitan acceso al administrador
ALTER TABLE public.usuarios ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.canchas ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.reservas ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.administradores ENABLE ROW LEVEL SECURITY;

-- Políticas para el administrador
CREATE POLICY IF NOT EXISTS "Los administradores pueden ver todos los usuarios"
    ON public.usuarios
    FOR ALL
    USING (
        auth.uid() IN (
            SELECT id FROM public.administradores
        )
    );

CREATE POLICY IF NOT EXISTS "Los administradores pueden gestionar todas las reservas"
    ON public.reservas
    FOR ALL
    USING (
        auth.uid() IN (
            SELECT id FROM public.administradores
        )
    );

CREATE POLICY IF NOT EXISTS "Los administradores pueden gestionar todas las canchas"
    ON public.canchas
    FOR ALL
    USING (
        auth.uid() IN (
            SELECT id FROM public.administradores
        )
    );

CREATE POLICY IF NOT EXISTS "Los administradores pueden gestionar administradores"
    ON public.administradores
    FOR ALL
    USING (
        auth.uid() IN (
            SELECT id FROM public.administradores
        )
    );