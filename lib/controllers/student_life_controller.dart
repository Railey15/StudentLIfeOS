import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../data/student_repository.dart';
import '../data/supabase_student_service.dart';
import '../models/student_models.dart';

enum AppTab { home, academics, budget, chat, marketplace }

enum StudentModule {
  academics,
  wellness,
  budget,
  chat,
  marketplace,
  projects,
  announcements,
}

class StudentLifeController extends ChangeNotifier {
  StudentLifeController(this.repository, this.service)
      : _profile = repository.profile,
        _settings = repository.settings,
        _academicTasks = repository.academicTasks,
        _subjects = repository.subjects,
        _wellnessLogs = repository.wellnessLogs,
        _budgetEntries = repository.budgetEntries,
        _budgetCategories = repository.budgetCategories,
        _campusPlaces = repository.campusPlaces,
        _listings = repository.listings,
        _projectTasks = repository.projectTasks,
        _announcements = repository.announcements;

  final StudentRepository repository;
  final SupabaseStudentService service;
  UserProfile _profile;
  StudentSettings _settings;
  List<AcademicTask> _academicTasks;
  List<SubjectRecord> _subjects;
  List<WellnessLog> _wellnessLogs;
  List<BudgetEntry> _budgetEntries;
  List<BudgetCategory> _budgetCategories;
  List<CampusPlace> _campusPlaces;
  List<Listing> _listings;
  List<ProjectTask> _projectTasks;
  List<AnnouncementItem> _announcements;
  List<ChatThread> _chatThreads = const [];
  double _initialBudget = 0;
  AppTab selectedTab = AppTab.home;
  bool isAuthenticated = false;
  bool isBootstrapping = true;
  bool isLoading = false;
  String? errorMessage;

  Future<void> initialize() async {
    isAuthenticated = service.currentUser != null;
    if (isAuthenticated) {
      await refreshAll();
    }
    isBootstrapping = false;
    notifyListeners();
  }

