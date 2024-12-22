import { User } from './user';
import { Court } from './court';

export type BookingStatus = 'pending' | 'confirmed' | 'cancelled';

export interface Booking {
  id: string;
  userId: string;
  courtId: string;
  date: string;
  startTime: string;
  endTime: string;
  status: BookingStatus;
  createdAt: string;
}

export interface BookingWithDetails extends Booking {
  user: User;
  court: Court;
}

export type NewBooking = Omit<Booking, 'id' | 'createdAt' | 'status'>;