import 'package:flutter/material.dart';
import 'data/events.dart';
import 'models/event.dart';
import 'screens/event_details.dart';
import 'widgets/event_card.dart';

void main() => runApp(const CampusApp());

class CampusApp extends StatelessWidget {
  const CampusApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Campus Event Explorer',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      useMaterial3: true,
      fontFamily: 'Manrope',
      scaffoldBackgroundColor: paper,
      colorScheme: ColorScheme.fromSeed(
        seedColor: ink,
        primary: ink,
        surface: paper,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: paper,
        foregroundColor: ink,
        centerTitle: false,
        elevation: 0,
      ),
      textTheme: ThemeData.light().textTheme.apply(
        fontFamily: 'Manrope',
        bodyColor: ink,
        displayColor: ink,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          textStyle: const TextStyle(
            fontFamily: 'Manrope',
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    ),
    home: const ExploreScreen(),
  );
}

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});
  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final List<CampusEvent> _events = createEvents();
  final _search = TextEditingController();
  String _category = 'All';
  int _tab = 0;

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  void _refresh() {
    if (mounted) setState(() {});
  }

  void _open(CampusEvent event) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (_) => EventDetails(event: event, onChanged: _refresh),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final joined = _events.where((e) => e.joined).length;
    final base = _events.where(
      (e) => _tab == 0 || (_tab == 1 ? e.favorite : e.joined),
    );
    final visible = filterEvents(base, _search.text, _category);
    final filtered = _search.text.trim().isNotEmpty || _category != 'All';
    const titles = [
      'Find your next\ncampus moment.',
      'Keep the good\nones close.',
      'Your plans,\nall in one place.',
    ];
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 68,
        title: const Row(
          children: [
            Icon(Icons.blur_on_rounded, size: 28),
            SizedBox(width: 9),
            Flexible(
              child: Text(
                'campus.',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 25,
                  letterSpacing: -1,
                ),
              ),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 20),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFD8DFD1)),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '$joined joined',
              key: const ValueKey('joined-count'),
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 680),
          child: CustomScrollView(
            key: ValueKey('list-$_tab'),
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(22, 12, 22, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _tab == 0
                            ? 'GET OUT. GET INVOLVED.'
                            : _tab == 1
                            ? 'YOUR PERSONAL SHORTLIST'
                            : 'MAKE TIME FOR WHAT MATTERS',
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 2,
                          color: muted,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        titles[_tab],
                        style: const TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.w800,
                          height: 1.15,
                          letterSpacing: -1.3,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _tab == 0
                            ? 'New ideas. New people. Right here on campus.'
                            : _tab == 1
                            ? 'A few things to look forward to.'
                            : 'Good experiences start with showing up.',
                        style: const TextStyle(color: muted, fontSize: 12),
                      ),
                      const SizedBox(height: 22),
                      TextField(
                        key: const ValueKey('search'),
                        controller: _search,
                        onChanged: (_) => setState(() {}),
                        decoration: InputDecoration(
                          hintText: 'Search events',
                          prefixIcon: const Icon(Icons.search_rounded),
                          suffixIcon: _search.text.isEmpty
                              ? null
                              : IconButton(
                                  tooltip: 'Clear search',
                                  icon: const Icon(Icons.close_rounded),
                                  onPressed: () => setState(_search.clear),
                                ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.all(16),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(
                              color: Color(0xFFE0E5DA),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(
                              color: Color(0xFFE0E5DA),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: categories
                              .map(
                                (category) => Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: ChoiceChip(
                                    key: ValueKey('category-$category'),
                                    label: Text(category),
                                    selected: _category == category,
                                    showCheckmark: false,
                                    selectedColor: ink,
                                    labelStyle: TextStyle(
                                      color: _category == category
                                          ? Colors.white
                                          : ink,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(22),
                                    ),
                                    onSelected: (_) =>
                                        setState(() => _category = category),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                      const SizedBox(height: 22),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              ['Coming up', 'Favorites', 'My Events'][_tab],
                              style: const TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Flexible(
                            child: Text(
                              '${visible.length} matching ${visible.length == 1 ? 'event' : 'events'}',
                              key: const ValueKey('result-count'),
                              textAlign: TextAlign.right,
                              style: const TextStyle(
                                fontSize: 11,
                                color: muted,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                    ],
                  ),
                ),
              ),
              if (visible.isEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(30, 30, 30, 50),
                    child: Column(
                      children: [
                        Icon(
                          _tab == 1
                              ? Icons.favorite_border_rounded
                              : _tab == 2
                              ? Icons.event_available_rounded
                              : Icons.search_off_rounded,
                          size: 44,
                          color: muted,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          filtered
                              ? 'No matching events'
                              : _tab == 1
                              ? 'Your favorites start here'
                              : 'Your calendar is open',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          filtered
                              ? 'Try another title or choose a different category.'
                              : _tab == 1
                              ? 'Tap the heart on any event to save it here.'
                              : 'Explore an event and join to make it part of your plans.',
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: muted),
                        ),
                        const SizedBox(height: 14),
                        TextButton(
                          onPressed: () => setState(() {
                            _search.clear();
                            _category = 'All';
                            if (!filtered) _tab = 0;
                          }),
                          child: Text(
                            filtered
                                ? 'Reset search & filters'
                                : 'Explore events',
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 22),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final event = visible[index];
                      return EventCard(
                        event: event,
                        onFavorite: () =>
                            setState(() => event.favorite = !event.favorite),
                        onOpen: () => _open(event),
                      );
                    }, childCount: visible.length),
                  ),
                ),
              const SliverToBoxAdapter(child: SizedBox(height: 10)),
            ],
          ),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tab,
        backgroundColor: paper,
        indicatorColor: const Color(0xFFDFE9D5),
        onDestinationSelected: (value) => setState(() => _tab = value),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.explore_outlined),
            selectedIcon: Icon(Icons.explore_rounded),
            label: 'Explore',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_border_rounded),
            selectedIcon: Icon(Icons.favorite_rounded),
            label: 'Favorites',
          ),
          NavigationDestination(
            icon: Icon(Icons.event_outlined),
            selectedIcon: Icon(Icons.event_rounded),
            label: 'My Events',
          ),
        ],
      ),
    );
  }
}
