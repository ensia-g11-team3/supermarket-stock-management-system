import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:se_project/l10n/app_localizations.dart';
import 'dart:convert';
import '../widgets/page_header.dart';
import '../widgets/primary_button.dart';
import '../theme/app_theme.dart';
import '../services/threshold_api.dart';
import '../services/api_service.dart';
import '../assets/colors.dart';

class AddThresholdPage extends StatefulWidget {
  final VoidCallback? onNavigateBack;
  final VoidCallback? onThresholdCreated;

  const AddThresholdPage({
    super.key,
    this.onNavigateBack,
    this.onThresholdCreated,
  });

  @override
  State<AddThresholdPage> createState() => _AddThresholdPageState();
}

class _AddThresholdPageState extends State<AddThresholdPage> {
  final _formKey = GlobalKey<FormState>();
  String _thresholdType = 'product';
  String? _selectedProduct;
  String? _selectedCategory;
  final _thresholdValueController = TextEditingController();

  List<Map<String, dynamic>> _products = [];
  List<Map<String, dynamic>> _categories = [];
  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _thresholdValueController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    try {
      // Load products
      final productsResponse = await http.get(
        Uri.parse('${ApiService.baseUrl}/api/products/products'),
      );

      // Load categories
      final categoriesResponse = await http.get(
        Uri.parse('${ApiService.baseUrl}/api/categories/'),
      );

      if (productsResponse.statusCode == 200 &&
          categoriesResponse.statusCode == 200) {
        final productsData = json.decode(productsResponse.body);
        final categoriesData = json.decode(categoriesResponse.body);

        setState(() {
          _products =
              List<Map<String, dynamic>>.from(productsData['products'] ?? []);
          _categories = List<Map<String, dynamic>>.from(categoriesData ?? []);
          _isLoading = false;
        });
      }
    } catch (e) {
      print(AppLocalizations.of(context)!.errorLoadingData + "$e");
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text(AppLocalizations.of(context)!.errorLoadingData + '$e')),
        );
      }
    }
  }

  Future<void> _saveThreshold() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_thresholdType == 'product' && _selectedProduct == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(AppLocalizations.of(context)!.pleaseSelectProduct)),
      );
      return;
    }

    if (_thresholdType == 'category' && _selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(AppLocalizations.of(context)!.pleaseSelectCategory)),
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      await ThresholdApi.createThreshold(
        thresholdType: _thresholdType,
        productId:
            _thresholdType == 'product' ? int.parse(_selectedProduct!) : null,
        categoryName: _thresholdType == 'category' ? _selectedCategory : null,
        thresholdValue: int.parse(_thresholdValueController.text),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text(AppLocalizations.of(context)!.thresholdCreateSuccess)),
        );
        widget.onThresholdCreated?.call();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  AppLocalizations.of(context)!.errorCreatingThreshold + '$e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PageHeader(
          title: AppLocalizations.of(context)!.addThreshold,
          description: AppLocalizations.of(context)!.addThresholdDescription,
          actions: [
            TextButton.icon(
              onPressed: widget.onNavigateBack,
              icon: const Icon(Icons.arrow_back, size: 20),
              label: Text(AppLocalizations.of(context)!.backToList),
              style: TextButton.styleFrom(
                foregroundColor: AppTheme.primaryBlue,
              ),
            ),
          ],
        ),
        Expanded(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(32),
                  child: Center(
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 800),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(32),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.thresholdInfo,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 24),
                                _buildThresholdTypeSelector(),
                                const SizedBox(height: 24),
                                if (_thresholdType == 'product') ...[
                                  _buildProductSelector(),
                                  const SizedBox(height: 24),
                                ] else ...[
                                  _buildCategorySelector(),
                                  const SizedBox(height: 24),
                                ],
                                _buildThresholdValueField(),
                                const SizedBox(height: 32),
                                _buildActionButtons(),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildThresholdTypeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.thresholdType,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: RadioListTile<String>(
                title: Text(AppLocalizations.of(context)!.product),
                subtitle:
                    Text(AppLocalizations.of(context)!.setProductThreshold),
                value: 'product',
                groupValue: _thresholdType,
                onChanged: (value) {
                  setState(() {
                    _thresholdType = value!;
                    _selectedProduct = null;
                    _selectedCategory = null;
                  });
                },
                activeColor: AppTheme.primaryBlue,
              ),
            ),
            Expanded(
              child: RadioListTile<String>(
                title: Text(AppLocalizations.of(context)!.category),
                subtitle:
                    Text(AppLocalizations.of(context)!.setCategoryThreshold),
                value: 'category',
                groupValue: _thresholdType,
                onChanged: (value) {
                  setState(() {
                    _thresholdType = value!;
                    _selectedProduct = null;
                    _selectedCategory = null;
                  });
                },
                activeColor: AppTheme.primaryBlue,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProductSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.selectProduct,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _selectedProduct,
          decoration: InputDecoration(
            hintText: AppLocalizations.of(context)!.chooseProduct,
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
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          items: _products.map((product) {
            return DropdownMenuItem<String>(
              value: product['product_id'].toString(),
              child: Text(product['name']),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedProduct = value;
            });
          },
          validator: (value) {
            if (_thresholdType == 'product' && value == null) {
              return AppLocalizations.of(context)!.pleaseSelectProduct;
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildCategorySelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.selectCategory,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _selectedCategory,
          decoration: InputDecoration(
            hintText: AppLocalizations.of(context)!.chooseCategory,
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
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          items: _categories.map((category) {
            return DropdownMenuItem<String>(
              value: category['category_name'],
              child: Text(category['category_name']),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedCategory = value;
            });
          },
          validator: (value) {
            if (_thresholdType == 'category' && value == null) {
              return AppLocalizations.of(context)!.pleaseSelectCategory;
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildThresholdValueField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.thresholdValue,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _thresholdValueController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: AppLocalizations.of(context)!.enterThresholdValue,
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
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return AppLocalizations.of(context)!.pleaseEnterValue;
            }
            final intValue = int.tryParse(value);
            if (intValue == null || intValue <= 0) {
              return AppLocalizations.of(context)!.pleaseEnterPositive;
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: _isSaving ? null : widget.onNavigateBack,
          child: Text(AppLocalizations.of(context)!.cancel),
        ),
        const SizedBox(width: 16),
        PrimaryButton(
          onPressed: _isSaving ? null : _saveThreshold,
          child: _isSaving
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Text(AppLocalizations.of(context)!.saveThreshold),
        ),
      ],
    );
  }
}
