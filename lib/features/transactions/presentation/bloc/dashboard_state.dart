import 'package:equatable/equatable.dart';
import '../../domain/entities/transaction_entity.dart';

abstract class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object?> get props => [];
}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardSuccess extends DashboardState {
  final double totalExpenses;
  final double trendPercentage;
  final double weeklySpending;
  final double weeklyBudget;
  final List<double> weeklyData; // 7 values for Mon–Sun
  final List<TransactionEntity> recentTransactions;

  const DashboardSuccess({
    required this.totalExpenses,
    required this.trendPercentage,
    required this.weeklySpending,
    required this.weeklyBudget,
    required this.weeklyData,
    required this.recentTransactions,
  });

  @override
  List<Object?> get props => [
        totalExpenses,
        trendPercentage,
        weeklySpending,
        weeklyBudget,
        weeklyData,
        recentTransactions,
      ];
}

class DashboardFailure extends DashboardState {
  final String message;

  const DashboardFailure(this.message);

  @override
  List<Object?> get props => [message];
}
