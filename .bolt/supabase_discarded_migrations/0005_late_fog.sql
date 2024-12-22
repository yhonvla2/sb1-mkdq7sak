/*
  # Initial Data Setup

  1. Content
    - Default admin user
    - Initial courts setup
*/

-- Insert initial courts
INSERT INTO canchas (nombre, tipo) VALUES
('Cancha de Voley 1', 'voley'),
('Cancha de Voley 2', 'voley'),
('Cancha de Voley 3', 'voley'),
('Cancha de Futsal', 'futsal');

-- Create function to set first user as admin
CREATE OR REPLACE FUNCTION set_first_user_as_admin()
RETURNS trigger AS $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM usuarios
    WHERE rol = 'admin'
  ) THEN
    UPDATE usuarios
    SET rol = 'admin'
    WHERE id = NEW.id;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger to set first user as admin
CREATE TRIGGER set_first_admin
  AFTER INSERT ON usuarios
  FOR EACH ROW
  EXECUTE FUNCTION set_first_user_as_admin();