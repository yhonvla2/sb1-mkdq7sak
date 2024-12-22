import React from 'react';

interface TimePickerProps {
  value: string;
  onChange: (time: string) => void;
  label?: string;
  minTime?: string;
}

export function TimePicker({ value, onChange, label, minTime }: TimePickerProps) {
  const timeSlots = [];
  for (let hour = 8; hour <= 22; hour++) {
    const time = `${hour.toString().padStart(2, '0')}:00`;
    if (!minTime || time > minTime) {
      timeSlots.push(time);
    }
  }

  return (
    <div className="space-y-2">
      {label && (
        <label className="block text-sm font-medium text-gray-700">
          {label}
        </label>
      )}
      <select
        value={value}
        onChange={(e) => onChange(e.target.value)}
        className="w-full px-3 py-2 border border-gray-300 rounded-md 
                 focus:ring-2 focus:ring-green-500 focus:border-transparent"
      >
        <option value="">--:--</option>
        {timeSlots.map((time) => (
          <option key={time} value={time}>
            {time}
          </option>
        ))}
      </select>
    </div>
  );
}