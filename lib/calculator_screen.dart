import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'history_screen.dart';
import 'profile_screen.dart';
import 'button_values.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String currentInput = "";
  List<String> history = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        backgroundColor: Colors.white, // Sidebar putih
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Color(0xFF1565C0), // Biru tua
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Calculator Menu",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 255, 255, 255)),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Pilih menu yang tersedia",
                    style: TextStyle(fontSize: 16, color: Colors.white70),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.history, color: Colors.black),
              title: const Text("History", style: TextStyle(color: Colors.black)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HistoryScreen(history: history)),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.person, color: Colors.black),
              title: const Text("Profile", style: TextStyle(color: Colors.black)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfileScreen()),
                );
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text('Calculator'),
        backgroundColor: const Color(0xFF1565C0), // Biru tua
      ),
      body: SafeArea(
        bottom: false,
        child: Center(
          child: Container(   
            width: 350,
            padding: const EdgeInsets.all(16),
            constraints: const BoxConstraints(
              maxHeight: 500, // Batasi tinggi agar tidak terlalu besar
            ),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 237, 250, 255), // Background utama putih kebiruan
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  spreadRadius: 2,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  alignment: Alignment.bottomRight,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  child: Text(
                     currentInput.isEmpty ? "0" : currentInput,
                     style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.black, // Set the input text color to black
                      ),
                    textAlign: TextAlign.end,
                    ),

                ),
                Flexible( // Agar grid tidak melebihi batas tinggi
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio: 1.2,
                    ),
                    itemCount: Btn.buttonValues.length,
                    itemBuilder: (context, index) {
                      String value = Btn.buttonValues[index];

                      if (value == Btn.n0) {
                        return GridTile(
                          child: SizedBox(
                            width: 170,
                            child: buildButton(value),
                          ),
                        );
                      }

                      return buildButton(value);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: Colors.white, // Latar belakang utama putih
    );
  }

  Widget buildButton(String value) {
    return Material(
      color: Color.fromARGB(255, 0, 0, 0),
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => onBtnTap(value),
        child: Center(
          child: Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
              color: getTextColor(value),
            ),
          ),
        ),
      ),
    );
  }

  void onBtnTap(String value) {
    if (value == Btn.del) {
      delete();
      return;
    }

    if (value == Btn.clr) {
      clearAll();
      return;
    }

    if (value == Btn.per) {
      convertToPercentage();
      return;
    }

    if (value == Btn.calculate) {
      calculate();
      return;
    }

    appendValue(value);
  }

  void calculate() {
    if (currentInput.isEmpty) return;

    try {
      var result = _evaluateExpression(currentInput);
      var resultString = result.toStringAsPrecision(3);

      if (resultString.endsWith(".0")) {
        resultString = resultString.substring(0, resultString.length - 2);
      }

      setState(() {
        history.add("$currentInput = $resultString");
        currentInput = resultString;
      });
    } catch (e) {
      setState(() {
        currentInput = "Error";
      });
    }
  }

  double _evaluateExpression(String expression) {
    try {
      Parser p = Parser();
      Expression exp =
          p.parse(expression.replaceAll('×', '*').replaceAll('÷', '/'));
      ContextModel cm = ContextModel();
      return exp.evaluate(EvaluationType.REAL, cm);
    } catch (e) {
      throw Exception("Invalid Expression");
    }
  }

  void convertToPercentage() {
    if (currentInput.isNotEmpty) {
      final number = double.tryParse(currentInput);
      if (number != null) {
        setState(() {
          currentInput = (number / 100).toStringAsFixed(2);
        });
      }
    }
  }

  void clearAll() {
    setState(() {
      currentInput = "";
    });
  }

  void delete() {
    if (currentInput.isNotEmpty) {
      setState(() {
        currentInput = currentInput.substring(0, currentInput.length - 1);
      });
    }
  }

  void appendValue(String value) {
    if (value == Btn.dot && currentInput.contains(Btn.dot)) return;
    setState(() {
      currentInput += value;
    });
  }

  Color getBtnColor(String value) {
    if ([Btn.del, Btn.clr].contains(value)) {
      return Colors.blue[200]!; // Biru muda (hapus)
    } else if ([Btn.per, Btn.multiply, Btn.add, Btn.subtract, Btn.divide, Btn.calculate].contains(value)) {
      return Colors.blue[300]!; // Biru terang (operator)
    } else {
      return Colors.blue[800]!; // Biru tua (angka)
    }
  }

  Color getTextColor(String value) {
    if ([Btn.del, Btn.clr].contains(value)) {
      return Color.fromARGB(255, 107, 245, 255); // Tombol hapus pakai teks hitam
    }
    return Colors.white; // Lainnya pakai teks putih
  }
}