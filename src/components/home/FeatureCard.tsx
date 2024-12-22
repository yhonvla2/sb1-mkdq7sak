import React from 'react';
import { LucideIcon } from 'lucide-react';

interface FeatureCardProps {
  icon: LucideIcon;
  title: string;
  description: string;
}

export function FeatureCard({ icon: Icon, title, description }: FeatureCardProps) {
  return (
    <div className="bg-white rounded-lg shadow-lg p-6 transition-transform hover:-translate-y-1">
      <div className="w-12 h-12 bg-green-100 rounded-lg flex items-center justify-center mb-4">
        <Icon className="w-6 h-6 text-green-600" />
      </div>
      <h3 className="text-lg font-semibold text-gray-900 mb-2">{title}</h3>
      <p className="text-gray-600">{description}</p>
    </div>
  );
}