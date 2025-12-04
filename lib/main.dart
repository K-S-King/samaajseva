import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(CharityDonationApp());
}

// Hardcoded charity data
final List<Map<String, String>> charitiesData = [
  {
    'name': 'Help Feed',
    'description': 'Provide meals to underprivileged children',
    'category': 'Food & Hunger',
    'upiId': 'helpfeed@paytm',
  },
  {
    'name': 'Educate India',
    'description': 'Support children\'s education',
    'category': 'Education',
    'upiId': 'educateindia@upi',
  },
  {
    'name': 'Healthy India',
    'description':
        'Provide Indian General or Majorities free food and MacD subscriptions',
    'category': 'Health & Care',
    'upiId': 'healthyindia@upi',
  },
  {
    'name': 'Clean Water Project',
    'description': 'Bring clean drinking water to rural areas',
    'category': 'Environment',
    'upiId': 'cleanwater@upi',
  },
];

class CharityDonationApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Earn. Give. Impact.',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.light(primary: Color(0xFF433DCB)),
        scaffoldBackgroundColor: Color(0xFFF5F5F5),
      ),
      home: HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Earn. Give. Impact.',
          style: TextStyle(color: Color(0xFFFFFFFF)),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF433DCB),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Featured Charities',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF000000),
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: charitiesData.length,
                itemBuilder: (context, index) {
                  var charity = charitiesData[index];
                  return CharityCard(
                    name: charity['name']!,
                    description: charity['description']!,
                    category: charity['category']!,
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DonateScreen()),
          );
        },
        backgroundColor: Color(0xFF433DCB),
        child: Icon(Icons.favorite, color: Color(0xFFFFFFFF)),
        tooltip: 'Donate',
      ),
    );
  }
}

class CharityCard extends StatelessWidget {
  final String name;
  final String description;
  final String category;

