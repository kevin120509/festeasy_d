import 'package:festeasy/features/requests/data/models/request_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RequestModel', () {
    test('should correctly parse JSON with nested eventos data', () {
      // Simulate the JSON response from Supabase with the joined table
      final jsonMap = {
        'id': 'request-123',
        'cliente_usuario_id': 'user-123',
        'evento_id': 'event-123',
        'categoria_servicio_id': 'cat-123',
        'titulo': 'My Request',
        'descripcion': 'Request description',
        'especificaciones': {'color': 'red'},
        'presupuesto_estimado': 1000.0,
        'estado': 'abierta',
        'expira_en': '2025-12-31T23:59:59.000Z',
        'creado_en': '2025-01-01T10:00:00.000Z',
        'actualizado_en': '2025-01-01T10:00:00.000Z',
        'eventos': {
          'id': 'event-123',
          'titulo': 'My Event',
          'tipo_evento_id': 'type-123',
          'fecha_evento': '2025-11-18',
          'hora_evento': '18:00:00',
          'nombre_lugar': 'Hotel Plaza',
          'direccion': '123 Main St',
          'numero_invitados': 100,
          'presupuesto_total': 5000.0,
          'estado': 'planning',
        },
      };

      final result = RequestModel.fromJson(jsonMap);

      // Verify direct fields
      expect(result.id, 'request-123');
      expect(result.title, 'My Request');
      expect(result.status, 'abierta');

      // Verify nested fields from 'eventos'
      expect(result.eventDate, DateTime(2025, 11, 18));
      expect(result.eventTime, '18:00:00');
      expect(result.location, 'Hotel Plaza');
      expect(result.address, '123 Main St'); // New field
      expect(result.guestCount, 100);
      expect(result.eventTypeId, 'type-123'); // New field
      expect(result.totalBudget, 5000.0); // New field
      expect(result.eventStatus, 'planning'); // New field
    });

    test('should handle missing optional nested fields', () {
      final jsonMap = {
        'id': 'request-123',
        'cliente_usuario_id': 'user-123',
        'evento_id': 'event-123',
        'categoria_servicio_id': 'cat-123',
        'titulo': 'My Request',
        'descripcion': 'Request description',
        'estado': 'abierta',
        'creado_en': '2025-01-01T10:00:00.000Z',
        'actualizado_en': '2025-01-01T10:00:00.000Z',
        'eventos': {
          // Missing optional fields like address, budget
          'fecha_evento': '2025-11-18',
        },
      };

      final result = RequestModel.fromJson(jsonMap);

      expect(result.address, null);
      expect(result.totalBudget, null);
      expect(result.eventDate, DateTime(2025, 11, 18));
    });
  });
}
