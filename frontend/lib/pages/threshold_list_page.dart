import 'package:flutter/material.dart';
import '../widgets/page_header.dart';
import '../widgets/primary_button.dart';
import '../theme/app_theme.dart';
import '../services/threshold_api.dart';
import '../services/product_api.dart';
import '../assets/colors.dart';

class ThresholdListPage extends StatefulWidget {
  final VoidCallback? onNavigateToAdd;
  final Function(String)? onNavigateToEdit;

  const ThresholdListPage({
    super.key,
    this.onNavigateToAdd,
    this.onNavigateToEdit,
  });

  @override
  State<ThresholdListPage> createState() => _ThresholdListPageState();
}

class _ThresholdListPageState extends State<ThresholdListPage> {
  List<Map<String, dynamic>> _thresholds = [];
  bool _isLoading = true;
  String _searchQuery = '';
  String _selectedType = 'All Types';

  @override
  void initState() {
    super.initState();
    _fetchThresholds();
  }

  Future<void> _fetchThresholds() async {
    try {
      final data = await ThresholdApi.getThresholds();
      setState(() {
        _thresholds = List<Map<String, dynamic>>.from(data['thresholds'] ?? []);
        _isLoading = false;
      });
    } catch (e) {
      print("Error loading thresholds: $e");
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading thresholds: $e')),
        );
      }
    }
  }

  List<Map<String, dynamic>> get _filteredThresholds {
    return _thresholds.where((threshold) {
      final matchesSearch = _searchQuery.isEmpty ||
          (threshold['entity_name'] ?? '')
              .toString()
              .toLowerCase()
              .contains(_searchQuery.toLowerCase());

      final matchesType = _selectedType == 'All Types' ||
          threshold['threshold_type'] == _selectedType.toLowerCase();

      return matchesSearch && matchesType;
    }).toList();
  }

  Future<void> _deleteThreshold(int thresholdId, String entityName) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Threshold'),
        content: Text('Are you sure you want to delete the threshold for "$entityName"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await ThresholdApi.deleteThreshold(thresholdId);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Threshold for "$entityName" deleted successfully')),
          );
        }
        _fetchThresholds();
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error deleting threshold: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PageHeader(
          title: 'Threshold Management',
          description: 'Manage low-stock thresholds for products and categories',
          actions: [
            PrimaryButton(
              onPressed: widget.onNavigateToAdd,
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add, size: 20),
                  SizedBox(width: 8),
                  Text('Add Threshold'),
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Filters Section
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Filters',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: _buildSearchField(),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: _buildTypeFilter(),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        // Stats Card
                        _buildStatsCard(),
                        const SizedBox(height: 24),
                        // Threshold Table
                        Card(
                          child: _filteredThresholds.isEmpty
                              ? Padding(
                                  padding: const EdgeInsets.all(48),
                                  child: Center(
                                    child: Column(
                                      children: [
                                        Icon(
                                          Icons.inventory_2_outlined,
                                          size: 64,
                                          color: AppColors.textSecondary.withOpacity(0.5),
                                        ),
                                        const SizedBox(height: 16),
                                        Text(
                                          'No thresholds found',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: AppColors.textSecondary.withOpacity(0.7),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : Table(
                                  columnWidths: const {
                                    0: FlexColumnWidth(1.5), // Type
                                    1: FlexColumnWidth(3), // Name
                                    2: FlexColumnWidth(1.5), // Threshold Value
                                    3: FlexColumnWidth(2), // Created At
                                    4: FlexColumnWidth(1.5), // Actions
                                  },
                                  children: [
                                    // Header Row
                                    const TableRow(
                                      decoration: BoxDecoration(
                                        color: AppTheme.brownGold,
                                        border: Border(
                                          bottom: BorderSide(color: AppTheme.borderColor),
                                        ),
                                      ),
                                      children: [
                                        _TableHeaderCell(Text('Type')),
                                        _TableHeaderCell(Text('Product/Category')),
                                        _TableHeaderCell(Text('Threshold Value')),
                                        _TableHeaderCell(Text('Created At')),
                                        _TableHeaderCell(Text('Actions')),
                                      ],
                                    ),
                                    // Data Rows
                                    ..._filteredThresholds.map((threshold) => _buildDataRow(threshold)),
                                  ],
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildSearchField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Search',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          onChanged: (value) {
            setState(() {
              _searchQuery = value;
            });
          },
          decoration: InputDecoration(
            hintText: 'Search by product or category name...',
            prefixIcon: const Icon(Icons.search, color: AppTheme.textSecondary),
            filled: true,
            fillColor: AppTheme.inputBackground,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppTheme.borderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppTheme.borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppTheme.primaryBlue, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildTypeFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Type',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: AppTheme.inputBackground,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppTheme.borderColor),
          ),
          child: DropdownButtonFormField<String>(
            value: _selectedType,
            decoration: InputDecoration(
              filled: true,
              fillColor: AppTheme.inputBackground,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            items: ['All Types', 'Product', 'Category'].map((item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(item),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedType = value!;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildStatsCard() {
    final productThresholds = _thresholds.where((t) => t['threshold_type'] == 'product').length;
    final categoryThresholds = _thresholds.where((t) => t['threshold_type'] == 'category').length;

    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            icon: Icons.inventory_2_outlined,
            iconColor: AppColors.primaryBlue,
            iconBgColor: AppColors.primaryBlue.withOpacity(0.1),
            title: 'Product Thresholds',
            value: productThresholds.toString(),
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          child: _buildStatCard(
            icon: Icons.category_outlined,
            iconColor: AppColors.brownGold,
            iconBgColor: AppColors.brownGold.withOpacity(0.1),
            title: 'Category Thresholds',
            value: categoryThresholds.toString(),
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          child: _buildStatCard(
            icon: Icons.analytics_outlined,
            iconColor: AppColors.green,
            iconBgColor: AppColors.green.withOpacity(0.1),
            title: 'Total Thresholds',
            value: _thresholds.length.toString(),
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 32),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  TableRow _buildDataRow(Map<String, dynamic> threshold) {
    final thresholdType = threshold['threshold_type'] ?? '';
    final entityName = threshold['entity_name'] ?? 'Unknown';
    final thresholdValue = threshold['threshold_value'] ?? 0;
    final createdAt = threshold['created_at'] ?? '';
    final thresholdId = threshold['threshold_id'];

    return TableRow(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppTheme.borderColor)),
      ),
      children: [
        _TableCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: thresholdType == 'product'
                  ? AppColors.primaryBlue.withOpacity(0.1)
                  : AppColors.brownGold.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              thresholdType == 'product' ? 'Product' : 'Category',
              style: TextStyle(
                color: thresholdType == 'product' ? AppColors.primaryBlue : AppColors.brownGold,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        _TableCell(
          Row(
            children: [
              Icon(
                thresholdType == 'product' ? Icons.inventory_2_outlined : Icons.category_outlined,
                size: 18,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  entityName,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        _TableCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              thresholdValue.toString(),
              style: const TextStyle(
                color: AppColors.orange,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        _TableCell(
          Text(
            _formatDate(createdAt),
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
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
                  widget.onNavigateToEdit?.call(thresholdId.toString());
                },
                color: AppTheme.primaryBlue,
                tooltip: 'Edit',
              ),
              IconButton(
                icon: const Icon(Icons.delete, size: 20),
                onPressed: () {
                  _deleteThreshold(thresholdId, entityName);
                },
                color: Colors.red,
                tooltip: 'Delete',
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    } catch (e) {
      return dateStr;
    }
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
