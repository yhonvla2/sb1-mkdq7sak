import React from 'react';
import { Calendar, Clock, CreditCard } from 'lucide-react';
import { Link } from 'react-router-dom';
import { useAuth } from '../hooks/useAuth';
import { COURT_IMAGES } from '../constants/business';

const COURTS_INFO = [
  {
    id: 1,
    name: 'Cancha de Voley 1',
    image: COURT_IMAGES['Cancha de Voley 1'],
    prices: {
      day: 20,
      night: 25,
      nightPromo: 22.50
    },
    features: [
      'Red profesional reglamentaria',
      'Superficie antideslizante',
      'Iluminación LED',
      'Medidas oficiales'
    ]
  },
  {
    id: 2,
    name: 'Cancha de Voley 2',
    image: COURT_IMAGES['Cancha de Voley 2'],
    prices: {
      day: 20,
      night: 25,
      nightPromo: 22.50
    },
    features: [
      'Red profesional reglamentaria',
      'Superficie antideslizante',
      'Iluminación LED',
      'Medidas oficiales'
    ]
  },
  {
    id: 3,
    name: 'Cancha de Voley 3',
    image: COURT_IMAGES['Cancha de Voley 3'],
    prices: {
      day: 20,
      night: 25,
      nightPromo: 22.50
    },
    features: [
      'Red profesional reglamentaria',
      'Superficie antideslizante',
      'Iluminación LED',
      'Medidas oficiales'
    ]
  },
  {
    id: 4,
    name: 'Cancha de Futsal',
    image: COURT_IMAGES['Cancha de Futsal'],
    prices: {
      fixed: 25
    },
    features: [
      'Césped sintético profesional',
      'Arcos reglamentarios',
      'Sistema de iluminación LED',
      'Líneas oficiales'
    ]
  }
];

export default function Courts() {
  const { user } = useAuth();

  return (
    <div className="max-w-6xl mx-auto px-4 py-12">
      <h1 className="text-3xl font-bold text-gray-900 mb-8 text-center">
        Nuestras Canchas
      </h1>

      <div className="grid grid-cols-1 md:grid-cols-2 gap-8">
        {COURTS_INFO.map((court) => (
          <div key={court.id} className="bg-white rounded-lg shadow-lg overflow-hidden">
            <div className="relative aspect-video">
              <img
                src={court.image}
                alt={court.name}
                className="w-full h-full object-cover"
              />
              <div className="absolute inset-0 bg-gradient-to-t from-black/60 to-transparent" />
              <div className="absolute bottom-0 left-0 right-0 p-6 text-white">
                <h3 className="text-2xl font-bold mb-2">{court.name}</h3>
              </div>
            </div>

            <div className="p-6 space-y-6">
              {/* Precios */}
              <div className="space-y-3">
                <h4 className="text-lg font-semibold text-gray-900 flex items-center gap-2">
                  <CreditCard className="w-5 h-5 text-green-600" />
                  Precios
                </h4>
                {'fixed' in court.prices ? (
                  <p className="text-gray-700">
                    Precio único: S/. {court.prices.fixed.toFixed(2)} por hora
                  </p>
                ) : (
                  <div className="space-y-1">
                    <p className="text-gray-700">
                      • Día: S/. {court.prices.day.toFixed(2)} por hora
                    </p>
                    <p className="text-gray-700">
                      • Noche: S/. {court.prices.night.toFixed(2)} por hora
                    </p>
                    <p className="text-green-700 font-medium">
                      ¡Promoción! 2+ horas de noche a S/. {court.prices.nightPromo.toFixed(2)} por hora
                    </p>
                  </div>
                )}
              </div>

              {/* Características */}
              <div className="space-y-3">
                <h4 className="text-lg font-semibold text-gray-900">Características</h4>
                <ul className="space-y-2">
                  {court.features.map((feature, index) => (
                    <li key={index} className="text-gray-600 flex items-center gap-2">
                      <div className="w-1.5 h-1.5 bg-green-600 rounded-full" />
                      {feature}
                    </li>
                  ))}
                </ul>
              </div>

              {/* Horarios */}
              <div className="space-y-3">
                <h4 className="text-lg font-semibold text-gray-900 flex items-center gap-2">
                  <Clock className="w-5 h-5 text-green-600" />
                  Horarios
                </h4>
                <div className="text-gray-600">
                  <p>Lunes a Viernes: 8:00 AM - 8:00 PM</p>
                  <p>Sábados y Domingos: 9:00 AM - 8:00 PM</p>
                </div>
              </div>

              {/* Botón de Reserva */}
              <Link
                to={user ? "/reservas" : "/login"}
                className="block w-full bg-green-600 text-white text-center py-3 px-4 rounded-lg 
                         hover:bg-green-700 transition duration-200 flex items-center justify-center gap-2"
              >
                <Calendar className="w-5 h-5" />
                {user ? "Reservar Ahora" : "Inicia Sesión para Reservar"}
              </Link>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
}