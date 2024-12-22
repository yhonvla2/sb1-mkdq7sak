export interface NuevaReserva {
  usuario_id: string;
  cancha_id: string;
  fecha: string;
  hora_inicio: string;
  hora_fin: string;
}

export interface Reserva extends NuevaReserva {
  id: string;
  estado: 'pendiente' | 'confirmada' | 'cancelada';
  creado_en: string;
}

export interface ReservaConUsuario extends Reserva {
  usuarios?: {
    nombres: string;
    apellidos: string;
  };
}

export interface Usuario {
  id: string;
  nombres: string;
  apellidos: string;
  correo: string;
  telefono: string;
  fecha_registro: string;
  provider?: 'email' | 'facebook';
  rol?: 'usuario' | 'admin';
}

export interface NuevoUsuario {
  nombres: string;
  apellidos: string;
  correo: string;
  telefono: string;
  provider?: 'email' | 'facebook';
  rol?: 'usuario' | 'admin';
}

export interface Cancha {
  id: string;
  nombre: string;
  tipo: 'voley' | 'futsal';
  estado: 'disponible' | 'mantenimiento';
}