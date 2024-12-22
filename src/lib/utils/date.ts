import { format, parse } from 'date-fns';

export function parseTime(timeStr: string): Date {
  return parse(timeStr, 'HH:mm', new Date());
}

export function formatTime(date: Date): string {
  return format(date, 'HH:mm');
}

export function formatDate(date: Date): string {
  return format(date, 'yyyy-MM-dd');
}