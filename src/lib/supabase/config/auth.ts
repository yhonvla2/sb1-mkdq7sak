import type { AuthConfig } from '@supabase/supabase-js';

export const SUPABASE_AUTH_CONFIG: AuthConfig = {
  persistSession: true,
  autoRefreshToken: true,
  detectSessionInUrl: true,
} as const;