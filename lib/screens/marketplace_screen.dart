import 'package:flutter/material.dart';

import '../app/app_theme.dart';
import '../controllers/student_life_controller.dart';
import '../models/student_models.dart';
import '../widgets/student_widgets.dart';

class MarketplaceScreen extends StatefulWidget {
  const MarketplaceScreen({
    super.key,
    required this.controller,
    this.embedded = false,
  });

  final StudentLifeController controller;
  final bool embedded;

  @override
  State<MarketplaceScreen> createState() => _MarketplaceScreenState();
}

class _MarketplaceScreenState extends State<MarketplaceScreen> {
  String _filter = 'All';

  @override
  Widget build(BuildContext context) {
    const title = 'Skill Swap + Mini Market';
    const subtitle =
        'Post items or services, choose sell or trade, and message sellers directly.';

    final myId = widget.controller.currentUserId;
    final allListings = widget.controller.listings;
    final myListings = allListings.where((l) => l.sellerId == myId).toList();
    final otherListings = allListings.where((l) => l.sellerId != myId).toList();

    final filtered = _filter == 'All'
        ? otherListings
        : otherListings.where((l) => l.listingType == _filter).toList();

    final content = [
      if (widget.embedded) ...[
        const EmbeddedModuleHeader(title: title, subtitle: subtitle),
        const SizedBox(height: 18),
      ],
      // Stats row
      Row(
        children: [
          Expanded(
            child: _StatPill(
              icon: Icons.storefront_rounded,
              label: '${allListings.length}',
              caption: 'Listings',
              color: AppPalette.softRed,
              iconColor: AppPalette.brightRed,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _StatPill(
              icon: Icons.person_pin_rounded,
              label: '${myListings.length}',
              caption: 'My Posts',
              color: AppPalette.sky,
              iconColor: AppPalette.royalBlue,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _StatPill(
              icon: Icons.chat_bubble_rounded,
              label: '${widget.controller.chatThreads.where((t) => t.isMarketplace).length}',
              caption: 'Chats',
              color: AppPalette.softGreen,
              iconColor: const Color(0xFF059669),
            ),
          ),
        ],
      ),
      const SizedBox(height: 18),
      SizedBox(
        width: double.infinity,
        child: FilledButton.icon(
          onPressed: _openPostSheet,
          icon: const Icon(Icons.add_rounded),
          label: const Text('Create New Listing'),
          style: FilledButton.styleFrom(
            backgroundColor: AppPalette.brightRed,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
          ),
        ),
      ),
      // My Listings section
      if (myListings.isNotEmpty) ...[
        const SizedBox(height: 28),
        Row(
          children: [
            const Expanded(child: SectionTitle('My Listings')),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppPalette.sky,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${myListings.length}',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: AppPalette.royalBlue,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        for (final listing in myListings) ...[
          _OwnListingCard(
            listing: listing,
            onEdit: () => _openEditSheet(listing),
            onDelete: () => _confirmDelete(listing),
          ),
          const SizedBox(height: 12),
        ],
      ],
      // Browse section
      const SizedBox(height: 28),
      const SectionTitle('Browse Listings'),
      const SizedBox(height: 12),
      // Filter chips
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            for (final f in ['All', 'Sell', 'Trade'])
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: GestureDetector(
                  onTap: () => setState(() => _filter = f),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                    decoration: BoxDecoration(
                      color: _filter == f ? AppPalette.navy : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: _filter == f ? AppPalette.navy : const Color(0xFFE2E8F0),
                      ),
                    ),
                    child: Text(
                      f,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                        color: _filter == f ? Colors.white : AppPalette.muted,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
      const SizedBox(height: 14),
      if (filtered.isEmpty)
        InfoCard(
          child: Column(
            children: [
              const Icon(Icons.storefront_outlined, size: 40, color: AppPalette.muted),
              const SizedBox(height: 10),
              Text(
                otherListings.isEmpty
                    ? 'No listings yet. Be the first to post!'
                    : 'No $_filter listings found.',
                style: const TextStyle(color: AppPalette.muted, height: 1.4),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      for (var i = 0; i < filtered.length; i++) ...[
        _BrowseListingCard(
          listing: filtered[i],
          accent: [
            AppPalette.navy,
            AppPalette.brightRed,
            AppPalette.royalBlue,
            const Color(0xFF0F766E),
          ][i % 4],
          onMessageTap: () => _openChatComposer(filtered[i]),
        ),
        const SizedBox(height: 12),
      ],
    ];

    if (widget.embedded) {
      return ListView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 120),
        children: content,
      );
    }

    return ModulePageScaffold(
      title: title,
      subtitle: subtitle,
      accent: AppPalette.brightRed,
      body: content,
    );
  }

  Future<void> _openPostSheet({Listing? existing}) async {
    final titleController = TextEditingController(text: existing?.title ?? '');
    final categoryController = TextEditingController(text: existing?.category ?? '');
    final priceController = TextEditingController(
      text: existing != null
          ? RegExp(r'[\d.]+').firstMatch(existing.price)?.group(0) ?? ''
          : '',
    );
    final descriptionController = TextEditingController(text: existing?.description ?? '');
    final imageController = TextEditingController(text: existing?.imageUrl ?? '');
    String listingType = existing?.listingType ?? 'Sell';

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return _MarketSheet(
              title: existing != null ? 'Edit Listing' : 'Create Listing',
              child: Column(
                children: [
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(hintText: 'Item or service title'),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: categoryController,
                    decoration: const InputDecoration(hintText: 'Category'),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: listingType,
                    items: const [
                      DropdownMenuItem(value: 'Sell', child: Text('Sell')),
                      DropdownMenuItem(value: 'Trade', child: Text('Trade')),
                    ],
                    onChanged: (v) => setModalState(() => listingType = v ?? 'Sell'),
                    decoration: const InputDecoration(hintText: 'Listing type'),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: priceController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(hintText: 'Price (PHP)'),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: imageController,
                    decoration: const InputDecoration(hintText: 'Image URL (optional)'),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: descriptionController,
                    maxLines: 3,
                    decoration: const InputDecoration(hintText: 'Description'),
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () async {
                        final price = double.tryParse(priceController.text.trim()) ?? 0;
                        if (existing != null) {
                          await widget.controller.updateListing(
                            listingId: existing.id,
                            title: titleController.text.trim(),
                            category: categoryController.text.trim(),
                            listingType: listingType,
                            price: price,
                            description: descriptionController.text.trim(),
                            imageUrl: imageController.text.trim(),
                          );
                        } else {
                          await widget.controller.addMarketplaceListing(
                            title: titleController.text.trim(),
                            category: categoryController.text.trim(),
                            listingType: listingType,
                            price: price,
                            description: descriptionController.text.trim(),
                            imageUrl: imageController.text.trim(),
                          );
                        }
                        if (mounted) Navigator.of(context).pop();
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: AppPalette.brightRed,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text(existing != null ? 'Save Changes' : 'Post Listing'),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _openEditSheet(Listing listing) => _openPostSheet(existing: listing);

  Future<void> _confirmDelete(Listing listing) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text(
          'Delete Listing?',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        content: Text('Remove "${listing.title}" from the marketplace?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(backgroundColor: AppPalette.brightRed),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await widget.controller.deleteListing(listing.id);
    }
  }

  Future<void> _openChatComposer(Listing listing) async {
    final messageController = TextEditingController();

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return _MarketSheet(
          title: 'Message ${listing.seller}',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppPalette.sky,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.storefront_rounded, color: AppPalette.royalBlue, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        listing.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: AppPalette.navy,
                        ),
                      ),
                    ),
                    Text(
                      listing.price,
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        color: AppPalette.royalBlue,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              Text(
                'Your message will start a conversation in the Chat tab.',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: AppPalette.muted),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: messageController,
                maxLines: 4,
                autofocus: true,
                decoration: const InputDecoration(hintText: 'Write your message...'),
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () async {
                    final msg = messageController.text.trim();
                    if (msg.isEmpty) return;
                    final id = await widget.controller.startChatWithListing(
                      listing: listing,
                      firstMessage: msg,
                    );
                    if (!mounted) return;
                    Navigator.of(context).pop();
                    if (id != null) widget.controller.selectTab(AppTab.chat);
                  },
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
        );
      },
    );
  }
}

class _StatPill extends StatelessWidget {
  const _StatPill({
    required this.icon,
    required this.label,
    required this.caption,
    required this.color,
    required this.iconColor,
  });

  final IconData icon;
  final String label;
  final String caption;
  final Color color;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 22),
          const SizedBox(height: 8),
          Text(
            label,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
          ),
          Text(
            caption,
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: AppPalette.muted),
          ),
        ],
      ),
    );
  }
}

class _OwnListingCard extends StatelessWidget {
  const _OwnListingCard({
    required this.listing,
    required this.onEdit,
    required this.onDelete,
  });

