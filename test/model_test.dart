
import 'dart:io';

import 'package:flutter_test_app1/ClientModel.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_test_app1/ClientModel.dart';

void main()
{
  testWidgets('', (WidgetTester tester) async {
    
    Client cm = clientFromJson(""
        "{"
        "\"id\": 1, "
        "\"word_pair\": \"SuckAss\" "
        "}"
        "");

    stderr.writeln(cm.toJson());
    expect(cm.wordPair, "SuckAss");
  });
}