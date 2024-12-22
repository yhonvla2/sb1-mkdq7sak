import React from 'react';
import { Calendar, Clock, CheckCircle } from 'lucide-react';

interface BookingStepsProps {
  currentStep: number;
}

export function BookingSteps({ currentStep }: BookingStepsProps) {
  const steps = [
    { icon: Calendar, title: 'Seleccionar Cancha' },
    { icon: Clock, title: 'Elegir Horario' },
    { icon: CheckCircle, title: 'Confirmación' }
  ];

  return (
    <div className="flex justify-between">
      {steps.map((step, index) => {
        const Icon = step.icon;
        const stepNumber = index + 1;
        const isActive = currentStep >= stepNumber;
        const isCompleted = currentStep > stepNumber;

        return (
          <div key={index} className="flex-1">
            <div className="relative flex items-center">
              <div className={`
                w-10 h-10 rounded-full flex items-center justify-center
                ${isActive ? 'bg-green-600 text-white' : 'bg-gray-200 text-gray-500'}
              `}>
                <Icon className="w-5 h-5" />
              </div>
              
              <div className="ml-3">
                <p className={`text-sm font-medium ${
                  isActive ? 'text-gray-900' : 'text-gray-500'
                }`}>
                  {step.title}
                </p>
              </div>

              {index < steps.length - 1 && (
                <div className={`
                  absolute top-5 left-10 w-full h-0.5
                  ${isCompleted ? 'bg-green-600' : 'bg-gray-200'}
                `} />
              )}
            </div>
          </div>
        );
      })}
    </div>
  );
}