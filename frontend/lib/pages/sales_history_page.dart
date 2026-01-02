import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import '../widgets/primary_button.dart';
import '../services/api_service.dart';
import '../l10n/app_localizations.dart';

void _debugLog(String location, String message, Map<String, dynamic> data, String hypothesisId) {
  try {
    final logEntry = {
      'location': location,
      'message': message,
      'data': data,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'sessionId': 'debug-session',
      'runId': 'run1',
      'hypothesisId': hypothesisId,
    };
    final logPath = r'c:\Users\wailo\Desktop\project\.cursor\debug.log';
    final file = File(logPath);
    file.writeAsStringSync('${jsonEncode(logEntry)}\n', mode: FileMode.append);
  } catch (e) {}
}
>>>>>>> Stashed changes

class SalesHistoryPage extends StatefulWidget {
  const SalesHistoryPage({super.key});

  @override
  State<SalesHistoryPage> createState() => _SalesHistoryPageState();
}

class _SalesHistoryPageState extends State<SalesHistoryPage> {
  final _searchController = TextEditingController();
  final _dateController = TextEditingController();
  String? _selectedPaymentMethod;
  String? _selectedCashier;

<<<<<<< Updated upstream
  final List<Map<String, dynamic>> _transactions = [
    {'id': 'TRX001', 'dateTime': '2025-11-16 09:15', 'items': 3, 'total': 15.47, 'payment': 'Cash', 'cashier': 'John Doe', 'status': 'completed'},
    {'id': 'TRX002', 'dateTime': '2025-11-16 09:30', 'items': 5, 'total': 28.95, 'payment': 'Card', 'cashier': 'John Doe', 'status': 'completed'},
  ];
=======
  List<Map<String, dynamic>> _transactions = [];
  bool _isLoading = false;
  bool _hasMore = true;
  int _currentPage = 1;
  final int _limit = 10;
  int _totalTransactions = 0;

  @override
  void initState() {
    super.initState();
    // #region agent log
    _debugLog('sales_history_page.dart:29', 'initState entry', {'selectedPaymentMethod': _selectedPaymentMethod, 'selectedCashier': _selectedCashier}, 'B');
    // #endregion
    _loadTransactions();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // #region agent log
    _debugLog('sales_history_page.dart:35', 'didChangeDependencies entry', {'hasContext': context != null, 'selectedPaymentMethod': _selectedPaymentMethod, 'selectedCashier': _selectedCashier}, 'B');
    // #endregion
    try {
      final localizations = AppLocalizations.of(context)!;
      // #region agent log
      _debugLog('sales_history_page.dart:40', 'localizations obtained', {'allMethods': localizations.allMethods, 'allCashiers': localizations.allCashiers}, 'A');
      // #endregion
      _selectedPaymentMethod ??= localizations.allMethods;
      _selectedCashier ??= localizations.allCashiers;
      // #region agent log
      _debugLog('sales_history_page.dart:44', 'dropdowns initialized', {'selectedPaymentMethod': _selectedPaymentMethod, 'selectedCashier': _selectedCashier}, 'B');
      // #endregion
    } catch (e) {
      // #region agent log
      _debugLog('sales_history_page.dart:48', 'localization error', {'error': e.toString()}, 'A');
      // #endregion
      rethrow;
    }
  }

