class UserProfile {
  const UserProfile({
    required this.name,
    required this.email,
    required this.campus,
    required this.program,
    required this.yearLevel,
    required this.studentId,
    required this.greeting,
    required this.bio,
  });

  final String name;
  final String email;
  final String campus;
  final String program;
  final String yearLevel;
  final String studentId;
  final String greeting;
  final String bio;

  UserProfile copyWith({
    String? name,
    String? email,
    String? campus,
    String? program,
    String? yearLevel,
    String? studentId,
    String? greeting,
    String? bio,
  }) {
    return UserProfile(
      name: name ?? this.name,
      email: email ?? this.email,
      campus: campus ?? this.campus,
      program: program ?? this.program,
      yearLevel: yearLevel ?? this.yearLevel,
      studentId: studentId ?? this.studentId,
      greeting: greeting ?? this.greeting,
      bio: bio ?? this.bio,
    );
  }
}

class StudentSettings {
  const StudentSettings({
    required this.pushNotifications,
    required this.deadlineReminders,
    required this.marketplaceMessages,
    required this.biometricLock,
    required this.darkMode,
  });

  final bool pushNotifications;
  final bool deadlineReminders;
  final bool marketplaceMessages;
  final bool biometricLock;
  final bool darkMode;

  StudentSettings copyWith({
    bool? pushNotifications,
    bool? deadlineReminders,
    bool? marketplaceMessages,
    bool? biometricLock,
    bool? darkMode,
  }) {
    return StudentSettings(
      pushNotifications: pushNotifications ?? this.pushNotifications,
      deadlineReminders: deadlineReminders ?? this.deadlineReminders,
      marketplaceMessages: marketplaceMessages ?? this.marketplaceMessages,
      biometricLock: biometricLock ?? this.biometricLock,
      darkMode: darkMode ?? this.darkMode,
    );
  }
}

class AcademicTask {
  const AcademicTask({
    required this.id,
    required this.title,
    required this.deadline,
    required this.details,
    required this.subjectId,
    required this.subject,
    required this.priority,
    required this.isDone,
  });

  final String id;
  final String title;
  final String deadline;
  final String details;
  final String subjectId;
  final String subject;
  final String priority;
  final bool isDone;
}

class SubjectRecord {
  const SubjectRecord({
    required this.id,
    required this.code,
    required this.title,
    required this.grade,
    required this.progress,
  });

  final String id;
  final String code;
  final String title;
  final String grade;
  final double progress;
}

class WellnessLog {
  const WellnessLog({
    required this.day,
    required this.mood,
    required this.note,
    required this.score,
  });

  final String day;
  final String mood;
  final String note;
  final int score;
}

class BudgetEntry {
  const BudgetEntry({
    required this.id,
    required this.title,
    required this.amount,
    required this.categoryId,
    required this.category,
    required this.when,
  });

  final String id;
  final String title;
  final double amount;
  final String categoryId;
  final String category;
  final String when;
}

class BudgetCategory {
  const BudgetCategory({
    required this.id,
    required this.name,
    required this.plannedAmount,
    required this.spentAmount,
    required this.percentLabel,
    required this.progress,
  });

  final String id;
  final String name;
  final double plannedAmount;
  final double spentAmount;
  final String percentLabel;
  final double progress;
}

class CampusPlace {
  const CampusPlace({
    required this.name,
    required this.type,
    required this.walkTime,
    required this.status,
    required this.description,
  });

  final String name;
  final String type;
  final String walkTime;
  final String status;
  final String description;
}

class Listing {
  const Listing({
    required this.id,
    required this.sellerId,
    required this.title,
    required this.category,
    required this.listingType,
    required this.price,
    required this.description,
    required this.seller,
    required this.imageUrl,
  });

  final String id;
  final String sellerId;
  final String title;
  final String category;
  final String listingType;
  final String price;
  final String description;
  final String seller;
  final String imageUrl;
}

class ProjectTask {
  const ProjectTask({
    required this.title,
    required this.owner,
    required this.status,
    required this.deadline,
  });

  final String title;
  final String owner;
  final String status;
  final String deadline;
}

class AnnouncementItem {
  const AnnouncementItem({
    required this.title,
    required this.date,
    required this.type,
    required this.description,
  });

  final String title;
  final String date;
  final String type;
  final String description;
}

class InsightMetric {
  const InsightMetric({
    required this.label,
    required this.value,
    required this.caption,
  });

  final String label;
  final String value;
  final String caption;
}

class BudgetOverview {
  const BudgetOverview({
    required this.initialBudget,
    required this.totalSpent,
  });

  final double initialBudget;
  final double totalSpent;

  double get remaining => initialBudget - totalSpent;
}

class ChatThread {
  const ChatThread({
    required this.id,
    required this.title,
    required this.counterpartName,
    required this.lastMessage,
    required this.lastActivity,
    required this.listingTitle,
    this.isMarketplace = true,
  });

  final String id;
  final String title;
  final String counterpartName;
  final String lastMessage;
  final String lastActivity;
  final String listingTitle;
  final bool isMarketplace;
}

class ChatMessage {
  const ChatMessage({
    required this.id,
    required this.threadId,
    required this.senderId,
    required this.senderName,
    required this.message,
    required this.createdAt,
    required this.isMine,
  });

  final String id;
  final String threadId;
  final String senderId;
  final String senderName;
  final String message;
  final String createdAt;
  final bool isMine;
}
