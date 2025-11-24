import 'package:festeasy/data/mock_data.dart';
import 'package:festeasy/features/requests/presentation/widgets/simple_header.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MessagesListPage extends StatelessWidget {
  const MessagesListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SimpleHeader(title: 'Mensajes'),
      body: ListView.separated(
        itemCount: MockData.mockChats.length,
        separatorBuilder: (context, index) =>
            const Divider(height: 1, indent: 80),
        itemBuilder: (context, index) {
          final chat = MockData.mockChats[index];
          return _ChatListItem(chat: chat);
        },
      ),
    );
  }
}

class _ChatListItem extends StatelessWidget {
  const _ChatListItem({required this.chat});

  final Chat chat;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => context.push('/messages/${chat.id}'),
      leading: CircleAvatar(
        radius: 28,
        // A simple avatar with initials
        child: Text(chat.userName.substring(0, 2).toUpperCase()),
      ),
      title: Text(
        chat.userName,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        chat.lastMessage,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            chat.time,
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
          const SizedBox(height: 4),
          if (chat.unread > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFFEF4444),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${chat.unread}',
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            )
          else
            const SizedBox(height: 18), // To align with the unread badge
        ],
      ),
    );
  }
}
