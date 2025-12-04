import 'package:flutter/material.dart';
import 'package:budgipets/widgets/main_page_nav_header.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LogsPage extends StatefulWidget {
  const LogsPage({super.key});

  @override
  State<LogsPage> createState() => _LogsPageState();
}

class _LogsPageState extends State<LogsPage> {
  bool _loading = true;
  String? _error;
  Map<String, List<Map<String, dynamic>>> _grouped = {};

  Color get bgCream => const Color(0xFFF4DCC2);
  Color get brown => const Color(0xFF6A3E1C);

  TextStyle titleStyle(double size, {Color color = Colors.white}) =>
      TextStyle(fontFamily: 'Questrial', fontSize: size, fontWeight: FontWeight.bold, color: color);

  TextStyle bodyStyle(double size, {Color color = Colors.white}) =>
      TextStyle(fontFamily: 'Questrial', fontSize: size, color: color);

  @override
  void initState() {
    super.initState();
    _loadLogs();
  }

  Future<void> _loadLogs() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final supabase = Supabase.instance.client;
      final user = supabase.auth.currentUser;
      if (user == null) {
        throw Exception('You are not signed in.');
      }

      final res = await supabase
          .from('spend_logs')
          .select('id, label, amount, occurred_at, kind, category, note')
          .eq('user_id', user.id)
          .order('occurred_at', ascending: false)
          .limit(200);

      if (res == null) {
        setState(() {
          _grouped = {};
          _loading = false;
        });
        return;
      }

      final List<Map<String, dynamic>> rows = (res as List)
          .map((r) => Map<String, dynamic>.from(r as Map))
          .toList();

      final Map<String, List<Map<String, dynamic>>> grouped = {};

      for (final row in rows) {
        final occurredRaw = row['occurred_at'];
        DateTime dt;
        try {
          if (occurredRaw is DateTime) {
            dt = occurredRaw;
          } else if (occurredRaw is String) {
            dt = DateTime.parse(occurredRaw).toLocal();
          } else {
            dt = DateTime.now();
          }
        } catch (e) {
          dt = DateTime.now();
        }

        final dateKey = _formatDateHeader(dt);
        grouped.putIfAbsent(dateKey, () => []).add({
          'id': row['id'],
          'label': row['label'],
          'amount': row['amount'],
          'occurred_at': dt,
          'kind': row['kind'] ?? 'Expense',
          'category': row['category'],
          'note': row['note'],
        });
      }

