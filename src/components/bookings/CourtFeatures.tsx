import React from 'react';
import { CheckCircle } from 'lucide-react';
import { COURT_FEATURES } from '../../lib/constants/courts';
import type { Cancha } from '../../types';

interface CourtFeaturesProps {
  court: Cancha;
}

export function CourtFeatures({ court }: CourtFeaturesProps) {
  const features = COURT_FEATURES[court.tipo];

  return (
    <div className="space-y-4">
      <h3 className="font-medium text-gray-900">Características:</h3>
      <ul className="space-y-2">
        {features.map((feature, index) => (
          <li key={index} className="flex items-center text-gray-600">
            <CheckCircle className="w-5 h-5 mr-2 text-green-500" />
            {feature}
          </li>
        ))}
      </ul>
    </div>
  );
}