import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/category_entity.dart';
import '../../domain/entities/transaction_entity.dart';
import 'dashboard_event.dart';
import 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc() : super(DashboardInitial()) {
    on<DashboardLoaded>(_onDashboardLoaded);
  }

  Future<void> _onDashboardLoaded(
    DashboardLoaded event,
    Emitter<DashboardState> emit,
  ) async {
    emit(DashboardLoading());

    // TODO: Replace with real use cases when data layer is ready
    await Future.delayed(const Duration(milliseconds: 600));

    final now = DateTime.now();

    final mockTransactions = [
      TransactionEntity(
        id: '1',
        userId: 'user-1',
        amount: 84.50,
        title: 'Whole Foods Market',
        category: const CategoryEntity(
          id: 'cat-1',
          name: 'Groceries',
          icon: '🛒',
          color: '#4CAF50',
          type: 'expense',
        ),
        date: now,
        inputSource: TransactionInputSource.manual,
        createdAt: now,
        updatedAt: now,
      ),
      TransactionEntity(
        id: '2',
        userId: 'user-1',
        amount: 32.00,
        title: 'Metro Card Refill',
        category: const CategoryEntity(
          id: 'cat-2',
          name: 'Transport',
          icon: '🚇',
          color: '#2196F3',
          type: 'expense',
        ),
        date: now.subtract(const Duration(days: 1)),
        inputSource: TransactionInputSource.manual,
        createdAt: now,
        updatedAt: now,
      ),
      TransactionEntity(
        id: '3',
        userId: 'user-1',
        amount: 15.99,
        title: 'Netflix Subscription',
        category: const CategoryEntity(
          id: 'cat-3',
          name: 'Entertainment',
          icon: '🎬',
          color: '#E91E63',
          type: 'expense',
        ),
        date: now.subtract(const Duration(days: 5)),
        notes: 'Automatic',
        inputSource: TransactionInputSource.manual,
        createdAt: now,
        updatedAt: now,
      ),
      TransactionEntity(
        id: '4',
        userId: 'user-1',
        amount: 6.45,
        title: 'Starbucks Coffee',
        category: const CategoryEntity(
          id: 'cat-4',
          name: 'Food & Drink',
          icon: '☕',
          color: '#FF9800',
          type: 'expense',
        ),
        date: now.subtract(const Duration(days: 7)),
        inputSource: TransactionInputSource.manual,
        createdAt: now,
        updatedAt: now,
      ),
    ];

    emit(DashboardSuccess(
      totalExpenses: 12450.00,
      trendPercentage: 2.5,
      weeklySpending: 450,
      weeklyBudget: 600,
      weeklyData: const [50, 75, 60, 90, 120, 35, 20],
      recentTransactions: mockTransactions,
    ));
  }
}