  void dispose() {
    _searchController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  /// HELPER: Safely parse any dynamic value into double
  double parseDouble(dynamic value) {
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  List<Map<String, dynamic>> get _filteredTransactions {
    // #region agent log
    _debugLog('sales_history_page.dart:56', '_filteredTransactions called', {'selectedPaymentMethod': _selectedPaymentMethod, 'selectedCashier': _selectedCashier, 'hasContext': context != null}, 'B');
    // #endregion
    return _transactions.where((transaction) {
      final bool matchesSearch = _searchController.text.isEmpty ||
          transaction['transaction_id']
              .toString()
              .contains(_searchController.text);

      final bool matchesDate = _dateController.text.isEmpty ||
          (transaction['transaction_date'] != null &&
              transaction['transaction_date']
                  .toString()
                  .toLowerCase()
                  .contains(_dateController.text.toLowerCase()));

      try {
        final localizations = AppLocalizations.of(context)!;
        // #region agent log
        _debugLog('sales_history_page.dart:73', 'localizations in filter', {'selectedPaymentMethod': _selectedPaymentMethod, 'selectedCashier': _selectedCashier}, 'A');
        // #endregion
        final bool matchesPayment = (_selectedPaymentMethod == null || _selectedPaymentMethod == localizations.allMethods) ||
            (transaction['payment_method'] != null &&
                transaction['payment_method'].toString().toLowerCase() ==
                    _selectedPaymentMethod!.toLowerCase());

        final bool matchesCashier = (_selectedCashier == null || _selectedCashier == localizations.allCashiers) ||
            (transaction['worker_name'] != null &&
                transaction['worker_name']
                    .toString()
                    .toLowerCase()
                    .contains(_selectedCashier!.toLowerCase()));

        return matchesSearch && matchesDate && matchesPayment && matchesCashier;
      } catch (e) {
        // #region agent log
        _debugLog('sales_history_page.dart:87', 'filter error', {'error': e.toString()}, 'A');
        // #endregion
        return matchesSearch && matchesDate;
      }
    }).toList();
  }

  String _formatDateToDDMMYYYY(String datetime) {
    try {
      String datePart = datetime.split(' ')[0].split('T')[0];
      final parts = datePart.split('-');
      if (parts.length == 3) {
        final year = parts[0];
        final month = parts[1];
        final day = parts[2];
        return '$day-$month-$year';
      }
      return datetime;
    } catch (e) {
      print('Error formatting date: $datetime, error: $e');
      return datetime;
    }
  }

  List<String> get _cashierOptions {
    final cashiers = _transactions
        .map((t) => t['worker_name']?.toString() ?? '')
        .where((name) => name.isNotEmpty)
        .toSet()
        .toList();
    cashiers.sort();
    final localizations = AppLocalizations.of(context)!;
    return [localizations.allCashiers, ...cashiers];
  }

  Future<void> _loadTransactions({bool loadMore = false}) async {
    // #region agent log
    _debugLog('sales_history_page.dart:130', '_loadTransactions entry', {'loadMore': loadMore, 'isLoading': _isLoading}, 'C');
    // #endregion
    if (_isLoading) return;
    setState(() => _isLoading = true);

    try {
      final page = loadMore ? _currentPage + 1 : 1;
      // #region agent log
      _debugLog('sales_history_page.dart:137', 'calling API', {'page': page, 'limit': _limit}, 'C');
      // #endregion
      final response =
          await ApiService.getTransactions(page: page, limit: _limit);
      // #region agent log
      _debugLog('sales_history_page.dart:141', 'API response received', {'hasTransactions': response['transactions'] != null, 'transactionsCount': (response['transactions'] ?? []).length, 'total': response['total'] ?? 0}, 'C');
      // #endregion
      final List<dynamic> transactions = response['transactions'] ?? [];
      final int total = response['total'] ?? 0;

      setState(() {
        if (loadMore) {
          _transactions.addAll(transactions.cast<Map<String, dynamic>>());
          _currentPage = page;
        } else {
          _transactions = transactions.cast<Map<String, dynamic>>();
          _currentPage = 1;
        }
        _totalTransactions = total;
        _hasMore = _transactions.length < total;
        _isLoading = false;
      });
    } catch (e) {
      // #region agent log
      _debugLog('sales_history_page.dart:158', 'API error', {'error': e.toString(), 'errorType': e.runtimeType.toString()}, 'C');
      // #endregion
      setState(() => _isLoading = false);
      if (mounted) {
        try {
          final localizations = AppLocalizations.of(context)!;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('${localizations.errorLoadingTransactions} $e'),
                backgroundColor: Colors.red),
          );
        } catch (e2) {
          // #region agent log
          _debugLog('sales_history_page.dart:169', 'localization error in error handler', {'error': e2.toString()}, 'A');
          // #endregion
        }
      }
    }
  }
>>>>>>> Stashed changes

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildHeader(),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                _buildFilters(),
                const SizedBox(height: 24),
                _buildSummaryCards(),
                const SizedBox(height: 24),
<<<<<<< Updated upstream
                _buildTransactionsTable(),
=======
                _isLoading && _transactions.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : _buildTransactionsTable(),
                if (_hasMore && !_isLoading) ...[
                  const SizedBox(height: 16),
                  PrimaryButton(
                    onPressed: () => _loadTransactions(loadMore: true),
                    child: Text(AppLocalizations.of(context)!.loadMore),
                  ),
                ],
                if (_isLoading && _transactions.isNotEmpty)
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(),
                  ),
