import 'package:festeasy/services/data/models/provider_package_model.dart';
import 'package:festeasy/services/data/datasources/provider_packages_remote_datasource.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:festeasy/features/requests/presentation/widgets/simple_header.dart';
import 'package:festeasy/shared/widgets/global_components.dart';
import 'package:flutter/material.dart';

import 'package:festeasy/services/view/edit_package_page.dart';

class ServicesPage extends StatefulWidget {
  const ServicesPage({super.key});

  @override
  State<ServicesPage> createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage> {
  late final ProviderPackagesRemoteDatasource datasource;
  List<ProviderPackage> _packages = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    datasource = ProviderPackagesRemoteDatasource(supabaseClient: Supabase.instance.client);
    _loadPackages();
  }

  Future<void> _loadPackages() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      setState(() {
        _error = 'Usuario no autenticado';
        _loading = false;
      });
      return;
    }
    try {
      final pkgs = await datasource.getPackagesForProvider(user.id);
      setState(() {
        _packages = pkgs;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Error al cargar servicios: $e';
        _loading = false;
      });
    }
  }

  Future<void> _deletePackage(String packageId) async {
    await datasource.deletePackage(packageId);
    _loadPackages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: const SimpleHeader(title: 'Mis Servicios'),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!))
              : _packages.isEmpty
                  ? const Center(child: Text('No tienes servicios registrados.'))
                  : RefreshIndicator(
                      onRefresh: _loadPackages,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _packages.length,
                        itemBuilder: (context, index) {
                          final pkg = _packages[index];
                          return _ServiceCard(
                            package: pkg,
                            onDelete: () => _deletePackage(pkg.id),
                          );
                        },
                      ),
                    ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.of(context).push<bool>(
            MaterialPageRoute(
              builder: (_) => EditPackagePage(),
            ),
          );
          if (result == true) _loadPackages();
        },
        backgroundColor: const Color(0xFFEF4444),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}


class _ServiceCard extends StatelessWidget {
  const _ServiceCard({required this.package, required this.onDelete});

  final ProviderPackage package;
  final VoidCallback onDelete;

  void _showDeleteDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Eliminar servicio'),
          content: Text('¿Estás seguro de eliminar "${package.name}"?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Eliminar'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
                onDelete();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: GestureDetector(
        onTap: () async {
          final result = await Navigator.of(context).push<bool>(
            MaterialPageRoute(
              builder: (_) => EditPackagePage(package: package),
            ),
          );
          if (result == true && context.mounted) {
            // ignore: invalid_use_of_protected_member
            (context.findAncestorStateOfType<_ServicesPageState>())?._loadPackages();
          }
        },
        child: CustomCard(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        package.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        package.description ?? '',
                        style: const TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        '\$${package.basePrice.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Color(0xFFEF4444),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                InkWell(
                  onTap: () => _showDeleteDialog(context),
                  customBorder: const CircleBorder(),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Color(0xFFFEE2E2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.delete_outline,
                      size: 20,
                      color: Color(0xFFEF4444),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
