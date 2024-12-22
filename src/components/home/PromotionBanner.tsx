import React from 'react';
import { Sparkles } from 'lucide-react';

export function PromotionBanner() {
  return (
    <div className="bg-gradient-to-r from-green-600 to-green-700 text-white p-6 rounded-lg shadow-lg mb-8">
      <div className="flex items-center justify-between">
        <div className="space-y-2">
          <div className="flex items-center gap-2">
            <Sparkles className="h-6 w-6 text-yellow-300" />
            <h2 className="text-xl font-bold">¡Promociones Especiales!</h2>
          </div>
          <div className="space-y-1">
            <p className="text-lg">
              <span className="font-semibold">Canchas de Voley:</span>
              <br />
              • Día: S/. 20.00 por hora
              <br />
              • Noche: S/. 25.00 por hora
              <br />
              • ¡Oferta Nocturna! 2+ horas a S/. 22.50 por hora
            </p>
            <p className="text-lg">
              <span className="font-semibold">Cancha de Futsal:</span>
              <br />
              • Precio único: S/. 25.00 por hora
            </p>
          </div>
        </div>
      </div>
    </div>
  );
}