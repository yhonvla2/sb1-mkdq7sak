import { useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { useAuth } from './useAuth';

export function useRedirectAuth(redirectTo: string, whenAuthed: boolean = true) {
  const { user, loading } = useAuth();
  const navigate = useNavigate();

  useEffect(() => {
    if (!loading && ((user && whenAuthed) || (!user && !whenAuthed))) {
      navigate(redirectTo);
    }
  }, [user, loading, navigate, redirectTo, whenAuthed]);

  return { loading };
}