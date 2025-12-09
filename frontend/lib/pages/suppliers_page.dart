import 'package:flutter/material.dart';
import '../widgets/page_header.dart';
import '../widgets/primary_button.dart';

class SuppliersPage extends StatefulWidget {
  const SuppliersPage({super.key});

  @override
  State<SuppliersPage> createState() => _SuppliersPageState();
}

class _SuppliersPageState extends State<SuppliersPage> {
  int _tab = 0;

  final _suppliers = [
    {'name': 'Beverage Co.', 'contact': '+1 555-0101', 'email': 'sales@bevco.com', 'products': 45},
    {'name': 'Snack Corp', 'contact': '+1 555-0102', 'email': 'orders@snackcorp.com', 'products': 32},
    {'name': 'Dairy Farms', 'contact': '+1 555-0103', 'email': 'info@dairyfarms.com', 'products': 28},
    {'name': 'Local Bakery', 'contact': '+1 555-0104', 'email': 'bakery@local.com', 'products': 19},
    {'name': 'Coffee Import', 'contact': '+1 555-0105', 'email': 'import@coffee.com', 'products': 12},
  ];

  void _showNewSupplierDialog() => showDialog(
    context: context,
    builder: (c) => AlertDialog(
      title: const Text('New Supplier'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(decoration: InputDecoration(labelText: 'Supplier Name', border: OutlineInputBorder())),
          const SizedBox(height: 12),
          TextField(decoration: InputDecoration(labelText: 'Contact', border: OutlineInputBorder())),
          const SizedBox(height: 12),
          TextField(decoration: InputDecoration(labelText: 'Email', border: OutlineInputBorder())),
        ],
      ),
      actions: [
        PrimaryButton(onPressed: () => Navigator.pop(c), variant: ButtonVariant.secondary, child: const Text('Cancel')),
        PrimaryButton(onPressed: () => Navigator.pop(c), child: const Text('Add')),
      ],
    ),
  );

  void _showNewOrderDialog() => showDialog(
    context: context,
    builder: (c) => AlertDialog(
      title: const Text('New Order'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<String>(
            decoration: InputDecoration(labelText: 'Select Supplier', border: OutlineInputBorder()),
            items: _suppliers.map((s) => DropdownMenuItem(value: s['name'] as String, child: Text(s['name'] as String))).toList(),
            onChanged: (v) {},
          ),
          const SizedBox(height: 12),
          TextField(decoration: InputDecoration(labelText: 'Product', border: OutlineInputBorder())),
          const SizedBox(height: 12),
          TextField(decoration: InputDecoration(labelText: 'Quantity', border: OutlineInputBorder()), keyboardType: TextInputType.number),
        ],
      ),
      actions: [
        PrimaryButton(onPressed: () => Navigator.pop(c), variant: ButtonVariant.secondary, child: const Text('Cancel')),
        PrimaryButton(onPressed: () => Navigator.pop(c), child: const Text('Create')),
      ],
    ),
  );

  void _showViewDialog(String name, String contact, String email, int products) => showDialog(
    context: context,
    builder: (c) => AlertDialog(
      title: Text('Supplier Details'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Name: $name', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          Text('Contact: $contact', style: TextStyle(fontSize: 14, color: Color(0xFF6B7280))),
          const SizedBox(height: 8),
          Text('Email: $email', style: TextStyle(fontSize: 14, color: Color(0xFF6B7280))),
          const SizedBox(height: 8),
          Text('Products: $products', style: TextStyle(fontSize: 14, color: Color(0xFF6B7280))),
        ],
      ),
      actions: [PrimaryButton(onPressed: () => Navigator.pop(c), variant: ButtonVariant.secondary, child: const Text('Close'))],
    ),
  );

  void _showEditDialog(String name) => showDialog(
    context: context,
    builder: (c) => AlertDialog(
      title: Text('Edit $name'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(decoration: InputDecoration(labelText: 'Supplier Name', border: OutlineInputBorder()), controller: TextEditingController(text: name)),
          const SizedBox(height: 12),
          TextField(decoration: InputDecoration(labelText: 'Contact', border: OutlineInputBorder())),
          const SizedBox(height: 12),
          TextField(decoration: InputDecoration(labelText: 'Email', border: OutlineInputBorder())),
        ],
      ),
      actions: [
        PrimaryButton(onPressed: () => Navigator.pop(c), variant: ButtonVariant.secondary, child: const Text('Cancel')),
        PrimaryButton(onPressed: () => Navigator.pop(c), child: const Text('Save')),
      ],
    ),
  );

  void _showDeleteDialog(String name) => showDialog(
    context: context,
    builder: (c) => AlertDialog(
      title: const Text('Delete Supplier'),
      content: Text('Are you sure you want to delete "$name"? This action cannot be undone.'),
      actions: [
        PrimaryButton(onPressed: () => Navigator.pop(c), variant: ButtonVariant.secondary, child: const Text('Cancel')),
        PrimaryButton(
          onPressed: () => Navigator.pop(c),
          variant: ButtonVariant.danger,
          child: const Text('Delete'),
        ),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PageHeader(
          title: 'Suppliers & Orders',
          description: 'Manage suppliers and purchase orders',
          actions: [
            PrimaryButton(
              onPressed: _showNewSupplierDialog,
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add, size: 18),
                  SizedBox(width: 8),
                  Text('New Supplier'),
                ],
              ),
            ),
            const SizedBox(width: 12),
            PrimaryButton(
              onPressed: _showNewOrderDialog,
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.shopping_cart_outlined, size: 18),
                  SizedBox(width: 8),
                  Text('New Order'),
                ],
              ),
            ),
          ],
        ),
        Expanded(
          child: Container(
            margin: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: Column(
              children: [
                Container(
                  decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xFFE5E7EB)))),
                  child: Row(
                    children: [
                      _buildTab('Suppliers', 0),
                      _buildTab('Purchase Orders', 1),
                    ],
                  ),
                ),
                Expanded(child: _tab == 0 ? _buildTable() : const Center(child: Text('Purchase Orders'))),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTab(String label, int i) {
    final sel = _tab == i;
    return GestureDetector(
      onTap: () => setState(() => _tab = i),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        decoration: BoxDecoration(border: Border(bottom: BorderSide(color: sel ? const Color(0xFF2563EB) : Colors.transparent, width: 2))),
        child: Text(label, style: TextStyle(color: sel ? const Color(0xFF2563EB) : const Color(0xFF6B7280), fontSize: 14, fontWeight: sel ? FontWeight.w600 : FontWeight.w500)),
      ),
    );
  }

  Widget _buildTable() {
    return Column(
      children: [
        Container(
          color: const Color(0xFFF9FAFB),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
          child: Row(
            children: [
              _buildHeader('Supplier Name', 3),
              _buildHeader('Contact', 2),
              _buildHeader('Email', 3),
              _buildHeader('Products', 2),
              _buildHeader('Actions', 2),
            ],
          ),
        ),
        ..._suppliers.map((s) => Container(
          decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xFFE5E7EB)))),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
          child: Row(
            children: [
              Expanded(flex: 3, child: Text(s['name'] as String, style: const TextStyle(fontSize: 14, color: Color(0xFF111827), fontWeight: FontWeight.w500))),
              Expanded(flex: 2, child: Text(s['contact'] as String, style: const TextStyle(fontSize: 14, color: Color(0xFF6B7280)))),
              Expanded(flex: 3, child: Text(s['email'] as String, style: const TextStyle(fontSize: 14, color: Color(0xFF6B7280)))),
              Expanded(
                flex: 2,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(color: const Color(0xFFD1FAE5), borderRadius: BorderRadius.circular(12)),
                  child: Text('${s['products']} products', style: const TextStyle(fontSize: 13, color: Color(0xFF065F46), fontWeight: FontWeight.w500)),
                ),
              ),
              Expanded(
                flex: 2,
                child: Row(
                  children: [
                    const SizedBox(width: 20),
                    IconButton(icon: const Icon(Icons.visibility_outlined, size: 20), color: const Color(0xFF6B7280), onPressed: () => _showViewDialog(s['name'] as String, s['contact'] as String, s['email'] as String, s['products'] as int), padding: EdgeInsets.zero, constraints: const BoxConstraints()),
                    const SizedBox(width: 20),
                    IconButton(icon: const Icon(Icons.edit_outlined, size: 20), color: const Color(0xFF2563EB), onPressed: () => _showEditDialog(s['name'] as String), padding: EdgeInsets.zero, constraints: const BoxConstraints()),
                    const SizedBox(width: 20),
                    IconButton(icon: const Icon(Icons.delete_outline, size: 20), color: const Color(0xFFEF4444), onPressed: () => _showDeleteDialog(s['name'] as String), padding: EdgeInsets.zero, constraints: const BoxConstraints()),
                  ],
                ),
              ),
            ],
          ),
        )),
      ],
    );
  }

  Widget _buildHeader(String text, int flex) => Expanded(flex: flex, child: Text(text, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF6B7280))));
}