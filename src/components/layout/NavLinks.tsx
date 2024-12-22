import React from 'react';
import { Link } from 'react-router-dom';

export function NavLinks() {
  const links = [
    { to: "/canchas", text: "Nuestras Canchas" },
    { to: "/nosotros", text: "Nosotros" },
    { to: "/contacto", text: "Contáctanos" }
  ];

  return (
    <div className="flex items-center space-x-6">
      {links.map(link => (
        <Link
          key={link.to}
          to={link.to}
          className="text-white hover:text-green-200 transition"
        >
          {link.text}
        </Link>
      ))}
    </div>
  );
}