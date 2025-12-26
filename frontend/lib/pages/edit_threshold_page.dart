import 'package:flutter/material.dart';
import '../widgets/page_header.dart';
import '../widgets/primary_button.dart';
import '../theme/app_theme.dart';
import '../services/threshold_api.dart';
import '../assets/colors.dart';

class EditThresholdPage extends StatefulWidget {
  final String thresholdId;
  final VoidCallback? onNavigateBack;
  final VoidCallback? onThresholdUpdated;

  const EditThresholdPage({
    super.key,
    required this.thresholdId,
    this.onNavigateBack,
    this.onThresholdUpdated,
  });

  @override
  State<EditThresholdPage> createState() => _EditThresholdPageState();
}

class _EditThresholdPageState extends State<EditThresholdPage> {
  final _formKey = GlobalKey<FormState>();
  final _thresholdValueController = TextEditingController();
  
  bool _isLoading = true;
  bool _isSaving = false;
  Map<String, dynamic>? _threshold;

  @override
  void initState() {
    super.initState();
    _loadThreshold();
  }

  @override
  void dispose() {
    _thresholdValueController.dispose();
    super.dispose();
  }

  Future<void> _loadThreshold() async {
    try {
      final threshold = await ThresholdApi.getThresholdById(int.parse(widget.thresholdId));
      setState(() {
        _threshold = threshold;
        _thresholdValueController.text = threshold['threshold_value'].toString();
        _isLoading = false;
      });
    } catch (e) {
      print("Error loading threshold: $e");
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading threshold: $e')),
        );
      }
    }
  }

  Future<void> _updateThreshold() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final thresholdType = _threshold?['threshold_type'] ?? '';
    final entityName = _threshold?['entity_name'] ?? 'Unknown';
    final oldValue = _threshold?['threshold_value'] ?? 0;
    final newValue = int.parse(_thresholdValueController.text);

    // Show warning dialog before updating
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: AppColors.orange),
            const SizedBox(width: 8),
            const Text('Confirm Threshold Update'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'You are about to update the threshold for:',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            Text('• ${thresholdType == 'product' ? 'Product' : 'Category'}: $entityName'),
            Text('• Old threshold: $oldValue'),
            Text('• New threshold: $newValue'),
            const SizedBox(height: 16),
            if (thresholdType == 'category') ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.orange.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: AppColors.orange, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'This will update ALL products in the "$entityName" category!',
                        style: TextStyle(
                          color: AppColors.orange,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ] else ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.primaryBlue.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: AppColors.primaryBlue, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'This will update the threshold for "$entityName" only.',
                        style: TextStyle(
                          color: AppColors.primaryBlue,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBlue,
              foregroundColor: Colors.white,
            ),
            child: const Text('Update'),
          ),
        ],
      ),
    );

    if (confirmed != true) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      await ThresholdApi.updateThreshold(
        thresholdId: int.parse(widget.thresholdId),
        thresholdValue: newValue,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Threshold updated successfully')),
        );
        widget.onThresholdUpdated?.call();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating threshold: $e')),
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

  Future<void> _removeThreshold() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Threshold'),
        content: Text(
          'Are you sure you want to remove this threshold for "${_threshold?['entity_name']}"?\n\n'
          'Note: For product thresholds, this will set the threshold to null. '
          'For category thresholds, this will delete the threshold entirely.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Remove'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await ThresholdApi.deleteThreshold(int.parse(widget.thresholdId));
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Threshold removed successfully')),
          );
          widget.onThresholdUpdated?.call();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error removing threshold: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PageHeader(
          title: 'Edit Threshold',
          description: 'Modify the low-stock threshold value',
          actions: [
            TextButton.icon(
              onPressed: widget.onNavigateBack,
              icon: const Icon(Icons.arrow_back, size: 20),
              label: const Text('Back to List'),
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
                                const Text(
                                  'Threshold Information',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 24),
                                _buildInfoCard(),
                                const SizedBox(height: 24),
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

  Widget _buildInfoCard() {
    final thresholdType = _threshold?['threshold_type'] ?? '';
    final entityName = _threshold?['entity_name'] ?? 'Unknown';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryBlue.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.primaryBlue.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: thresholdType == 'product'
                      ? AppColors.primaryBlue.withOpacity(0.1)
                      : AppColors.brownGold.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  thresholdType == 'product' ? 'Product Threshold' : 'Category Threshold',
                  style: TextStyle(
                    color: thresholdType == 'product' ? AppColors.primaryBlue : AppColors.brownGold,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(
                thresholdType == 'product' ? Icons.inventory_2_outlined : Icons.category_outlined,
                size: 20,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: 8),
              Text(
                entityName,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
            ],
          ),
          if (thresholdType == 'category') ...[
            const SizedBox(height: 8),
            Text(
              'Note: Updating this threshold will apply to all products in this category',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary.withOpacity(0.8),
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildThresholdValueField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Threshold Value',
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
            hintText: 'Enter threshold value...',
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
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a threshold value';
            }
            final intValue = int.tryParse(value);
            if (intValue == null || intValue <= 0) {
              return 'Please enter a valid positive number';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton.icon(
          onPressed: _isSaving ? null : _removeThreshold,
          icon: const Icon(Icons.delete_outline, size: 20),
          label: const Text('Remove Threshold'),
          style: TextButton.styleFrom(
            foregroundColor: Colors.red,
          ),
        ),
        Row(
          children: [
            TextButton(
              onPressed: _isSaving ? null : widget.onNavigateBack,
              child: const Text('Cancel'),
            ),
            const SizedBox(width: 16),
            PrimaryButton(
              onPressed: _isSaving ? null : _updateThreshold,
              child: _isSaving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text('Update Threshold'),
            ),
          ],
        ),
      ],
    );
  }
}
