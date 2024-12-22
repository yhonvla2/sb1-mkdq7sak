import React from 'react';
import { format, addDays, isSameDay } from 'date-fns';
import { es } from 'date-fns/locale';
import { ChevronLeft, ChevronRight } from 'lucide-react';

interface BookingCalendarProps {
  selectedDate: Date;
  onDateChange: (date: Date) => void;
}

export function BookingCalendar({ selectedDate, onDateChange }: BookingCalendarProps) {
  const today = new Date();
  const nextMonth = addDays(today, 30);

  const handlePrevDay = () => {
    const prevDay = addDays(selectedDate, -1);
    if (prevDay >= today) {
      onDateChange(prevDay);
    }
  };

  const handleNextDay = () => {
    const nextDay = addDays(selectedDate, 1);
    if (nextDay <= nextMonth) {
      onDateChange(nextDay);
    }
  };

  return (
    <div className="bg-white rounded-lg shadow-lg p-4">
      <div className="flex items-center justify-between mb-4">
        <button
          onClick={handlePrevDay}
          disabled={isSameDay(selectedDate, today)}
          className="p-2 rounded-full hover:bg-gray-100 disabled:opacity-50 disabled:cursor-not-allowed"
        >
          <ChevronLeft className="w-5 h-5" />
        </button>
        
        <h3 className="text-lg font-semibold text-gray-900">
          {format(selectedDate, "EEEE d 'de' MMMM", { locale: es })}
        </h3>
        
        <button
          onClick={handleNextDay}
          disabled={selectedDate >= nextMonth}
          className="p-2 rounded-full hover:bg-gray-100 disabled:opacity-50 disabled:cursor-not-allowed"
        >
          <ChevronRight className="w-5 h-5" />
        </button>
      </div>
    </div>
  );
}