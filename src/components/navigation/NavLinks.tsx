import React from 'react';
import { Link } from 'react-router-dom';

export function NavLinks() {
  return (
    <div className="hidden md:flex items-center space-x-6">
      <Link to="/canchas" className="text-white hover:text-green-200 transition">
        Nuestras Canchas
      </Link>
      <Link to="/nosotros" className="text-white hover:text-green-200 transition">
        Nosotros
      </Link>
      <Link to="/contacto" className="text-white hover:text-green-200 transition">
        Contáctanos
      </Link>
    </div>
  );
}