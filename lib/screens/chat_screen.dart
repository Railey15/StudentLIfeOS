import 'package:flutter/material.dart';

import '../app/app_theme.dart';
import '../controllers/student_life_controller.dart';
import '../models/student_models.dart';
import '../widgets/student_widgets.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({
    super.key,
    required this.controller,
    this.embedded = false,
  });

  final StudentLifeController controller;
  final bool embedded;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final marketplaceThreads =
        widget.controller.chatThreads.where((t) => t.isMarketplace).toList();
    final directThreads =
        widget.controller.chatThreads.where((t) => !t.isMarketplace).toList();

    if (widget.embedded) {
      return _EmbeddedChatView(
        controller: widget.controller,
        marketplaceThreads: marketplaceThreads,
        directThreads: directThreads,
        tabController: _tabController,
      );
    }

    return Scaffold(
      backgroundColor: AppPalette.canvas,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
              child: Row(
                children: [
                  _IconBtn(
                    icon: Icons.arrow_back_ios_new_rounded,
                    onTap: () => Navigator.of(context).maybePop(),
                  ),
                  const Spacer(),
                  const Text(
                    'Chat Inbox',
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                    ),
                  ),
                  const Spacer(),
                  _IconBtn(
                    icon: Icons.tune_rounded,
                    iconColor: AppPalette.royalBlue,
                    onTap: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Tab bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(
                    color: AppPalette.navy,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  dividerColor: Colors.transparent,
                  labelColor: Colors.white,
                  unselectedLabelColor: AppPalette.muted,
                  labelStyle: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                  tabs: [
                    Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.storefront_rounded, size: 15),
                          const SizedBox(width: 6),
                          const Text('Marketplace'),
                          if (marketplaceThreads.isNotEmpty) ...[
                            const SizedBox(width: 6),
                            _CountBadge(count: marketplaceThreads.length),
                          ],
                        ],
                      ),
                    ),
                    Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.person_rounded, size: 15),
                          const SizedBox(width: 6),
                          const Text('Direct'),
                          if (directThreads.isNotEmpty) ...[
                            const SizedBox(width: 6),
                            _CountBadge(count: directThreads.length),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Tab views
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _MarketplaceChatsTab(
                    controller: widget.controller,
                    threads: marketplaceThreads,
                  ),
                  _DirectChatsTab(
                    controller: widget.controller,
                    threads: directThreads,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmbeddedChatView extends StatelessWidget {
  const _EmbeddedChatView({
    required this.controller,
    required this.marketplaceThreads,
    required this.directThreads,
    required this.tabController,
  });

  final StudentLifeController controller;
  final List<ChatThread> marketplaceThreads;
  final List<ChatThread> directThreads;
  final TabController tabController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Chat Inbox',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 4),
              Text(
                'Marketplace conversations and direct student messages.',
                style: TextStyle(color: AppPalette.muted, fontSize: 14),
              ),
              const SizedBox(height: 16),
              Container(
                height: 46,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: TabBar(
                  controller: tabController,
                  indicator: BoxDecoration(
                    color: AppPalette.navy,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  dividerColor: Colors.transparent,
                  labelColor: Colors.white,
                  unselectedLabelColor: AppPalette.muted,
                  labelStyle: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                  tabs: [
                    Tab(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.storefront_rounded, size: 14),
                          const SizedBox(width: 5),
                          const Text('Marketplace'),
                          if (marketplaceThreads.isNotEmpty) ...[
                            const SizedBox(width: 5),
                            _CountBadge(count: marketplaceThreads.length),
                          ],
                        ],
                      ),
                    ),
                    Tab(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.person_rounded, size: 14),
                          const SizedBox(width: 5),
                          const Text('Direct'),
                          if (directThreads.isNotEmpty) ...[
                            const SizedBox(width: 5),
                            _CountBadge(count: directThreads.length),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: tabController,
            children: [
              _MarketplaceChatsTab(
                controller: controller,
                threads: marketplaceThreads,
                embedded: true,
              ),
              _DirectChatsTab(
                controller: controller,
                threads: directThreads,
                embedded: true,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─── Marketplace Chats Tab ─────────────────────────────────────────────────

class _MarketplaceChatsTab extends StatelessWidget {
  const _MarketplaceChatsTab({
    required this.controller,
    required this.threads,
    this.embedded = false,
  });

  final StudentLifeController controller;
  final List<ChatThread> threads;
  final bool embedded;

  @override
  Widget build(BuildContext context) {
    if (threads.isEmpty) {
      return _EmptyState(
        icon: Icons.storefront_outlined,
        title: 'No marketplace chats yet',
        body: 'When you message a seller from the Market tab, conversations appear here.',
      );
    }

    return ListView.separated(
      padding: EdgeInsets.fromLTRB(20, 12, 20, embedded ? 120 : 32),
      itemCount: threads.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (ctx, i) => _ThreadTile(
        thread: threads[i],
        accent: AppPalette.royalBlue,
        icon: Icons.storefront_rounded,
        onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => ChatDetailScreen(
            controller: controller,
            thread: threads[i],
          ),
        )),
      ),
    );
  }
}

// ─── Direct Chats Tab ─────────────────────────────────────────────────────

class _DirectChatsTab extends StatefulWidget {
  const _DirectChatsTab({
    required this.controller,
    required this.threads,
    this.embedded = false,
  });

  final StudentLifeController controller;
  final List<ChatThread> threads;
  final bool embedded;

  @override
  State<_DirectChatsTab> createState() => _DirectChatsTabState();
}

class _DirectChatsTabState extends State<_DirectChatsTab> {
  final _searchCtrl = TextEditingController();
  List<Map<String, String>> _results = [];
  bool _searching = false;

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _onSearch(String q) async {
    if (q.trim().isEmpty) {
      setState(() => _results = []);
      return;
    }
    setState(() => _searching = true);
    final r = await widget.controller.searchUsers(q);
    if (mounted) setState(() { _results = r; _searching = false; });
  }

  Future<void> _startChat(String userId, String userName) async {
    final messageCtrl = TextEditingController();
    final confirmed = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _ComposeSheet(
        recipientName: userName,
        messageCtrl: messageCtrl,
      ),
    );
    if (confirmed != true || !mounted) return;

    final msg = messageCtrl.text.trim();
    if (msg.isEmpty) return;

    final id = await widget.controller.startDirectChat(
      recipientId: userId,
      recipientName: userName,
      firstMessage: msg,
    );
    if (!mounted || id == null) return;

    // Find the created thread
    final thread = widget.controller.chatThreads
        .firstWhere((t) => t.id == id, orElse: () => ChatThread(
          id: id,
          title: 'Direct',
          counterpartName: userName,
          lastMessage: msg,
          lastActivity: 'Now',
          listingTitle: '',
          isMarketplace: false,
        ));

    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => ChatDetailScreen(
        controller: widget.controller,
        thread: thread,
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.fromLTRB(20, 12, 20, widget.embedded ? 120 : 32),
      children: [
        // Search bar
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: TextField(
            controller: _searchCtrl,
            onChanged: _onSearch,
            decoration: InputDecoration(
              hintText: 'Search student by full name...',
              hintStyle: const TextStyle(color: AppPalette.muted, fontSize: 14),
              prefixIcon: const Icon(Icons.search_rounded, color: AppPalette.muted),
              suffixIcon: _searchCtrl.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.close_rounded, color: AppPalette.muted),
                      onPressed: () {
                        _searchCtrl.clear();
                        setState(() => _results = []);
                      },
                    )
                  : null,
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
            ),
          ),
        ),
        const SizedBox(height: 12),
        // Search results
        if (_searching)
          const Padding(
            padding: EdgeInsets.all(20),
            child: Center(child: CircularProgressIndicator()),
          )
        else if (_results.isNotEmpty) ...[
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
                  child: Text(
                    '${_results.length} student${_results.length == 1 ? '' : 's'} found',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppPalette.muted,
                    ),
                  ),
                ),
                for (var i = 0; i < _results.length; i++) ...[
                  if (i > 0)
                    const Divider(height: 1, indent: 16, endIndent: 16),
                  _UserResultTile(
                    user: _results[i],
                    onTap: () => _startChat(_results[i]['id']!, _results[i]['name']!),
                  ),
                ],
                const SizedBox(height: 4),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ] else if (_searchCtrl.text.isNotEmpty && !_searching) ...[
          const InfoCard(
            child: Row(
              children: [
                Icon(Icons.person_search_rounded, color: AppPalette.muted),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'No students found. Try their full name.',
                    style: TextStyle(color: AppPalette.muted),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
        // Direct threads
        if (widget.threads.isNotEmpty) ...[
          const Text(
            'Conversations',
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
          ),
          const SizedBox(height: 10),
          for (final t in widget.threads) ...[
            _ThreadTile(
              thread: t,
              accent: AppPalette.navy,
              icon: Icons.person_rounded,
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => ChatDetailScreen(
                  controller: widget.controller,
                  thread: t,
                ),
              )),
            ),
            const SizedBox(height: 10),
          ],
        ] else if (_searchCtrl.text.isEmpty) ...[
          _EmptyState(
            icon: Icons.chat_bubble_outline_rounded,
            title: 'No direct messages yet',
            body: 'Search for a student by name above to start a conversation.',
          ),
        ],
      ],
    );
  }
}

// ─── Shared Widgets ───────────────────────────────────────────────────────

class _ThreadTile extends StatelessWidget {
  const _ThreadTile({
    required this.thread,
    required this.accent,
    required this.icon,
    required this.onTap,
  });

  final ChatThread thread;
  final Color accent;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: accent.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: accent, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    thread.counterpartName,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 15,
                    ),
                  ),
                  if (thread.isMarketplace && thread.listingTitle.isNotEmpty)
                    Text(
                      thread.listingTitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: accent,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  const SizedBox(height: 2),
                  Text(
                    thread.lastMessage,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppPalette.muted,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  thread.lastActivity,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppPalette.muted,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                const Icon(Icons.chevron_right_rounded,
                    size: 18, color: AppPalette.muted),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _UserResultTile extends StatelessWidget {
  const _UserResultTile({required this.user, required this.onTap});

  final Map<String, String> user;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final name = user['name'] ?? 'Student';
    final initials = name
        .split(' ')
        .take(2)
        .map((w) => w.isNotEmpty ? w[0].toUpperCase() : '')
        .join();

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppPalette.navy, AppPalette.royalBlue],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Center(
                child: Text(
                  initials,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                name,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppPalette.sky,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                children: [
                  Icon(Icons.message_rounded, size: 13, color: AppPalette.royalBlue),
                  SizedBox(width: 5),
                  Text(
                    'Chat',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppPalette.royalBlue,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CountBadge extends StatelessWidget {
  const _CountBadge({required this.count});
  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
      decoration: BoxDecoration(
        color: AppPalette.brightRed,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '$count',
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w800,
          color: Colors.white,
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({
    required this.icon,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 52, color: AppPalette.muted.withValues(alpha: 0.5)),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            body,
            style: const TextStyle(color: AppPalette.muted, height: 1.4),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _ComposeSheet extends StatelessWidget {
  const _ComposeSheet({
    required this.recipientName,
    required this.messageCtrl,
  });

  final String recipientName;
  final TextEditingController messageCtrl;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Message $recipientName',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context, false),
                    icon: const Icon(Icons.close_rounded),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextField(
                controller: messageCtrl,
                maxLines: 4,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Write your first message...',
                ),
              ),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () => Navigator.pop(context, true),
                  icon: const Icon(Icons.send_rounded),
                  label: const Text('Send Message'),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppPalette.navy,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Chat Detail Screen ──────────────────────────────────────────────────

class ChatDetailScreen extends StatefulWidget {
  const ChatDetailScreen({
    super.key,
    required this.controller,
    required this.thread,
  });

  final StudentLifeController controller;
  final ChatThread thread;

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final _msgCtrl = TextEditingController();
  final _scrollCtrl = ScrollController();
  List<ChatMessage> _messages = const [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final data = await widget.controller.getMessagesForThread(widget.thread.id);
    if (mounted) {
      setState(() {
        _messages = data;
        _loading = false;
      });
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(
          _scrollCtrl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _send() async {
    final text = _msgCtrl.text.trim();
    if (text.isEmpty) return;
    _msgCtrl.clear();
    await widget.controller.sendChatMessage(
      threadId: widget.thread.id,
      message: text,
    );
    await _load();
  }

  @override
  void dispose() {
    _msgCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMarket = widget.thread.isMarketplace;
    final accent = isMarket ? AppPalette.royalBlue : AppPalette.navy;

    return Scaffold(
      backgroundColor: AppPalette.canvas,
      body: SafeArea(
        child: Column(
          children: [
            // App bar
            Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(12, 12, 20, 12),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_ios_new_rounded),
                    color: AppPalette.ink,
                  ),
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: accent.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      isMarket ? Icons.storefront_rounded : Icons.person_rounded,
                      color: accent,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.thread.counterpartName,
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 15,
                          ),
                        ),
                        if (isMarket && widget.thread.listingTitle.isNotEmpty)
                          Text(
                            widget.thread.listingTitle,
                            style: TextStyle(
                              fontSize: 11,
                              color: accent,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Messages
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : _messages.isEmpty
                      ? const Center(
                          child: Text(
                            'No messages yet. Say hello!',
                            style: TextStyle(color: AppPalette.muted),
                          ),
                        )
                      : ListView.builder(
                          controller: _scrollCtrl,
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                          itemCount: _messages.length,
                          itemBuilder: (_, i) => _MessageBubble(
                            message: _messages[i],
                            accent: accent,
                          ),
                        ),
            ),
            // Input bar
            Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _msgCtrl,
                      minLines: 1,
                      maxLines: 4,
                      textInputAction: TextInputAction.newline,
                      decoration: const InputDecoration(
                        hintText: 'Write a message...',
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: _send,
                    child: Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        color: accent,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(Icons.send_rounded,
                          color: Colors.white, size: 20),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({required this.message, required this.accent});

  final ChatMessage message;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final isMine = message.isMine;
    return Align(
      alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        constraints: const BoxConstraints(maxWidth: 280),
        child: Column(
          crossAxisAlignment:
              isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isMine ? accent : Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(18),
                  topRight: const Radius.circular(18),
                  bottomLeft: Radius.circular(isMine ? 18 : 4),
                  bottomRight: Radius.circular(isMine ? 4 : 18),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                message.message,
                style: TextStyle(
                  color: isMine ? Colors.white : AppPalette.ink,
                  height: 1.35,
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(height: 3),
            Text(
              message.createdAt,
              style: const TextStyle(fontSize: 10, color: AppPalette.muted),
            ),
          ],
        ),
      ),
    );
  }
}

class _IconBtn extends StatelessWidget {
  const _IconBtn({
    required this.icon,
    required this.onTap,
    this.iconColor = AppPalette.ink,
  });

  final IconData icon;
  final VoidCallback onTap;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Icon(icon, size: 18, color: iconColor),
      ),
    );
  }
}
