import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:campus_event_explorer/main.dart';
import 'package:campus_event_explorer/screens/event_details.dart';

void main() {
  Future<void> start(WidgetTester tester) async {
    tester.view.physicalSize = const Size(430, 932);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final loader = FontLoader('Manrope')
      ..addFont(rootBundle.load('assets/fonts/Manrope.ttf'));
    await tester.runAsync(loader.load);
    final icons = FontLoader('MaterialIcons')
      ..addFont(rootBundle.load('fonts/MaterialIcons-Regular.otf'));
    await tester.runAsync(icons.load);
    await tester.pumpWidget(
      RepaintBoundary(key: const ValueKey('capture'), child: const CampusApp()),
    );
    await tester.runAsync(() async {
      final context = tester.element(find.byType(ExploreScreen));
      for (final category in ['technology', 'arts', 'sports']) {
        await precacheImage(AssetImage('assets/images/$category.png'), context);
      }
    });
    await tester.pumpAndSettle();
  }

  Future<void> capture(WidgetTester tester, String name) async {
    ScaffoldMessenger.of(
      tester.element(find.byType(ExploreScreen, skipOffstage: false)),
    ).clearSnackBars();
    await tester.pumpAndSettle();
    final boundary = tester.renderObject<RenderRepaintBoundary>(
      find.byKey(const ValueKey('capture')),
    );
    await tester.runAsync(() async {
      final image = await boundary.toImage(pixelRatio: 2);
      final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
      await Directory('screenshots').create(recursive: true);
      await File(
        'screenshots/$name.png',
      ).writeAsBytes(bytes!.buffer.asUint8List());
      image.dispose();
    });
  }

  Future<void> tap(WidgetTester tester, Finder finder) async {
    await tester.ensureVisible(finder);
    await tester.pumpAndSettle();
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  testWidgets(
    'core journey, image navigation, synced views and screenshot evidence',
    (tester) async {
      await start(tester);
      await capture(tester, '01-explore');
      await tap(tester, find.byKey(const ValueKey('favorite-tech-01')));
      await tap(tester, find.byKey(const ValueKey('details-tech-01')));
      expect(find.byType(EventDetails), findsOneWidget);
      await capture(tester, '02-details');
      final image = find.byKey(const ValueKey('detail-image'));
      await tester.tap(image);
      await tester.pump(const Duration(milliseconds: 80));
      await tester.tap(image);
      await tester.pumpAndSettle();
      expect(find.byType(ImageViewer), findsOneWidget);
      final viewer = tester.widget<InteractiveViewer>(
        find.byType(InteractiveViewer),
      );
      expect(viewer.transformationController!.value.getMaxScaleOnAxis(), 2);
      await capture(tester, '05-image-viewer');
      await tester.pageBack();
      await tester.pumpAndSettle();
      await tap(tester, find.byKey(const ValueKey('participation')));
      expect(find.text('Join this event?'), findsOneWidget);
      expect(find.text('Engineering Building · Lab 204'), findsWidgets);
      await tap(tester, find.text('No'));
      expect(find.text('12 / 30 available'), findsOneWidget);
      await tap(tester, find.byKey(const ValueKey('participation')));
      await tap(tester, find.text('Yes'));
      expect(find.text('Cancel participation'), findsOneWidget);
      expect(find.text('11 / 30 available'), findsOneWidget);
      await tester.pageBack();
      await tester.pumpAndSettle();
      expect(find.text('1 joined'), findsOneWidget);
      await tap(tester, find.byType(NavigationDestination).at(1));
      expect(find.text('Build Something Great'), findsOneWidget);
      await capture(tester, '03-favorites');
      await tap(tester, find.byType(NavigationDestination).at(2));
      expect(find.text('Build Something Great'), findsOneWidget);
      await capture(tester, '04-my-events');
      await tap(tester, find.byKey(const ValueKey('details-tech-01')));
      await tap(tester, find.byKey(const ValueKey('participation')));
      await capture(tester, '06-cancel-dialog');
      await tap(tester, find.text('Yes'));
      expect(find.text('12 / 30 available'), findsOneWidget);
      await tester.pageBack();
      await tester.pumpAndSettle();
      expect(find.text('Your calendar is open'), findsOneWidget);
      expect(find.text('0 joined'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'last place, dialog dismissal, shared filters, empty states and full event',
    (tester) async {
      await start(tester);
      await tester.enterText(find.byKey(const ValueKey('search')), '  JAZZ  ');
      await tester.pumpAndSettle();
      expect(find.text('1 matching event'), findsOneWidget);
      await tap(tester, find.byKey(const ValueKey('category-Technology')));
      expect(find.text('No matching events'), findsOneWidget);
      await capture(tester, '07-empty-search');
      await tap(tester, find.byType(NavigationDestination).at(1));
      expect(find.text('No matching events'), findsOneWidget);
      await tap(tester, find.byType(NavigationDestination).at(2));
      expect(find.text('No matching events'), findsOneWidget);
      await tap(tester, find.text('Reset search & filters'));
      expect(find.text('Your calendar is open'), findsOneWidget);
      await tap(tester, find.byType(NavigationDestination).at(1));
      expect(find.text('Your favorites start here'), findsOneWidget);
      await tap(tester, find.byType(NavigationDestination).at(0));
      await tester.enterText(find.byKey(const ValueKey('search')), 'jazz');
      await tester.pumpAndSettle();
      await tap(tester, find.byKey(const ValueKey('details-arts-01')));
      await tap(tester, find.byKey(const ValueKey('participation')));
      // Dismiss by tapping the modal barrier, equivalent to an outside tap.
      await tester.tapAt(const Offset(8, 80));
      await tester.pumpAndSettle();
      expect(find.text('1 / 80 available'), findsOneWidget);
      await tap(tester, find.byKey(const ValueKey('participation')));
      await tap(tester, find.text('Yes'));
      expect(find.text('0 / 80 available'), findsOneWidget);
      expect(find.text('Cancel participation'), findsOneWidget);
      await tap(tester, find.byKey(const ValueKey('details-favorite')));
      await tap(tester, find.byKey(const ValueKey('participation')));
      await tap(tester, find.text('No'));
      expect(find.text('0 / 80 available'), findsOneWidget);
      await tap(tester, find.byKey(const ValueKey('participation')));
      await tap(tester, find.text('Yes'));
      expect(find.text('1 / 80 available'), findsOneWidget);
      await tester.pageBack();
      await tester.pumpAndSettle();
      await tap(tester, find.byType(NavigationDestination).at(1));
      expect(find.text('After Hours: Campus Jazz'), findsOneWidget);
      await tap(tester, find.byKey(const ValueKey('favorite-arts-01')));
      expect(find.text('After Hours: Campus Jazz'), findsNothing);
      await tap(tester, find.byType(NavigationDestination).at(0));
      await tester.enterText(find.byKey(const ValueKey('search')), 'sunrise');
      await tester.pumpAndSettle();
      await tap(tester, find.byKey(const ValueKey('details-sports-01')));
      final button = tester.widget<FilledButton>(
        find.byKey(const ValueKey('participation')),
      );
      expect(button.onPressed, isNull);
      await capture(tester, '08-full-event');
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('narrow display and large text remain usable', (tester) async {
    await start(tester);
    tester.view.physicalSize = const Size(320, 740);
    tester.platformDispatcher.textScaleFactorTestValue = 1.5;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.byKey(const ValueKey('details-tech-01')),
      250,
      scrollable: find
          .descendant(
            of: find.byType(CustomScrollView),
            matching: find.byType(Scrollable),
          )
          .first,
    );
    await tap(tester, find.byKey(const ValueKey('details-tech-01')));
    expect(find.byType(EventDetails), findsOneWidget);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}
