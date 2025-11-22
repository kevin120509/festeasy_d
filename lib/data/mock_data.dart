// ignore_for_file: public_member_api_docs

class Request {
  const Request({
    required this.id,
    required this.category,
    required this.title,
    required this.description,
    required this.date,
    required this.location,
    required this.address,
    required this.time,
    required this.guests,
    required this.status,
  });

  final int id;
  final String category;
  final String title;
  final String description;
  final String date;
  final String location;
  final String address;
  final String time;
  final int guests;
  final String status;
}

class Service {
  const Service({
    required this.id,
    required this.name,
    required this.desc,
    required this.price,
  });

  final int id;
  final String name;
  final String desc;
  final String price;
}

class Event {
  const Event({
    required this.id,
    required this.title,
    required this.service,
    required this.date,
    required this.time,
    required this.location,
    required this.address,
    required this.clientName,
    required this.clientPhone,
    required this.status,
  });

  final int id;
  final String title;
  final String service;
  final String date;
  final String time;
  final String location;
  final String address;
  final String clientName;
  final String clientPhone;
  final String status;
}

class OngoingRequest {
  const OngoingRequest({
    required this.id,
    required this.title,
    required this.date,
    required this.status,
    required this.statusLabel,
  });

  final int id;
  final String title;
  final String date;
  final String status;
  final String statusLabel;
}

class Chat {
  const Chat({
    required this.id,
    required this.userName,
    required this.lastMessage,
    required this.time,
    required this.unread,
    required this.event,
  });

  final int id;
  final String userName;
  final String lastMessage;
  final String time;
  final int unread;
  final String event;
}

class Message {
  const Message({
    required this.id,
    required this.text,
    required this.sender,
    required this.time,
  });

  final int id;
  final String text;
  final String sender;
  final String time;
}

/// A class containing mock data for the application.
abstract final class MockData {
  /// --- LIST OF NEW REQUESTS ---
  static const List<Request> mockRequests = [
    Request(
      id: 1,
      category: 'Decoración',
      title: 'Boda estilo rústico en el campo',
      description:
          'Cliente necesita decoración completa para una boda. Mesas, sillas, flores, y un arco ceremonial.',
      date: 'Sáb, 25 de Octubre',
      location: 'Hacienda San José',
      address: 'Av. Siempre Viva 123',
      time: '16:00 PM',
      guests: 150,
      status: 'pending',
    ),
    Request(
      id: 2,
      category: 'Catering',
      title: 'Menú de 3 tiempos corporativo',
      description:
          'Solicitud de menú con opción vegetariana para la cena de fin de año.',
      date: 'Vie, 12 de Diciembre',
      location: 'Oficinas Centrales',
      address: 'Calle 60 Norte',
      time: '20:00 PM',
      guests: 80,
      status: 'pending',
    ),
  ];

  /// --- LIST OF SERVICES (For "My Services" screen) ---
  static const List<Service> mockServices = [
    Service(
      id: 1,
      name: 'Fotografía Profesional',
      desc: 'Fotos de alta calidad para tu evento.',
      price: r'$500.00',
    ),
    Service(
      id: 2,
      name: 'Servicio de DJ',
      desc: 'Música y entretenimiento para mantener la fiesta.',
      price: r'$800.00',
    ),
    Service(
      id: 3,
      name: 'Paquete de Catering',
      desc: 'Opciones de comida deliciosa para hasta 50 personas.',
      price: 'A cotizar',
    ),
  ];

  /// --- LIST OF EVENTS (For the Calendar) ---
  static const List<Event> mockEvents = [
    Event(
      id: 101,
      title: 'Boda de Ana & Luis',
      service: 'Catering, DJ',
      date: '15 Oct 2024',
      time: '18:00',
      location: "Salón 'El Encanto'",
      address: 'Av. Siempre Viva 123',
      clientName: 'Juan Pérez',
      clientPhone: '+52 999 123 4567',
      status: 'confirmed',
    ),
  ];

  /// --- LIST OF ONGOING REQUESTS ---
  static const List<OngoingRequest> mockOngoing = [
    OngoingRequest(
      id: 10,
      title: 'Lanzamiento Anual de Producto',
      date: '10 Feb 2025',
      status: 'accepted',
      statusLabel: 'Aceptada',
    ),
    OngoingRequest(
      id: 11,
      title: 'Boda de Ana y Juan',
      date: '24 Dic 2024',
      status: 'sent',
      statusLabel: 'Cotización enviada',
    ),
    OngoingRequest(
      id: 12,
      title: '15 Años de Sofía',
      date: '15 Ene 2025',
      status: 'waiting',
      statusLabel: 'Esperando confirmación',
    ),
  ];

  /// --- LIST OF CHATS ---
  static const List<Chat> mockChats = [
    Chat(
      id: 1,
      userName: 'Juan Pérez',
      lastMessage: '¿Podríamos cambiar el color de los manteles?',
      time: '10:30 AM',
      unread: 2,
      event: 'Boda de Ana & Luis',
    ),
    Chat(
      id: 2,
      userName: 'Empresa Tech S.A.',
      lastMessage: 'Perfecto, esperamos la factura.',
      time: 'Ayer',
      unread: 0,
      event: 'Lanzamiento Anual',
    ),
  ];

  /// --- MESSAGES OF A CONVERSATION ---
  static const List<Message> mockConversation = [
    Message(
      id: 1,
      text: 'Hola, buen día. Recibimos tu cotización.',
      sender: 'client',
      time: '10:00 AM',
    ),
    Message(
      id: 2,
      text: '¡Hola! Excelente, quedo atento a cualquier duda.',
      sender: 'me',
      time: '10:05 AM',
    ),
    Message(
      id: 3,
      text: '¿Podríamos cambiar el color de los manteles a azul?',
      sender: 'client',
      time: '10:30 AM',
    ),
  ];
}
