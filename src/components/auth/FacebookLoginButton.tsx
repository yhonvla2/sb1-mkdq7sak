import React from 'react';
import { Facebook } from 'lucide-react';
import { authService } from '../../lib/services/authService';

interface FacebookLoginButtonProps {
  onError?: (error: Error) => void;
}

export function FacebookLoginButton({ onError }: FacebookLoginButtonProps) {
  const handleClick = async () => {
    try {
      await authService.signInWithFacebook();
    } catch (err) {
      console.error('Facebook login error:', err);
      if (onError) onError(err instanceof Error ? err : new Error('Error al iniciar sesión con Facebook'));
    }
  };

  return (
    <button
      type="button"
      onClick={handleClick}
      className="w-full flex items-center justify-center gap-2 bg-blue-600 text-white py-2 px-4 
                rounded-md hover:bg-blue-700 transition duration-200"
    >
      <Facebook className="w-5 h-5" />
      Continuar con Facebook
    </button>
  );
}