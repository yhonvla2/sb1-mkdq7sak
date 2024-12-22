export interface NuevaReserva {
  usuario_id: string;
  cancha_id: string;
  fecha_reserva: string;
  hora_inicio: string;
  hora_fin: string;
}

export interface Reserva extends NuevaReserva {
  id: string;
  estado: 'pendiente' | 'confirmada' | 'cancelada';
  fecha_creacion: string;
}

export interface ReservaConUsuario extends Reserva {
  usuarios?: {
    nombres: string;
    apellidos: string;
  };
}