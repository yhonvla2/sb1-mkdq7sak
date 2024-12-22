import { StrictMode } from 'react';
import { createRoot } from 'react-dom/client';
import App from './App';
import { initializeDatabase } from './lib/services/database';
import './index.css';

// Initialize database connection
initializeDatabase()
  .then((success) => {
    if (!success) {
      console.error('Failed to initialize database');
    }
  })
  .catch(console.error);

createRoot(document.getElementById('root')!).render(
  <StrictMode>
    <App />
  </StrictMode>
);