  final Listing listing;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppPalette.royalBlue.withValues(alpha: 0.18)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row with "Your Listing" badge + actions
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 12, 0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppPalette.sky,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.person_rounded, size: 13, color: AppPalette.royalBlue),
                      SizedBox(width: 4),
                      Text(
                        'Your Listing',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppPalette.royalBlue,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                // Edit button
                InkWell(
                  onTap: onEdit,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppPalette.sky,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.edit_rounded,
                        size: 16, color: AppPalette.royalBlue),
                  ),
                ),
                const SizedBox(width: 8),
                // Delete button
                InkWell(
                  onTap: onDelete,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppPalette.softRed,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.delete_rounded,
                        size: 16, color: AppPalette.brightRed),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image or placeholder
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: listing.imageUrl.isNotEmpty
                      ? Image.network(
                          listing.imageUrl,
                          width: 72,
                          height: 72,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _placeholder(),
                        )
                      : _placeholder(),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        listing.title,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppPalette.navy.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              listing.listingType,
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: AppPalette.navy,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            listing.category,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppPalette.muted,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        listing.price,
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          color: AppPalette.navy,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        color: AppPalette.sky,
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Icon(Icons.image_rounded, color: AppPalette.muted),
    );
  }
}

class _BrowseListingCard extends StatelessWidget {
  const _BrowseListingCard({
    required this.listing,
    required this.accent,
    required this.onMessageTap,
  });

