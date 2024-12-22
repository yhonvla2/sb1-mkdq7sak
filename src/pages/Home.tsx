import React from 'react';
import { Calendar } from 'lucide-react';
import { ImageCarousel } from '../components/home/ImageCarousel';
import { CourtCard } from '../components/home/CourtCard';
import { PromotionBanner } from '../components/home/PromotionBanner';
import { useCourts } from '../hooks/useCourts';

export default function Home() {
  const { courts, loading } = useCourts();

  return (
    <div className="max-w-6xl mx-auto px-4 space-y-12">
      {/* Hero Section con Carousel */}
      <section className="relative">
        <ImageCarousel />
        <div className="absolute inset-0 flex items-center justify-center flex-col text-white z-10">
          <h1 className="text-4xl font-bold mb-4 text-center">
            Bienvenido a la Cancha Balón de Oro
          </h1>
          <p className="text-xl text-center">
            Reserva tu cancha favorita de manera fácil y rápida
          </p>
        </div>
      </section>

      {/* Banner de Promociones */}
      <PromotionBanner />

      {/* Grid de Canchas */}
      <section>
        <h2 className="text-2xl font-bold text-gray-900 mb-8">
          Nuestras Canchas
        </h2>
        
        {loading ? (
          <div className="flex justify-center">
            <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-green-600"></div>
          </div>
        ) : (
          <div className="grid grid-cols-1 md:grid-cols-2 gap-8">
            {courts.map((court) => (
              <CourtCard key={court.id} court={court} />
            ))}
          </div>
        )}
      </section>

      {/* Resto del contenido existente */}
    </div>
  );
}