import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/provider_package_model.dart';
import '../models/package_item_model.dart';

class ProviderPackagesRemoteDatasource {
  final SupabaseClient supabaseClient;
  ProviderPackagesRemoteDatasource({required this.supabaseClient});

  Future<List<ProviderPackage>> getPackagesForProvider(String providerUserId) async {
    final response = await supabaseClient
        .from('paquetes_proveedor')
        .select('*')
        .eq('proveedor_usuario_id', providerUserId)
        .order('creado_en', ascending: false);
    return (response as List)
        .map((json) => ProviderPackage.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<ProviderPackage> createPackage(ProviderPackage pkg) async {
    final response = await supabaseClient
        .from('paquetes_proveedor')
        .insert(pkg.toJson(forInsert: true))
        .select()
        .single();
    return ProviderPackage.fromJson(response);
  }

  Future<ProviderPackage> updatePackage(ProviderPackage pkg) async {
    final response = await supabaseClient
        .from('paquetes_proveedor')
        .update(pkg.toJson())
        .eq('id', pkg.id)
        .select()
        .single();
    return ProviderPackage.fromJson(response);
  }

  Future<void> deletePackage(String packageId) async {
    await supabaseClient.from('paquetes_proveedor').delete().eq('id', packageId);
  }

  Future<List<PackageItem>> getItemsForPackage(String packageId) async {
    final response = await supabaseClient
        .from('items_paquete')
        .select('*')
        .eq('paquete_id', packageId)
        .order('creado_en', ascending: true);
    return (response as List)
        .map((json) => PackageItem.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<PackageItem> createItem(PackageItem item) async {
    final response = await supabaseClient
        .from('items_paquete')
        .insert(item.toJson())
        .select()
        .single();
    return PackageItem.fromJson(response);
  }

  Future<PackageItem> updateItem(PackageItem item) async {
    final response = await supabaseClient
        .from('items_paquete')
        .update(item.toJson())
        .eq('id', item.id)
        .select()
        .single();
    return PackageItem.fromJson(response);
  }

  Future<void> deleteItem(String itemId) async {
    await supabaseClient.from('items_paquete').delete().eq('id', itemId);
  }
}
