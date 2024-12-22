import React from 'react';
import { Link } from 'react-router-dom';
import { Facebook, Phone, MapPin, Clock } from 'lucide-react';
import { BUSINESS_INFO } from '../../constants/courts';

export function Footer() {
  return (
    <footer className="bg-gray-900 text-white py-12">
      <div className="container mx-auto px-4">
        <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
          <div>
            <h3 className="text-lg font-semibold mb-4">Contacto</h3>
            <div className="space-y-2">
              <p className="flex items-center">
                <Phone className="w-5 h-5 mr-2" />
                {BUSINESS_INFO.phones[0]}
              </p>
              <p className="flex items-center">
                <Phone className="w-5 h-5 mr-2" />
                {BUSINESS_INFO.phones[1]}
              </p>
              <p className="flex items-center">
                <MapPin className="w-5 h-5 mr-2" />
                {BUSINESS_INFO.address}
              </p>
            </div>
          </div>

          <div>
            <h3 className="text-lg font-semibold mb-4">Horarios</h3>
            <div className="space-y-2">
              <p className="flex items-center">
                <Clock className="w-5 h-5 mr-2" />
                Lun-Vie: {BUSINESS_INFO.schedule.weekdays}
              </p>
              <p className="flex items-center">
                <Clock className="w-5 h-5 mr-2" />
                Sáb-Dom: {BUSINESS_INFO.schedule.weekends}
              </p>
            </div>
          </div>

          <div>
            <h3 className="text-lg font-semibold mb-4">Síguenos</h3>
            <a
              href="https://www.facebook.com/CanchaGrassBalonDeOro?locale=es_LA"
              target="_blank"
              rel="noopener noreferrer"
              className="inline-flex items-center space-x-2 text-white hover:text-green-400 transition"
            >
              <Facebook className="w-6 h-6" />
              <span>Facebook</span>
            </a>
          </div>
        </div>

        <div className="mt-8 pt-8 border-t border-gray-800 text-center text-sm text-gray-400">
          <p>© {new Date().getFullYear()} Canchas Deportivas. Todos los derechos reservados.</p>
        </div>
      </div>
    </footer>
  );
}