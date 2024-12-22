import React from 'react';
import { Link } from 'react-router-dom';
import { Calendar, Facebook } from 'lucide-react';
import { NavLinks } from './NavLinks';
import { AuthButtons } from './AuthButtons';

export default function Navbar() {
  return (
    <nav className="bg-green-600 shadow-lg">
      <div className="container mx-auto px-4">
        <div className="flex items-center justify-between h-16">
          <Link to="/" className="flex items-center space-x-2">
            <Calendar className="h-8 w-8 text-white" />
            <span className="font-bold text-xl text-white">Balón de Oro</span>
          </Link>

          <div className="hidden md:flex items-center space-x-8">
            <NavLinks />
            <div className="flex items-center space-x-4">
              <a
                href="https://www.facebook.com/CanchaGrassBalonDeOro?locale=es_LA"
                target="_blank"
                rel="noopener noreferrer"
                className="text-white hover:text-green-200 transition"
              >
                <Facebook className="h-6 w-6" />
              </a>
              <AuthButtons />
            </div>
          </div>
        </div>
      </div>
    </nav>
  );
}