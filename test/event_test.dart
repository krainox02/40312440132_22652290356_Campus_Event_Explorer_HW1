import 'package:flutter_test/flutter_test.dart';
import 'package:campus_event_explorer/data/events.dart';
import 'package:campus_event_explorer/models/event.dart';

void main() {
  test('data meets event, date, category, image and capacity requirements', () {
    final events = createEvents();
    expect(events.length, greaterThanOrEqualTo(6));
    expect(events.map((e) => e.id).toSet().length, events.length);
    expect(
      events.map((e) => e.category).toSet().length,
      greaterThanOrEqualTo(3),
    );
    expect(events.map((e) => e.image).toSet().length, greaterThanOrEqualTo(3));
    expect(events.any((e) => e.available == 0), isTrue);
    expect(events.any((e) => e.available == 1), isTrue);
    for (final event in events) {
      expect(event.date.isAfter(DateTime(2026, 10, 25, 23, 59)), isTrue);
      expect(event.available, inInclusiveRange(0, event.capacity));
    }
  });

  test('last-place join is unique and cancellation restores exactly one', () {
    final event = createEvents().firstWhere((e) => e.available == 1);
    expect(event.join(), isTrue);
    expect(event.available, 0);
    expect(event.joined, isTrue);
    expect(event.join(), isFalse);
    expect(event.available, 0);
    expect(event.cancel(), isTrue);
    expect(event.available, 1);
    expect(event.cancel(), isFalse);
    expect(event.available, 1);
  });

  test(
    'full event rejects participation and favorites leave capacity alone',
    () {
      final event = createEvents().firstWhere((e) => e.available == 0);
      expect(event.join(), isFalse);
      expect(event.cancel(), isFalse);
      event.favorite = true;
      expect(event.available, 0);
      expect(event.joined, isFalse);
    },
  );

  test('search trims whitespace, ignores case and combines with category', () {
    final events = createEvents();
    expect(
      filterEvents(events, '  BUILD  ', 'Technology').single.id,
      'tech-01',
    );
    expect(filterEvents(events, '  BUILD  ', 'Arts'), isEmpty);
    expect(filterEvents(events, '   ', 'Sports').length, 2);
    expect(filterEvents(events, 'unmatched title', 'All'), isEmpty);
  });
}
