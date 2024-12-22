import React from 'react';
import { Link } from 'react-router-dom';
import { Calendar } from 'lucide-react';
import { NavLinks } from './navigation/NavLinks';
import { AuthButtons } from './navigation/AuthButtons';
import { MobileMenu } from './navigation/MobileMenu';

export default function Navbar() {
  return (
    <nav className="bg-green-600 shadow-lg">
      <div className="container mx-auto px-4">
        <div className="flex items-center justify-between h-16">
          <div className="flex items-center">
            <Link to="/" className="flex items-center space-x-2">
              <Calendar className="h-8 w-8 text-white" />
              <span className="font-bold text-xl text-white">Canchas Deportivas</span>
            </Link>
          </div>

          <div className="hidden md:flex items-center space-x-8">
            <NavLinks />
            <AuthButtons />
          </div>

          <MobileMenu />
        </div>
      </div>
    </nav>
  );
}