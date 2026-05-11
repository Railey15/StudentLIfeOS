import 'package:supabase_flutter/supabase_flutter.dart';

import '../core/supabase_client.dart';
import '../models/student_models.dart';

class SupabaseStudentService {
  User? get currentUser => supabase.auth.currentUser;

  Future<AuthResponse> signUp({
    required String email,
    required String password,
    required String fullName,
  }) {
    return supabase.auth.signUp(
      email: email,
      password: password,
      data: {
        'full_name': fullName,
      },
    );
  }

  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) {
    return supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() {
    return supabase.auth.signOut();
  }

  Future<UserProfile?> getProfile() async {
    final user = currentUser;
    if (user == null) {
      return null;
    }

    final data = await supabase.from('profiles').select().eq('id', user.id).maybeSingle();
    if (data == null) {
      return null;
    }

    return UserProfile(
      name: (data['full_name'] as String?) ?? 'Student User',
      email: (data['email'] as String?) ?? user.email ?? '',
      campus: (data['campus'] as String?) ?? '',
      program: (data['program'] as String?) ?? '',
      yearLevel: (data['year_level'] as String?) ?? '',
      studentId: (data['student_id'] as String?) ?? '',
      greeting: 'Student Life OS dashboard',
      bio: (data['bio'] as String?) ?? '',
    );
  }

  Future<void> updateProfile(UserProfile profile) async {
    final user = currentUser;
    if (user == null) {
      return;
    }

    await supabase.from('profiles').update({
      'full_name': profile.name,
      'email': profile.email,
      'campus': profile.campus,
      'program': profile.program,
      'year_level': profile.yearLevel,
      'student_id': profile.studentId,
      'bio': profile.bio,
      'updated_at': DateTime.now().toIso8601String(),
    }).eq('id', user.id);
  }

  Future<StudentSettings?> getSettings() async {
    final user = currentUser;
    if (user == null) {
      return null;
    }

    final data =
        await supabase.from('user_settings').select().eq('user_id', user.id).maybeSingle();
    if (data == null) {
      return null;
    }

    return StudentSettings(
      pushNotifications: (data['push_notifications'] as bool?) ?? true,
      deadlineReminders: (data['deadline_reminders'] as bool?) ?? true,
      marketplaceMessages: (data['marketplace_messages'] as bool?) ?? true,
      biometricLock: (data['biometric_lock'] as bool?) ?? false,
      darkMode: (data['dark_mode'] as bool?) ?? false,
    );
  }

  Future<void> updateSettings(StudentSettings settings) async {
    final user = currentUser;
    if (user == null) {
      return;
    }

    await supabase.from('user_settings').update({
      'push_notifications': settings.pushNotifications,
      'deadline_reminders': settings.deadlineReminders,
      'marketplace_messages': settings.marketplaceMessages,
      'biometric_lock': settings.biometricLock,
      'dark_mode': settings.darkMode,
      'updated_at': DateTime.now().toIso8601String(),
    }).eq('user_id', user.id);
  }

  Future<List<SubjectRecord>> getSubjects() async {
    final user = currentUser;
    if (user == null) {
      return [];
    }

    final data =
        await supabase.from('subjects').select().eq('user_id', user.id).order('created_at');
    return (data as List)
        .map(
          (row) => SubjectRecord(
            id: row['id']?.toString() ?? '',
            code: (row['code'] as String?) ?? '',
            title: (row['title'] as String?) ?? '',
            grade: (row['grade'] as String?) ?? '--',
            progress: ((row['progress'] as num?) ?? 0).toDouble(),
          ),
        )
        .toList();
  }

  Future<List<AcademicTask>> getAcademicTasks() async {
    final user = currentUser;
    if (user == null) {
      return [];
    }

    final subjectRows =
        await supabase.from('subjects').select('id,title').eq('user_id', user.id);
    final subjectsById = <String, String>{
      for (final row in subjectRows as List)
        if (row['id'] != null) row['id'].toString(): (row['title'] as String?) ?? '',
    };

    final data = await supabase
        .from('academic_tasks')
        .select()
        .eq('user_id', user.id)
        .order('deadline', ascending: true);

    return (data as List)
        .map(
          (row) => AcademicTask(
            id: row['id']?.toString() ?? '',
            title: (row['title'] as String?) ?? '',
            deadline: _formatDateTime(row['deadline'] as String?),
            details: (row['details'] as String?) ?? '',
            subjectId: row['subject_id']?.toString() ?? '',
            subject: subjectsById[row['subject_id']?.toString()] ?? 'General',
            priority: (row['priority'] as String?) ?? 'Medium',
            isDone: (row['status'] as String?) == 'Done',
          ),
        )
        .toList();
  }

  Future<void> addSubject({
    required String code,
    required String title,
    String? grade,
  }) async {
    final user = currentUser;
    if (user == null) {
      return;
    }

    await supabase.from('subjects').insert({
      'user_id': user.id,
      'code': code,
      'title': title,
      'grade': grade,
      'progress': 0,
    });
  }

  Future<void> addAcademicTask({
    required String title,
    required String details,
    required String priority,
    required String subjectId,
    DateTime? deadline,
  }) async {
    final user = currentUser;
    if (user == null) {
      return;
    }

    await supabase.from('academic_tasks').insert({
      'user_id': user.id,
      'subject_id': subjectId.isEmpty ? null : subjectId,
      'title': title,
      'details': details,
      'priority': priority,
      'deadline': deadline?.toIso8601String(),
      'status': 'To Do',
    });
  }

  Future<void> updateAcademicTaskStatus({
    required String taskId,
    required bool isDone,
  }) async {
    final user = currentUser;
    if (user == null) {
      return;
    }

    await supabase
        .from('academic_tasks')
        .update({'status': isDone ? 'Done' : 'To Do'})
        .eq('id', taskId)
        .eq('user_id', user.id);
  }

  Future<List<WellnessLog>> getWellnessLogs() async {
    final user = currentUser;
    if (user == null) {
      return [];
    }

    final data = await supabase
        .from('wellness_logs')
        .select()
        .eq('user_id', user.id)
        .order('logged_at', ascending: false);

    return (data as List)
        .map(
          (row) => WellnessLog(
            day: _weekdayLabel(row['logged_at'] as String?),
            mood: (row['mood'] as String?) ?? '',
            note: (row['note'] as String?) ?? '',
            score: (row['score'] as int?) ?? 0,
          ),
        )
        .toList();
  }

  Future<List<BudgetEntry>> getBudgetEntries() async {
    final user = currentUser;
    if (user == null) {
      return [];
    }

    final data = await supabase
        .from('budget_entries')
        .select()
        .eq('user_id', user.id)
        .order('spent_at', ascending: false);

    return (data as List)
        .map(
          (row) => BudgetEntry(
            id: row['id']?.toString() ?? '',
            title: (row['title'] as String?) ?? '',
            amount: ((row['amount'] as num?) ?? 0).toDouble(),
            categoryId: row['category_id']?.toString() ?? '',
            category: (row['category'] as String?) ?? '',
            when: _relativeDateLabel(row['spent_at'] as String?),
          ),
        )
        .toList();
  }

  Future<double> getInitialBudget() async {
    final user = currentUser;
    if (user == null) {
      return 0;
    }

    try {
      final data =
          await supabase.from('budget_profiles').select().eq('user_id', user.id).maybeSingle();
      return ((data?['initial_budget'] as num?) ?? 0).toDouble();
    } catch (_) {
      return 0;
    }
  }

  Future<void> setInitialBudget(double amount) async {
    final user = currentUser;
    if (user == null) {
      return;
    }

    await supabase.from('budget_profiles').upsert({
      'user_id': user.id,
      'initial_budget': amount,
      'updated_at': DateTime.now().toIso8601String(),
    });
  }

  Future<List<BudgetCategory>> getBudgetCategories() async {
    final user = currentUser;
    if (user == null) {
      return [];
    }

    try {
      final categoryRows = await supabase
          .from('budget_categories')
          .select()
          .eq('user_id', user.id)
          .order('created_at');
      final entries = await getBudgetEntries();

      return (categoryRows as List).map((row) {
        final id = row['id']?.toString() ?? '';
        final plannedAmount = ((row['planned_amount'] as num?) ?? 0).toDouble();
        final spentAmount = entries
            .where((entry) => entry.categoryId == id || entry.category == (row['name'] as String?))
            .fold<double>(0, (sum, item) => sum + item.amount);
        final progress = plannedAmount == 0 ? 0.0 : (spentAmount / plannedAmount).clamp(0.0, 1.0);
        return BudgetCategory(
          id: id,
          name: (row['name'] as String?) ?? '',
          plannedAmount: plannedAmount,
          spentAmount: spentAmount,
          percentLabel: '${(progress * 100).round()}%',
          progress: progress.toDouble(),
        );
      }).toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> addBudgetCategory({
    required String name,
    required double plannedAmount,
  }) async {
    final user = currentUser;
    if (user == null) {
      return;
    }

    await supabase.from('budget_categories').insert({
      'user_id': user.id,
      'name': name,
      'planned_amount': plannedAmount,
    });
  }

  Future<void> addBudgetEntry({
    required String title,
    required double amount,
    required String categoryName,
    required String categoryId,
  }) async {
    final user = currentUser;
    if (user == null) {
      return;
    }

    final bool isRealUuid = categoryId.length == 36 && categoryId.split('-').length == 5;
    await supabase.from('budget_entries').insert({
      'user_id': user.id,
      'title': title,
      'amount': amount,
      'category': categoryName,
      'category_id': isRealUuid ? categoryId : null,
      'entry_type': 'Expense',
    });
  }

  Future<List<CampusPlace>> getCampusPlaces() async {
    final data = await supabase
        .from('campus_places')
        .select()
        .eq('is_active', true)
        .order('name');

    return (data as List)
        .map(
          (row) => CampusPlace(
            name: (row['name'] as String?) ?? '',
            type: (row['place_type'] as String?) ?? '',
            walkTime: (row['walk_time'] as String?) ?? '',
            status: (row['crowd_status'] as String?) ?? '',
            description: (row['description'] as String?) ?? '',
          ),
        )
        .toList();
  }

  Future<List<Listing>> getMarketplaceListings() async {
    final data = await supabase
        .from('marketplace_listings')
        .select()
        .eq('status', 'Active')
        .order('created_at', ascending: false);

    return (data as List)
        .map(
          (row) => Listing(
            id: row['id']?.toString() ?? '',
            sellerId: row['seller_id']?.toString() ?? '',
            title: (row['title'] as String?) ?? '',
            category: (row['category'] as String?) ?? '',
            listingType: (row['listing_type'] as String?) ?? 'Sell',
            price: _formatPrice((row['price'] as num?)?.toDouble()),
            description: (row['description'] as String?) ?? '',
            seller: (row['seller_name'] as String?) ?? 'Student Seller',
            imageUrl: (row['image_url'] as String?) ?? '',
          ),
        )
        .toList();
  }

  Future<void> updateMarketplaceListing({
    required String listingId,
    required String title,
    required String category,
    required String listingType,
    required double price,
    required String description,
    required String imageUrl,
  }) async {
    final user = currentUser;
    if (user == null) return;
    await supabase.from('marketplace_listings').update({
      'title': title,
      'category': category,
      'listing_type': listingType,
      'price': price,
      'description': description,
      'image_url': imageUrl,
    }).eq('id', listingId).eq('seller_id', user.id);
  }

  Future<void> deleteMarketplaceListing(String listingId) async {
    final user = currentUser;
    if (user == null) return;
    await supabase
        .from('marketplace_listings')
        .update({'status': 'Archived'})
        .eq('id', listingId)
        .eq('seller_id', user.id);
  }

  Future<void> addMarketplaceListing({
    required String title,
    required String category,
    required String listingType,
    required double price,
    required String description,
    required String imageUrl,
  }) async {
    final user = currentUser;
    if (user == null) {
      return;
    }
    final profile = await getProfile();

    await supabase.from('marketplace_listings').insert({
      'seller_id': user.id,
      'title': title,
      'category': category,
      'listing_type': listingType,
      'price': price,
      'description': description,
      'image_url': imageUrl,
      'seller_name': profile?.name ?? 'Student Seller',
      'status': 'Active',
    });
  }

  Future<List<ProjectTask>> getProjectTasks() async {
    final user = currentUser;
    if (user == null) {
      return [];
    }

    final projectRows =
        await supabase.from('group_projects').select('id,title').eq('owner_id', user.id);
    final projectIds = (projectRows as List)
        .map((row) => row['id'])
        .where((id) => id != null)
        .map((id) => id.toString())
        .toList();

    if (projectIds.isEmpty) {
      return [];
    }

    final data = await supabase
        .from('project_tasks')
        .select()
        .inFilter('project_id', projectIds)
        .order('deadline', ascending: true);

    return (data as List)
        .map(
          (row) => ProjectTask(
            title: (row['title'] as String?) ?? '',
            owner: row['assignee_id'] == user.id ? 'You' : 'Team Member',
            status: (row['status'] as String?) ?? 'To Do',
            deadline: _formatShortDate(row['deadline'] as String?),
          ),
        )
        .toList();
  }

  Future<List<ChatThread>> getChatThreads() async {
    final user = currentUser;
    if (user == null) {
      return [];
    }

    try {
      final data = await supabase
          .from('chat_conversations')
          .select()
          .or('buyer_id.eq.${user.id},seller_id.eq.${user.id}')
          .order('last_message_at', ascending: false);

      return (data as List)
          .map(
            (row) => ChatThread(
              id: row['id']?.toString() ?? '',
              title: (row['listing_title'] as String?) ?? 'Chat',
              counterpartName: (row['buyer_id'] == user.id
                      ? row['seller_name']
                      : row['buyer_name']) as String? ??
                  'Student',
              lastMessage: (row['last_message'] as String?) ?? 'No messages yet',
              lastActivity: _relativeDateLabel(row['last_message_at'] as String?),
              listingTitle: (row['listing_title'] as String?) ?? '',
              isMarketplace: row['listing_id'] != null,
            ),
          )
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<List<ChatMessage>> getChatMessages(String threadId) async {
    final user = currentUser;
    if (user == null) {
      return [];
    }

    try {
      final data = await supabase
          .from('chat_messages')
          .select()
          .eq('conversation_id', threadId)
          .order('created_at', ascending: true);

      return (data as List)
          .map(
            (row) => ChatMessage(
              id: row['id']?.toString() ?? '',
              threadId: row['conversation_id']?.toString() ?? '',
              senderId: row['sender_id']?.toString() ?? '',
              senderName: (row['sender_name'] as String?) ?? 'Student',
              message: (row['message'] as String?) ?? '',
              createdAt: _formatDateTime(row['created_at'] as String?),
              isMine: row['sender_id'] == user.id,
            ),
          )
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<String?> createConversationAndSend({
    required Listing listing,
    required String firstMessage,
  }) async {
    final user = currentUser;
    final profile = await getProfile();
    if (user == null || listing.sellerId.isEmpty || user.id == listing.sellerId) {
      return null;
    }

    final existing = await supabase
        .from('chat_conversations')
        .select('id')
        .eq('listing_id', listing.id)
        .eq('buyer_id', user.id)
        .eq('seller_id', listing.sellerId)
        .maybeSingle();

    String conversationId;
    if (existing != null && existing['id'] != null) {
      conversationId = existing['id'].toString();
    } else {
      final inserted = await supabase
          .from('chat_conversations')
          .insert({
            'listing_id': listing.id,
            'listing_title': listing.title,
            'buyer_id': user.id,
            'buyer_name': profile?.name ?? 'Buyer',
            'seller_id': listing.sellerId,
            'seller_name': listing.seller,
            'last_message': firstMessage,
            'last_message_at': DateTime.now().toIso8601String(),
          })
          .select('id')
          .single();
      conversationId = inserted['id'].toString();
    }

    await sendChatMessage(conversationId: conversationId, message: firstMessage);
    return conversationId;
  }

  Future<void> sendChatMessage({
    required String conversationId,
    required String message,
  }) async {
    final user = currentUser;
    final profile = await getProfile();
    if (user == null) {
      return;
    }

    await supabase.from('chat_messages').insert({
      'conversation_id': conversationId,
      'sender_id': user.id,
      'sender_name': profile?.name ?? 'Student',
      'message': message,
    });

    await supabase.from('chat_conversations').update({
      'last_message': message,
      'last_message_at': DateTime.now().toIso8601String(),
    }).eq('id', conversationId);
  }

  Future<List<Map<String, String>>> searchUsers(String query) async {
    final user = currentUser;
    if (user == null || query.trim().isEmpty) return [];
    try {
      final data = await supabase
          .from('profiles')
          .select('id, full_name')
          .ilike('full_name', '%${query.trim()}%')
          .neq('id', user.id)
          .limit(10);
      return (data as List)
          .map((row) => {
                'id': row['id'].toString(),
                'name': (row['full_name'] as String?) ?? 'Student',
              })
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<String?> createDirectConversation({
    required String recipientId,
    required String recipientName,
    required String firstMessage,
  }) async {
    final user = currentUser;
    final profile = await getProfile();
    if (user == null) return null;

    try {
      final existing = await supabase
          .from('chat_conversations')
          .select('id')
          .eq('buyer_id', user.id)
          .eq('seller_id', recipientId)
          .filter('listing_id', 'is', null)
          .maybeSingle();

      String conversationId;
      if (existing != null && existing['id'] != null) {
        conversationId = existing['id'].toString();
      } else {
        final inserted = await supabase
            .from('chat_conversations')
            .insert({
              'listing_id': null,
              'listing_title': null,
              'buyer_id': user.id,
              'buyer_name': profile?.name ?? 'Student',
              'seller_id': recipientId,
              'seller_name': recipientName,
              'last_message': firstMessage,
              'last_message_at': DateTime.now().toIso8601String(),
            })
            .select('id')
            .single();
        conversationId = inserted['id'].toString();
      }

      await sendChatMessage(conversationId: conversationId, message: firstMessage);
      return conversationId;
    } catch (_) {
      return null;
    }
  }

  Future<List<AnnouncementItem>> getAnnouncements() async {
    final data = await supabase
        .from('announcements')
        .select()
        .order('event_date', ascending: true);

    return (data as List)
        .map(
          (row) => AnnouncementItem(
            title: (row['title'] as String?) ?? '',
            date: _formatShortDate(row['event_date'] as String?),
            type: (row['announcement_type'] as String?) ?? '',
            description: (row['description'] as String?) ?? '',
          ),
        )
        .toList();
  }

  static String _formatDateTime(String? value) {
    if (value == null || value.isEmpty) {
      return 'No deadline';
    }
    final date = DateTime.tryParse(value)?.toLocal();
    if (date == null) {
      return value;
    }
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final hour = date.hour == 0 ? 12 : (date.hour > 12 ? date.hour - 12 : date.hour);
    final minute = date.minute.toString().padLeft(2, '0');
    final suffix = date.hour >= 12 ? 'PM' : 'AM';
    return '${months[date.month - 1]} ${date.day} | $hour:$minute $suffix';
  }

  static String _formatShortDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'No date';
    }
    final date = DateTime.tryParse(value)?.toLocal();
    if (date == null) {
      return value;
    }
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}';
  }

  static String _relativeDateLabel(String? value) {
    if (value == null || value.isEmpty) {
      return 'Unknown';
    }
    final date = DateTime.tryParse(value)?.toLocal();
    if (date == null) {
      return value;
    }
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(date.year, date.month, date.day);
    final diff = today.difference(target).inDays;
    if (diff == 0) {
      return 'Today';
    }
    if (diff == 1) {
      return 'Yesterday';
    }
    return _formatShortDate(value);
  }

  static String _weekdayLabel(String? value) {
    if (value == null || value.isEmpty) {
      return '--';
    }
    final date = DateTime.tryParse(value)?.toLocal();
    if (date == null) {
      return '--';
    }
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[date.weekday - 1];
  }

  static String _formatPrice(double? value) {
    if (value == null) {
      return 'Negotiable';
    }
    if (value == value.roundToDouble()) {
      return 'PHP ${value.toStringAsFixed(0)}';
    }
    return 'PHP ${value.toStringAsFixed(2)}';
  }
}
