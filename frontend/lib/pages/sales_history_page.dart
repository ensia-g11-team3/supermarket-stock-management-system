import 'package:flutter/material.dart';
import 'package:se_project/l10n/app_localizations.dart';
import '../widgets/primary_button.dart';
import '../services/api_service.dart';

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

  List<Map<String, dynamic>> _transactions = [];
  bool _isLoading = false;
  bool _hasMore = true;
  int _currentPage = 1;
  final int _limit = 10;
  int _totalTransactions = 0;

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  @override
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

      // map UI labels (localized) -> DB values
      final Map<String, String> paymentMethodMap = {
        AppLocalizations.of(context)!.cash: 'cash',
        AppLocalizations.of(context)!.card: 'card',
        'Cash': 'cash',
        'Card': 'card',
      };

      final bool matchesPayment = _selectedPaymentMethod == null ||
          _selectedPaymentMethod == 'All Methods' ||
          _selectedPaymentMethod == AppLocalizations.of(context)!.allMethods ||
          (transaction['payment_method'] != null &&
              transaction['payment_method'].toString().toLowerCase() ==
                  paymentMethodMap[_selectedPaymentMethod]?.toLowerCase());

      final bool matchesCashier = _selectedCashier == null ||
          _selectedCashier == 'All Cashiers' ||
          _selectedCashier == AppLocalizations.of(context)!.allCashiers ||
          (transaction['worker_name'] != null &&
              transaction['worker_name']
                  .toString()
                  .toLowerCase()
                  .contains(_selectedCashier!.toLowerCase()));

      return matchesSearch && matchesDate && matchesPayment && matchesCashier;
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
    return [AppLocalizations.of(context)!.allCashiers, ...cashiers];
  }

  Future<void> _loadTransactions({bool loadMore = false}) async {
    if (_isLoading) return;
    setState(() => _isLoading = true);

    try {
      final page = loadMore ? _currentPage + 1 : 1;
      final response =
          await ApiService.getTransactions(page: page, limit: _limit);

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
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Error loading transactions: $e'),
              backgroundColor: Colors.red),
        );
      }
    }
  }

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
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppLocalizations.of(context)!.salesHistory,
              style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFB87653))),
          const SizedBox(height: 4),
          Text(AppLocalizations.of(context)!.salesHistorySubtitle,
              style: TextStyle(fontSize: 14, color: Colors.grey[600])),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Filters',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800])),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                  child: _buildTextField(
                      AppLocalizations.of(context)!.searchTransaction,
                      _searchController,
                      AppLocalizations.of(context)!.transactionId + '...',
                      Icons.search,
                      onChanged: (v) => setState(() {}))),
              const SizedBox(width: 16),
              Expanded(
                  child: _buildTextField(AppLocalizations.of(context)!.date,
                      _dateController, 'e.g., 25, Dec, 2025...', null,
                      onChanged: (v) => setState(() {}))),
              const SizedBox(width: 16),
              Expanded(
                  child: _buildDropdown(
                      AppLocalizations.of(context)!.paymentMethod,
                      _selectedPaymentMethod,
                      [
                        AppLocalizations.of(context)!.allMethods,
                        AppLocalizations.of(context)!.cash,
                        AppLocalizations.of(context)!.card
                      ],
                      (v) => setState(() => _selectedPaymentMethod = v))),
              const SizedBox(width: 16),
              Expanded(
                  child: _buildDropdown(
                      AppLocalizations.of(context)!.cashier,
                      _selectedCashier,
                      _cashierOptions,
                      (v) => setState(() => _selectedCashier = v),
                      highlight: true)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      String hint, IconData? icon,
      {Function(String)? onChanged}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 13, color: Colors.grey[700])),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[400]),
            prefixIcon:
                icon != null ? Icon(icon, color: Colors.grey[400]) : null,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey[300]!)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey[300]!)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.blue)),
            contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown(String label, String? value, List<String> items,
      Function(String?) onChanged,
      {bool highlight = false}) {
    // Ensure value is either null or exists in items list
    final validValue = (value != null && items.contains(value)) ? value : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 13, color: Colors.grey[700])),
        const SizedBox(height: 8),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            border: Border.all(
                color: highlight ? Colors.blue : Colors.grey[300]!,
                width: highlight ? 2 : 1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButton<String>(
            value: validValue,
            isExpanded: true,
            underline: SizedBox(),
            hint: Text(items.isNotEmpty ? items[0] : ''),
            items: items
                .map((v) => DropdownMenuItem(value: v, child: Text(v)))
                .toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCards() {
    final totalSales = _transactions.fold<double>(0, (sum, txn) {
      return sum + parseDouble(txn['total_amount']);
    });
    final avgTransaction =
        _transactions.isNotEmpty ? totalSales / _transactions.length : 0.0;

    return Row(
      children: [
        Expanded(
            child: _SummaryCard(
                title: AppLocalizations.of(context)!.totalTransactions,
                value: '$_totalTransactions')),
        const SizedBox(width: 16),
        Expanded(
            child: _SummaryCard(
                title: AppLocalizations.of(context)!.totalSales,
                value: '${totalSales.toStringAsFixed(2)} DA')),
        const SizedBox(width: 16),
        Expanded(
            child: _SummaryCard(
                title: AppLocalizations.of(context)!.averageTransaction,
                value: '${avgTransaction.toStringAsFixed(2)} DA',
                valueColor: Color(0xFFB87653))),
      ],
    );
  }

  Widget _buildTransactionsTable() {
    if (_filteredTransactions.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(48),
        decoration: _cardDecoration(),
        child: Center(
          child: Text(AppLocalizations.of(context)!.noTransactionsFound,
              style: TextStyle(fontSize: 16, color: Colors.grey[600])),
        ),
      );
    }

    return Container(
      decoration: _cardDecoration(),
      child: Column(
        children: [
          _buildTableHeader(),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: _filteredTransactions.length,
            itemBuilder: (context, index) =>
                _buildTableRow(_filteredTransactions[index], index),
          ),
        ],
      ),
    );
  }

  Widget _buildTableHeader() {
    final headers = [
      AppLocalizations.of(context)!.tableTransactionId,
      AppLocalizations.of(context)!.tableDateTime,
      AppLocalizations.of(context)!.tableTotal,
      AppLocalizations.of(context)!.tablePayment,
      AppLocalizations.of(context)!.tableCashier,
      AppLocalizations.of(context)!.tableActions
    ];
    final flex = [1, 2, 1, 1, 1, 0];

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey[200]!))),
      child: Row(
        children: List.generate(
            headers.length,
            (i) => i == 5
                ? SizedBox(
                    width: 80, child: Text(headers[i], style: _headerStyle()))
                : Expanded(
                    flex: flex[i],
                    child: Text(headers[i], style: _headerStyle()))),
      ),
    );
  }

  Widget _buildTableRow(Map<String, dynamic> txn, int index) {
    final transactionId = txn['transaction_id']?.toString() ??
        AppLocalizations.of(context)!.notAvailable;
    final dateTime = txn['transaction_date']?.toString() ??
        AppLocalizations.of(context)!.notAvailable;
    final totalAmount = parseDouble(txn['total_amount']);
    var payment = '';
    if (txn['payment_method'] == 'card') {
      payment = AppLocalizations.of(context)!.card;
    } else if (txn['payment_method'] == 'cash') {
      payment = AppLocalizations.of(context)!.cash;
    } else {
      payment = AppLocalizations.of(context)!.notAvailable;
    }
    final cashier =
        txn['worker_name'] ?? AppLocalizations.of(context)!.notAvailable;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey[100]!))),
      child: Row(
        children: [
          Expanded(flex: 1, child: Text(transactionId, style: _cellStyle())),
          Expanded(flex: 2, child: Text(dateTime, style: _cellStyle())),
          Expanded(
              flex: 1,
              child: Text('${totalAmount.toStringAsFixed(2)} DA',
                  style: _cellStyle())),
          Expanded(flex: 1, child: Text(payment, style: _cellStyle())),
          Expanded(flex: 1, child: Text(cashier, style: _cellStyle())),
          SizedBox(width: 80, child: _buildActions(txn)),
        ],
      ),
    );
  }

  Widget _buildActions(Map<String, dynamic> txn) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _iconButton(Icons.visibility_outlined, Colors.grey[600]!,
            () => _showViewDialog(context, txn)),
      ],
    );
  }

  Widget _iconButton(IconData icon, Color color, VoidCallback onPressed) {
    return IconButton(
        icon: Icon(icon, size: 20),
        onPressed: onPressed,
        color: color,
        padding: EdgeInsets.zero,
        constraints: BoxConstraints());
  }

  void _showViewDialog(BuildContext context, Map<String, dynamic> txn) async {
    try {
      final transactionId = txn['transaction_id'];
      final details = await ApiService.getTransactionDetails(transactionId);
      if (!mounted) return;

      showDialog(
        context: context,
        builder: (context) => Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Container(
            width: 500,
            padding: EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _dialogHeader(AppLocalizations.of(context)!.transactionDetails),
                Divider(height: 32),
                ...[
                  (
                    AppLocalizations.of(context)!.transactionId,
                    details['transaction_id']?.toString() ??
                        AppLocalizations.of(context)!.notAvailable
                  ),
                  (
                    AppLocalizations.of(context)!.tableDateTime,
                    details['transaction_date']?.toString() ??
                        AppLocalizations.of(context)!.notAvailable
                  ),
                  (
                    AppLocalizations.of(context)!.totalAmount,
                    '${AppLocalizations.of(context)!.totalAmount}: ${parseDouble(details['total_amount']).toStringAsFixed(2)} DA'
                  ),
                  (
                    AppLocalizations.of(context)!.paymentMethod,
                    details['payment_method'] ??
                        AppLocalizations.of(context)!.notAvailable
                  ),
                  (
                    AppLocalizations.of(context)!.cashier,
                    details['worker_name'] ??
                        AppLocalizations.of(context)!.notAvailable
                  ),
                ].map((e) => _detailRow(e.$1, e.$2)),
                SizedBox(height: 24),
                Text(AppLocalizations.of(context)!.itemsPurchased,
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[700])),
                SizedBox(height: 12),
                _buildItemsList(details['items'] ?? []),
                SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    PrimaryButton(
                        onPressed: () => Navigator.pop(context),
                        variant: ButtonVariant.secondary,
                        child: Text(AppLocalizations.of(context)!.close)),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  AppLocalizations.of(context)!.errorLoadingDetails + ' $e'),
              backgroundColor: Colors.red),
        );
      }
    }
  }

  Widget _dialogHeader(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Color(0xFFB87653))),
        IconButton(
            icon: Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
            padding: EdgeInsets.zero,
            constraints: BoxConstraints()),
      ],
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
              width: 140,
              child: Text(label,
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[600]))),
          Expanded(
              child: Text(value,
                  style: TextStyle(fontSize: 14, color: Colors.grey[800]))),
        ],
      ),
    );
  }

  Widget _buildItemsList(List<dynamic> items) {
    if (items.isEmpty) {
      return Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[200]!)),
        child:
            Text('No items found', style: TextStyle(color: Colors.grey[600])),
      );
    }

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[200]!)),
      child: Column(
        children: List.generate(
          items.length * 2 - 1,
          (i) => i.isEven
              ? _itemRow(
                  items[i ~/ 2]['product_name'] ??
                      AppLocalizations.of(context)!.unknown,
                  items[i ~/ 2]['quantity'] ?? 0,
                  parseDouble(items[i ~/ 2]['selling_price']),
                )
              : Divider(height: 16),
        ),
      ),
    );
  }

  Widget _itemRow(String name, int qty, double price) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
            child: Text(name,
                style: TextStyle(fontSize: 14, color: Colors.grey[800]))),
        Text('x$qty', style: TextStyle(fontSize: 14, color: Colors.grey[600])),
        SizedBox(width: 24),
        Text('${(price * qty).toStringAsFixed(2)} DA',
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey[800])),
      ],
    );
  }

  BoxDecoration _cardDecoration() => BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: Offset(0, 2))
          ]);

  TextStyle _headerStyle() => TextStyle(
      fontSize: 13, fontWeight: FontWeight.w600, color: Colors.grey[700]);

  TextStyle _cellStyle() => TextStyle(fontSize: 14, color: Colors.grey[800]);
}

class _SummaryCard extends StatelessWidget {
  final String title, value;
  final Color? valueColor;

  const _SummaryCard(
      {required this.title, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: Offset(0, 2))
          ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
          const SizedBox(height: 8),
          Text(value,
              style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w600,
                  color: valueColor ?? Colors.grey[800])),
        ],
      ),
    );
  }
}
