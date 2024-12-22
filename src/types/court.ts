export type CourtType = 'voley' | 'futsal';
export type CourtStatus = 'available' | 'maintenance';

export interface Court {
  id: string;
  name: string;
  type: CourtType;
  status: CourtStatus;
}

export interface CourtWithSchedule extends Court {
  availableSlots: string[];
}