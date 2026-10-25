import 'package:flutter/material.dart';
import '../models/event.dart';

const ink = Color(0xFF203D35);
const muted = Color(0xFF66766E);
const paper = Color(0xFFF7F7F0);

class Availability extends StatelessWidget {
  const Availability({super.key, required this.event});
  final CampusEvent event;

  @override
  Widget build(BuildContext context) {
    final warning = !event.joined && event.available <= 1;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: warning ? const Color(0xFFFFEADF) : const Color(0xFFE7EFE7),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        event.availability,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w800,
          color: warning ? const Color(0xFF9A4729) : ink,
        ),
      ),
    );
  }
}

class EventCard extends StatelessWidget {
  const EventCard({
    super.key,
    required this.event,
    required this.onFavorite,
    required this.onOpen,
  });
  final CampusEvent event;
  final VoidCallback onFavorite;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) => Card(
    margin: const EdgeInsets.only(bottom: 20),
    clipBehavior: Clip.antiAlias,
    elevation: 0,
    color: Colors.white,
    shape: RoundedRectangleBorder(
      side: const BorderSide(color: Color(0xFFE3E8DE)),
      borderRadius: BorderRadius.circular(22),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            Semantics(
              label: 'Open ${event.title} details',
              button: true,
              child: InkWell(
                onTap: onOpen,
                child: Image.asset(
                  event.image,
                  height: 158,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  semanticLabel: '${event.category} event illustration',
                ),
              ),
            ),
            Positioned(
              top: 12,
              left: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 11,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: paper,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  event.category.toUpperCase(),
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 10,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: Material(
                color: Colors.white,
                shape: const CircleBorder(),
                child: IconButton(
                  key: ValueKey('favorite-${event.id}'),
                  tooltip: event.favorite
                      ? 'Remove from favorites'
                      : 'Add to favorites',
                  onPressed: onFavorite,
                  icon: Icon(
                    event.favorite
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                    color: event.favorite ? const Color(0xFFAE5340) : ink,
                  ),
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 15, 16, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                event.title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -.6,
                ),
              ),
              const SizedBox(height: 10),
              MetaLine(icon: Icons.schedule_rounded, text: event.dateLabel),
              const SizedBox(height: 5),
              MetaLine(icon: Icons.location_on_outlined, text: event.venue),
              const SizedBox(height: 10),
              Row(
                children: [
                  Availability(event: event),
                  const Spacer(),
                  TextButton(
                    key: ValueKey('details-${event.id}'),
                    onPressed: onOpen,
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Details'),
                        SizedBox(width: 5),
                        Icon(Icons.arrow_forward_rounded, size: 17),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class MetaLine extends StatelessWidget {
  const MetaLine({super.key, required this.icon, required this.text});
  final IconData icon;
  final String text;
  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Icon(icon, size: 16, color: muted),
      const SizedBox(width: 7),
      Expanded(
        child: Text(text, style: const TextStyle(color: muted, fontSize: 12)),
      ),
    ],
  );
}
