# Guía de Uso: Sistema de Cotizaciones

## Resumen

El sistema de cotizaciones permite a los clientes recibir propuestas de precio de múltiples proveedores y aceptar la que más les convenga.

---

## Para Clientes

### Ver Cotizaciones Recibidas

```dart
import 'package:festeasy/features/quotes/presentation/pages/quotes_list_page.dart';

// Navegar a la lista de cotizaciones
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => QuotesListPage(
      requestId: 'uuid-de-tu-request',
      requestTitle: 'Título de tu solicitud',
    ),
  ),
);
```

### Aceptar una Cotización

```dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:festeasy/features/quotes/domain/usecases/accept_quote.dart';

// Obtener el use case
final acceptQuote = context.read<AcceptQuote>();

// Aceptar cotización
final result = await acceptQuote('quote-id-uuid');

result.fold(
  (failure) => print('Error: ${failure.message}'),
  (quote) {
    print('¡Cotización aceptada!');
    // Automáticamente crea payment y hired_service en Supabase
  },
);
```

---

## Para Proveedores

### Crear Nueva Cotización

```dart
import 'package:festeasy/features/quotes/presentation/pages/create_quote_page.dart';

// Navegar al formulario
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => CreateQuotePage(
      requestId: 'uuid-del-request',
      requestTitle: 'Título de la solicitud',
      providerId: 'tu-provider-id-uuid',
    ),
  ),
);
```

### Enviar Cotización Programáticamente

```dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:festeasy/features/quotes/domain/usecases/create_quote.dart';
import 'package:festeasy/features/quotes/data/models/quote_model.dart';

final createQuote = context.read<CreateQuote>();

final newQuote = QuoteModel(
  id: '', // Se genera automáticamente
  requestId: 'request-uuid',
  providerId: 'provider-uuid',
  proposedPrice: 5000.00,
  notes: 'Incluye decoración completa',
  validUntil: DateTime.now().add(Duration(days: 7)),
  status: 'pending',
  createdAt: DateTime.now(),
  updatedAt: DateTime.now(),
);

final result = await createQuote(newQuote);
```

### Ver Mis Cotizaciones

```dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:festeasy/features/quotes/domain/usecases/get_quotes_for_request.dart';

final getQuotes = context.read<GetQuotesForRequest>();
final result = await getQuotes('request-id');

result.fold(
  (failure) => print('Error'),
  (quotes) {
    for (var quote in quotes) {
      print('Quote ${quote.id}: \$${quote.proposedPrice} - ${quote.status}');
    }
  },
);
```

---

## Integración en Pantallas Existentes

### Ejemplo: Agregar Botón en Request Detail

```dart
// En la página de detalle de request
ElevatedButton(
  onPressed: () {
    // Si es cliente
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QuotesListPage(
          requestId: request.id,
          requestTitle: request.title,
        ),
      ),
    );
  },
  child: const Text('Ver Cotizaciones'),
)

// Si es proveedor
ElevatedButton(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateQuotePage(
          requestId: request.id,
          requestTitle: request.title,
          providerId: currentUserProviderId,
        ),
      ),
    );
  },
  child: const Text('Enviar Cotización'),
)
```

---

## Flujo Completo

```
1. Cliente crea REQUEST
   ↓
2. Proveedores ven request en "Solicitudes Abiertas"
   ↓
3. Proveedor abre CreateQuotePage
   ↓
4. Llena precio, notas, fecha de expiración
   ↓
5. Submit → CreateQuote use case
   ↓
6. Quote guardado en Supabase
   ↓
7. [TRIGGER] Request.status → 'quoted'
   ↓
8. Cliente abre QuotesListPage
   ↓
9. Ve lista de cotizaciones
   ↓
10. Cliente acepta una → AcceptQuote
    ↓
11. [TRIGGER] Crea Payment + HiredService
    ↓
12. ✅ Servicio apartado
```

---

## Campos de Quote

```dart
class Quote {
  String id;              // UUID
  String requestId;       // FK a requests
  String providerId;      // FK a profiles
  String? serviceId;      // FK a services (opcional)
  double proposedPrice;   // Precio propuesto
  Map? breakdown;         // Desglose de precios
  String? notes;          // Observaciones
  DateTime? validUntil;   // Fecha de expiración
  String status;          // 'pending' | 'accepted' | 'rejected' | 'expired'
  DateTime createdAt;
  DateTime updatedAt;
}
```

---

## Estados de Cotización

- **pending**: Enviada, esperando respuesta del cliente
- **accepted**: Cliente aceptó (se crea payment y hired_service)
- **rejected**: Cliente rechazó
- **expired**: Pasó la fecha de validUntil

---

## Notas Importantes

1. **Dependency Injection**: Todas las páginas y use cases ya están configurados en `app.dart`
2. **RLS**: Solo el cliente del request puede ver/aceptar quotes. Solo el proveedor puede crear quotes.
3. **Triggers**: Al aceptar una quote, Supabase automáticamente crea el payment y hired_service
4. **IDs**: Todos los IDs son UUIDs (String), no int

---

## Ejemplo Completo de Widget

```dart
class RequestDetailPage extends StatelessWidget {
  final String requestId;
  final bool isProvider;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Detalle de Solicitud')),
      body: Column(
        children: [
          // ... Detalles del request
          
          SizedBox(height: 20),
          
          // Botón dinámico según rol
          ElevatedButton(
            onPressed: () {
              if (isProvider) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CreateQuotePage(
                      requestId: requestId,
                      requestTitle: 'Mi servicio',
                      providerId: 'current-user-id',
                    ),
                  ),
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QuotesListPage(
                      requestId: requestId,
                      requestTitle: 'Mi solicitud',
                    ),
                  ),
                );
              }
            },
            child: Text(
              isProvider ? 'Enviar Cotización' : 'Ver Cotizaciones',
            ),
          ),
        ],
      ),
    );
  }
}
```

---

## Troubleshooting

### "No aparecen cotizaciones"
- Verificar que el SQL fue ejecutado en Supabase
- Verificar que el usuario esté autenticado
- Revisar RLS policies en Supabase

### "Error al crear cotización"
- Verificar que providerId sea válido
- Verificar que requestId exista
- Revisar logs de Supabase

### "Error al aceptar cotización"
- Verificar que el usuario sea el dueño del request
- Verificar que la quote esté en status 'pending'
- Revisar trigger en Supabase
