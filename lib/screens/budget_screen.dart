import 'package:flutter/material.dart';

import '../app/app_theme.dart';
import '../controllers/student_life_controller.dart';
import '../models/student_models.dart';
import '../widgets/student_widgets.dart';

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({
    super.key,
    required this.controller,
    this.embedded = false,
  });

  final StudentLifeController controller;
  final bool embedded;

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  @override
  Widget build(BuildContext context) {
    const title = 'Budget Tracker';
    const subtitle =
        'Set your budget, create categories, log spending, and track remaining balance.';

    final initial = widget.controller.initialBudget;
    final spent = widget.controller.totalBudgetSpent;
    final remaining = initial - spent;
    final progress = initial > 0 ? (spent / initial).clamp(0.0, 1.0) : 0.0;
    final isOverBudget = remaining < 0;

    final page = [
      if (widget.embedded) ...[
        const EmbeddedModuleHeader(title: title, subtitle: subtitle),
        const SizedBox(height: 18),
      ],

      // Budget overview card
      Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppPalette.navy, AppPalette.royalBlue],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(26),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Budget Overview',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              initial > 0
                  ? 'PHP ${initial.toStringAsFixed(0)}'
                  : 'No budget set',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 16),
            // Progress bar
            if (initial > 0) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 10,
                  backgroundColor: Colors.white.withValues(alpha: 0.2),
                  valueColor: AlwaysStoppedAnimation(
                    isOverBudget ? AppPalette.brightRed : const Color(0xFF34D399),
                  ),
                ),
              ),
              const SizedBox(height: 14),
            ],
            Row(
              children: [
                Expanded(
                  child: _OverviewPill(
                    label: 'Spent',
                    value: 'PHP ${spent.toStringAsFixed(0)}',
                    color: Colors.white.withValues(alpha: 0.15),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _OverviewPill(
                    label: 'Remaining',
                    value: 'PHP ${remaining.abs().toStringAsFixed(0)}',
                    color: isOverBudget
                        ? AppPalette.brightRed.withValues(alpha: 0.6)
                        : Colors.white.withValues(alpha: 0.15),
                    prefix: isOverBudget ? '-' : '',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      const SizedBox(height: 18),

      // Action buttons
      Row(
        children: [
          Expanded(
            child: _ActionBtn(
              icon: Icons.savings_rounded,
              label: 'Set Budget',
              color: AppPalette.brightRed,
              onTap: _openInitialBudgetSheet,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _ActionBtn(
              icon: Icons.category_rounded,
              label: 'Add Category',
              color: AppPalette.navy,
              onTap: _openCategorySheet,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _ActionBtn(
              icon: Icons.add_card_rounded,
              label: 'Add Expense',
              color: AppPalette.royalBlue,
              onTap: _openExpenseSheet,
            ),
          ),
        ],
      ),

      // Categories
      if (widget.controller.budgetCategories.isNotEmpty) ...[
        const SizedBox(height: 28),
        const SectionTitle('Categories'),
        const SizedBox(height: 12),
        InfoCard(
          child: Column(
            children: [
              for (var i = 0; i < widget.controller.budgetCategories.length; i++)
                BudgetCategoryCard(
                  category: widget.controller.budgetCategories[i],
                  color: [
                    AppPalette.brightRed,
                    AppPalette.royalBlue,
                    AppPalette.navy,
                    const Color(0xFF10B981),
                    const Color(0xFFF59E0B),
                  ][i % 5],
                ),
            ],
          ),
        ),
      ],

      // Recent expenses
      const SizedBox(height: 28),
      Row(
        children: [
          const Expanded(child: SectionTitle('Recent Expenses')),
          if (widget.controller.budgetEntries.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppPalette.softRed,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${widget.controller.budgetEntries.length}',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: AppPalette.brightRed,
                ),
              ),
            ),
        ],
      ),
      const SizedBox(height: 12),
      if (widget.controller.budgetEntries.isEmpty)
        InfoCard(
          child: Column(
            children: [
              const Icon(Icons.receipt_long_rounded,
                  size: 40, color: AppPalette.muted),
              const SizedBox(height: 10),
              const Text(
                'No expenses yet. Tap "Add Expense" to log your first spending.',
                style: TextStyle(color: AppPalette.muted, height: 1.4),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      for (final entry in widget.controller.budgetEntries) ...[
        _ExpenseTile(entry: entry),
        const SizedBox(height: 10),
      ],
    ];

    if (widget.embedded) {
      return ListView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 120),
        children: page,
      );
    }

    return ModulePageScaffold(
      title: title,
      subtitle: subtitle,
      accent: AppPalette.brightRed,
      body: page,
    );
  }

  Future<void> _openInitialBudgetSheet() async {
    final ctrl = TextEditingController(
      text: widget.controller.initialBudget > 0
          ? widget.controller.initialBudget.toStringAsFixed(0)
          : '',
    );

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _BudgetSheet(
        title: 'Set Initial Budget',
        child: Column(
          children: [
            TextField(
              controller: ctrl,
              keyboardType: TextInputType.number,
              autofocus: true,
              decoration: const InputDecoration(
                hintText: 'Enter your total budget (PHP)',
                prefixIcon: Icon(Icons.savings_rounded),
              ),
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () async {
                  final amount = double.tryParse(ctrl.text.trim()) ?? 0;
                  if (amount <= 0) return;
                  await widget.controller.setInitialBudget(amount);
                  if (mounted) Navigator.of(context).pop();
                },
                style: FilledButton.styleFrom(
                  backgroundColor: AppPalette.brightRed,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Save Budget'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openCategorySheet() async {
    final nameCtrl = TextEditingController();
    final amtCtrl = TextEditingController();

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _BudgetSheet(
        title: 'Create Category',
        child: Column(
          children: [
            TextField(
              controller: nameCtrl,
              autofocus: true,
              decoration: const InputDecoration(
                hintText: 'Category name (e.g. Food, Transport)',
                prefixIcon: Icon(Icons.category_rounded),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: amtCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: 'Planned amount (PHP)',
                prefixIcon: Icon(Icons.attach_money_rounded),
              ),
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () async {
                  final name = nameCtrl.text.trim();
                  if (name.isEmpty) return;
                  await widget.controller.addBudgetCategory(
                    name: name,
                    plannedAmount: double.tryParse(amtCtrl.text.trim()) ?? 0,
                  );
                  if (mounted) Navigator.of(context).pop();
                },
                style: FilledButton.styleFrom(
                  backgroundColor: AppPalette.navy,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Save Category'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openExpenseSheet() async {
    final titleCtrl = TextEditingController();
    final amtCtrl = TextEditingController();
    BudgetCategory? selectedCategory =
        widget.controller.budgetCategories.isNotEmpty
            ? widget.controller.budgetCategories.first
            : null;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => _BudgetSheet(
          title: 'Add Expense',
          child: Column(
            children: [
              // Category selector (if categories exist)
              if (widget.controller.budgetCategories.isNotEmpty)
                DropdownButtonFormField<String>(
                  value: selectedCategory?.id,
                  items: widget.controller.budgetCategories
                      .map((c) => DropdownMenuItem(
                            value: c.id,
                            child: Text(c.name),
                          ))
                      .toList(),
                  onChanged: (val) {
                    final next = widget.controller.budgetCategories
                        .firstWhere((c) => c.id == val,
                            orElse: () =>
                                widget.controller.budgetCategories.first);
                    setModalState(() => selectedCategory = next);
                  },
                  decoration: const InputDecoration(
                    hintText: 'Select category',
                    prefixIcon: Icon(Icons.category_rounded),
                  ),
                )
              else
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppPalette.sky,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.info_outline_rounded,
                          color: AppPalette.royalBlue, size: 18),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'No categories yet — expense will be saved as uncategorized.',
                          style: TextStyle(
                              fontSize: 13, color: AppPalette.royalBlue),
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 12),
              TextField(
                controller: titleCtrl,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Expense title (e.g. Lunch)',
                  prefixIcon: Icon(Icons.receipt_rounded),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: amtCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: 'Amount (PHP)',
                  prefixIcon: Icon(Icons.attach_money_rounded),
                ),
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () async {
                    final title = titleCtrl.text.trim();
                    final amount =
                        double.tryParse(amtCtrl.text.trim()) ?? 0;
                    if (title.isEmpty || amount <= 0) return;
                    await widget.controller.addBudgetExpense(
                      title: title,
                      amount: amount,
                      categoryName: selectedCategory?.name ?? 'General',
                      categoryId: selectedCategory?.id ?? '',
                    );
                    if (mounted) Navigator.of(context).pop();
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: AppPalette.royalBlue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Save Expense'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OverviewPill extends StatelessWidget {
  const _OverviewPill({
    required this.label,
    required this.value,
    required this.color,
    this.prefix = '',
  });

  final String label;
  final String value;
  final Color color;
  final String prefix;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '$prefix$value',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionBtn extends StatelessWidget {
  const _ActionBtn({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.white, size: 22),
            const SizedBox(height: 6),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _ExpenseTile extends StatelessWidget {
  const _ExpenseTile({required this.entry});

  final BudgetEntry entry;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppPalette.softRed,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.receipt_rounded,
                color: AppPalette.brightRed, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppPalette.sky,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        entry.category.isNotEmpty
                            ? entry.category
                            : 'General',
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppPalette.royalBlue,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      entry.when,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppPalette.muted,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Text(
            '− PHP ${entry.amount.toStringAsFixed(0)}',
            style: const TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 14,
              color: AppPalette.brightRed,
            ),
          ),
        ],
      ),
    );
  }
}

class _BudgetSheet extends StatelessWidget {
  const _BudgetSheet({required this.title, required this.child});

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