>>>>>>> Stashed changes
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    final localizations = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
<<<<<<< Updated upstream
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Sales History', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600, color: Color(0xFFB87653))),
              const SizedBox(height: 4),
              Text('View and manage all transactions', style: TextStyle(fontSize: 14, color: Colors.grey[600])),
            ],
          ),
          PrimaryButton(
            onPressed: () {},
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.download, size: 18),
                SizedBox(width: 8),
                Text('Export Report'),
              ],
            ),
          ),
=======
          Text(localizations.salesHistoryTitle,
              style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFB87653))),
          const SizedBox(height: 4),
          Text(localizations.salesHistorySubtitle,
              style: TextStyle(fontSize: 14, color: Colors.grey[600])),
>>>>>>> Stashed changes
        ],
      ),
    );
  }

  Widget _buildFilters() {
    final localizations = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
<<<<<<< Updated upstream
          Text('Filters', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.grey[800])),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(child: _buildTextField('Search Transaction', _searchController, 'Transaction ID...', Icons.search)),
              const SizedBox(width: 16),
              Expanded(child: _buildTextField('Date', _dateController, 'mm/dd/yyyy', null)),
              const SizedBox(width: 16),
              Expanded(child: _buildDropdown('Payment Method', _selectedPaymentMethod, ['All Methods', 'Cash', 'Card', 'Mobile Payment'], (v) => setState(() => _selectedPaymentMethod = v!))),
              const SizedBox(width: 16),
              Expanded(child: _buildDropdown('Cashier', _selectedCashier, ['All Cashiers', 'John Doe', 'Jane Smith'], (v) => setState(() => _selectedCashier = v!), highlight: true)),
=======
          Text(localizations.filters,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800])),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                  child: _buildTextField(localizations.searchTransaction,
                      _searchController, localizations.transactionIdPlaceholder, Icons.search,
                      onChanged: (v) => setState(() {}))),
              const SizedBox(width: 16),
              Expanded(
                  child: _buildTextField(
                      localizations.date, _dateController, localizations.datePlaceholder, null,
                      onChanged: (v) => setState(() {}))),
              const SizedBox(width: 16),
              Expanded(
                  child: _buildDropdown(
                      localizations.paymentMethod,
                      _selectedPaymentMethod ?? localizations.allMethods,
                      [localizations.allMethods, localizations.cash, localizations.card, localizations.mobilePayment],
                      (v) => setState(() => _selectedPaymentMethod = v!))),
              const SizedBox(width: 16),
              Expanded(
                  child: _buildDropdown(
                      localizations.cashier,
                      _selectedCashier ?? localizations.allCashiers,
                      _cashierOptions,
                      (v) => setState(() => _selectedCashier = v!),
                      highlight: true)),
