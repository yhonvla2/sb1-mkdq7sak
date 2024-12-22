import React, { useState } from 'react';
import { adminService } from '../../lib/services/adminService';
import type { Usuario } from '../../types';

interface AdminUserManagementProps {
  users: Usuario[];
  onUpdate: () => void;
}

export function AdminUserManagement({ users, onUpdate }: AdminUserManagementProps) {
  const [loading, setLoading] = useState(false);

  const handleToggleAdmin = async (userId: string, isCurrentlyAdmin: boolean) => {
    try {
      setLoading(true);
      if (isCurrentlyAdmin) {
        await adminService.removeAdmin(userId);
      } else {
        await adminService.addAdmin(userId);
      }
      onUpdate();
    } catch (error) {
      console.error('Error toggling admin status:', error);
      alert('Error al actualizar el estado de administrador');
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="overflow-x-auto">
      <table className="min-w-full divide-y divide-gray-200">
        <thead className="bg-gray-50">
          <tr>
            <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
              Usuario
            </th>
            <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
              Correo
            </th>
            <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
              Rol
            </th>
            <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
              Acciones
            </th>
          </tr>
        </thead>
        <tbody className="bg-white divide-y divide-gray-200">
          {users.map((user) => (
            <tr key={user.id}>
              <td className="px-6 py-4 whitespace-nowrap">
                <div className="text-sm font-medium text-gray-900">
                  {user.nombres} {user.apellidos}
                </div>
              </td>
              <td className="px-6 py-4 whitespace-nowrap">
                <div className="text-sm text-gray-500">{user.correo}</div>
              </td>
              <td className="px-6 py-4 whitespace-nowrap">
                <span className={`px-2 inline-flex text-xs leading-5 font-semibold rounded-full ${
                  user.administradores ? 'bg-green-100 text-green-800' : 'bg-gray-100 text-gray-800'
                }`}>
                  {user.administradores ? 'Administrador' : 'Usuario'}
                </span>
              </td>
              <td className="px-6 py-4 whitespace-nowrap text-sm">
                <button
                  onClick={() => handleToggleAdmin(user.id, !!user.administradores)}
                  disabled={loading}
                  className="text-green-600 hover:text-green-900 disabled:opacity-50"
                >
                  {user.administradores ? 'Remover Admin' : 'Hacer Admin'}
                </button>
              </td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}