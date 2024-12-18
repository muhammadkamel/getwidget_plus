import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:getwidget_plus/getwidget_plus.dart';

class StateMarker extends StatefulWidget {
  const StateMarker({Key? key, this.child}) : super(key: key);
  final Widget? child;
  @override
  StateMarkerState createState() => StateMarkerState();
}

class StateMarkerState extends State<StateMarker> {
  String? marker;
  @override
  Widget build(BuildContext context) {
    if (widget.child != null) {
      return widget.child!;
    }
    return Container();
  }
}

void main() {
  final Key carouselKey = UniqueKey();
  final List<String> textList = <String>[
    'AAAAAA',
    'BBBBBB',
    'CCCCCC',
    'DDDDDD',
    'EEEEEE'
  ];
  final List<Widget> itemList = [
    Text(textList[0]),
    Text(textList[1]),
    Text(textList[2]),
    Text(textList[3]),
    Text(textList[4])
  ];

  testWidgets('GFCarousel can be constructed', (tester) async {
    String value = textList[0];
    late int changedIndex;

    final GFCarousel carousel = GFCarousel(
      key: carouselKey,
      items: itemList.map((text) => StateMarker(child: text)).toList(),
      onPageChanged: (index) {
        changedIndex = index;
        print('inr $index $changedIndex');
      },
    );

    StateMarkerState findStateMarkerState(String name) =>
        tester.state(find.widgetWithText(StateMarker, name));

    final TestApp app = TestApp(carousel);
    await tester.pumpWidget(app);

    // find carousel by key
    expect(find.byKey(carouselKey), findsOneWidget);
    // find the 'AAAAAA' text in carousel
    expect(find.text('AAAAAA'), findsOneWidget);

    TestGesture gesture =
        await tester.startGesture(tester.getCenter(find.text('AAAAAA')));
    await gesture.moveBy(const Offset(-600, 0));
    await tester.pump();
    expect(value, equals(textList[0]));
    findStateMarkerState(textList[1]).marker = 'marked';
    await gesture.up();
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    value = textList[changedIndex];
    expect(value, equals(textList[1]));
    await tester.pumpWidget(app);
    expect(findStateMarkerState(textList[1]).marker, equals('marked'));

    // slide on to the third slide.
    gesture =
        await tester.startGesture(tester.getCenter(find.text(textList[1])));
    await gesture.moveBy(const Offset(-600, 0));
    await gesture.up();
    await tester.pump();
    expect(findStateMarkerState(textList[1]).marker, equals('marked'));
    await tester.pump(const Duration(seconds: 1));
    value = textList[changedIndex];
    expect(value, equals(textList[2]));
    await tester.pumpWidget(app);
    expect(find.text(textList[2]), findsOneWidget);
    // slide back to the second slide.
    gesture =
        await tester.startGesture(tester.getCenter(find.text(textList[2])));
    await gesture.moveBy(const Offset(600, 0));
    await tester.pump();
    final StateMarkerState markerState = findStateMarkerState(textList[1]);
    markerState.marker = 'marked';
    await gesture.up();
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    value = textList[changedIndex];
    expect(value, equals(textList[1]));
    await tester.pumpWidget(app);
    expect(findStateMarkerState(textList[1]).marker, equals('marked'));
  });
}

class TestApp extends StatefulWidget {
  const TestApp(this.carousel);

  final GFCarousel carousel;

  @override
  _TestAppState createState() => _TestAppState();
}

class _TestAppState extends State<TestApp> {
  @override
  Widget build(BuildContext context) => MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              widget.carousel,
            ],
          ),
        ),
      );
}
