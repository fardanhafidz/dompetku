import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/di/injection_container.dart';

import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_design_system.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../bloc/dashboard_bloc.dart';
import '../bloc/dashboard_event.dart';
import '../bloc/dashboard_state.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/expense_summary_card.dart';
import '../widgets/quick_actions_row.dart';
import '../widgets/weekly_chart_card.dart';
import '../widgets/recent_transactions_section.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<DashboardBloc>()..add(DashboardLoaded()),
      child: const _DashboardView(),
    );
  }
}

class _DashboardView extends StatelessWidget {
  const _DashboardView();

  @override
  Widget build(BuildContext context) {
    // Get user name from AuthBloc
    String fullName = 'User';
    final authState = context.watch<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      fullName = authState.session.user.fullName;
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: BlocBuilder<DashboardBloc, DashboardState>(
          builder: (context, state) {
            if (state is DashboardLoading || state is DashboardInitial) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              );
            }

            if (state is DashboardFailure) {
              return Center(
                child: Text(
                  state.message,
                  style: GoogleFonts.manrope(color: AppColors.subtext),
                ),
              );
            }

            if (state is DashboardSuccess) {
              return RefreshIndicator(
                color: AppColors.primary,
                onRefresh: () async {
                  context.read<DashboardBloc>().add(DashboardLoaded());
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: AppSpacing.lg),
                      DashboardHeader(fullName: fullName),
                      const SizedBox(height: AppSpacing.xxl),
                      ExpenseSummaryCard(
                        totalExpenses: state.totalExpenses,
                        trendPercentage: state.trendPercentage,
                        onDetailPressed: () {}, // Enable the button
                      ),
                      const SizedBox(height: AppSpacing.xxxl),
                      const QuickActionsRow(
                        actions: [
                          QuickActionItem(
                            icon: Icons.add,
                            label: 'Tambah\nManual',
                          ),
                          QuickActionItem(
                            icon: Icons.calendar_today_outlined,
                            label: 'Harian',
                          ),
                          QuickActionItem(
                            icon: Icons.grid_view_outlined,
                            label: 'Kategori',
                          ),
                          QuickActionItem(
                            icon: Icons.download_outlined,
                            label: 'Ekspor',
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.xxxl),
                      WeeklyChartCard(
                        weeklySpending: state.weeklySpending,
                        weeklyBudget: state.weeklyBudget,
                        weeklyData: state.weeklyData,
                      ),
                      const SizedBox(height: AppSpacing.xxxl),
                      RecentTransactionsSection(
                        transactions: state.recentTransactions,
                      ),
                      const SizedBox(height: AppSpacing.xxl),
                    ],
                  ),
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
