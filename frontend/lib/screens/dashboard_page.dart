import 'package:flutter/material.dart';
import '../widgets/page_header.dart';
import 'package:fl_chart/fl_chart.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Good Evening, hh!',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w600,
              color: Color(0xFFB87653),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Here\'s what\'s happening with your store today',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 32),
          
          // Stats Cards
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  icon: Icons.inventory_2_outlined,
                  iconColor: Color(0xFF5B9BD5),
                  iconBgColor: Color(0xFFD9E9F7),
                  title: 'Total Products',
                  value: '1,248',
                  change: '12%',
                  isPositive: true,
                  borderColor: Color(0xFF5B9BD5),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _StatCard(
                  icon: Icons.attach_money,
                  iconColor: Color(0xFF70AD47),
                  iconBgColor: Color(0xFFE2F0D9),
                  title: 'Today\'s Sales',
                  value: '\$2,845',
                  change: '8%',
                  isPositive: true,
                  borderColor: Color(0xFF70AD47),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _StatCard(
                  icon: Icons.warning_amber_outlined,
                  iconColor: Color(0xFFFFC000),
                  iconBgColor: Color(0xFFFFF2CC),
                  title: 'Low Stock Alerts',
                  value: '18',
                  change: '3 items',
                  isPositive: false,
                  borderColor: Color(0xFFFFC000),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _StatCard(
                  icon: Icons.trending_up,
                  iconColor: Color(0xFFFFC000),
                  iconBgColor: Color(0xFFFFF2CC),
                  title: 'Monthly Profit',
                  value: '\$12,450',
                  change: '15%',
                  isPositive: true,
                  borderColor: Color(0xFFFFC000),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 32),
          
          // Sales Overview and Quick Stats
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: _SalesOverview(),
              ),
              const SizedBox(width: 24),
              Expanded(
                flex: 1,
                child: _QuickStats(),
              ),
            ],
          ),
          
          const SizedBox(height: 32),
          
          // Most Sold Items
          _MostSoldItems(),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final String title;
  final String value;
  final String change;
  final bool isPositive;
  final Color borderColor;

  const _StatCard({
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    required this.title,
    required this.value,
    required this.change,
    required this.isPositive,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border(
          left: BorderSide(color: borderColor, width: 4),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: iconColor, size: 24),
              ),
              Row(
                children: [
                  Icon(
                    isPositive ? Icons.arrow_upward : Icons.arrow_upward,
                    color: isPositive ? Colors.green : Colors.orange,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    change,
                    style: TextStyle(
                      color: isPositive ? Colors.green : Colors.orange,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),
        ],
      ),
    );
  }
}

class _SalesOverview extends StatelessWidget {
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
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sales Overview',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFFB87653),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Monthly sales performance for 2025',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 280,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 42,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov'];
                        if (value.toInt() >= 0 && value.toInt() < months.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              months[value.toInt()],
                              style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                            ),
                          );
                        }
                        return Text('');
                      },
                    ),
                  ),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: 10,
                minY: 0,
                maxY: 10000,
                lineBarsData: [
                  LineChartBarData(
                    spots: [
                      FlSpot(0, 4000),
                      FlSpot(1, 3800),
                      FlSpot(2, 5100),
                      FlSpot(3, 4700),
                      FlSpot(4, 5900),
                      FlSpot(5, 6200),
                      FlSpot(6, 7200),
                      FlSpot(7, 6900),
                      FlSpot(8, 7600),
                      FlSpot(9, 8700),
                      FlSpot(10, 8400),
                    ],
                    isCurved: true,
                    color: Color(0xFFB87653),
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 4,
                          color: Color(0xFFB87653),
                          strokeWidth: 2,
                          strokeColor: Colors.white,
                        );
                      },
                    ),
                    belowBarData: BarAreaData(show: false),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickStats extends StatelessWidget {
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
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Stats',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFFB87653),
            ),
          ),
          const SizedBox(height: 24),
          _QuickStatItem(
            title: 'Total Revenue',
            value: '\$87,450',
            change: '+18% from last month',
            bgColor: Color(0xFFE2F0D9),
          ),
          const SizedBox(height: 16),
          _QuickStatItem(
            title: 'Orders Today',
            value: '156',
            change: '+12 from yesterday',
            bgColor: Color(0xFFD9E9F7),
          ),
          const SizedBox(height: 16),
          _QuickStatItem(
            title: 'Avg Order Value',
            value: '\$18.24',
            change: '+5% from last week',
            bgColor: Color(0xFFFFF2CC),
          ),
        ],
      ),
    );
  }
}

