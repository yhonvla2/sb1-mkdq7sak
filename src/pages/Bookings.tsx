import React, { useState } from 'react';
import { Calendar } from 'lucide-react';
import { BookingSteps } from '../components/bookings/BookingSteps';
import { CourtSelection } from '../components/bookings/CourtSelection';
import { BookingForm } from '../components/bookings/BookingForm';
import { BookingConfirmation } from '../components/bookings/BookingConfirmation';
import { useCourts } from '../hooks/useCourts';

export default function Bookings() {
  const { courts, loading } = useCourts();
  const [step, setStep] = useState(1);
  const [selectedCourt, setSelectedCourt] = useState<string | null>(null);

  const handleCourtSelect = (courtId: string) => {
    setSelectedCourt(courtId);
    setStep(2);
  };

  const handleBookingSuccess = () => {
    setStep(3);
  };

  const handleReset = () => {
    setSelectedCourt(null);
    setStep(1);
  };

  if (loading) {
    return (
      <div className="flex justify-center py-12">
        <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-green-600"></div>
      </div>
    );
  }

  return (
    <div className="max-w-6xl mx-auto px-4 py-8">
      <div className="bg-white rounded-lg shadow-xl p-8">
        <div className="flex items-center gap-3 mb-8">
          <Calendar className="h-8 w-8 text-green-600" />
          <h1 className="text-2xl font-bold text-gray-900">Sistema de Reservas</h1>
        </div>

        <BookingSteps currentStep={step} />

        <div className="mt-8">
          {step === 1 && (
            <CourtSelection
              courts={courts}
              selectedCourt={selectedCourt}
              onSelect={handleCourtSelect}
            />
          )}

          {step === 2 && selectedCourt && (
            <BookingForm
              court={courts.find(c => c.id === selectedCourt)!}
              onSuccess={handleBookingSuccess}
              onCancel={handleReset}
            />
          )}

          {step === 3 && (
            <BookingConfirmation onNewBooking={handleReset} />
          )}
        </div>
      </div>
    </div>
  );
}