>>>>>>> Stashed changes
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, String hint, IconData? icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 13, color: Colors.grey[700])),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[400]),
            prefixIcon: icon != null ? Icon(icon, color: Colors.grey[400]) : null,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey[300]!)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey[300]!)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.blue)),
            contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown(String label, String value, List<String> items, Function(String?) onChanged, {bool highlight = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 13, color: Colors.grey[700])),
        const SizedBox(height: 8),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            border: Border.all(color: highlight ? Colors.blue : Colors.grey[300]!, width: highlight ? 2 : 1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButton<String>(
            value: value,
            isExpanded: true,
            underline: SizedBox(),
            items: items.map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCards() {
<<<<<<< Updated upstream
    return Row(
      children: [
        Expanded(child: _SummaryCard(title: 'Total Transactions', value: '8')),
        const SizedBox(width: 16),
        Expanded(child: _SummaryCard(title: 'Total Sales', value: '\$166.60')),
        const SizedBox(width: 16),
        Expanded(child: _SummaryCard(title: 'Average Transaction', value: '\$20.82', valueColor: Color(0xFFB87653))),
=======
    final localizations = AppLocalizations.of(context)!;
    final totalSales = _transactions.fold<double>(0, (sum, txn) {
      return sum + parseDouble(txn['total_amount']);
    });
    final avgTransaction =
        _transactions.isNotEmpty ? totalSales / _transactions.length : 0.0;

    return Row(
      children: [
        Expanded(
            child: _SummaryCard(
                title: localizations.totalTransactions, value: '$_totalTransactions')),
        const SizedBox(width: 16),
        Expanded(
            child: _SummaryCard(
                title: localizations.totalSales,
                value: '${totalSales.toStringAsFixed(2)} DA')),
        const SizedBox(width: 16),
        Expanded(
            child: _SummaryCard(
                title: localizations.averageTransaction,
                value: '${avgTransaction.toStringAsFixed(2)} DA',
                valueColor: Color(0xFFB87653))),
>>>>>>> Stashed changes
      ],
    );
  }

  Widget _buildTransactionsTable() {
<<<<<<< Updated upstream
=======
    final localizations = AppLocalizations.of(context)!;
    if (_filteredTransactions.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(48),
        decoration: _cardDecoration(),
        child: Center(
          child: Text(localizations.noTransactionsFound,
              style: TextStyle(fontSize: 16, color: Colors.grey[600])),
        ),
      );
    }

>>>>>>> Stashed changes
    return Container(
      decoration: _cardDecoration(),
      child: Column(
        children: [
          _buildTableHeader(),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: _transactions.length,
            itemBuilder: (context, index) => _buildTableRow(_transactions[index], index),
          ),
        ],
      ),
    );
  }

  Widget _buildTableHeader() {
<<<<<<< Updated upstream
    final headers = ['Transaction ID', 'Date & Time', 'Items', 'Total', 'Payment', 'Cashier', 'Status', 'Actions'];
    final flex = [1, 2, 1, 1, 1, 1, 1, 0];
    
=======
    final localizations = AppLocalizations.of(context)!;
    final headers = [
      localizations.transactionId,
      localizations.dateTime,
      localizations.total,
      localizations.payment,
      localizations.cashier,
      localizations.actions
    ];
    final flex = [1, 2, 1, 1, 1, 0];

>>>>>>> Stashed changes
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey[200]!))),
      child: Row(
        children: List.generate(headers.length, (i) => 
          i == 7 
            ? SizedBox(width: 100, child: Text(headers[i], style: _headerStyle()))
            : Expanded(flex: flex[i], child: Text(headers[i], style: _headerStyle()))
        ),
      ),
    );
  }

  Widget _buildTableRow(Map<String, dynamic> txn, int index) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey[100]!))),
      child: Row(
        children: [
          Expanded(flex: 1, child: Text(txn['id'], style: _cellStyle())),
          Expanded(flex: 2, child: Text(txn['dateTime'], style: _cellStyle())),
          Expanded(flex: 1, child: Text(txn['items'].toString(), style: _cellStyle())),
          Expanded(flex: 1, child: Text('\$${txn['total'].toStringAsFixed(2)}', style: _cellStyle())),
          Expanded(flex: 1, child: Text(txn['payment'], style: _cellStyle())),
          Expanded(flex: 1, child: Text(txn['cashier'], style: _cellStyle())),
          Expanded(flex: 1, child: _buildStatusBadge(txn['status'])),
          SizedBox(width: 100, child: _buildActions(txn, index)),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(color: Color(0xFFD4F4DD), borderRadius: BorderRadius.circular(12)),
      child: Text(status, style: TextStyle(fontSize: 12, color: Color(0xFF198754)), textAlign: TextAlign.center),
    );
  }

  Widget _buildActions(Map<String, dynamic> txn, int index) {
    return Row(
      children: [
        _iconButton(Icons.visibility_outlined, Colors.grey[600]!, () => _showViewDialog(context, txn)),
        const SizedBox(width: 12),
        _iconButton(Icons.edit_outlined, Colors.blue, () => _showEditDialog(context, txn, index)),
        const SizedBox(width: 12),
        _iconButton(Icons.cancel_outlined, Colors.red, () => _showCancelDialog(context, txn, index)),
      ],
    );
  }

  Widget _iconButton(IconData icon, Color color, VoidCallback onPressed) {
    return IconButton(icon: Icon(icon, size: 20), onPressed: onPressed, color: color, padding: EdgeInsets.zero, constraints: BoxConstraints());
  }

  void _showViewDialog(BuildContext context, Map<String, dynamic> txn) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          width: 500,
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _dialogHeader('Transaction Details'),
              Divider(height: 32),
              ...[
                ('Transaction ID:', txn['id']),
                ('Date & Time:', txn['dateTime']),
                ('Number of Items:', txn['items'].toString()),
                ('Total Amount:', '\$${txn['total'].toStringAsFixed(2)}'),
                ('Payment Method:', txn['payment']),
                ('Cashier:', txn['cashier']),
                ('Status:', txn['status']),
              ].map((e) => _detailRow(e.$1, e.$2)),
              SizedBox(height: 24),
              Text('Items Purchased:', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey[700])),
              SizedBox(height: 12),
              _buildItemsList(txn['items']),
              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  PrimaryButton(onPressed: () => Navigator.pop(context), variant: ButtonVariant.secondary, child: const Text('Close')),
                  const SizedBox(width: 12),
                  PrimaryButton(
                    onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Receipt printed successfully'))),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.print, size: 18),
                        SizedBox(width: 8),
                        Text('Print Receipt'),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

<<<<<<< Updated upstream
  void _showEditDialog(BuildContext context, Map<String, dynamic> txn, int index) {
    final itemsCtrl = TextEditingController(text: txn['items'].toString());
    final totalCtrl = TextEditingController(text: txn['total'].toString());
    String payment = txn['payment'], cashier = txn['cashier'];

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
=======
      final localizations = AppLocalizations.of(context)!;
      showDialog(
        context: context,
        builder: (context) => Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
>>>>>>> Stashed changes
          child: Container(
            width: 500,
            padding: EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
<<<<<<< Updated upstream
                _dialogHeader('Edit Transaction'),
                Divider(height: 32),
                Text('Transaction ID: ${txn['id']}', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey[700])),
                SizedBox(height: 24),
                _editField('Number of Items', itemsCtrl, TextInputType.number),
                SizedBox(height: 16),
                _editField('Total Amount', totalCtrl, TextInputType.numberWithOptions(decimal: true), prefix: '\$ '),
                SizedBox(height: 16),
                _buildDropdown('Payment Method', payment, ['Cash', 'Card', 'Mobile Payment'], (v) => setDialogState(() => payment = v!)),
                SizedBox(height: 16),
                _buildDropdown('Cashier', cashier, ['John Doe', 'Jane Smith', 'Mike Johnson'], (v) => setDialogState(() => cashier = v!)),
=======
                _dialogHeader(localizations.transactionDetails),
                Divider(height: 32),
                ...[
                  (
                    '${localizations.transactionId}:',
                    details['transaction_id']?.toString() ?? 'N/A'
                  ),
                  (
                    '${localizations.dateTime}:',
                    details['transaction_date']?.toString() ?? 'N/A'
                  ),
                  (
                    localizations.totalAmount,
                    '${parseDouble(details['total_amount']).toStringAsFixed(2)} DA'
                  ),
                  ('${localizations.paymentMethodLabel}', details['payment_method'] ?? 'N/A'),
                  ('${localizations.cashierLabel}', details['worker_name'] ?? 'N/A'),
                ].map((e) => _detailRow(e.$1, e.$2)),
                SizedBox(height: 24),
                Text(localizations.itemsPurchased,
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[700])),
                SizedBox(height: 12),
                _buildItemsList(details['items'] ?? []),
>>>>>>> Stashed changes
                SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    PrimaryButton(onPressed: () => Navigator.pop(context), variant: ButtonVariant.secondary, child: const Text('Cancel')),
                    const SizedBox(width: 12),
                    PrimaryButton(
<<<<<<< Updated upstream
                      onPressed: () {
                        setState(() {
                          _transactions[index].addAll({'items': int.parse(itemsCtrl.text), 'total': double.parse(totalCtrl.text), 'payment': payment, 'cashier': cashier});
                        });
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Transaction updated successfully')));
                      },
                      child: const Text('Save Changes'),
                    ),
=======
                        onPressed: () => Navigator.pop(context),
                        variant: ButtonVariant.secondary,
                        child: Text(localizations.close)),
>>>>>>> Stashed changes
                  ],
                ),
              ],
            ),
          ),
        ),
