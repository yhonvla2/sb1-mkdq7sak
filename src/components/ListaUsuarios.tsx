import React, { useState, useEffect } from 'react';
import { supabase } from '../lib/supabase/client';

const ListaUsuarios: React.FC = () => {
  const [usuarios, setUsuarios] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const fetchUsuarios = async () => {
      const { data, error } = await supabase.auth.admin.listUsers();

      if (error) {
        console.error('Error fetching users:', error);
        return;
      }

      setUsuarios(data.users || []);
      setLoading(false);
    };

    fetchUsuarios();
  }, []);

  if (loading) {
    return <p>Cargando usuarios...</p>;
  }

  return (
    <div className="max-w-md mx-auto">
      <h2 className="text-2xl font-bold mb-4">Lista de Usuarios</h2>
      <ul>
        {usuarios.map((usuario) => (
          <li key={usuario.id}>
            {usuario.email} - {usuario.created_at}
          </li>
        ))}
      </ul>
    </div>
  );
};

export default ListaUsuarios;