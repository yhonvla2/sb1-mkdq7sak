import React from 'react';
import { MapPin, Phone } from 'lucide-react';
import { BUSINESS_INFO } from '../../constants/business';

export function ContactButtons() {
  const openWhatsApp = () => {
    const message = encodeURIComponent('Hola, quisiera hacer una reserva');
    window.open(`https://wa.me/${BUSINESS_INFO.phones.whatsapp}?text=${message}`, '_blank');
  };

  return (
    <div className="fixed bottom-4 right-4 flex flex-col gap-2 z-50">
      <a
        href={BUSINESS_INFO.location.maps}
        target="_blank"
        rel="noopener noreferrer"
        className="bg-green-600 text-white p-3 rounded-full hover:bg-green-700 transition-colors shadow-lg flex items-center gap-2"
        title="Ver ubicación"
      >
        <MapPin className="w-6 h-6" />
      </a>
      <button
        onClick={openWhatsApp}
        className="bg-green-600 text-white p-3 rounded-full hover:bg-green-700 transition-colors shadow-lg flex items-center gap-2"
        title="Contactar por WhatsApp"
      >
        <Phone className="w-6 h-6" />
      </button>
    </div>
  );
}