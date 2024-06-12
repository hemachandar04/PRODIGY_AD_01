import 'package:flutter/material.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF2B2B2B),
      ),
      home: const Calculator(),
    );
  }
}

class Calculator extends StatefulWidget {
  const Calculator({super.key});

  @override
  CalculatorState createState() => CalculatorState();
}

class CalculatorState extends State<Calculator> {
  String display = '0';
  String currentInput = '';
  String operator = '';
  String previousInput = '';
  List<String> history = [];
  bool isHistoryVisible = false;

  void clearDisplay() {
    setState(() {
      currentInput = '';
      operator = '';
      previousInput = '';
      display = '0';
    });
  }

  void deleteLast() {
    setState(() {
      if (currentInput.isNotEmpty) {
        currentInput = currentInput.substring(0, currentInput.length - 1);
        updateDisplay();
      }
    });
  }

  void appendNumber(String number) {
    setState(() {
      if (number == '.' && currentInput.contains('.')) return;
      currentInput += number;
      updateDisplay();
    });
  }

  void appendOperator(String op) {
    setState(() {
      if (currentInput.isEmpty) return;
      if (operator.isNotEmpty) calculate();
      operator = op;
      previousInput = currentInput;
      currentInput = '';
      updateDisplay();
    });
  }

  void calculate() {
    setState(() {
      double result;
      double prev = double.tryParse(previousInput) ?? 0;
      double current = double.tryParse(currentInput) ?? 0;

      switch (operator) {
        case '+':
          result = prev + current;
          break;
        case '-':
          result = prev - current;
          break;
        case '*':
          result = prev * current;
          break;
        case '/':
          result = prev / current;
          break;
        default:
          return;
      }

      currentInput = result.toString();
      history.add('$previousInput $operator $current = $result');
      updateHistory();
      operator = '';
      previousInput = '';
      updateDisplay();
    });
  }

  void updateDisplay() {
    setState(() {
      display = '$previousInput $operator $currentInput';
      if (display.trim().isEmpty) {
        display = '0';
      }
    });
  }

  void updateHistory() {
    // History display will be updated automatically by setState
  }

  void toggleHistory() {
    setState(() {
      isHistoryVisible = !isHistoryVisible;
    });
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
            child: Container(
              alignment: Alignment.bottomRight,
              padding: const EdgeInsets.all(20),
              child: Text(
                display,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 48,
                ),
              ),
            ),
          ),
          if (isHistoryVisible)
            Container(
              color: const Color(0xFF222222),
              height: 100,
              child: ListView.builder(
                itemCount: history.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      history[index],
                      style: TextStyle(color: Colors.grey[400]),
                    ),
                  );
                },
              ),
            ),
          Row(
            children: [
              CalculatorButton(text: 'AC', onTap: clearDisplay),
              CalculatorButton(text: '←', onTap: deleteLast),
              CalculatorButton(text: '÷', onTap: () => appendOperator('/')),
              CalculatorButton(text: '×', onTap: () => appendOperator('*')),
            ],
          ),
          Row(
            children: [
              CalculatorButton(text: '7', onTap: () => appendNumber('7')),
              CalculatorButton(text: '8', onTap: () => appendNumber('8')),
              CalculatorButton(text: '9', onTap: () => appendNumber('9')),
              CalculatorButton(text: '-', onTap: () => appendOperator('-')),
            ],
          ),
          Row(
            children: [
              CalculatorButton(text: '4', onTap: () => appendNumber('4')),
              CalculatorButton(text: '5', onTap: () => appendNumber('5')),
              CalculatorButton(text: '6', onTap: () => appendNumber('6')),
              CalculatorButton(text: '+', onTap: () => appendOperator('+')),
            ],
          ),
          Row(
            children: [
              CalculatorButton(text: '1', onTap: () => appendNumber('1')),
              CalculatorButton(text: '2', onTap: () => appendNumber('2')),
              CalculatorButton(text: '3', onTap: () => appendNumber('3')),
              CalculatorButton(
                text: '=',
                onTap: calculate,
                backgroundColor: const Color(0xFFF39C12),
              ),
            ],
          ),
          Row(
            children: [
              CalculatorButton(
                  text: '0', onTap: () => appendNumber('0'), flex: 2),
              CalculatorButton(text: '.', onTap: () => appendNumber('.')),
              CalculatorButton(
                text: isHistoryVisible ? 'Hide History' : 'Show History',
                onTap: toggleHistory,
                backgroundColor: const Color(0xFF575757),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CalculatorButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final int flex;
  final Color? backgroundColor;

  const CalculatorButton({
    required this.text,
    required this.onTap,
    this.flex = 1,
    this.backgroundColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: backgroundColor ?? const Color(0xFF3C3C3C),
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Text(
            text,
            style: const TextStyle(color: Colors.white, fontSize: 24),
          ),
        ),
      ),
    );
  }
}
