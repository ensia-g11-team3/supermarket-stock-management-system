import 'package:flutter/material.dart';
import '../widgets/page_header.dart';
import '../assets/colors.dart';

class AlertsPage extends StatefulWidget {
  const AlertsPage({super.key});

  @override
  State<AlertsPage> createState() => _AlertsPageState();
}

class _AlertsPageState extends State<AlertsPage> {

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const PageHeader(
          title: 'Low Stock Alerts',
          description: 'Monitor inventory levels',
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStatsCards(),
                const SizedBox(height: 32),
                _buildDataTable(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatsCards() {
    return _buildStatCard(
      icon: Icons.inventory_2_outlined,
      iconColor: AppColors.brownGold,
      iconBgColor: AppColors.brownGold.withOpacity(0.1),
      title: 'Low Stock Items',
      value: '4',
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



  Widget _buildDataTable() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Table(
        columnWidths: const {
          0: FlexColumnWidth(2), // Product Name
          1: FlexColumnWidth(1.5), // Category
          2: FlexColumnWidth(1), // Current Stock
          3: FlexColumnWidth(1), // Min Stock
          4: FlexColumnWidth(1.5), // Supplier
        },
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: [
          // Header Row
          TableRow(
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: AppColors.borderColor)),
              color: Color(0xFFFAFAFA),
            ),
            children: [
              _buildHeaderCell('Product Name'),
              _buildHeaderCell('Category'),
              _buildHeaderCell('Current Stock'),
              _buildHeaderCell('Min Stock'),
              _buildHeaderCell('Supplier'),
            ],
          ),
          // Data Rows
          _buildDataRow(
            'Butter 250g',
            'Dairy',
            5,
            10,
            'Dairy Farms',
            true, // Critical
          ),
          _buildDataRow(
            'Coffee Beans 500g',
            'Beverages',
            8,
            15,
            'Coffee Import',
            false, // Warning
          ),
          _buildDataRow(
            'Olive Oil 500ml',
            'Pantry',
            3,
            10,
            'Food Supplies',
            true, // Critical
          ),
          _buildDataRow(
            'Honey 250g',
            'Pantry',
            6,
            12,
            'Natural Foods',
            false, // Warning
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(String text, {Alignment alignment = Alignment.centerLeft}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Align(
        alignment: alignment,
        child: Text(
          text,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  TableRow _buildDataRow(
    String name,
    String category,
    int currentStock,
    int minStock,
    String supplier,
    bool isCritical,
  ) {
    return TableRow(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.borderColor)),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Row(
            children: [
              Container(
                width: 4,
                height: 24,
                decoration: BoxDecoration(
                  color: AppColors.brownGold,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                name,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Text(
            category,
            style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: isCritical ? AppColors.red.withOpacity(0.1) : AppColors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              currentStock.toString(),
              style: TextStyle(
                color: isCritical ? AppColors.red : AppColors.orange,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Text(
            minStock.toString(),
            style: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Text(
            supplier,
            style: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
          ),
        ),
      ],
    );
  }
}
