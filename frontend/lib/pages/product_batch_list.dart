import 'package:flutter/material.dart';
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
      final batches = await BatchApi.getBatchesByProduct(int.parse(widget.productId));
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
          SnackBar(content: Text('Failed to load batches: $e')),
        );
      }
      setState(() => _isLoading = false);
    }
  }

  String _formatDate(dynamic date) {
    if (date == null) return 'N/A';
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
    if (expiryDate == null) return 'No Expiry';
    
    switch (status) {
      case 'expired':
        return 'Expired';
      case 'near_expiry':
        try {
          final daysLeft = DateTime.parse(expiryDate.toString()).difference(DateTime.now()).inDays;
          return 'Expires in $daysLeft days';
        } catch (e) {
          return 'Near Expiry';
        }
      case 'normal':
        return 'Valid';
      default:
        return 'Unknown';
    }
  }

  void _deleteBatch(int batchId, String batchName) async {
    try {
      await BatchApi.deleteBatch(batchId);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$batchName deleted successfully')),
        );
        _fetchBatches(); // Refresh list
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete batch: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final totalQuantity = _batches.fold<int>(0, (sum, b) => sum + ((b['quantity'] as num?)?.toInt() ?? 0));
    final expiredCount = _batches.where((b) => _getExpiryStatus(b['expiry_date']) == 'expired').length;
    final nearExpiryCount = _batches.where((b) => _getExpiryStatus(b['expiry_date']) == 'near_expiry').length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PageHeader(
          title: 'Product Batches - ${widget.productName}',
          description: 'Manage batches for this product',
          actions: [
            TextButton.icon(
              onPressed: widget.onNavigateBack,
              icon: const Icon(Icons.arrow_back),
              label: const Text('Back to Products'),
            ),
            const SizedBox(width: 12),
            PrimaryButton(
              onPressed: widget.onNavigateToCreate,
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add, size: 20),
                  SizedBox(width: 8),
                  Text('Create New Batch'),
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
                                  'Total Batches',
                                  _batches.length.toString(),
                                  Icons.inventory_2,
                                  Colors.blue,
                                ),
                                _buildSummaryCard(
                                  'Total Quantity',
                                  totalQuantity.toString(),
                                  Icons.warehouse,
                                  Colors.green,
                                ),
                                _buildSummaryCard(
                                  'Expired',
                                  expiredCount.toString(),
                                  Icons.warning,
                                  Colors.red,
                                ),
                                _buildSummaryCard(
                                  'Near Expiry',
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
                                      Icon(Icons.inventory_2_outlined, size: 64, color: Colors.grey[400]),
                                      const SizedBox(height: 16),
                                      Text(
                                        'No batches found for this product',
                                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                                      ),
                                      const SizedBox(height: 8),
                                      TextButton.icon(
                                        onPressed: widget.onNavigateToCreate,
                                        icon: const Icon(Icons.add),
                                        label: const Text('Create your first batch'),
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
                                    const TableRow(
                                      decoration: BoxDecoration(
                                        color: AppTheme.brownGold,
                                      ),
                                      children: [
                                        _TableHeaderCell(Text('Batch ID')),
                                        _TableHeaderCell(Text('Quantity')),
                                        _TableHeaderCell(Text('Mfg. Date')),
                                        _TableHeaderCell(Text('Expiry Date')),
                                        _TableHeaderCell(Text('Status')),
                                        _TableHeaderCell(Text('Actions')),
                                      ],
                                    ),
                                    // Data Rows
                                    ..._batches.map((batch) {
                                      final expiryStatus = _getExpiryStatus(batch['expiry_date']);
                                      final expiryColor = _getExpiryColor(expiryStatus);
                                      final expiryLabel = _getExpiryLabel(expiryStatus, batch['expiry_date']);
                                      
                                      // Handle both 'manufacture_date' and 'manifacture_date' (typo in DB)
                                      final mfgDate = batch['manufacture_date'] ?? batch['manifacture_date'];

                                      return TableRow(
                                        decoration: BoxDecoration(
                                          border: Border(
                                            bottom: BorderSide(color: AppTheme.borderColor.withOpacity(0.3)),
                                          ),
                                        ),
                                        children: [
                                          _TableCell(Text('#${batch['batch_id']}')),
                                          _TableCell(Text('${batch['quantity']} units')),
                                          _TableCell(Text(_formatDate(mfgDate))),
                                          _TableCell(Text(_formatDate(batch['expiry_date']))),
                                          _TableCell(
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                              decoration: BoxDecoration(
                                                color: expiryColor.withOpacity(0.1),
                                                borderRadius: BorderRadius.circular(12),
                                                border: Border.all(color: expiryColor),
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
                                                  icon: const Icon(Icons.edit, size: 20),
                                                  onPressed: () {
                                                    widget.onNavigateToEdit?.call(batch['batch_id'].toString());
                                                  },
                                                  color: AppTheme.primaryBlue,
                                                  tooltip: 'Edit Batch',
                                                ),
                                                IconButton(
                                                  icon: const Icon(Icons.delete, size: 20),
                                                  onPressed: () {
                                                    showDialog(
                                                      context: context,
                                                      builder: (context) => AlertDialog(
                                                        title: const Text('Delete Batch'),
                                                        content: Text('Are you sure you want to delete Batch #${batch['batch_id']}?'),
                                                        actions: [
                                                          TextButton(
                                                            onPressed: () => Navigator.pop(context),
                                                            child: const Text('Cancel'),
                                                          ),
                                                          TextButton(
                                                            onPressed: () {
                                                              Navigator.pop(context);
                                                              _deleteBatch(
                                                                batch['batch_id'] as int,
                                                                'Batch #${batch['batch_id']}',
                                                              );
                                                            },
                                                            style: TextButton.styleFrom(
                                                              foregroundColor: Colors.red,
                                                            ),
                                                            child: const Text('Delete'),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                  color: Colors.red,
                                                  tooltip: 'Delete Batch',
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

  Widget _buildSummaryCard(String label, String value, IconData icon, Color color) {
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