      setState(() {
        _grouped = grouped;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  String _formatDateHeader(DateTime dt) {
    const months = [
      '',
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return '${months[dt.month]} ${dt.day}, ${dt.year}';
  }

  String _formatAmount(num amount, String kind) {
    final isExpense = (kind ?? 'Expense') == 'Expense';
    final signed = isExpense ? -amount : amount;
    final symbol = isExpense ? '-' : '+';
    return '$symbol₱${signed.abs().toStringAsFixed(2)}';
  }

  IconData _iconForCategory(String? cat, String kind) {
  // Expense categories
  final expenseMap = <String, IconData>{
    'Medical': Icons.healing,
    'Car': Icons.directions_car,
    'Food': Icons.fastfood,
    'Travel': Icons.flight_takeoff,
    'Recreation': Icons.sports_esports,
    'Pets': Icons.pets,
    'Bills': Icons.receipt_long,
    'Other': Icons.category,
  };
  
  // Income categories
  final incomeMap = <String, IconData>{
    'Salary': Icons.attach_money,
    'Loan': Icons.handshake,
    'Sold Item': Icons.shopping_bag,
    'Donation': Icons.volunteer_activism,
    'Other': Icons.category,
  };
  
  // Check if it's an income or expense
  if (kind == 'Income' && cat != null && incomeMap.containsKey(cat)) {
    return incomeMap[cat]!;
  }
  
  if (kind == 'Expense' && cat != null && expenseMap.containsKey(cat)) {
    return expenseMap[cat]!;
  }
  
  // Default icons
  if (kind == 'Income') return Icons.attach_money;
  return Icons.category;

  }

  Color _colorForCategory(String? cat, String kind) {
  // Expense categories
  final expenseMap = <String, Color>{
    'Medical': const Color(0xFF720607),
    'Car': const Color(0xFF073598),
    'Food': const Color(0xFFC57000),
    'Travel': const Color(0xFF390488),
    'Recreation': const Color(0xFFFEB65B),
    'Pets': const Color(0xFFCD6082),
    'Bills': Color.fromARGB(255, 71, 166, 114),
    'Other': const Color(0xFF582901),
  };
  
  // Income categories
  final incomeMap = <String, Color>{
    'Salary': Colors.green,
    'Loan': Colors.teal,
    'Sold Item': Colors.blue,
    'Donation': Colors.purple,
    'Other': Colors.brown,
  };
  
  // Check if it's an income or expense
  if (kind == 'Income' && cat != null && incomeMap.containsKey(cat)) {
    return incomeMap[cat]!;
  }
  
  if (kind == 'Expense' && cat != null && expenseMap.containsKey(cat)) {
    return expenseMap[cat]!;
  }
  
  // Default colors
  if (kind == 'Income') return Colors.green;
  return const Color(0xFF582901); // Default brown for uncategorized expense

  }

  Widget _logDate(String date) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        date,
        style: const TextStyle(
          fontFamily: 'Questrial',
          fontSize: 16,
          color: Colors.black87,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _logCard(Map<String, dynamic> data) {
    final icon = _iconForCategory(data['category'] as String?, data['kind'] as String? ?? 'Expense');
    final color = _colorForCategory(data['category'] as String?, data['kind'] as String? ?? 'Expense');
    final amountStr = _formatAmount(data['amount'] as num, data['kind'] as String? ?? 'Expense');
    final note = (data['note'] as String?) ?? (data['label'] as String?) ?? '';
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 26),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(amountStr, style: const TextStyle(fontFamily: 'Questrial', fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold)),
                const SizedBox(height: 2),
                Text(note, style: const TextStyle(fontFamily: 'Questrial', fontSize: 14, color: Colors.white)),
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dateKeys = _grouped.keys.toList();
    final screenWidth = MediaQuery.of(context).size.width;
    final isLargeScreen = screenWidth > 600;

    return Scaffold(
      backgroundColor: bgCream,
      body: Column(
        children: [
          CommonHeader(
            goToDashboard: true,
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Your Logs", style: TextStyle(fontFamily: 'Modak', fontSize: 50, color: Colors.white)),
                      Text(
                        "Here you'll find all your logged\nexpenses and income!",
                        style: bodyStyle(14),
                      ),
                    ],
                  ),
                ),
                Image.asset(
                  'assets/images/dog.png',
                  width: 130,
                  height: 130,
                )
              ],
            ),
          ),

          // content area with max width constraint for large screens
          Expanded(
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: isLargeScreen ? 800 : double.infinity,
                ),
                child: RefreshIndicator(
                  onRefresh: _loadLogs,
                  child: _loading
                      ? const Center(child: CircularProgressIndicator())
                      : _error != null
                          ? ListView(
                              padding: EdgeInsets.symmetric(
                                horizontal: isLargeScreen ? 40 : 20,
                                vertical: 20,
                              ),
                              children: [
                                Text('Error loading logs: $_error', style: const TextStyle(color: Colors.red)),
                                const SizedBox(height: 12),
                                ElevatedButton(
                                  onPressed: _loadLogs,
                                  child: const Text('Retry'),
                                ),
                              ],
                            )
                          : dateKeys.isEmpty
                              ? ListView(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: isLargeScreen ? 40 : 20,
                                    vertical: 20,
                                  ),
                                  children: const [
                                    Center(
                                      child: Text(
                                        'No logs found.',
                                        style: TextStyle(
                                          fontFamily: 'Questrial',
                                          fontSize: 16,
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : ListView.builder(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: isLargeScreen ? 40 : 20,
                                    vertical: 20,
                                  ),
                                  itemCount: dateKeys.length + 1,
                                  itemBuilder: (context, index) {
                                    if (index >= dateKeys.length) {
                                      return const SizedBox(height: 30);
                                    }
                                    final dateKey = dateKeys[index];
                                    final items = _grouped[dateKey] ?? [];
                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        _logDate(dateKey),
                                        ...items.map((it) {
                                          return Padding(
                                            padding: const EdgeInsets.only(bottom: 10),
                                            child: _logCard(it),
                                          );
                                        }).toList(),
                                        const SizedBox(height: 18),
                                      ],
                                    );
                                  },
                                ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}