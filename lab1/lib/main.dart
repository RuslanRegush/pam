import 'package:flutter/material.dart';

void main() {
  runApp(LoanCalculatorApp());
}

class LoanCalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Loan Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoanCalculatorScreen(),
    );
  }
}

class LoanCalculatorScreen extends StatefulWidget {
  @override
  _LoanCalculatorScreenState createState() => _LoanCalculatorScreenState();
}

class _LoanCalculatorScreenState extends State<LoanCalculatorScreen> {
  final TextEditingController _amountController = TextEditingController();
  double _months = 1;
  final TextEditingController _percentController = TextEditingController();
  double _monthlyPayment = 0;

  void _calculatePayment() {
    final double amount = double.tryParse(_amountController.text) ?? 0;
    final double percent = double.tryParse(_percentController.text) ?? 0;
    if (amount > 0 && percent > 0 && _months > 0) {
      setState(() {
        _monthlyPayment = (amount * (1 + (percent / 100))) / _months;
      });
    } else {
      setState(() {
        _monthlyPayment = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Loan Calculator',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Enter amount',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            Text('Enter number of months'),
            Slider(
              value: _months,
              min: 1,
              max: 60,
              divisions: 59,
              label: _months.toString(),
              onChanged: (double value) {
                setState(() {
                  _months = value;
                });
              },
            ),
            SizedBox(height: 10),
            TextField(
              controller: _percentController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Enter % per month',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _calculatePayment,
              child: Text('Calculate'),
            ),
            SizedBox(height: 20),
            // Capsule-like container with separated sections
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: Colors.grey,
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Top part (Grey background)
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[300], // Light grey background
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                      ),
                    ),
                    padding: EdgeInsets.all(16),
                    child: Center(
                      child: Text(
                        'You will pay the approximate amount monthly:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  // Bottom part (White background)
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white, // White background
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(15),
                        bottomRight: Radius.circular(15),
                      ),
                    ),
                    padding: EdgeInsets.all(16),
                    child: Center(
                      child: Text(
                        '${_monthlyPayment.toStringAsFixed(2)} €',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
