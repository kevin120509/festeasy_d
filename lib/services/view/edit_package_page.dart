import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../data/models/provider_package_model.dart';
import '../data/datasources/provider_packages_remote_datasource.dart';

class EditPackagePage extends StatefulWidget {
  final ProviderPackage? package;
  const EditPackagePage({super.key, this.package});

  @override
  State<EditPackagePage> createState() => _EditPackagePageState();
}

class _EditPackagePageState extends State<EditPackagePage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _descController;
  late final TextEditingController _priceController;
  bool _saving = false;
  String? _error;

  // UUID de ejemplo para la categoría "Mobiliario"
  static const String mobiliarioCategoryId = '11111111-1111-1111-1111-111111111111';
  String? _selectedCategoryId;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.package?.name ?? '');
    _descController = TextEditingController(text: widget.package?.description ?? '');
    _priceController = TextEditingController(text: widget.package?.basePrice.toString() ?? '');
    _selectedCategoryId = widget.package?.categoryId.isNotEmpty == true
        ? widget.package!.categoryId
        : null;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCategoryId == null || _selectedCategoryId!.isEmpty) {
      setState(() { _error = 'Debes seleccionar una categoría.'; });
      return;
    }
    setState(() { _saving = true; _error = null; });
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      setState(() { _error = 'Usuario no autenticado'; _saving = false; });
      return;
    }
    final ds = ProviderPackagesRemoteDatasource(supabaseClient: Supabase.instance.client);
    try {
      final pkg = ProviderPackage(
        id: widget.package?.id ?? '',
        providerUserId: user.id,
        categoryId: _selectedCategoryId!,
        name: _nameController.text.trim(),
        description: _descController.text.trim().isEmpty ? null : _descController.text.trim(),
        basePrice: double.tryParse(_priceController.text) ?? 0,
        status: widget.package?.status ?? 'borrador',
        createdAt: widget.package?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
      );
      if (widget.package == null) {
        await ds.createPackage(pkg);
      } else {
        await ds.updatePackage(pkg);
      }
      if (mounted) Navigator.of(context).pop(true);
    } catch (e) {
      setState(() { _error = 'Error: $e'; _saving = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.package == null ? 'Agregar Paquete' : 'Editar Paquete'),
        backgroundColor: const Color(0xFFEF4444),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DropdownButtonFormField<String>(
                value: _selectedCategoryId,
                items: const [
                  DropdownMenuItem(
                    value: mobiliarioCategoryId,
                    child: Text('Mobiliario'),
                  ),
                ],
                onChanged: (value) => setState(() => _selectedCategoryId = value),
                decoration: const InputDecoration(labelText: 'Categoría *'),
                validator: (v) => v == null || v.isEmpty ? 'Selecciona una categoría' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nombre del paquete *'),
                validator: (v) => v == null || v.trim().isEmpty ? 'Requerido' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descController,
                decoration: const InputDecoration(labelText: 'Descripción'),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Precio base *'),
                keyboardType: TextInputType.number,
                validator: (v) => (double.tryParse(v ?? '') ?? 0) <= 0 ? 'Precio inválido' : null,
              ),
              const SizedBox(height: 24),
              if (_error != null) ...[
                Text(_error!, style: const TextStyle(color: Colors.red)),
                const SizedBox(height: 12),
              ],
              ElevatedButton(
                onPressed: _saving ? null : _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFEF4444),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _saving
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
                      )
                    : Text(widget.package == null ? 'Agregar' : 'Guardar cambios'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
