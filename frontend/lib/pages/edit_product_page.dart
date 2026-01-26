import 'package:flutter/material.dart';
import 'package:se_project/l10n/app_localizations.dart';
import 'package:se_project/services/categories_api.dart';
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

  List<Map<String, dynamic>> _categories = [];
  Map<String, dynamic>? _selectedCategory;
  bool _loadingCategories = true;

  Future<void> _loadCategories() async {
    try {
      final data = await await CategoryApi.getCategories();
      setState(() {
        _categories = data;
        _loadingCategories = false;

        // Ensure selected category exists in list
        if (_selectedCategory != null) {
          _selectedCategory = _categories.firstWhere(
            (c) => c['category_id'] == _selectedCategory!['category_id'],
            orElse: () => _selectedCategory!,
          );
        }
      });
    } catch (e) {
      setState(() {
        _loadingCategories = false;
      });
    }
  }

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
        _selectedCategory = {
          'category_id': product["category_id"],
          'category_name': product["category_name"]
        };
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

    _productNameController = TextEditingController();
    _barcodeController = TextEditingController();
    _quantityController = TextEditingController();
    _sellingPriceController = TextEditingController();
    _buyingPriceController = TextEditingController();
    _descriptionController = TextEditingController();
    _supplierController = TextEditingController();

    // Load product first, then categories
    _loadProductData().then((_) => _loadCategories());
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
          content: Text(AppLocalizations.of(context)!.selectCategoryMsg),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final updatedData = {
      "name": _productNameController.text,
      "barcode": _barcodeController.text,
      "category_id": _selectedCategory!['category_id'],
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

      widget.onNavigateBack();
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
                              _loadingCategories
                                  ? const CircularProgressIndicator()
                                  : DropdownButtonFormField<
                                      Map<String, dynamic>>(
                                      value: _selectedCategory,
                                      hint: Text(AppLocalizations.of(context)!
                                          .category),
                                      items: _categories.map((cat) {
                                        return DropdownMenuItem<
                                            Map<String, dynamic>>(
                                          value: cat,
                                          child: Text(cat['category_name']),
                                        );
                                      }).toList(),
                                      onChanged: (val) => setState(
                                          () => _selectedCategory = val),
                                      validator: (val) => val == null
                                          ? AppLocalizations.of(context)!
                                              .selectCategoryMsg
                                          : null,
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
                              Text(AppLocalizations.of(context)!.saveChanges),
                        ),
                        const SizedBox(width: 12),
                        TextButton(
                          onPressed: widget.onNavigateBack,
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
            hintStyle: const TextStyle(color: Colors.grey),
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
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
  }
}
