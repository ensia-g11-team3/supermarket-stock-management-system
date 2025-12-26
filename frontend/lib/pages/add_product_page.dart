import 'package:flutter/material.dart';
import 'package:se_project/l10n/app_localizations.dart';
import '../widgets/page_header.dart';
import '../widgets/primary_button.dart';
import '../theme/app_theme.dart';
import '../services/product_api.dart';

class AddProductPage extends StatefulWidget {
  final VoidCallback? onProductAdded;
  const AddProductPage({
    super.key,
    this.onProductAdded,
  });

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();
  final _productNameController = TextEditingController();
  final _barcodeController = TextEditingController();
  final _quantityController = TextEditingController(text: '0');
  final _sellingPriceController = TextEditingController(text: '0.00');
  final _buyingPriceController = TextEditingController(text: '0.00');
  final _descriptionController = TextEditingController();
  final _supplierController = TextEditingController();

  String? _selectedCategory;

  final List<String> _categories = [
    'Electronics',
    'Clothing',
    'Food & Beverages',
    'Office Supplies',
    'Furniture',
  ];

  @override
  void dispose() {
    _productNameController.dispose();
    _barcodeController.dispose();
    _quantityController.dispose();
    _sellingPriceController.dispose();
    _buyingPriceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.selectCategoryMsg),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final data = {
      "name": _productNameController.text,
      "barcode": _barcodeController.text,
      "category": _selectedCategory,
      "supplier": _supplierController.text,
      "qty": int.parse(_quantityController.text),
      "buying_price": double.parse(_buyingPriceController.text),
      "selling_price": double.parse(_sellingPriceController.text),
      "description": _descriptionController.text,
    };

    try {
      await ProductApi.addProduct(data);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.productAddedMsg),
            backgroundColor: Colors.green,
          ),
        );

        _resetForm();
        widget.onProductAdded?.call();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text(AppLocalizations.of(context)!.failedToLoadProductMsg + '$e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _resetForm() {
    _formKey.currentState!.reset();
    _productNameController.clear();
    _barcodeController.clear();
    _quantityController.text = '0';
    _buyingPriceController.text = '0.00';
    _sellingPriceController.text = '0.00';
    _supplierController.clear();
    _descriptionController.clear();

    setState(() {
      _selectedCategory = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PageHeader(
          title: AppLocalizations.of(context)!.addNewProduct,
          description: AppLocalizations.of(context)!.enterProductDetails,
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32),
            child: Form(
              key: _formKey,
              child: Container(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              _buildTextField(
                                controller: _productNameController,
                                label:
                                    AppLocalizations.of(context)!.productName,
                                hint: AppLocalizations.of(context)!
                                    .enterProductName,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return AppLocalizations.of(context)!
                                        .plzEnterProductName;
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 20),
                              _buildTextField(
                                controller: _barcodeController,
                                label:
                                    AppLocalizations.of(context)!.barcodeNumber,
                                hint:
                                    AppLocalizations.of(context)!.enterBarcode,
                              ),
                              const SizedBox(height: 20),
                              _buildDropdown(
                                label: AppLocalizations.of(context)!.category,
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
                              _buildTextField(
                                controller: _supplierController,
                                label: AppLocalizations.of(context)!.supplier,
                                hint:
                                    AppLocalizations.of(context)!.enterSupplier,
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
                                label: AppLocalizations.of(context)!
                                    .initialQuantity,
                                hint: '0',
                                keyboardType: TextInputType.number,
                                isRequired: true,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return AppLocalizations.of(context)!
                                        .plzEnterInitialQty;
                                  }
                                  if (int.tryParse(value) == null) {
                                    return AppLocalizations.of(context)!
                                        .plzEnterValidNum;
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 20),
                              _buildTextField(
                                controller: _buyingPriceController,
                                label:
                                    AppLocalizations.of(context)!.buyingPrice,
                                hint: '0.00',
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                        decimal: true),
                                isRequired: true,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return AppLocalizations.of(context)!
                                        .plzEnterPrice;
                                  }
                                  if (double.tryParse(value) == null) {
                                    return AppLocalizations.of(context)!
                                        .plzEnterValidPrice;
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 20),
                              _buildTextField(
                                controller: _sellingPriceController,
                                label:
                                    AppLocalizations.of(context)!.sellingPrice,
                                hint: '0.00',
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                        decimal: true),
                                isRequired: true,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return AppLocalizations.of(context)!
                                        .plzEnterPrice;
                                  }
                                  if (double.tryParse(value) == null) {
                                    return AppLocalizations.of(context)!
                                        .plzEnterValidPrice;
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 20),
                              _buildTextField(
                                controller: _descriptionController,
                                label:
                                    AppLocalizations.of(context)!.description,
                                hint: AppLocalizations.of(context)!
                                    .enterDescription,
                                maxLines: 4,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    Row(
                      children: [
                        PrimaryButton(
                          onPressed: _handleSave,
                          child:
                              Text(AppLocalizations.of(context)!.saveProduct),
                        ),
                        const SizedBox(width: 12),
                        TextButton(
                          onPressed: _resetForm,
                          child: Text(AppLocalizations.of(context)!.resetForm),
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
            if (isRequired)
              const Text(
                '*',
                style: TextStyle(color: Colors.red),
              ),
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
            hintStyle: const TextStyle(
              color: Colors.grey, // ← this is what you want
            ),
            filled: true,
            fillColor: AppTheme.inputBackground,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppTheme.borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide:
                  const BorderSide(color: AppTheme.primaryBlue, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
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
            if (isRequired)
              const Text('*', style: TextStyle(color: Colors.red)),
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
              border: OutlineInputBorder(borderSide: BorderSide.none),
              filled: true,
              fillColor: AppTheme.inputBackground,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            items: items.map((item) {
              return DropdownMenuItem(value: item, child: Text(item));
            }).toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