  CharityCard({
    required this.name,
    required this.description,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 2,
      color: Color(0xFFFFFFFF),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.volunteer_activism, color: Color(0xFF4CAF50)),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    name,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF000000),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(description, style: TextStyle(color: Color(0xFF616161))),
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Color(0xFFC8E6C9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                category,
                style: TextStyle(color: Color(0xFF1B5E20), fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DonateScreen extends StatefulWidget {
  @override
  State<DonateScreen> createState() => _DonateScreenState();
}

class _DonateScreenState extends State<DonateScreen> {
  final _amountController = TextEditingController();
  final _customUpiController = TextEditingController();
  final _customNameController = TextEditingController();

  String? selectedCharity;
  String? selectedCharityUpi;
  bool _useCustomUpi = false;

  // Validate UPI ID format
  bool _isValidUpiId(String upiId) {
    final upiRegex = RegExp(r'^[\w.-]+@[\w.-]+$');
    return upiRegex.hasMatch(upiId);
  }

  // Show payment details dialog
  void _showPaymentDetails() {
    if (_amountController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Please enter donation amount')));
      return;
    }

    String receiverUpi;
    String receiverName;

    if (_useCustomUpi) {
      if (_customUpiController.text.isEmpty ||
          _customNameController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please enter UPI ID and receiver name')),
        );
        return;
      }

      if (!_isValidUpiId(_customUpiController.text)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invalid UPI ID format (e.g., name@paytm)')),
        );
        return;
      }

      receiverUpi = _customUpiController.text.trim();
      receiverName = _customNameController.text.trim();
    } else {
      if (selectedCharity == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Please select a charity')));
        return;
      }
      receiverUpi = selectedCharityUpi!;
      receiverName = selectedCharity!;
    }

    final amount = _amountController.text;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.info_outline, color: Color(0xFF433DCB)),
            SizedBox(width: 8),
            Text('Payment Details'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Open any UPI app and pay to:',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              SizedBox(height: 20),

              // UPI ID Section
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.account_balance_wallet,
                      color: Color(0xFF433DCB),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'UPI ID',
                            style: TextStyle(fontSize: 11, color: Colors.grey),
                          ),
                          SizedBox(height: 4),
                          SelectableText(
                            receiverUpi,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.copy, size: 20),
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: receiverUpi));
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('UPI ID copied to clipboard')),
                        );
                      },
                    ),
                  ],
                ),
              ),

              SizedBox(height: 12),

              // Name Section
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.person, color: Color(0xFF433DCB)),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Receiver Name',
                            style: TextStyle(fontSize: 11, color: Colors.grey),
                          ),
                          SizedBox(height: 4),
                          Text(
                            receiverName,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 12),

              // Amount Section
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.currency_rupee, color: Color(0xFF433DCB)),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Amount',
                            style: TextStyle(fontSize: 11, color: Colors.grey),
                          ),
                          SizedBox(height: 4),
                          Text(
                            '₹$amount',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.green[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              _initiatePayment();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF433DCB)),
            icon: Icon(Icons.open_in_new, color: Colors.white, size: 18),
            label: Text('Open UPI App', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // Initiate UPI Payment
  Future<void> _initiatePayment() async {
    // Validation
    if (_amountController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Please enter donation amount')));
      return;
    }

    String receiverUpi;
    String receiverName;

    if (_useCustomUpi) {
      if (_customUpiController.text.isEmpty ||
          _customNameController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please enter UPI ID and receiver name')),
        );
        return;
      }

      if (!_isValidUpiId(_customUpiController.text)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invalid UPI ID format (e.g., name@paytm)')),
        );
        return;
      }

      receiverUpi = _customUpiController.text.trim();
      receiverName = _customNameController.text.trim();
    } else {
      if (selectedCharity == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Please select a charity')));
        return;
      }
      receiverUpi = selectedCharityUpi!;
      receiverName = selectedCharity!;
    }

    final amount = double.tryParse(_amountController.text);
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Please enter a valid amount')));
      return;
    }

    try {
      // Multiple UPI URL formats to try
      final List<String> upiUrls = [
        // Format 1: Standard UPI format
        'upi://pay?pa=$receiverUpi&pn=${Uri.encodeComponent(receiverName)}&am=$amount&cu=INR&tn=${Uri.encodeComponent("Donation")}',

        // Format 2: Google Pay specific
        'gpay://upi/pay?pa=$receiverUpi&pn=${Uri.encodeComponent(receiverName)}&am=$amount&cu=INR',

        // Format 3: PhonePe specific
        'phonepe://pay?pa=$receiverUpi&pn=${Uri.encodeComponent(receiverName)}&am=$amount&cu=INR',

        // Format 4: Paytm specific
        'paytmmp://pay?pa=$receiverUpi&pn=${Uri.encodeComponent(receiverName)}&am=$amount&cu=INR',
      ];

      bool launched = false;

      // Try each URL format
      for (String upiUrl in upiUrls) {
        try {
          final uri = Uri.parse(upiUrl);

          if (await canLaunchUrl(uri)) {
            launched = await launchUrl(
              uri,
              mode: LaunchMode.externalApplication,
            );

            if (launched) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Opening UPI app for ₹${amount.toStringAsFixed(0)} payment...',
                  ),
                  backgroundColor: Colors.green,
                  duration: Duration(seconds: 2),
                ),
              );
              break;
            }
          }
        } catch (e) {
          continue;
        }
      }

      if (!launched) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Could not auto-open UPI app. Use "Show Details" to pay manually.',
            ),
            backgroundColor: Colors.orange,
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Make a Donation',
          style: TextStyle(color: Color(0xFFFFFFFF)),
        ),
        backgroundColor: Color(0xFF433DCB),
        foregroundColor: Color(0xFFFFFFFF),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Toggle between charity selection and custom UPI
            Card(
              color: Color(0xFFE8EAF6),
              child: SwitchListTile(
                title: Text(
                  'Enter Custom UPI ID',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text('Toggle to donate to any UPI ID'),
                value: _useCustomUpi,
                activeColor: Color(0xFF433DCB),
                onChanged: (value) {
                  setState(() {
                    _useCustomUpi = value;
                    if (value) {
                      selectedCharity = null;
                    } else {
                      _customUpiController.clear();
                      _customNameController.clear();
                    }
                  });
                },
              ),
            ),
            SizedBox(height: 24),

            // OPTION 1: Featured Charity Selection
            if (!_useCustomUpi) ...[
              Text(
                'Select Featured Charity',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                isExpanded: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                ),
                hint: Text('Choose a charity'),
                value: selectedCharity,
                items: charitiesData.map((charity) {
                  return DropdownMenuItem(
                    value: charity['name'],
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          charity['name']!,
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        Text(
                          charity['category']!,
                          style: TextStyle(fontSize: 11, color: Colors.grey),
                        ),
                      ],
                    ),
                    onTap: () {
                      selectedCharityUpi = charity['upiId'];
                    },
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() => selectedCharity = value);
                },
              ),
            ],

            // OPTION 2: Custom UPI Entry
            if (_useCustomUpi) ...[
              Text(
                'Enter Receiver Details',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _customNameController,
                decoration: InputDecoration(
                  labelText: 'Receiver Name',
                  hintText: 'e.g., John Doe',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _customUpiController,
                decoration: InputDecoration(
                  labelText: 'UPI ID',
                  hintText: 'e.g., example@paytm',
                  prefixIcon: Icon(Icons.account_balance_wallet),
                  border: OutlineInputBorder(),
                  helperText: 'Format: username@bank',
                ),
              ),
            ],

            SizedBox(height: 24),

            // Donation Amount
            Text(
              'Donation Amount',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                prefixText: '₹ ',
                border: OutlineInputBorder(),
                hintText: 'Enter amount',
                helperText:
                    '100% of your donation goes to the receiver (No fees!)',
                helperStyle: TextStyle(color: Colors.green),
              ),
            ),
            SizedBox(height: 32),

            // Dual Action Buttons
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 56,
                    child: OutlinedButton.icon(
                      onPressed: _showPaymentDetails,
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Color(0xFF433DCB), width: 2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: Icon(Icons.info_outline, color: Color(0xFF433DCB)),
                      label: Text(
                        'Show Details',
                        style: TextStyle(
                          fontSize: 15,
                          color: Color(0xFF433DCB),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: SizedBox(
                    height: 56,
                    child: ElevatedButton.icon(
                      onPressed: _initiatePayment,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF433DCB),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: Icon(Icons.payment, color: Colors.white),
                      label: Text(
                        'Pay Now',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 16),

            // Info text
            Center(
              child: Text(
                'Tap "Show Details" to copy payment info or "Pay Now" to auto-open UPI app',
                style: TextStyle(fontSize: 11, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    _customUpiController.dispose();
    _customNameController.dispose();
    super.dispose();
  }
}
