import React from 'react';
import { Users, MapPin, Phone, Clock, Shield } from 'lucide-react';

export default function About() {
  return (
    <div className="max-w-6xl mx-auto px-4 py-12">
      <div className="bg-white rounded-lg shadow-xl overflow-hidden">
        {/* Hero Section */}
        <div className="relative h-[300px]">
          <img
            src="https://images.unsplash.com/photo-1526232761682-d26e03ac148e?auto=format&fit=crop&q=80&w=1200"
            alt="Grupo jugando voleibol"
            className="w-full h-full object-cover"
          />
          <div className="absolute inset-0 bg-gradient-to-t from-black/60 via-black/30 to-transparent" />
          <div className="absolute bottom-0 left-0 right-0 p-8 text-white">
            <h1 className="text-4xl font-bold mb-2">Sobre Nosotros</h1>
            <p className="text-lg">Más que canchas, creamos experiencias deportivas</p>
          </div>
        </div>

        <div className="p-8 space-y-8">
          {/* Descripción */}
          <section className="max-w-3xl mx-auto text-center">
            <p className="text-lg text-gray-600 leading-relaxed mb-6">
              Somos un complejo deportivo comprometido con brindar las mejores instalaciones 
              para la práctica del vóley y futsal. Nuestras canchas están diseñadas y 
              mantenidas bajo los más altos estándares de calidad, ofreciendo a nuestros 
              usuarios una experiencia deportiva excepcional.
            </p>
            <p className="text-lg text-gray-600 leading-relaxed">
              Contamos con tres modernas canchas de vóley equipadas con iluminación LED y 
              superficies profesionales, además de una cancha de futsal con césped sintético 
              de última generación. Nuestro objetivo es fomentar el deporte y la recreación 
              en un ambiente seguro y agradable.
            </p>
          </section>

          {/* Cards de Información */}
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-8">
            <div className="bg-gray-50 p-6 rounded-lg">
              <MapPin className="w-8 h-8 text-green-600 mb-4" />
              <h3 className="font-semibold text-gray-900 mb-2">Dirección</h3>
              <p className="text-gray-600">Jr. Nazaret con Demetria Umpire</p>
            </div>

            <div className="bg-gray-50 p-6 rounded-lg">
              <Phone className="w-8 h-8 text-green-600 mb-4" />
              <h3 className="font-semibold text-gray-900 mb-2">Teléfonos</h3>
              <p className="text-gray-600">950008353</p>
              <p className="text-gray-600">977130236</p>
            </div>

            <div className="bg-gray-50 p-6 rounded-lg">
              <Clock className="w-8 h-8 text-green-600 mb-4" />
              <h3 className="font-semibold text-gray-900 mb-2">Horario</h3>
              <p className="text-gray-600">Lunes a Viernes: 8:00 AM - 8:00 PM</p>
              <p className="text-gray-600">Sábados y Domingos: 9:00 AM - 8:00 PM</p>
            </div>

            <div className="bg-gray-50 p-6 rounded-lg">
              <Shield className="w-8 h-8 text-green-600 mb-4" />
              <h3 className="font-semibold text-gray-900 mb-2">Servicios</h3>
              <ul className="text-gray-600 space-y-1">
                <li>• Estacionamiento</li>
                <li>• Vestuarios</li>
                <li>• Iluminación LED</li>
                <li>• Seguridad 24/7</li>
              </ul>
            </div>
          </div>

          {/* Valores */}
          <section className="max-w-4xl mx-auto">
            <h2 className="text-2xl font-bold text-gray-900 mb-6 text-center">
              Nuestros Valores
            </h2>
            <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
              <div className="text-center">
                <div className="bg-green-100 w-16 h-16 rounded-full flex items-center justify-center mx-auto mb-4">
                  <Shield className="w-8 h-8 text-green-600" />
                </div>
                <h3 className="font-semibold text-gray-900 mb-2">Calidad</h3>
                <p className="text-gray-600">
                  Mantenemos nuestras instalaciones en óptimas condiciones
                </p>
              </div>
              <div className="text-center">
                <div className="bg-green-100 w-16 h-16 rounded-full flex items-center justify-center mx-auto mb-4">
                  <Users className="w-8 h-8 text-green-600" />
                </div>
                <h3 className="font-semibold text-gray-900 mb-2">Comunidad</h3>
                <p className="text-gray-600">
                  Fomentamos un ambiente familiar y deportivo
                </p>
              </div>
              <div className="text-center">
                <div className="bg-green-100 w-16 h-16 rounded-full flex items-center justify-center mx-auto mb-4">
                  <Clock className="w-8 h-8 text-green-600" />
                </div>
                <h3 className="font-semibold text-gray-900 mb-2">Compromiso</h3>
                <p className="text-gray-600">
                  Horarios flexibles y atención personalizada
                </p>
              </div>
            </div>
          </section>
        </div>
      </div>
    </div>
  );
}