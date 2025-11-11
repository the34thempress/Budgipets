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
    final map = <String, IconData>{
      'Medical': Icons.medical_services,
      'Water': Icons.receipt_long,
      'Food': Icons.fastfood,
      'Transport': Icons.directions_bus,
      'Entertainment': Icons.star_rate,
      'Pet': Icons.pets,
      'Shopping': Icons.shopping_bag,
      'Salary': Icons.attach_money,
      'Uncategorized': Icons.more_horiz,
    };
    if (cat != null && map.containsKey(cat)) return map[cat]!;
    if (kind == 'Income') return Icons.attach_money;
    if (kind == 'Expense') return Icons.remove_circle;
    return Icons.more_horiz;
  }

  Color _colorForCategory(String? cat, String kind) {
    final map = <String, Color>{
      'Medical': const Color(0xFF8E0F18),
      'Water': const Color(0xFF3B7F55),
      'Food': const Color(0xFFD0538E),
      'Transport': const Color(0xFF4F2A09),
      'Entertainment': const Color(0xFFF6A12C),
      'Pet': const Color(0xFF4C6EF5),
      'Shopping': const Color(0xFF9A4D8E),
      'Salary': const Color(0xFFDB8F00),
      'Uncategorized': const Color(0xFF666666),
    };
    if (cat != null && map.containsKey(cat)) return map[cat]!;
    if (kind == 'Income') return const Color(0xFF2E8B57);
    return const Color(0xFF4F2A09);
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
                        "Here you’ll find all your logged\nexpenses and income!",
                        style: bodyStyle(14),
                      ),
                    ],
                  ),
                ),
                Image.asset(
                  'assets/images/pet.png',
                  width: 130,
                  height: 130,
                )
              ],
            ),
          ),

          // content area
          Expanded(
            child: RefreshIndicator(
              onRefresh: _loadLogs,
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : _error != null
                      ? ListView(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                          children: [
                            Text('Error loading logs: $_error', style: const TextStyle(color: Colors.red)),
                            const SizedBox(height: 12),
                            ElevatedButton(
                              onPressed: _loadLogs,
                              child: const Text('Retry'),
                            ),
                          ],
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                          itemCount: dateKeys.length + 1,
                          itemBuilder: (context, index) {
                            if (dateKeys.isEmpty) {
                              return const Center(child: Text('No logs found.'));
                            }
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
        ],
      ),
    );
  }
}
