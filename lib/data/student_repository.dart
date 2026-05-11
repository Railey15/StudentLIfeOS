import '../models/student_models.dart';

class StudentRepository {
  const StudentRepository({
    required this.profile,
    required this.settings,
    required this.academicTasks,
    required this.subjects,
    required this.wellnessLogs,
    required this.budgetEntries,
    required this.budgetCategories,
    required this.campusPlaces,
    required this.listings,
    required this.projectTasks,
    required this.announcements,
    required this.dashboardMetrics,
  });

  final UserProfile profile;
  final StudentSettings settings;
  final List<AcademicTask> academicTasks;
  final List<SubjectRecord> subjects;
  final List<WellnessLog> wellnessLogs;
  final List<BudgetEntry> budgetEntries;
  final List<BudgetCategory> budgetCategories;
  final List<CampusPlace> campusPlaces;
  final List<Listing> listings;
  final List<ProjectTask> projectTasks;
  final List<AnnouncementItem> announcements;
  final List<InsightMetric> dashboardMetrics;

  factory StudentRepository.demo() {
    return const StudentRepository(
      profile: UserProfile(
        name: 'Andrea',
        email: 'andrea@student.nu.edu.ph',
        campus: 'National University',
        program: 'BS Information Technology',
        yearLevel: '3rd Year',
        studentId: '2024-01782',
        greeting: 'Student Life OS dashboard',
        bio: 'Productive on good coffee, campus study sprints, and clean project boards.',
      ),
      settings: StudentSettings(
        pushNotifications: true,
        deadlineReminders: true,
        marketplaceMessages: true,
        biometricLock: false,
        darkMode: false,
      ),
      academicTasks: [
        AcademicTask(
          id: 'task-1',
          title: 'Mobile Development Prototype',
          deadline: 'Tomorrow | 6:00 PM',
          details: 'UI flow, API hooks, demo script',
          subjectId: 'sub-1',
          subject: 'Mobile Development',
          priority: 'High',
          isDone: false,
        ),
        AcademicTask(
          id: 'task-2',
          title: 'Operating Systems Reflection',
          deadline: 'May 14 | 11:59 PM',
          details: '2-page paper with attached notes',
          subjectId: 'sub-2',
          subject: 'Operating Systems',
          priority: 'Medium',
          isDone: false,
        ),
        AcademicTask(
          id: 'task-3',
          title: 'Database ERD Revision',
          deadline: 'May 15 | 9:00 AM',
          details: 'Normalize tables and revise constraints',
          subjectId: 'sub-3',
          subject: 'Database Systems',
          priority: 'High',
          isDone: true,
        ),
      ],
      subjects: [
        SubjectRecord(
          id: 'sub-1',
          code: 'IT 311',
          title: 'Mobile Development',
          grade: '1.50',
          progress: 0.82,
        ),
        SubjectRecord(
          id: 'sub-2',
          code: 'CS 302',
          title: 'Operating Systems',
          grade: '1.75',
          progress: 0.74,
        ),
        SubjectRecord(
          id: 'sub-3',
          code: 'IT 305',
          title: 'Database Systems',
          grade: '1.50',
          progress: 0.87,
        ),
      ],
      wellnessLogs: [
        WellnessLog(
          day: 'Mon',
          mood: 'Focused',
          note: 'Finished two assignments before lunch.',
          score: 4,
        ),
        WellnessLog(
          day: 'Tue',
          mood: 'Tired',
          note: 'Needed a break after lab work.',
          score: 3,
        ),
        WellnessLog(
          day: 'Wed',
          mood: 'Calm',
          note: 'Better balance after study block and walk.',
          score: 4,
        ),
      ],
      budgetEntries: [
        BudgetEntry(
          id: 'budget-1',
          title: 'Lunch at Student Plaza',
          amount: 120,
          categoryId: 'cat-1',
          category: 'Food',
          when: 'Today',
        ),
        BudgetEntry(
          id: 'budget-2',
          title: 'Jeep fare to campus',
          amount: 26,
          categoryId: 'cat-2',
          category: 'Transport',
          when: 'Today',
        ),
        BudgetEntry(
          id: 'budget-3',
          title: 'Printing handouts',
          amount: 75,
          categoryId: 'cat-3',
          category: 'School Needs',
          when: 'Yesterday',
        ),
      ],
      budgetCategories: [
        BudgetCategory(
          id: 'cat-1',
          name: 'Food',
          plannedAmount: 2500,
          spentAmount: 1200,
          percentLabel: '48%',
          progress: 0.48,
        ),
        BudgetCategory(
          id: 'cat-2',
          name: 'Transport',
          plannedAmount: 1200,
          spentAmount: 520,
          percentLabel: '43%',
          progress: 0.43,
        ),
        BudgetCategory(
          id: 'cat-3',
          name: 'School Needs',
          plannedAmount: 1800,
          spentAmount: 720,
          percentLabel: '40%',
          progress: 0.40,
        ),
        BudgetCategory(
          id: 'cat-4',
          name: 'Savings',
          plannedAmount: 1000,
          spentAmount: 210,
          percentLabel: '21%',
          progress: 0.21,
        ),
      ],
      campusPlaces: [
        CampusPlace(
          name: 'Innovation Hub',
          type: 'Study Area',
          walkTime: '2 min walk',
          status: 'Moderate crowd',
          description: 'Project rooms, sockets, fast Wi-Fi',
        ),
        CampusPlace(
          name: 'Student Plaza Food Lane',
          type: 'Food',
          walkTime: '4 min walk',
          status: 'Busy',
          description: 'Meals, coffee, and quick supplies',
        ),
        CampusPlace(
          name: 'Library Wing B',
          type: 'Quiet Zone',
          walkTime: '3 min walk',
          status: 'Quiet',
          description: 'Best for solo review and research',
        ),
      ],
      listings: [
        Listing(
          id: 'listing-1',
          sellerId: 'seller-1',
          title: 'Calculus tutoring session',
          category: 'Skill Swap',
          listingType: 'Trade',
          price: 'PHP 250/hr',
          description: 'Peer tutor with quiz review and sample problem sets.',
          seller: 'Miguel R.',
          imageUrl: '',
        ),
        Listing(
          id: 'listing-2',
          sellerId: 'seller-2',
          title: 'Second-hand lab gown',
          category: 'Mini Market',
          listingType: 'Sell',
          price: 'PHP 180',
          description: 'Clean, lightly used, medium size, pickup near gate 2.',
          seller: 'Trina P.',
          imageUrl: '',
        ),
        Listing(
          id: 'listing-3',
          sellerId: 'seller-3',
          title: 'Poster and pubmat design',
          category: 'Creative Service',
          listingType: 'Sell',
          price: 'PHP 400/project',
          description: 'Fast turnaround for org events and class presentations.',
          seller: 'Joaquin A.',
          imageUrl: '',
        ),
      ],
      projectTasks: [
        ProjectTask(
          title: 'Wireframe dashboard',
          owner: 'Andrea',
          status: 'To Do',
          deadline: 'May 12',
        ),
        ProjectTask(
          title: 'Connect mock API data',
          owner: 'Mia',
          status: 'In Progress',
          deadline: 'May 13',
        ),
        ProjectTask(
          title: 'Finalize prototype pitch',
          owner: 'Luis',
          status: 'Done',
          deadline: 'May 10',
        ),
      ],
      announcements: [
        AnnouncementItem(
          title: 'Enrollment advisory released',
          date: 'May 11',
          type: 'Announcement',
          description: 'Updated enrollment schedule and document checklist.',
        ),
        AnnouncementItem(
          title: 'Innovation Week kickoff',
          date: 'May 14',
          type: 'Event',
          description: 'Talks, booths, and student startup demos across campus.',
        ),
        AnnouncementItem(
          title: 'Library extended hours',
          date: 'May 15',
          type: 'Advisory',
          description: 'Wing B will stay open until 10 PM during finals week.',
        ),
      ],
      dashboardMetrics: [
        InsightMetric(
          label: 'Mood',
          value: 'Calm',
          caption: '3-day positive streak',
        ),
        InsightMetric(
          label: 'Events',
          value: '5',
          caption: 'saved this month',
        ),
        InsightMetric(
          label: 'Tasks',
          value: '12',
          caption: 'across all modules',
        ),
      ],
    );
  }
}
