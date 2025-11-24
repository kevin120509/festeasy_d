import 'package:festeasy/features/requests/presentation/widgets/simple_header.dart';
import 'package:festeasy/shared/widgets/global_components.dart';
import 'package:flutter/material.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SimpleHeader(title: 'Editar Información'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildTextField(
              label: 'Nombre del Negocio',
              initialValue: 'FestaFusion Catering',
            ),
            const SizedBox(height: 16),
            _buildTextField(
              label: 'Correo de Contacto',
              initialValue: 'contacto@festafusion.com',
            ),
            const SizedBox(height: 16),
            _buildTextField(
              label: 'Teléfono',
              initialValue: '+52 999 123 4567',
            ),
            const SizedBox(height: 16),
            _buildTextField(
              label: 'Descripción Corta',
              initialValue:
                  'Expertos en catering para bodas y eventos corporativos.',
              maxLines: 3,
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16).copyWith(bottom: 32),
        child: PrimaryButton(
          title: 'Guardar Cambios',
          onPress: () {
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String initialValue,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: initialValue,
          maxLines: maxLines,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}
