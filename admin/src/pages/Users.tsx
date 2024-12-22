import { useState, useEffect } from 'react';
import { format } from 'date-fns';
import { supabase } from '../lib/supabase';

export function Users() {
  const [users, setUsers] = useState([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    async function loadUsers() {
      const { data } = await supabase
        .from('usuarios')
        .select('*')
        .order('fecha_registro', { ascending: false });
      
      setUsers(data || []);
      setLoading(false);
    }

    loadUsers();
  }, []);

  if (loading) {
    return <div className="p-6">Cargando...</div>;
  }

  return (
    <div className="p-6">
      <h1 className="text-2xl font-bold mb-6">Usuarios Registrados</h1>
      
      <div className="bg-white rounded-lg shadow-md overflow-hidden">
        <table className="min-w-full divide-y divide-gray-200">
          <thead className="bg-gray-50">
            <tr>
              <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Nombre</th>
              <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Email</th>
              <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Teléfono</th>
              <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Fecha Registro</th>
            </tr>
          </thead>
          <tbody className="bg-white divide-y divide-gray-200">
            {users.map((user: any) => (
              <tr key={user.id}>
                <td className="px-6 py-4 whitespace-nowrap">
                  {user.nombres} {user.apellidos}
                </td>
                <td className="px-6 py-4 whitespace-nowrap">{user.correo}</td>
                <td className="px-6 py-4 whitespace-nowrap">{user.telefono}</td>
                <td className="px-6 py-4 whitespace-nowrap">
                  {format(new Date(user.fecha_registro), 'dd/MM/yyyy HH:mm')}
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
}