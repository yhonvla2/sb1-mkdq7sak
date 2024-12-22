import React from 'react';
import { MapPin, Phone, Clock, CreditCard } from 'lucide-react';
import { BUSINESS_INFO } from '../../constants/business';

export function ContactInfo() {
  return (
    <div className="space-y-6">
      <div className="flex items-start space-x-4">
        <MapPin className="w-6 h-6 text-green-600 flex-shrink-0" />
        <div>
          <h3 className="font-semibold text-gray-900">Ubicación</h3>
          <p className="text-gray-600">{BUSINESS_INFO.address}</p>
          <a 
            href={BUSINESS_INFO.location.maps}
            target="_blank"
            rel="noopener noreferrer"
            className="text-green-600 hover:text-green-700 text-sm mt-1 inline-block"
          >
            Ver en Google Maps
          </a>
        </div>
      </div>

      <div className="flex items-start space-x-4">
        <Phone className="w-6 h-6 text-green-600 flex-shrink-0" />
        <div>
          <h3 className="font-semibold text-gray-900">Teléfonos</h3>
          <p className="text-gray-600">{BUSINESS_INFO.phones.main} (Principal)</p>
          <p className="text-gray-600">{BUSINESS_INFO.phones.secondary}</p>
        </div>
      </div>

      <div className="flex items-start space-x-4">
        <Clock className="w-6 h-6 text-green-600 flex-shrink-0" />
        <div>
          <h3 className="font-semibold text-gray-900">Horario de Atención</h3>
          <p className="text-gray-600">Lunes a Viernes: {BUSINESS_INFO.schedule.weekdays}</p>
          <p className="text-gray-600">Sábados y Domingos: {BUSINESS_INFO.schedule.weekends}</p>
        </div>
      </div>

      <div className="flex items-start space-x-4">
        <CreditCard className="w-6 h-6 text-green-600 flex-shrink-0" />
        <div>
          <h3 className="font-semibold text-gray-900">Métodos de Pago</h3>
          <p className="text-gray-600">Yape: {BUSINESS_INFO.payments.yape}</p>
          <p className="text-gray-600">Efectivo</p>
        </div>
      </div>
    </div>
  );
}