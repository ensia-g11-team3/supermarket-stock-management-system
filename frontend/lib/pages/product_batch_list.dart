import 'package:flutter/material.dart';
import 'package:se_project/l10n/app_localizations.dart';
import '../widgets/page_header.dart';
import '../widgets/primary_button.dart';
import '../theme/app_theme.dart';
import '../services/batch_api.dart';

class ProductBatchListPage extends StatefulWidget {
  final String productId;
  final String productName;
  final VoidCallback? onNavigateBack;
  final Function(String batchId)? onNavigateToEdit;
  final VoidCallback? onNavigateToCreate;

  const ProductBatchListPage({
    super.key,
    required this.productId,
    required this.productName,
    this.onNavigateBack,
    this.onNavigateToEdit,
    this.onNavigateToCreate,
  });

  @override
  State<ProductBatchListPage> createState() => _ProductBatchListPageState();
}

class _ProductBatchListPageState extends State<ProductBatchListPage> {
  List<Map<String, dynamic>> _batches = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchBatches();
  }

  Future<void> _fetchBatches() async {
    setState(() => _isLoading = true);
    try {
      final batches =
          await BatchApi.getBatchesByProduct(int.parse(widget.productId));
      print("Fetched ${batches.length} batches"); // Debug print
      print("Batch data: $batches"); // Debug print
      setState(() {
        _batches = batches;
        _isLoading = false;
      });
    } catch (e) {
      print("Error loading batches: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(AppLocalizations.of(context)!.loadError + ' $e')),
        );
      }
      setState(() => _isLoading = false);
    }
  }

  String _formatDate(dynamic date) {
    if (date == null) return AppLocalizations.of(context)!.na;
    try {
      // Handle both string and DateTime
      if (date is String) {
        // If it's already a date string, return it
        return date;
      }
      return date.toString();
    } catch (e) {
      return 'N/A';
    }
  }

  String _getExpiryStatus(dynamic expiryDate) {
    if (expiryDate == null) return 'no_expiry';

    try {
      String dateStr = expiryDate.toString();
      final expiry = DateTime.parse(dateStr);
      final now = DateTime.now();
      final daysUntilExpiry = expiry.difference(now).inDays;

      if (daysUntilExpiry < 0) return 'expired';
      if (daysUntilExpiry <= 30) return 'near_expiry';
      return 'normal';
    } catch (e) {
      print("Error parsing expiry date: $e");
      return 'no_expiry';
    }
  }

  Color _getExpiryColor(String status) {
    switch (status) {
      case 'expired':
        return Colors.red;
      case 'near_expiry':
        return Colors.orange;
      case 'normal':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  String _getExpiryLabel(String status, dynamic expiryDate) {
    if (expiryDate == null) return AppLocalizations.of(context)!.noExpiry;

    switch (status) {
      case 'expired':
        return 'Expired';
      case 'near_expiry':
        try {
          final daysLeft = DateTime.parse(expiryDate.toString())
              .difference(DateTime.now())
              .inDays;
          return AppLocalizations.of(context)!.expiresIn +
              ' $daysLeft ' +
              AppLocalizations.of(context)!.days;
        } catch (e) {
          return 'Near Expiry';
        }
      case 'normal':
        return AppLocalizations.of(context)!.valid;
      default:
        return AppLocalizations.of(context)!.unknown;
    }
  }

  void _deleteBatch(int batchId, String batchName) async {
    try {
      await BatchApi.deleteBatch(batchId);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  '$batchName ' + AppLocalizations.of(context)!.deleteSuccess)),
        );
        _fetchBatches(); // Refresh list
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(AppLocalizations.of(context)!.deleteError + ' $e'),
              backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final totalQuantity = _batches.fold<int>(
        0, (sum, b) => sum + ((b['quantity'] as num?)?.toInt() ?? 0));
    final expiredCount = _batches
        .where((b) => _getExpiryStatus(b['expiry_date']) == 'expired')
        .length;
    final nearExpiryCount = _batches
        .where((b) => _getExpiryStatus(b['expiry_date']) == 'near_expiry')
        .length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PageHeader(
          title: AppLocalizations.of(context)!.productBatchesTitle +
              ' - ${widget.productName}',
          description: AppLocalizations.of(context)!.manageBatchesDescription,
          actions: [
            TextButton.icon(
              onPressed: widget.onNavigateBack,
              icon: const Icon(Icons.arrow_back),
              label: Text(AppLocalizations.of(context)!.backToProducts),
            ),
            const SizedBox(width: 12),
            PrimaryButton(
              onPressed: widget.onNavigateToCreate,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add, size: 20),
                  SizedBox(width: 8),
                  Text(AppLocalizations.of(context)!.createNewBatch),
                ],
              ),
            ),
          ],
        ),
        Expanded(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(32),
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 1400),
                    child: Card(
                      child: Column(
                        children: [
                          // Summary Section
                          Container(
                            padding: const EdgeInsets.all(24),
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(color: AppTheme.borderColor),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _buildSummaryCard(
                                  AppLocalizations.of(context)!.totalBatches,
                                  _batches.length.toString(),
                                  Icons.inventory_2,
                                  Colors.blue,
                                ),
                                _buildSummaryCard(
                                  AppLocalizations.of(context)!.totalQuantity,
                                  totalQuantity.toString(),
                                  Icons.warehouse,
                                  Colors.green,
                                ),
                                _buildSummaryCard(
                                  AppLocalizations.of(context)!.expired,
                                  expiredCount.toString(),
                                  Icons.warning,
                                  Colors.red,
                                ),
                                _buildSummaryCard(
                                  AppLocalizations.of(context)!.nearExpiry,
                                  nearExpiryCount.toString(),
                                  Icons.access_time,
                                  Colors.orange,
                                ),
                              ],
                            ),
                          ),
                          // Batch Table
                          _batches.isEmpty
                              ? Padding(
                                  padding: const EdgeInsets.all(48.0),
                                  child: Column(
                                    children: [
                                      Icon(Icons.inventory_2_outlined,
                                          size: 64, color: Colors.grey[400]),
                                      const SizedBox(height: 16),
                                      Text(
                                        AppLocalizations.of(context)!
                                            .noBatchesFound,
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey[600]),
                                      ),
                                      const SizedBox(height: 8),
                                      TextButton.icon(
                                        onPressed: widget.onNavigateToCreate,
                                        icon: const Icon(Icons.add),
                                        label: Text(
                                            AppLocalizations.of(context)!
                                                .createFirstBatch),
                                      ),
                                    ],
                                  ),
                                )
                              : Table(
                                  columnWidths: const {
                                    0: FlexColumnWidth(1),
                                    1: FlexColumnWidth(1.5),
                                    2: FlexColumnWidth(1.5),
                                    3: FlexColumnWidth(1.5),
                                    4: FlexColumnWidth(2),
                                    5: FlexColumnWidth(2),
                                  },
                                  children: [
                                    // Header Row
                                    TableRow(
                                      decoration: BoxDecoration(
                                        color: AppTheme.brownGold,
                                      ),
                                      children: [
                                        _TableHeaderCell(Text(
                                            AppLocalizations.of(context)!
                                                .batchId)),
                                        _TableHeaderCell(Text(
                                            AppLocalizations.of(context)!
                                                .quantity)),
                                        _TableHeaderCell(Text(
                                            AppLocalizations.of(context)!
                                                .mfgDate)),
                                        _TableHeaderCell(Text(
                                            AppLocalizations.of(context)!
                                                .expiryDate)),
                                        _TableHeaderCell(Text(
                                            AppLocalizations.of(context)!
                                                .status)),
                                        _TableHeaderCell(Text(
                                            AppLocalizations.of(context)!
                                                .actions)),
                                      ],
                                    ),
                                    // Data Rows
                                    ..._batches.map((batch) {
                                      final expiryStatus = _getExpiryStatus(
                                          batch['expiry_date']);
                                      final expiryColor =
                                          _getExpiryColor(expiryStatus);
                                      final expiryLabel = _getExpiryLabel(
                                          expiryStatus, batch['expiry_date']);

                                      // Handle both 'manufacture_date' and 'manifacture_date' (typo in DB)
                                      final mfgDate =
                                          batch['manufacture_date'] ??
                                              batch['manifacture_date'];

                                      return TableRow(
                                        decoration: BoxDecoration(
                                          border: Border(
                                            bottom: BorderSide(
                                                color: AppTheme.borderColor
                                                    .withOpacity(0.3)),
                                          ),
                                        ),
                                        children: [
                                          _TableCell(
                                              Text('#${batch['batch_id']}')),
                                          _TableCell(Text(
                                              '${batch['quantity']} ' +
                                                  AppLocalizations.of(context)!
                                                      .units)),
                                          _TableCell(
                                              Text(_formatDate(mfgDate))),
                                          _TableCell(Text(_formatDate(
                                              batch['expiry_date']))),
                                          _TableCell(
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                      vertical: 6),
                                              decoration: BoxDecoration(
                                                color: expiryColor
                                                    .withOpacity(0.1),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                border: Border.all(
                                                    color: expiryColor),
                                              ),
                                              child: Text(
                                                expiryLabel,
                                                style: TextStyle(
                                                  color: expiryColor,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                          ),
                                          _TableCell(
                                            Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                IconButton(
                                                  icon: const Icon(Icons.edit,
                                                      size: 20),
                                                  onPressed: () {
                                                    widget.onNavigateToEdit
                                                        ?.call(batch['batch_id']
                                                            .toString());
                                                  },
                                                  color: AppTheme.primaryBlue,
                                                  tooltip: AppLocalizations.of(
                                                          context)!
                                                      .editBatch,
                                                ),
                                                IconButton(
                                                  icon: const Icon(Icons.delete,
                                                      size: 20),
                                                  onPressed: () {
                                                    showDialog(
                                                      context: context,
                                                      builder: (context) =>
                                                          AlertDialog(
                                                        title: Text(
                                                            AppLocalizations.of(
                                                                    context)!
                                                                .deleteBatch),
                                                        content: Text(AppLocalizations
                                                                    .of(context)!
                                                                .deleteConfirmation +
                                                            ' #${batch['batch_id']}?'),
                                                        actions: [
                                                          TextButton(
                                                            onPressed: () =>
                                                                Navigator.pop(
                                                                    context),
                                                            child: Text(
                                                                AppLocalizations.of(
                                                                        context)!
                                                                    .cancel),
                                                          ),
                                                          TextButton(
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context);
                                                              _deleteBatch(
                                                                batch['batch_id']
                                                                    as int,
                                                                'Batch #${batch['batch_id']}',
                                                              );
                                                            },
                                                            style: TextButton
                                                                .styleFrom(
                                                              foregroundColor:
                                                                  Colors.red,
                                                            ),
                                                            child: Text(
                                                                AppLocalizations.of(
                                                                        context)!
                                                                    .delete),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                  color: Colors.red,
                                                  tooltip: AppLocalizations.of(
                                                          context)!
                                                      .deleteBatch,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      );
                                    }),
                                  ],
                                ),
                        ],
                      ),
                    ),
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard(
      String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _TableHeaderCell extends StatelessWidget {
  final Widget child;

  const _TableHeaderCell(this.child);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: DefaultTextStyle(
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 14,
          color: Colors.white,
        ),
        child: child,
      ),
    );
  }
}

class _TableCell extends StatelessWidget {
  final Widget child;

  const _TableCell(this.child);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: DefaultTextStyle(
        style: const TextStyle(
          fontSize: 14,
          color: AppTheme.textPrimary,
        ),
        child: child,
      ),
    );
  }
}
