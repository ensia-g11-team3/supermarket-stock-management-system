import 'package:flutter/material.dart';
import '../widgets/page_header.dart';
import '../widgets/primary_button.dart';
import '../theme/app_theme.dart';
import '../services/batch_api.dart';
import 'dart:io';

class CreateBatchPage extends StatefulWidget {
  final String productId;
  final String productName;
  final String? batchId; // null for create, has value for edit
  final VoidCallback? onNavigateBack;
  final VoidCallback? onBatchSaved;

  const CreateBatchPage({
    super.key,
    required this.productId,
    required this.productName,
    this.batchId,
    this.onNavigateBack,
    this.onBatchSaved,
  });

  @override
  State<CreateBatchPage> createState() => _CreateBatchPageState();
}

class _CreateBatchPageState extends State<CreateBatchPage> {
  final _formKey = GlobalKey<FormState>();
  final _quantityController = TextEditingController(text: '0');
  
  DateTime? _manufactureDate;
  DateTime? _expiryDate;
  bool _isLoading = false;

  bool get _isEditMode => widget.batchId != null;

  @override
  void initState() {
    super.initState();
    if (_isEditMode) {
      _loadBatchData();
    }
  }

  Future<void> _loadBatchData() async {
    setState(() => _isLoading = true);
    try {
      final batch = await BatchApi.getBatchById(int.parse(widget.batchId!));
      setState(() {
        _quantityController.text = batch['quantity'].toString();
        
        // Handle both 'manufacture_date' and 'manifacture_date' (typo in DB)
        final mfgDate = batch['manufacture_date'] ?? batch['manifacture_date'];
        if (mfgDate != null) {
          _manufactureDate = HttpDate.parse(mfgDate.toString());
        }
        
        if (batch['expiry_date'] != null) {
          _expiryDate = HttpDate.parse(batch['expiry_date'].toString());
        }
        
        _isLoading = false;
      });
    } catch (e) {
      print("Error loading batch: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load batch: $e'), backgroundColor: Colors.red),
        );
      }
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, bool isManufactureDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isManufactureDate 
          ? (_manufactureDate ?? DateTime.now()) 
          : (_expiryDate ?? DateTime.now().add(const Duration(days: 365))),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    
    if (picked != null) {
      setState(() {
        if (isManufactureDate) {
          _manufactureDate = picked;
        } else {
          _expiryDate = picked;
        }
      });
    }
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // Prepare the data to send to the API
      final batchData = {
        'product_id': int.parse(widget.productId),
        'quantity': int.parse(_quantityController.text),
        'manufacture_date': _manufactureDate?.toIso8601String().split('T')[0],
        'expiry_date': _expiryDate?.toIso8601String().split('T')[0],
      };

      print("Sending batch data: $batchData"); // Debug print

      if (_isEditMode) {
        await BatchApi.updateBatch(int.parse(widget.batchId!), batchData);
      } else {
        await BatchApi.createBatch(batchData);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_isEditMode ? 'Batch updated successfully!' : 'Batch created successfully!'),
            backgroundColor: Colors.green,
          ),
        );

        // Call the callback to refresh the list and navigate back
        widget.onBatchSaved?.call();
      }
    } catch (e) {
      print("Error saving batch: $e"); // Debug print
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save batch: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Not selected';
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PageHeader(
          title: _isEditMode ? 'Edit Batch' : 'Create New Batch',
          description: 'Product: ${widget.productName}',
          actions: [
            TextButton.icon(
              onPressed: widget.onNavigateBack,
              icon: const Icon(Icons.arrow_back),
              label: const Text('Back to Batches'),
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
                      child: Form(
                        key: _formKey,
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(32),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Quantity Field
                                _buildTextField(
                                  controller: _quantityController,
                                  label: 'Quantity',
                                  hint: 'Enter batch quantity',
                                  keyboardType: TextInputType.number,
                                  isRequired: true,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter quantity';
                                    }
                                    if (int.tryParse(value) == null) {
                                      return 'Please enter a valid number';
                                    }
                                    if (int.parse(value) <= 0) {
                                      return 'Quantity must be greater than 0';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 24),

                                // Manufacture Date
                                _buildDateField(
                                  label: 'Manufacture Date',
                                  date: _manufactureDate,
                                  onTap: () => _selectDate(context, true),
                                  isRequired: false,
                                ),
                                const SizedBox(height: 24),

                                // Expiry Date
                                _buildDateField(
                                  label: 'Expiry Date',
                                  date: _expiryDate,
                                  onTap: () => _selectDate(context, false),
                                  isRequired: false,
                                ),
                                const SizedBox(height: 32),

                                // Action Buttons
                                Row(
                                  children: [
                                    PrimaryButton(
                                      onPressed: _isLoading ? null : _handleSave,
                                      child: _isLoading
                                          ? const SizedBox(
                                              width: 20,
                                              height: 20,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                              ),
                                            )
                                          : Text(_isEditMode ? 'Update Batch' : 'Create Batch'),
                                    ),
                                    const SizedBox(width: 12),
                                    TextButton(
                                      onPressed: _isLoading ? null : widget.onNavigateBack,
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
                ' *',
                style: TextStyle(color: Colors.red),
              ),
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
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
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateField({
    required String label,
    required DateTime? date,
    required VoidCallback onTap,
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
              const Text(
                ' *',
                style: TextStyle(color: Colors.red),
              ),
          ],
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppTheme.inputBackground,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppTheme.borderColor),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatDate(date),
                  style: TextStyle(
                    fontSize: 14,
                    color: date == null ? AppTheme.textSecondary : AppTheme.textPrimary,
                  ),
                ),
                const Icon(Icons.calendar_today, size: 20, color: AppTheme.primaryBlue),
              ],
            ),
          ),
        ),
      ],
    );
  }
}