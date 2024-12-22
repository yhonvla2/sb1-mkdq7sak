import React from 'react';
import { format } from 'date-fns';
import { es } from 'date-fns/locale';
import { Search } from 'lucide-react';

interface BookingFiltersProps {
  date: Date;
  searchTerm: string;
  onDateChange: (date: Date) => void;
  onSearchChange: (term: string) => void;
}

export function BookingFilters({
  date,
  searchTerm,
  onDateChange,
  onSearchChange
}: BookingFiltersProps) {
  return (
    <div className="flex flex-col md:flex-row gap-4 mb-6">
      <div className="flex-1">
        <input
          type="date"
          value={format(date, 'yyyy-MM-dd')}
          onChange={(e) => onDateChange(new Date(e.target.value))}
          className="w-full px-4 py-2 border border-gray-300 rounded-md focus:ring-2 focus:ring-green-500 focus:border-transparent"
        />
        <p className="mt-1 text-sm text-gray-500">
          {format(date, "EEEE d 'de' MMMM", { locale: es })}
        </p>
      </div>

      <div className="flex-1">
        <div className="relative">
          <Search className="h-5 w-5 text-gray-400 absolute left-3 top-1/2 transform -translate-y-1/2" />
          <input
            type="text"
            placeholder="Buscar por nombre..."
            value={searchTerm}
            onChange={(e) => onSearchChange(e.target.value)}
            className="w-full pl-10 pr-4 py-2 border border-gray-300 rounded-md focus:ring-2 focus:ring-green-500 focus:border-transparent"
          />
        </div>
      </div>
    </div>
  );
}