  final Listing listing;
  final Color accent;
  final VoidCallback onMessageTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image or placeholder with message icon overlay
          Stack(
            children: [
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(22)),
                child: listing.imageUrl.isNotEmpty
                    ? Image.network(
                        listing.imageUrl,
                        height: 140,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _imgPlaceholder(accent),
                      )
                    : _imgPlaceholder(accent),
              ),
              // Message icon top-right
              Positioned(
                top: 10,
                right: 10,
                child: GestureDetector(
                  onTap: onMessageTap,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.10),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(Icons.message_rounded, size: 18, color: accent),
                  ),
                ),
              ),
              // Type badge top-left
              Positioned(
                top: 10,
                left: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: accent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    listing.listingType,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 11,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        listing.title,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      listing.price,
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                        color: accent,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.person_outline_rounded,
                        size: 14, color: AppPalette.muted),
                    const SizedBox(width: 4),
                    Text(
                      listing.seller,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppPalette.muted,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(
                        color: accent.withValues(alpha: 0.10),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        listing.category,
                        style: TextStyle(
                          fontSize: 11,
                          color: accent,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                if (listing.description.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    listing.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppPalette.muted,
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),
                ],
                const SizedBox(height: 12),
                // Tap to message banner
                GestureDetector(
                  onTap: onMessageTap,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: accent.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: accent.withValues(alpha: 0.18)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.message_rounded, size: 16, color: accent),
                        const SizedBox(width: 8),
                        Text(
                          'Message Seller',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                            color: accent,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _imgPlaceholder(Color accent) {
    return Container(
      height: 140,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [accent.withValues(alpha: 0.15), Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: const Center(
        child: Icon(Icons.image_rounded, size: 42, color: AppPalette.muted),
      ),
    );
  }
}

class _MarketSheet extends StatelessWidget {
  const _MarketSheet({required this.title, required this.child});

  final String title;
  final Widget child;

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
              Text(
                title,
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 16),
              child,
            ],
          ),
        ),
      ),
    );
  }
}
