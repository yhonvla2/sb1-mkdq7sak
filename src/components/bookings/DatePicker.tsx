import React from 'react';
import { format, addDays } from 'date-fns';
import { es } from 'date-fns/locale';

interface DatePickerProps {
  selectedDate: Date;
  onChange: (date: Date) => void;
  label?: string;
}

export function DatePicker({ selectedDate, onChange, label }: DatePickerProps) {
  const minDate = format(new Date(), 'yyyy-MM-dd');
  const maxDate = format(addDays(new Date(), 30), 'yyyy-MM-dd');

  return (
    <div className="space-y-2">
      {label && (
        <label className="block text-sm font-medium text-gray-700">
          {label}
        </label>
      )}
      <input
        type="date"
        min={minDate}
        max={maxDate}
        value={format(selectedDate, 'yyyy-MM-dd')}
        onChange={(e) => onChange(new Date(e.target.value))}
        className="w-full px-3 py-2 border border-gray-300 rounded-md 
                 focus:ring-2 focus:ring-green-500 focus:border-transparent"
      />
      <p className="text-sm text-gray-500">
        {format(selectedDate, "EEEE d 'de' MMMM", { locale: es })}
      </p>
    </div>
  );
}