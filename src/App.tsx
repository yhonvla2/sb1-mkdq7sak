import React, { useEffect } from 'react';
import { BrowserRouter as Router, Routes, Route, Navigate } from 'react-router-dom';
import { supabase } from './lib/supabase/client'; // Importa tu cliente de Supabase
import Navbar from './components/layout/Navbar';
import { Footer } from './components/layout/Footer';
import { ContactButtons } from './components/layout/ContactButtons';
import { ProtectedRoute } from './components/auth/ProtectedRoute';
import { AdminProtectedRoute } from './components/admin/AdminProtectedRoute';
import { AuthCallback } from './components/auth/AuthCallback';
import { TodoList } from './components/todos/TodoList';
import CrearUsuario from './components/CrearUsuario'; // Importamos CrearUsuario
import ListaUsuarios from './components/ListaUsuarios'; // Importamos ListaUsuarios
import Home from './pages/Home';
import Login from './pages/Login';
import Register from './pages/Register';
import Courts from './pages/Courts';
import About from './pages/About';
import Contact from './pages/Contact';
import Bookings from './pages/Bookings';
import AdminLogin from './pages/AdminLogin';
import AdminDashboard from './pages/AdminDashboard';

export default function App() {
  // Código para probar conexión a Supabase
  useEffect(() => {
    const testConnection = async () => {
      try {
        const { data, error } = await supabase.from('usuarios').select('*'); // Cambia 'usuarios' por tu tabla
        if (error) {
          console.error('Error al conectar con Supabase:', error.message);
        } else {
          console.log('Datos obtenidos desde Supabase:', data);
        }
      } catch (err) {
        console.error('Error inesperado:', err);
      }
    };

    testConnection();
  }, []); // Se ejecuta una vez al cargar el componente

  return (
    <Router>
      <Routes>
        {/* Auth Callback */}
        <Route path="/auth/callback" element={<AuthCallback />} />

        {/* Admin Routes */}
        <Route path="/admin">
          <Route index element={<Navigate to="/admin/dashboard" replace />} />
          <Route path="login" element={<AdminLogin />} />
          <Route
            path="dashboard"
            element={
              <AdminProtectedRoute>
                <AdminDashboard />
              </AdminProtectedRoute>
            }
          />
        </Route>

        {/* Public Routes */}
        <Route
          path="*"
          element={
            <div className="min-h-screen flex flex-col bg-gray-50">
              <Navbar />
              <main className="flex-grow container mx-auto px-4 py-8">
                <Routes>
                  <Route path="/" element={<Home />} />
                  <Route path="/login" element={<Login />} />
                  <Route path="/register" element={<Register />} />
                  <Route path="/canchas" element={<Courts />} />
                  <Route path="/nosotros" element={<About />} />
                  <Route path="/contacto" element={<Contact />} />
                  <Route path="/todos" element={<TodoList />} />
                  <Route path="/usuarios" element={<ListaUsuarios />} /> {/* Lista de usuarios */}
                  <Route path="/crear-usuario" element={<CrearUsuario />} /> {/* Crear usuario */}
                  <Route
                    path="/reservas"
                    element={
                      <ProtectedRoute>
                        <Bookings />
                      </ProtectedRoute>
                    }
                  />
                </Routes>
              </main>
              <ContactButtons />
              <Footer />
            </div>
          }
        />
      </Routes>
    </Router>
  );
}
