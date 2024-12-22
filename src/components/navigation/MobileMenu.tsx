import React, { useState } from 'react';
import { Link } from 'react-router-dom';
import { Menu, X } from 'lucide-react';

export function MobileMenu() {
  const [isOpen, setIsOpen] = useState(false);

  return (
    <div className="md:hidden">
      <button
        onClick={() => setIsOpen(!isOpen)}
        className="text-white p-2"
      >
        {isOpen ? <X className="h-6 w-6" /> : <Menu className="h-6 w-6" />}
      </button>

      {isOpen && (
        <div className="absolute top-16 left-0 right-0 bg-green-600 p-4 shadow-lg">
          <div className="flex flex-col space-y-4">
            <Link
              to="/canchas"
              className="text-white hover:text-green-200 transition"
              onClick={() => setIsOpen(false)}
            >
              Nuestras Canchas
            </Link>
            <Link
              to="/nosotros"
              className="text-white hover:text-green-200 transition"
              onClick={() => setIsOpen(false)}
            >
              Nosotros
            </Link>
            <Link
              to="/contacto"
              className="text-white hover:text-green-200 transition"
              onClick={() => setIsOpen(false)}
            >
              Contáctanos
            </Link>
          </div>
        </div>
      )}
    </div>
  );
}