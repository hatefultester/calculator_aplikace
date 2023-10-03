import 'package:flutter/material.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: CalculatorPage(),
    );
  }
}

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  late final ValueNotifier<String> calculatorInputNotifier;

  String? get lastCharacter => calculatorInputNotifier.value.isEmpty
      ? null
      : calculatorInputNotifier.value
          .substring(calculatorInputNotifier.value.length - 1);

  final operatorsList = ['+', 'x', '/', '-'];

  final numbersList = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '0'];

  final calculatorGridList = [
    '7',
    '8',
    '9',
    'x',
    '4',
    '5',
    '6',
    '/',
    '1',
    '2',
    '3',
    '-',
    '0',
    'C',
    '=',
    '+'
  ];

  @override
  void initState() {
    super.initState();
    calculatorInputNotifier = ValueNotifier<String>('');
  }

  @override
  void dispose() {
    calculatorInputNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculator'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: calculatorInputNotifier,
              builder: (context, value, _) {
                return Center(
                  child: Text(
                    value,
                    style: const TextStyle(
                      fontSize: 45,
                      color: Colors.black,
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: GridView.builder(
                itemCount: calculatorGridList.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                ),
                itemBuilder: (context, index) {
                  final value = calculatorGridList[index];
                  return InkWell(
                    onTap: () {
                      switch ((value, calculatorInputNotifier.value)) {
                        case ('-', ''):
                          calculatorInputNotifier.value = '-';
                        case ('+' || '-' || 'x' || '/', ''):
                          return;
                        case ('+' || 'x' || '/' || '-', _):
                          if (operatorsList.contains(lastCharacter)) {
                            return;
                          }
                          calculatorInputNotifier.value += value;
                        case ('C', _):
                          calculatorInputNotifier.value = '';
                        case ('=', _):
                          if (operatorsList.contains(lastCharacter)) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('seš piča vole')));
                            return;
                          };
                          final stringList =
                              calculatorInputNotifier.value.split('');
                          String? numStr;
                          String? operator;
                          double? sum;
                          for (final character in stringList) {
                            switch ((character, operator, numStr, sum)) {
                              case ('-', _, null, _):
                                numStr = '-';
                              case (final character, _, null, _)
                                  when numbersList.contains(character):
                                numStr = character;
                              case (final character, _, final String str, _)
                                  when numbersList.contains(character):
                                numStr = str + character;
                              case (
                                    final character,
                                    null,
                                    final String str,
                                    null
                                  )
                                  when operatorsList.contains(character):
                                operator = character;
                                sum = double.parse(str);
                                numStr = null;
                              case (
                                    final subStr,
                                    final String op,
                                    final String str,
                                    final double currentSum
                                  )
                                  when operatorsList.contains(subStr):
                                final val = double.parse(str);
                                sum = switch (op) {
                                  '+' => currentSum + val,
                                  '-' => currentSum - val,
                                  'x' => currentSum * val,
                                  _ => val != 0 ? currentSum / val : 0,
                                };
                                operator = subStr;
                                numStr = null;
                            }
                          }

                          if ((operator, numStr, sum)
                              case final (String, String, double) data) {
                            final val = double.parse(data.$2);
                            final result = switch (data.$1) {
                              '+' => data.$3 + val,
                              '-' => data.$3 - val,
                              'x' => data.$3 * val,
                              _ => val != 0 ? data.$3 / val : 0,
                            };
                            calculatorInputNotifier.value =
                                result.toInt().toString();
                          } else {
                            calculatorInputNotifier.value = '';
                          }
                        default:
                          calculatorInputNotifier.value += value;
                      }
                      ;
                    },
                    child: Center(
                      child: Text(
                        value,
                        style: const TextStyle(
                          fontSize: 25,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