<<<<<<< Updated upstream
      ),
    );
  }

  void _showCancelDialog(BuildContext context, Map<String, dynamic> txn, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Row(children: [Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 28), SizedBox(width: 12), Text('Cancel Transaction', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600))]),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Are you sure you want to cancel this transaction?', style: TextStyle(fontSize: 15)),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey[200]!)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Transaction ID: ${txn['id']}', style: TextStyle(fontWeight: FontWeight.w500)),
                  SizedBox(height: 4),
                  Text('Total: \$${txn['total'].toStringAsFixed(2)}'),
                  SizedBox(height: 4),
                  Text('Date: ${txn['dateTime']}'),
                ],
              ),
            ),
            SizedBox(height: 16),
            Text('This action cannot be undone. The inventory will be restored.', style: TextStyle(fontSize: 13, color: Colors.red[700])),
          ],
        ),
        actions: [
          PrimaryButton(onPressed: () => Navigator.pop(context), variant: ButtonVariant.secondary, child: const Text('Keep Transaction')),
          PrimaryButton(
            onPressed: () {
              setState(() => _transactions[index]['status'] = 'cancelled');
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Transaction cancelled successfully'), backgroundColor: Colors.red));
            },
            variant: ButtonVariant.danger,
            child: const Text('Cancel Transaction'),
          ),
        ],
      ),
    );
