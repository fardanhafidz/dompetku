import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_transactions.dart';
import 'dashboard_event.dart';
import 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final GetTransactionsUseCase getTransactions;

  DashboardBloc({required this.getTransactions}) : super(DashboardInitial()) {
    on<DashboardLoaded>(_onDashboardLoaded);
  }

  Future<void> _onDashboardLoaded(
    DashboardLoaded event,
    Emitter<DashboardState> emit,
  ) async {
    emit(DashboardLoading());

    // 1. Panggil UseCase untuk fetch data asli dari DB
    final result = await getTransactions.call(const GetTransactionsParams());

    result.fold(
      (failure) {
        emit(DashboardFailure(failure.message));
      },
      (transactions) {
        // 2. Kalkulasi Total Expense dari semua transaksi asli
        final expense = transactions.fold(0.0, (sum, t) => sum + t.amount);
            
        emit(DashboardSuccess(
          totalExpenses: expense,
          trendPercentage: 2.5, // Dummy trend until analytics implemented
          weeklySpending: 450.0, // Dummy
          weeklyBudget: 600.0, // Dummy
          weeklyData: const [50, 75, 60, 90, 120, 35, 20], // Dummy
          recentTransactions: transactions,
        ));
      },
    );
  }
}
