import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_design_system.dart';
import '../../domain/entities/category_entity.dart';
import '../bloc/transaction_form_bloc.dart';
import '../bloc/transaction_form_event.dart';
import '../bloc/transaction_form_state.dart';

class FormInputPage extends StatelessWidget {
  const FormInputPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<TransactionFormBloc>()..add(LoadCategories()),
      child: const _FormInputView(),
    );
  }
}

class _FormInputView extends StatefulWidget {
  const _FormInputView();

  @override
  State<_FormInputView> createState() => _FormInputViewState();
}

class _FormInputViewState extends State<_FormInputView> {
  final _amountController = TextEditingController();
  final _titleController = TextEditingController();
  final _notesController = TextEditingController();

  CategoryEntity? _selectedCategory;
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();

  @override
  void dispose() {
    _amountController.dispose();
    _titleController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.onBackground),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Tambah Pengeluaran',
          style: GoogleFonts.manrope(
            color: AppColors.onBackground,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocConsumer<TransactionFormBloc, TransactionFormState>(
        listener: (context, state) {
          if (state is TransactionFormSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.primary,
              ),
            );
            Navigator.of(context).pop();
          }
          if (state is TransactionFormFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is TransactionFormLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          List<CategoryEntity> categories = [];
          if (state is CategoriesLoaded) {
            categories = state.categories;
          }
          if (state is TransactionFormFailure && state.categories != null) {
            categories = state.categories!;
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppSpacing.lg),
                _buildSectionLabel('AMOUNT'),
                const SizedBox(height: AppSpacing.sm),
                _buildAmountField(),
                const SizedBox(height: AppSpacing.xxl),
                _buildSectionLabel('TITLE'),
                const SizedBox(height: AppSpacing.sm),
                _buildTitleField(),
                const SizedBox(height: AppSpacing.xxl),
                _buildSectionLabel('CATEGORY'),
                const SizedBox(height: AppSpacing.md),
                _buildCategorySelector(categories),
                const SizedBox(height: AppSpacing.xxl),
                _buildSectionLabel('DATE & TIME'),
                const SizedBox(height: AppSpacing.sm),
                _buildDateTimePicker(),
                const SizedBox(height: AppSpacing.xxl),
                _buildSectionLabel('NOTES (OPTIONAL)'),
                const SizedBox(height: AppSpacing.sm),
                _buildNotesField(),
                const SizedBox(height: AppSpacing.xxxl),
                _buildSubmitButton(state),
                const SizedBox(height: AppSpacing.xxxl),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionLabel(String text) {
    return Text(
      text,
      style: GoogleFonts.manrope(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: AppColors.subtext,
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildAmountField() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.medium,
        border: Border.all(color: AppColors.neutralGrey),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.xs,
      ),
      child: Row(
        children: [
          Text(
            'Rp',
            style: GoogleFonts.manrope(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppColors.onBackground,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              style: GoogleFonts.manrope(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: AppColors.onBackground,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: '0',
                hintStyle: GoogleFonts.manrope(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: AppColors.subtext.withValues(alpha: 0.4),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitleField() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.medium,
        border: Border.all(color: AppColors.neutralGrey),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.xs,
      ),
      child: TextField(
        controller: _titleController,
        style: GoogleFonts.manrope(
          fontSize: 16,
          color: AppColors.onBackground,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Enter transaction title',
          hintStyle: GoogleFonts.manrope(
            fontSize: 16,
            color: AppColors.subtext.withValues(alpha: 0.5),
          ),
        ),
      ),
    );
  }

  Widget _buildCategorySelector(List<CategoryEntity> categories) {
    if (categories.isEmpty) {
      return const SizedBox(
        height: 80,
        child: Center(child: CircularProgressIndicator(color: AppColors.primary)),
      );
    }

    return SizedBox(
      height: 80,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.md),
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = _selectedCategory?.id == category.id;

          return GestureDetector(
            onTap: () => setState(() => _selectedCategory = category),
            child: Column(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.neutralGrey,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      _getCategoryIcon(category.icon),
                      size: 24,
                      color: isSelected
                          ? AppColors.onPrimary
                          : AppColors.subtext,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  category.name,
                  style: GoogleFonts.manrope(
                    fontSize: 11,
                    fontWeight:
                        isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected
                        ? AppColors.onBackground
                        : AppColors.subtext,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  IconData _getCategoryIcon(String iconName) {
    const iconMap = {
      'restaurant': Icons.restaurant,
      'directions_car': Icons.directions_car,
      'shopping_cart': Icons.shopping_cart,
      'coffee': Icons.coffee,
      'receipt_long': Icons.receipt_long,
      'movie': Icons.movie,
    };
    return iconMap[iconName] ?? Icons.category;
  }

  Widget _buildDateTimePicker() {
    final formattedDate = DateFormat('MM/dd/yyyy').format(_selectedDate);
    final formattedTime = _selectedTime.format(context);

    return GestureDetector(
      onTap: () => _pickDateTime(),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: AppRadius.medium,
          border: Border.all(color: AppColors.neutralGrey),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.lg,
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_today_outlined,
                color: AppColors.subtext, size: 20),
            const SizedBox(width: AppSpacing.md),
            Text(
              '$formattedDate, $formattedTime',
              style: GoogleFonts.manrope(
                fontSize: 16,
                color: AppColors.onBackground,
              ),
            ),
            const Spacer(),
            const Icon(Icons.calendar_month_outlined,
                color: AppColors.subtext, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildNotesField() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.medium,
        border: Border.all(color: AppColors.neutralGrey),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.xs,
      ),
      child: TextField(
        controller: _notesController,
        maxLines: 3,
        style: GoogleFonts.manrope(
          fontSize: 14,
          color: AppColors.onBackground,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Add details about this expense...',
          hintStyle: GoogleFonts.manrope(
            fontSize: 14,
            color: AppColors.subtext.withValues(alpha: 0.5),
          ),
        ),
      ),
    );
  }

  Widget _buildSubmitButton(TransactionFormState state) {
    final isSubmitting = state is TransactionFormSubmitting;

    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton.icon(
        onPressed: isSubmitting ? null : _onSubmit,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.large,
          ),
          elevation: 0,
        ),
        icon: isSubmitting
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.onPrimary,
                ),
              )
            : const Icon(Icons.save_outlined),
        label: Text(
          isSubmitting ? 'Menyimpan...' : 'Simpan Transaksi',
          style: GoogleFonts.manrope(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  void _onSubmit() {
    final amountText = _amountController.text.trim();
    final title = _titleController.text.trim();

    if (amountText.isEmpty || double.tryParse(amountText) == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Masukkan jumlah yang valid'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Masukkan nama merchant / judul'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pilih kategori'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final dateTime = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );

    context.read<TransactionFormBloc>().add(
          SubmitTransaction(
            amount: double.parse(amountText),
            title: title,
            category: _selectedCategory!,
            date: dateTime,
            notes: _notesController.text.trim().isEmpty
                ? null
                : _notesController.text.trim(),
          ),
        );
  }

  Future<void> _pickDateTime() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: AppColors.primary),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null && mounted) {
      final pickedTime = await showTimePicker(
        context: context,
        initialTime: _selectedTime,
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(primary: AppColors.primary),
            ),
            child: child!,
          );
        },
      );

      if (pickedTime != null && mounted) {
        setState(() {
          _selectedDate = pickedDate;
          _selectedTime = pickedTime;
        });
      }
    }
  }
}
