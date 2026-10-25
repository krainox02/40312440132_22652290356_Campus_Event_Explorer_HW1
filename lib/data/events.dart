import '../models/event.dart';

const categories = ['All', 'Technology', 'Arts', 'Sports'];

List<CampusEvent> createEvents() => [
  CampusEvent(
    id: 'tech-01',
    title: 'Build Something Great',
    category: 'Technology',
    date: DateTime(2026, 10, 28, 14),
    venue: 'Engineering Building · Lab 204',
    description:
        'Turn a small idea into your first Flutter prototype. Bring your laptop and join a friendly, hands-on workshop on widgets, layouts and creative problem-solving. No previous mobile development experience is needed.',
    image: 'assets/images/technology.png',
    capacity: 30,
    available: 12,
  ),
  CampusEvent(
    id: 'arts-01',
    title: 'After Hours: Campus Jazz',
    category: 'Arts',
    date: DateTime(2026, 10, 29, 19, 30),
    venue: 'Student Center · Main Stage',
    description:
        'An evening of warm melodies and unexpected improvisation with the campus jazz collective. Meet other music lovers and enjoy a relaxed live set. Doors open at 19:00; all students are welcome.',
    image: 'assets/images/arts.png',
    capacity: 80,
    available: 1,
  ),
  CampusEvent(
    id: 'sports-01',
    title: 'Sunrise Running Club',
    category: 'Sports',
    date: DateTime(2026, 10, 30, 7, 30),
    venue: 'Athletics Track · North Gate',
    description:
        'Start your day with an easy five-kilometer social run around campus. We will warm up together, split into comfortable pace groups and finish with a stretch. Bring water and comfortable running shoes.',
    image: 'assets/images/sports.png',
    capacity: 25,
    available: 0,
  ),
  CampusEvent(
    id: 'tech-02',
    title: 'Ideas into AI',
    category: 'Technology',
    date: DateTime(2026, 11, 2, 16),
    venue: 'Engineering Building · Auditorium',
    description:
        'Explore how student teams approach practical machine-learning projects. A short introduction is followed by fictional project demonstrations and an open discussion about responsible technology. Bring your questions.',
    image: 'assets/images/technology.png',
    capacity: 60,
    available: 24,
  ),
  CampusEvent(
    id: 'arts-02',
    title: 'Make Your Mark',
    category: 'Arts',
    date: DateTime(2026, 11, 4, 15),
    venue: 'Fine Arts Studio · Room 12',
    description:
        'Slow down and experiment with color at our beginner-friendly poster-making session. Paper, brushes and paints are provided. Leave with a piece of your own and a few new creative friends.',
    image: 'assets/images/arts.png',
    capacity: 20,
    available: 8,
  ),
  CampusEvent(
    id: 'sports-02',
    title: 'Courtside Connections',
    category: 'Sports',
    date: DateTime(2026, 11, 7, 11),
    venue: 'Sports Hall · Basketball Court',
    description:
        'Meet your next teammates at a casual three-on-three basketball meetup. Teams are formed on arrival and all skill levels can participate. Bring indoor sports shoes and a refillable water bottle.',
    image: 'assets/images/sports.png',
    capacity: 24,
    available: 6,
  ),
];
