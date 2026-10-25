class CampusEvent {
  CampusEvent({
    required this.id,
    required this.title,
    required this.category,
    required this.date,
    required this.venue,
    required this.description,
    required this.image,
    required this.capacity,
    required this.available,
  }) : assert(capacity > 0),
       assert(available >= 0 && available <= capacity);

  final String id;
  final String title;
  final String category;
  final DateTime date;
  final String venue;
  final String description;
  final String image;
  final int capacity;
  int available;
  bool favorite = false;
  bool joined = false;

  // Guards preserve capacity even if a callback is accidentally repeated.
  bool join() {
    if (joined || available == 0) return false;
    joined = true;
    available--;
    return true;
  }

  bool cancel() {
    if (!joined) return false;
    joined = false;
    available++;
    return true;
  }

  String get availability => joined
      ? 'You are going'
      : available == 0
      ? 'Full'
      : available == 1
      ? 'Last place!'
      : '$available places left';

  String get dateLabel {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '${months[date.month - 1]} ${date.day}, ${date.year} · $hour:$minute';
  }
}

List<CampusEvent> filterEvents(
  Iterable<CampusEvent> events,
  String query,
  String category,
) {
  final normalized = query.trim().toLowerCase();
  return events.where((event) {
    return event.title.toLowerCase().contains(normalized) &&
        (category == 'All' || event.category == category);
  }).toList();
}
