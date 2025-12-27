import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:se_project/l10n/app_localizations.dart';
import '../widgets/page_header.dart';
import '../widgets/primary_button.dart';
import '../theme/app_theme.dart';
import '../services/product_api.dart';

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
  late TextEditingController _buyingPriceController;
  late TextEditingController _sellingPriceController;
  late TextEditingController _descriptionController;
  late TextEditingController _supplierController;

  String? _selectedCategory;

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

  Future<void> _loadProductData() async {
    try {
      final response = await ProductApi.getProductById(widget.productId);
      final product = response['product'] ?? response;

      setState(() {
        _productNameController.text = product["name"];
        _barcodeController.text = product["barcode"];
        _quantityController.text = product["qty"].toString();
        _buyingPriceController.text = product["buying_price"].toString();
        _sellingPriceController.text = product["selling_price"].toString();
        _descriptionController.text = product["description"] ?? "";
        _supplierController.text = product["supplier"];
        _selectedCategory = product["category"];
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                AppLocalizations.of(context)!.failedToLoadProductMsg + "$e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();

    // Initialize controllers
    _productNameController = TextEditingController();
    _barcodeController = TextEditingController();
    _quantityController = TextEditingController();
    _sellingPriceController = TextEditingController();
    _buyingPriceController = TextEditingController();
    _descriptionController = TextEditingController();
    _supplierController = TextEditingController();

    // Load product data
    _loadProductData();
  }

  @override
  void dispose() {
    _productNameController.dispose();
    _barcodeController.dispose();
    _quantityController.dispose();
    _sellingPriceController.dispose();
    _buyingPriceController.dispose();
    _descriptionController.dispose();
    _supplierController.dispose();
    super.dispose();
  }

  void _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.plzSelectCategory),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final updatedData = {
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
      await ProductApi.updateProduct(int.parse(widget.productId), updatedData);

      widget.onProductUpdated();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.productUpdatedMsg),
          backgroundColor: Colors.green,
        ),
      );

      widget.onNavigateBack(); // go back to list
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              AppLocalizations.of(context)!.failedToUpdateProductMsg + "$e"),
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
          title: AppLocalizations.of(context)!.editProduct,
          description: AppLocalizations.of(context)!.updateDetails,
          actions: [
            TextButton.icon(
              onPressed: widget.onNavigateBack,
              icon: const Icon(Icons.arrow_back),
              label: Text(AppLocalizations.of(context)!.backToProductList),
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
                    // Action Buttons
                    Row(
                      children: [
                        PrimaryButton(
                          onPressed: _handleSave,
                          child:
                              Text(AppLocalizations.of(context)!.saveChanges),
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
                          child: Text(AppLocalizations.of(context)!.cancel),
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
            hintStyle: const TextStyle(
              color: Colors.grey, // ← this is what you want
            ),
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
              borderSide:
                  const BorderSide(color: AppTheme.primaryBlue, width: 2),
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
                borderSide:
                    const BorderSide(color: AppTheme.primaryBlue, width: 2),
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
