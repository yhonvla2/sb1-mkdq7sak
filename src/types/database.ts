export interface Usuario {
  id: string;
  nombre: string;
  correo: string;
  contraseña: string;
  creado_en: string;
}

export interface Cancha {
  id: string;
  nombre: string;
  tipo: 'voley' | 'futsal';
  estado: 'disponible' | 'mantenimiento';
}

export interface Reserva {
  id: string;
  usuario_id: string;
  cancha_id: string;
  fecha_reserva: string;
  hora_inicio: string;
  hora_fin: string;
  estado: 'pendiente' | 'confirmada' | 'cancelada';
  creado_en: string;
}

export interface Pago {
  id: string;
  reserva_id: string;
  monto: number;
  metodo: 'efectivo' | 'tarjeta';
  estado: 'pendiente' | 'completado';
  creado_en: string;
}