import { AuthConfig } from '@supabase/supabase-js';

export const authConfig: AuthConfig = {
  autoRefreshToken: true,
  persistSession: true,
  detectSessionInUrl: true,
  flowType: 'pkce'
};

export const authCallbackUrl = `${window.location.origin}/auth/callback`;

export const facebookAuthConfig = {
  provider: 'facebook' as const,
  options: {
    redirectTo: authCallbackUrl,
    scopes: 'email,public_profile'
  }
};