  void selectTab(AppTab tab) {
    if (selectedTab == tab) {
      return;
    }
    selectedTab = tab;
    notifyListeners();
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    if (email.trim().isEmpty || password.trim().isEmpty) {
      return;
    }
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      await service.signIn(email: email.trim(), password: password);
      isAuthenticated = service.currentUser != null;
      if (isAuthenticated) {
        await refreshAll();
      }
    } on AuthException catch (error) {
      errorMessage = error.message;
    } catch (_) {
      errorMessage = 'Unable to login right now.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    if (name.trim().isEmpty || email.trim().isEmpty || password.trim().isEmpty) {
      return;
    }
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      final response = await service.signUp(
        email: email.trim(),
        password: password.trim(),
        fullName: name.trim(),
      );
      if (response.session == null) {
        await service.signIn(email: email.trim(), password: password.trim());
      }
      isAuthenticated = service.currentUser != null;
      if (isAuthenticated) {
        await refreshAll();
      } else {
        errorMessage = 'Check your email to confirm your account.';
      }
    } on AuthException catch (error) {
      errorMessage = error.message;
    } catch (_) {
      errorMessage = 'Unable to create your account right now.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await service.signOut();
    isAuthenticated = false;
    selectedTab = AppTab.home;
    errorMessage = null;
    notifyListeners();
  }

  Future<void> updateProfile(UserProfile profile) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      await service.updateProfile(profile);
      _profile = profile;
    } catch (_) {
      errorMessage = 'Unable to save profile changes right now.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateSettings(StudentSettings settings) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      await service.updateSettings(settings);
      _settings = settings;
    } catch (_) {
      errorMessage = 'Unable to save settings right now.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshAll() async {
    try {
      final results = await Future.wait([
        service.getProfile(),
        service.getSettings(),
        service.getSubjects(),
        service.getAcademicTasks(),
        service.getWellnessLogs(),
        service.getBudgetEntries(),
        service.getCampusPlaces(),
        service.getMarketplaceListings(),
        service.getProjectTasks(),
        service.getAnnouncements(),
        service.getInitialBudget(),
        service.getBudgetCategories(),
        service.getChatThreads(),
      ]);

      final profile = results[0] as UserProfile?;
      final settings = results[1] as StudentSettings?;
      final subjects = results[2] as List<SubjectRecord>;
      final tasks = results[3] as List<AcademicTask>;
      final wellness = results[4] as List<WellnessLog>;
      final budgetEntries = results[5] as List<BudgetEntry>;
      final places = results[6] as List<CampusPlace>;
      final listings = results[7] as List<Listing>;
      final projectTasks = results[8] as List<ProjectTask>;
      final announcements = results[9] as List<AnnouncementItem>;
      final initialBudget = results[10] as double;
      final budgetCategories = results[11] as List<BudgetCategory>;
      final chatThreads = results[12] as List<ChatThread>;

      _profile = profile ?? _profile;
      _settings = settings ?? _settings;
      _subjects = subjects;
      _academicTasks = tasks;
      _wellnessLogs = wellness;
      _budgetEntries = budgetEntries;
      _budgetCategories =
          budgetCategories.isNotEmpty ? budgetCategories : _deriveBudgetCategories(budgetEntries);
      _campusPlaces = places;
      _listings = listings;
      _projectTasks = projectTasks;
      _announcements = announcements;
      _initialBudget = initialBudget;
      _chatThreads = chatThreads;
      errorMessage = null;
    } catch (_) {
      errorMessage = 'Connected, but some data could not be loaded yet.';
    }
    notifyListeners();
  }

  UserProfile get profile => _profile;
  StudentSettings get settings => _settings;
  List<AcademicTask> get academicTasks => _academicTasks;
  List<SubjectRecord> get subjects => _subjects;
  List<WellnessLog> get wellnessLogs => _wellnessLogs;
  List<BudgetEntry> get budgetEntries => _budgetEntries;
  List<BudgetCategory> get budgetCategories => _budgetCategories;
  List<CampusPlace> get campusPlaces => _campusPlaces;
  List<Listing> get listings => _listings;
  List<ProjectTask> get projectTasks => _projectTasks;
  List<AnnouncementItem> get announcements => _announcements;
  List<ChatThread> get chatThreads => _chatThreads;
  double get initialBudget => _initialBudget;
  List<InsightMetric> get dashboardMetrics => [
        InsightMetric(
          label: 'Open Tasks',
          value: '$dueTaskCount',
          caption: dueTaskCount == 0 ? 'all caught up' : 'pending academic tasks',
        ),
        InsightMetric(
          label: 'Budget Left',
          value: remainingBudgetLabel,
          caption: initialBudget > 0 ? 'from your current setup' : 'set your initial budget',
        ),
        InsightMetric(
          label: 'Chats',
          value: '${chatThreads.length}',
          caption: chatThreads.isEmpty ? 'no active conversations' : 'active marketplace inbox',
        ),
      ];

  String? get currentUserId => service.currentUser?.id;
  int get dueTaskCount => academicTasks.where((task) => !task.isDone).length;
  int get unreadAnnouncements => announcements.length;
  String get weeklyBudgetLeft {
    if (budgetEntries.isEmpty) {
      return initialBudget > 0 ? remainingBudgetLabel : 'No entries yet';
    }
    return remainingBudgetLabel;
  }

  String get currentGpa {
    final grades = subjects
        .map((item) => double.tryParse(item.grade))
        .whereType<double>()
        .toList();
    if (grades.isEmpty) {
      return '--';
    }
    final average = grades.reduce((a, b) => a + b) / grades.length;
    return average.toStringAsFixed(2);
  }

  String get moodSnapshot => wellnessLogs.isEmpty ? 'No logs yet' : wellnessLogs.first.mood;
  String get remainingBudgetLabel {
    final remaining = _initialBudget - totalBudgetSpent;
    return 'PHP ${remaining.toStringAsFixed(0)}';
  }

  double get totalBudgetSpent =>
      budgetEntries.fold<double>(0, (sum, item) => sum + item.amount);

  Future<void> addSubject({
    required String code,
    required String title,
    String? grade,
  }) async {
    isLoading = true;
    notifyListeners();
    try {
      await service.addSubject(code: code, title: title, grade: grade);
      await refreshAll();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addAcademicTask({
    required String title,
    required String details,
    required String priority,
    required String subjectId,
    required DateTime? deadline,
  }) async {
    isLoading = true;
    notifyListeners();
    try {
      await service.addAcademicTask(
        title: title,
        details: details,
        priority: priority,
        subjectId: subjectId,
        deadline: deadline,
      );
      await refreshAll();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggleAcademicTask(AcademicTask task, bool isDone) async {
    await service.updateAcademicTaskStatus(taskId: task.id, isDone: isDone);
    await refreshAll();
  }

  Future<void> setInitialBudget(double amount) async {
    await service.setInitialBudget(amount);
    _initialBudget = amount;
    await refreshAll();
  }

  Future<void> addBudgetCategory({
    required String name,
    required double plannedAmount,
  }) async {
    await service.addBudgetCategory(name: name, plannedAmount: plannedAmount);
    await refreshAll();
  }

  Future<void> addBudgetExpense({
    required String title,
    required double amount,
    required String categoryName,
    required String categoryId,
  }) async {
    await service.addBudgetEntry(
      title: title,
      amount: amount,
      categoryName: categoryName,
      categoryId: categoryId,
    );
    await refreshAll();
  }

  Future<void> updateListing({
    required String listingId,
    required String title,
    required String category,
    required String listingType,
    required double price,
    required String description,
    required String imageUrl,
  }) async {
    await service.updateMarketplaceListing(
      listingId: listingId,
      title: title,
      category: category,
      listingType: listingType,
      price: price,
      description: description,
      imageUrl: imageUrl,
    );
    await refreshAll();
  }

  Future<void> deleteListing(String listingId) async {
    await service.deleteMarketplaceListing(listingId);
    await refreshAll();
  }

  Future<List<Map<String, String>>> searchUsers(String query) {
    return service.searchUsers(query);
  }

  Future<String?> startDirectChat({
    required String recipientId,
    required String recipientName,
    required String firstMessage,
  }) async {
    final id = await service.createDirectConversation(
      recipientId: recipientId,
      recipientName: recipientName,
      firstMessage: firstMessage,
    );
    await refreshAll();
    return id;
  }

  Future<void> addMarketplaceListing({
    required String title,
    required String category,
    required String listingType,
    required double price,
    required String description,
    required String imageUrl,
  }) async {
    await service.addMarketplaceListing(
      title: title,
      category: category,
      listingType: listingType,
      price: price,
      description: description,
      imageUrl: imageUrl,
    );
    await refreshAll();
  }

  Future<String?> startChatWithListing({
    required Listing listing,
    required String firstMessage,
  }) async {
    final id = await service.createConversationAndSend(
      listing: listing,
      firstMessage: firstMessage,
    );
    await refreshAll();
    return id;
  }

  Future<List<ChatMessage>> getMessagesForThread(String threadId) {
    return service.getChatMessages(threadId);
  }

  Future<void> sendChatMessage({
    required String threadId,
    required String message,
  }) async {
    await service.sendChatMessage(conversationId: threadId, message: message);
    await refreshAll();
  }

  static List<BudgetCategory> _deriveBudgetCategories(List<BudgetEntry> entries) {
    if (entries.isEmpty) {
      return const [
        BudgetCategory(
          id: 'food',
          name: 'Food',
          plannedAmount: 0,
          spentAmount: 0,
          percentLabel: '0%',
          progress: 0,
        ),
        BudgetCategory(
          id: 'transport',
          name: 'Transport',
          plannedAmount: 0,
          spentAmount: 0,
          percentLabel: '0%',
          progress: 0,
        ),
        BudgetCategory(
          id: 'school-needs',
          name: 'School Needs',
          plannedAmount: 0,
          spentAmount: 0,
          percentLabel: '0%',
          progress: 0,
        ),
        BudgetCategory(
          id: 'other',
          name: 'Other',
          plannedAmount: 0,
          spentAmount: 0,
          percentLabel: '0%',
          progress: 0,
        ),
      ];
    }

    final totals = <String, double>{};
    for (final entry in entries) {
      totals.update(entry.category, (value) => value + entry.amount, ifAbsent: () => entry.amount);
    }
    final sum = totals.values.fold<double>(0, (a, b) => a + b);
    return totals.entries.map((entry) {
      final progress = sum == 0 ? 0 : entry.value / sum;
      final percent = (progress * 100).round();
      return BudgetCategory(
        id: entry.key.toLowerCase().replaceAll(' ', '-'),
        name: entry.key,
        plannedAmount: entry.value,
        spentAmount: entry.value,
        percentLabel: '$percent%',
        progress: progress.clamp(0.0, 1.0).toDouble(),
      );
    }).toList()
      ..sort((a, b) => b.progress.compareTo(a.progress));
  }
}
