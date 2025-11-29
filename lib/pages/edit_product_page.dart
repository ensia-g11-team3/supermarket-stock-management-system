import 'package:flutter/material.dart';
import '../widgets/page_header.dart';
import '../widgets/primary_button.dart';
import '../theme/app_theme.dart';

class EditProductPage extends StatefulWidget {
  final String productId;
  final VoidCallback onNavigateBack;
  final VoidCallback onProductUpdated;

  const EditProductPage({
    super.key,
    required this.productId,
    required this.onNavigateBack,
    required this.onProductUpdated,
  });

  @override
  State<EditProductPage> createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _productNameController;
  late TextEditingController _barcodeController;
  late TextEditingController _quantityController;
  late TextEditingController _minStockController;
  late TextEditingController _priceController;
  late TextEditingController _descriptionController;

  String? _selectedCategory;
  String? _selectedSupplier;

  final List<String> _categories = [
    'Beverages',
    'Snacks',
    'Dairy',
    'Bakery',
    'Electronics',
    'Clothing',
    'Food & Beverages',
    'Office Supplies',
    'Furniture',
  ];

  final List<String> _suppliers = [
    'Beverage Co.',
    'Snack Corp',
    'Dairy Farms',
    'Local Bakery',
    'Coffee Import',
    'Supplier A',
    'Supplier B',
    'Supplier C',
    'Supplier D',
  ];

  // Simulate loading product data by productId
  Future<void> _loadProductData() async {
  try {
    final product = await ProductApi.getProductById(widget.productId);

    setState(() {
      _productNameController.text = product["name"];
      _barcodeController.text = product["barcode"];
      _quantityController.text = product["quantity"].toString();
      _minStockController.text = product["minStock"].toString();
      _priceController.text = product["price"].toString();
      _descriptionController.text = product["description"] ?? "";
      _selectedCategory = product["category"];
      _selectedSupplier = product["supplier"];
    });
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Failed to load product: $e"),
        backgroundColor: Colors.red,
      ),
    );
  }
}


  @override
  void initState() {
    super.initState();
    _productNameController = TextEditingController();
    _barcodeController = TextEditingController();
    _quantityController = TextEditingController(text: '0');
    _minStockController = TextEditingController(text: '10');
    _priceController = TextEditingController(text: '0.00');
    _descriptionController = TextEditingController();
    _loadProductData();
  }

  @override
  void dispose() {
    _productNameController.dispose();
    _barcodeController.dispose();
    _quantityController.dispose();
    _minStockController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _handleSave() async {
  if (!_formKey.currentState!.validate()) return;

  if (_selectedCategory == null || _selectedSupplier == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Please select a category and supplier'),
        backgroundColor: Colors.red,
      ),
    );
    return;
  }

  final updatedData = {
    "name": _productNameController.text,
    "barcode": _barcodeController.text,
    "category": _selectedCategory,
    "supplier": _selectedSupplier,
    "quantity": int.parse(_quantityController.text),
    "minStock": int.parse(_minStockController.text),
    "price": double.parse(_priceController.text),
    "description": _descriptionController.text,
  };

  try {
    await ProductApi.updateProduct(widget.productId, updatedData);

    widget.onProductUpdated();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Product updated successfully!'),
        backgroundColor: Colors.green,
      ),
    );

    widget.onNavigateBack(); // go back to list

  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Failed to update product: $e"),
        backgroundColor: Colors.red,
      ),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PageHeader(
          title: 'Edit Product',
          description: 'Update product details',
          actions: [
            TextButton.icon(
              onPressed: widget.onNavigateBack,
              icon: const Icon(Icons.arrow_back),
              label: const Text('Back to Product List'),
            ),
          ],
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Form Fields
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              _buildTextField(
                                controller: _productNameController,
                                label: 'Product Name',
                                hint: 'Enter product name',
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter product name';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 20),
                              _buildTextField(
                                controller: _barcodeController,
                                label: 'Barcode Number',
                                hint: 'Enter barcode number',
                              ),
                              const SizedBox(height: 20),
                              _buildDropdown(
                                label: 'Category',
                                value: _selectedCategory,
                                items: _categories,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedCategory = value;
                                  });
                                },
                                isRequired: true,
                              ),
                              const SizedBox(height: 20),
                              _buildDropdown(
                                label: 'Supplier',
                                value: _selectedSupplier,
                                items: _suppliers,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedSupplier = value;
                                  });
                                },
                                isRequired: true,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 32),
                        Expanded(
                          child: Column(
                            children: [
                              _buildTextField(
                                controller: _quantityController,
                                label: 'Initial Quantity',
                                hint: '0',
                                keyboardType: TextInputType.number,
                                isRequired: true,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter initial quantity';
                                  }
                                  if (int.tryParse(value) == null) {
                                    return 'Please enter a valid number';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 20),
                              _buildTextField(
                                controller: _minStockController,
                                label: 'Minimum Stock Level',
                                hint: '10',
                                keyboardType: TextInputType.number,
                                isRequired: true,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter minimum stock level';
                                  }
                                  if (int.tryParse(value) == null) {
                                    return 'Please enter a valid number';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 20),
                              _buildTextField(
                                controller: _priceController,
                                label: 'Price (\$)',
                                hint: '0.00',
                                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                isRequired: true,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter price';
                                  }
                                  if (double.tryParse(value) == null) {
                                    return 'Please enter a valid price';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 20),
                              _buildTextField(
                                controller: _descriptionController,
                                label: 'Description',
                                hint: 'Enter product description (optional)',
                                maxLines: 4,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    // Action Buttons
                    Row(
                      children: [
                        PrimaryButton(
                          onPressed: _handleSave,
                          child: const Text('Save Changes'),
                        ),
                        const SizedBox(width: 12),
                        TextButton(
                          onPressed: widget.onNavigateBack,
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                          ),
                          child: const Text('Cancel'),
                        ),
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? hint,
    TextInputType? keyboardType,
    int maxLines = 1,
    bool isRequired = false,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppTheme.textPrimary,
              ),
            ),
            if (isRequired) ...[
              const SizedBox(width: 4),
              const Text(
                '*',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 14,
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
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
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: maxLines > 1 ? 12 : 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    bool isRequired = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppTheme.textPrimary,
              ),
            ),
            if (isRequired) ...[
              const SizedBox(width: 4),
              const Text(
                '*',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 14,
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: AppTheme.inputBackground,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppTheme.borderColor),
          ),
          child: DropdownButtonFormField<String>(
            value: value,
            decoration: InputDecoration(
              hintText: 'Select ${label.toLowerCase()}',
              filled: true,
              fillColor: AppTheme.inputBackground,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppTheme.primaryBlue, width: 2),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
            items: items.map((item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(item),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}

