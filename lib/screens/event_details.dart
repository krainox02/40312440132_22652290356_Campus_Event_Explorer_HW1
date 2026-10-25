import 'package:flutter/material.dart';
import '../models/event.dart';
import '../widgets/event_card.dart';

class EventDetails extends StatefulWidget {
  const EventDetails({super.key, required this.event, required this.onChanged});
  final CampusEvent event;
  final VoidCallback onChanged;
  @override
  State<EventDetails> createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails> {
  bool _confirming = false;

  Future<void> _participate() async {
    final event = widget.event;
    if (_confirming || (!event.joined && event.available == 0)) return;
    setState(() => _confirming = true);
    final cancelling = event.joined;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(cancelling ? 'Cancel participation?' : 'Join this event?'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              event.title,
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 14),
            Text(event.dateLabel),
            const SizedBox(height: 8),
            Text(event.venue),
            const SizedBox(height: 14),
            Text(
              cancelling
                  ? 'Your place will become available to another student.'
                  : 'Reserve one place for yourself.',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('No'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Yes'),
          ),
        ],
      ),
    );
    if (!mounted) return;
    var changed = false;
    setState(() {
      _confirming = false;
      if (confirmed == true) {
        changed = cancelling ? event.cancel() : event.join();
      }
    });
    if (changed) {
      widget.onChanged();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            cancelling
                ? 'Participation cancelled. Your place has been restored.'
                : 'You are going to ${event.title}!',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final event = widget.event;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Event details'),
        actions: [
          IconButton(
            key: const ValueKey('details-favorite'),
            tooltip: event.favorite
                ? 'Remove from favorites'
                : 'Add to favorites',
            icon: Icon(
              event.favorite
                  ? Icons.favorite_rounded
                  : Icons.favorite_border_rounded,
            ),
            onPressed: () {
              setState(() => event.favorite = !event.favorite);
              widget.onChanged();
            },
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(22, 8, 22, 24),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: GestureDetector(
              key: const ValueKey('detail-image'),
              onDoubleTap: () => Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (_) => ImageViewer(event: event),
                ),
              ),
              child: Image.asset(
                event.image,
                height: 210,
                fit: BoxFit.cover,
                semanticLabel:
                    '${event.category} illustration. Double tap to enlarge.',
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.zoom_out_map_rounded, size: 13, color: muted),
              SizedBox(width: 5),
              Text(
                'Double-tap image to explore',
                style: TextStyle(fontSize: 11, color: muted),
              ),
            ],
          ),
          const SizedBox(height: 22),
          Text(
            event.category.toUpperCase(),
            style: const TextStyle(
              color: muted,
              letterSpacing: 2,
              fontSize: 11,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 9),
          Text(
            event.title,
            style: const TextStyle(
              fontSize: 31,
              height: 1.15,
              letterSpacing: -1,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 20),
          MetaLine(icon: Icons.schedule_rounded, text: event.dateLabel),
          const SizedBox(height: 12),
          MetaLine(icon: Icons.location_on_outlined, text: event.venue),
          const SizedBox(height: 22),
          const Divider(),
          const SizedBox(height: 16),
          const Text(
            'A little about the event',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 10),
          Text(
            event.description,
            style: const TextStyle(color: muted, height: 1.7, fontSize: 14),
          ),
          const SizedBox(height: 22),
          Row(
            children: [
              Availability(event: event),
              const Spacer(),
              Text(
                '${event.available} / ${event.capacity} available',
                style: const TextStyle(fontSize: 12, color: muted),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'Event ID: ${event.id}',
            style: const TextStyle(color: muted, fontSize: 10),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 12, 22, 14),
          child: FilledButton.icon(
            key: const ValueKey('participation'),
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(54),
            ),
            onPressed: _confirming || (!event.joined && event.available == 0)
                ? null
                : _participate,
            icon: Icon(
              event.joined
                  ? Icons.event_busy_rounded
                  : Icons.confirmation_number_outlined,
            ),
            label: Text(
              event.joined
                  ? 'Cancel participation'
                  : event.available == 0
                  ? 'Full'
                  : 'Join event',
            ),
          ),
        ),
      ),
    );
  }
}

class ImageViewer extends StatefulWidget {
  const ImageViewer({super.key, required this.event});
  final CampusEvent event;
  @override
  State<ImageViewer> createState() => _ImageViewerState();
}

class _ImageViewerState extends State<ImageViewer> {
  final _transform = TransformationController();
  Size? _viewport;

  @override
  void dispose() {
    _transform.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: ink,
    appBar: AppBar(
      title: Text(widget.event.title),
      backgroundColor: ink,
      foregroundColor: Colors.white,
    ),
    body: LayoutBuilder(
      builder: (context, box) {
        // Open 2x enlarged around the centre; pinch out to see the whole image.
        if (box.biggest != _viewport) {
          _viewport = box.biggest;
          _transform.value = Matrix4.diagonal3Values(2, 2, 1)
            ..setTranslationRaw(-box.maxWidth / 2, -box.maxHeight / 2, 0);
        }
        return InteractiveViewer(
          transformationController: _transform,
          minScale: 1,
          maxScale: 4,
          child: Image.asset(
            widget.event.image,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.contain,
            semanticLabel: 'Enlarged ${widget.event.category} illustration',
          ),
        );
      },
    ),
    bottomNavigationBar: const SafeArea(
      child: Padding(
        padding: EdgeInsets.all(14),
        child: Text(
          'Pinch to zoom · drag to explore',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white70, fontSize: 12),
        ),
      ),
    ),
  );
}
