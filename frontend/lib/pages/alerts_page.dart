import 'package:flutter/material.dart';
import '../widgets/page_header.dart';
import '../assets/colors.dart';

class AlertsPage extends StatefulWidget {
  const AlertsPage({super.key});

  @override
  State<AlertsPage> createState() => _AlertsPageState();
}

class _AlertsPageState extends State<AlertsPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PageHeader(
          title: 'Low Stock & Expiry Alerts',
          description: 'Monitor inventory levels and expiration dates',
          actions: [
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add_box_outlined, size: 20),
              label: const Text('Create Purchase Order'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStatsCards(),
                const SizedBox(height: 32),
                _buildTabs(),
                const SizedBox(height: 24),
                _buildDataTable(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatsCards() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            icon: Icons.warning_amber_rounded,
            iconColor: AppColors.red,
            iconBgColor: AppColors.red.withOpacity(0.1),
            title: 'Critical Alerts',
            value: '2',
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          child: _buildStatCard(
            icon: Icons.inventory_2_outlined,
            iconColor: AppColors.brownGold,
            iconBgColor: AppColors.brownGold.withOpacity(0.1),
            title: 'Low Stock Items',
            value: '4',
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          child: _buildStatCard(
            icon: Icons.calendar_today_outlined,
            iconColor: AppColors.orange,
            iconBgColor: AppColors.orange.withOpacity(0.1),
            title: 'Expiring Soon',
            value: '4',
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

  Widget _buildTabs() {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.borderColor),
        ),
      ),
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        labelColor: AppColors.primaryBlue,
        unselectedLabelColor: AppColors.textSecondary,
        labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
        indicatorColor: AppColors.primaryBlue,
        indicatorWeight: 3,
        tabs: const [
          Tab(text: 'Low Stock'),
          Tab(text: 'Close to Expiry'),
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
          5: FixedColumnWidth(120), // Actions
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
              _buildHeaderCell('Actions', alignment: Alignment.centerRight),
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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text('Order Now', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
            ),
          ),
        ),
      ],
    );
  }
}
