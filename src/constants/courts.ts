export const COURT_IMAGES = {
  'Cancha de Voley 1': 'https://i.postimg.cc/0y9X42dx/Imagen-de-Whats-App-2024-12-16-a-las-18-23-32-7f179e40.jpg',
  'Cancha de Voley 2': 'https://i.postimg.cc/Gt0qxchW/Imagen-de-Whats-App-2024-12-16-a-las-18-23-34-09e6edfd.jpg',
  'Cancha de Voley 3': 'https://i.postimg.cc/W3q5ZDjm/Imagen-de-Whats-App-2024-12-16-a-las-18-23-34-3bb5f6ac.jpg',
  'Cancha de Futsal': 'https://i.postimg.cc/DfsCybxn/Imagen-de-Whats-App-2024-12-16-a-las-18-23-34-46ceb5c6.jpg'
} as const;

export const COURT_FEATURES = {
  voley: [
    'Red profesional reglamentaria',
    'Superficie antideslizante',
    'Iluminación LED',
    'Medidas oficiales: 18m x 9m',
    'Área libre: 3m por lado'
  ],
  futsal: [
    'Césped sintético profesional',
    'Arcos reglamentarios',
    'Sistema de iluminación LED',
    'Medidas: 25m x 15m',
    'Líneas oficiales'
  ]
} as const;

export const BUSINESS_INFO = {
  address: 'Jr. Nazaret con Demetria Umpire',
  phones: ['950008353', '977130236'],
  schedule: {
    weekdays: '8:00 AM - 10:00 PM',
    weekends: '9:00 AM - 11:00 PM'
  }
} as const;