class _QuickStatItem extends StatelessWidget {
  final String title;
  final String value;
  final String change;
  final Color bgColor;

  const _QuickStatItem({
    required this.title,
    required this.value,
    required this.change,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            change,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}

class _MostSoldItems extends StatelessWidget {
  final List<Map<String, dynamic>> items = [
    {
      'name': 'Coca Cola 500ml',
      'quantity': 1250,
      'profit': 625.00,
      'trend': 'Trending',
      'performance': 100,
    },
    {
      'name': 'Lays Chips',
      'quantity': 980,
      'profit': 490.00,
      'trend': 'Trending',
      'performance': 78,
    },
    {
      'name': 'Milk 1L',
      'quantity': 875,
      'profit': 437.50,
      'trend': 'Declining',
      'performance': 70,
    },
    {
      'name': 'White Bread',
      'quantity': 820,
      'profit': 410.00,
      'trend': 'Trending',
      'performance': 66,
    },
    {
      'name': 'Orange Juice 1L',
      'quantity': 650,
      'profit': 325.00,
      'trend': 'Trending',
      'performance': 52,
    },
  ];

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
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Most Sold Items',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFFB87653),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Top performing products this month',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 24),
          Table(
            columnWidths: {
              0: FlexColumnWidth(2),
              1: FlexColumnWidth(1.2),
              2: FlexColumnWidth(1),
              3: FlexColumnWidth(1),
              4: FlexColumnWidth(1.5),
            },
            children: [
              TableRow(
                decoration: BoxDecoration(
                  color: Color(0xFFB87653),
                  borderRadius: BorderRadius.circular(8),
                ),
                children: [
                  _TableHeader('Product'),
                  _TableHeader('Sold Quantity'),
                  _TableHeader('Profit'),
                  _TableHeader('Trend'),
                  _TableHeader('Performance'),
                ],
              ),
              ...items.map((item) => TableRow(
                children: [
                  _TableCell(
                    child: Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          item['name'],
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[800],
                          ),
                        ),
                      ],
                    ),
                  ),
                  _TableCell(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: Color(0xFFD9E9F7),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${item['quantity']} units',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[800],
                        ),
                      ),
                    ),
                  ),
                  _TableCell(
                    child: Text(
                      '\$${item['profit'].toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.green,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  _TableCell(
                    child: Row(
                      children: [
                        Icon(
                          item['trend'] == 'Trending' 
                            ? Icons.arrow_upward 
                            : Icons.arrow_downward,
                          size: 14,
                          color: item['trend'] == 'Trending' 
                            ? Colors.green 
                            : Colors.red,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          item['trend'],
                          style: TextStyle(
                            fontSize: 13,
                            color: item['trend'] == 'Trending' 
                              ? Colors.green 
                              : Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _TableCell(
                    child: Row(
                      children: [
                        Expanded(
                          child: Stack(
                            children: [
                              Container(
                                height: 8,
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              FractionallySizedBox(
                                widthFactor: item['performance'] / 100,
                                child: Container(
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${item['performance']}%',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )),
            ],
          ),
        ],
      ),
    );
  }

  Widget _TableHeader(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _TableCell({required Widget child}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: child,
    );
  }
}