=======
      );
    } catch (e) {
      if (mounted) {
        final localizations = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('${localizations.errorLoadingDetails} $e'),
              backgroundColor: Colors.red),
        );
      }
    }
>>>>>>> Stashed changes
  }

  Widget _dialogHeader(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Color(0xFFB87653))),
        IconButton(icon: Icon(Icons.close), onPressed: () => Navigator.pop(context), padding: EdgeInsets.zero, constraints: BoxConstraints()),
      ],
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 140, child: Text(label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey[600]))),
          Expanded(child: Text(value, style: TextStyle(fontSize: 14, color: Colors.grey[800]))),
        ],
      ),
    );
  }

<<<<<<< Updated upstream
  Widget _buildItemsList(int itemCount) {
    final items = [('Coca Cola 500ml', 2, 3.99), ('Lays Chips', 1, 2.49), if (itemCount > 2) ('Milk 1L', 2, 2.50)];
=======
  Widget _buildItemsList(List<dynamic> items) {
    final localizations = AppLocalizations.of(context)!;
    if (items.isEmpty) {
      return Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[200]!)),
        child:
            Text(localizations.noItemsFound, style: TextStyle(color: Colors.grey[600])),
      );
    }

>>>>>>> Stashed changes
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey[200]!)),
      child: Column(
        children: List.generate(
          items.length * 2 - 1,
          (i) => i.isEven ? _itemRow(items[i ~/ 2].$1, items[i ~/ 2].$2, items[i ~/ 2].$3) : Divider(height: 16),
        ),
      ),
    );
  }

  Widget _itemRow(String name, int qty, double price) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: Text(name, style: TextStyle(fontSize: 14, color: Colors.grey[800]))),
        Text('x$qty', style: TextStyle(fontSize: 14, color: Colors.grey[600])),
        SizedBox(width: 24),
        Text('\$${(price * qty).toStringAsFixed(2)}', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey[800])),
      ],
    );
  }

  Widget _editField(String label, TextEditingController ctrl, TextInputType type, {String? prefix}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 13, color: Colors.grey[700])),
        SizedBox(height: 8),
        TextField(
          controller: ctrl,
          keyboardType: type,
          decoration: InputDecoration(
            prefixText: prefix,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ],
    );
  }

  BoxDecoration _cardDecoration() => BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: Offset(0, 2))]);
  TextStyle _headerStyle() => TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.grey[700]);
  TextStyle _cellStyle() => TextStyle(fontSize: 14, color: Colors.grey[800]);
}

class _SummaryCard extends StatelessWidget {
  final String title, value;
  final Color? valueColor;

  const _SummaryCard({required this.title, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: Offset(0, 2))]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
          const SizedBox(height: 8),
          Text(value, style: TextStyle(fontSize: 32, fontWeight: FontWeight.w600, color: valueColor ?? Colors.grey[800])),
        ],
      ),
    );
  }
}