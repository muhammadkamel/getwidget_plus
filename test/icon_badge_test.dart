import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:getwidget_plus/getwidget_plus.dart';

void main() {
  const badge = GFBadge(
    child: Text('12'),
  );
  const size = GFSize.SMALL;

  testWidgets('Disabled GF IconBadge can be constructed', (tester) async {
    const iconBadgeKey = Key('header');

    final GFIconBadge iconBadge = GFIconBadge(
      counterChild: badge,
      child: GFIconButton(
        key: iconBadgeKey,
        onPressed: null,
        icon: const Icon(
          Icons.directions_bike_sharp,
        ),
        size: size,
        disabledColor: Colors.teal.shade300,
      ),
    );

    final TestApp app = TestApp(iconBadge);

    await tester.pumpWidget(app);

    expect(find.byIcon(Icons.directions_bike_sharp), findsOneWidget);
    expect(find.byWidget(badge), findsOneWidget);
    expect(app.iconBadge.counterChild, badge);

    await tester.tap(find.byKey(iconBadgeKey));
    await tester.pump();

    await tester.pumpWidget(app);
  });

  testWidgets('GF IconBadge can be constructed', (tester) async {
    const iconBadgeKey = Key('header');

    final GFIconBadge iconBadge = GFIconBadge(
      counterChild: badge,
      child: GFIconButton(
        key: iconBadgeKey,
        onPressed: () {},
        icon: const Icon(
          Icons.directions_bike_sharp,
        ),
        size: size,
        color: Colors.teal,
      ),
    );

    final TestApp app = TestApp(iconBadge);

    await tester.pumpWidget(app);

    expect(find.byIcon(Icons.directions_bike_sharp), findsOneWidget);
    expect(find.byWidget(badge), findsOneWidget);
    expect(app.iconBadge.counterChild, badge);

    await tester.tap(find.byKey(iconBadgeKey));
    await tester.pump();

    await tester.pumpWidget(app);
  });
}

class TestApp extends StatefulWidget {
  const TestApp(this.iconBadge);

  final GFIconBadge iconBadge;

  @override
  _TestAppState createState() => _TestAppState();
}

class _TestAppState extends State<TestApp> {
  @override
  Widget build(BuildContext context) => MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              widget.iconBadge,
            ],
          ),
        ),
      );
}
