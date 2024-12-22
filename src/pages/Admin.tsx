import React, { useState, useEffect } from 'react';
import { Database } from 'lucide-react';
import { usuarioService } from '../lib/services/usuarios';
import { reservaService } from '../lib/services/reservas';
import { AdminUserTable } from '../components/admin/AdminUserTable';
import { AdminBookingTable } from '../components/admin/AdminBookingTable';
import { AdminTabs } from '../components/admin/AdminTabs';
import type { Usuario, Reserva } from '../types';

export default function Admin() {
  const [usuarios, setUsuarios] = useState<Usuario[]>([]);
  const [reservas, setReservas] = useState<Reserva[]>([]);
  const [activeTab, setActiveTab] = useState('usuarios');

  useEffect(() => {
    loadData();
  }, [activeTab]);

  async function loadData() {
    try {
      if (activeTab === 'usuarios') {
        const data = await usuarioService.obtenerTodos();
        setUsuarios(data);
      } else {
        const data = await reservaService.obtenerTodos();
        setReservas(data);
      }
    } catch (error) {
      console.error('Error loading data:', error);
      alert('Error al cargar los datos');
    }
  }

  return (
    <div className="max-w-6xl mx-auto">
      <div className="bg-white rounded-lg shadow-xl p-8">
        <div className="flex items-center mb-6">
          <Database className="h-8 w-8 text-green-600 mr-2" />
          <h1 className="text-2xl font-bold text-gray-800">
            Panel de Administración
          </h1>
        </div>

        <AdminTabs activeTab={activeTab} onTabChange={setActiveTab} />

        {activeTab === 'usuarios' ? (
          <AdminUserTable usuarios={usuarios} />
        ) : (
          <AdminBookingTable reservas={reservas} />
        )}
      </div>
    </div>
  );
}