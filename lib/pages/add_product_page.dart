  final List<String> _categories = [
    'Electronics',
    'Clothing',
    'Food & Beverages',
    'Office Supplies',
    'Furniture',
  ];

  final List<String> _suppliers = [
    'Supplier A',
    'Supplier B',
    'Supplier C',
    'Supplier D',
  ];

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


  final data = {
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
    await ProductApi.addProduct(data);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Product added successfully!'),
        backgroundColor: Colors.green,
      ),
    );

    _resetForm();

    // Optional: Navigate back
    Navigator.pop(context, true); // tells previous screen to refresh list

  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Failed to add product: $e'),
        backgroundColor: Colors.red,
      ),
    );
  }
}

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

