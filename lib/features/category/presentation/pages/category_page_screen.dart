import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resub/app/theme/theme_data.dart';
import 'package:resub/app/routes/app_routes.dart';
import 'package:resub/features/category/domain/entities/category_entity.dart';
import 'package:resub/features/category/presentation/pages/create_category_screen.dart';
import 'package:resub/features/category/presentation/pages/update_category_screen.dart';
import 'package:resub/features/category/presentation/state/category_state.dart';
import 'package:resub/features/category/presentation/view_models/category_view_model.dart';
import 'package:resub/features/category/presentation/widgets/category_card.dart';

class CategoryPageScreen extends ConsumerStatefulWidget {
  const CategoryPageScreen({super.key});

  @override
  ConsumerState<CategoryPageScreen> createState() => _CategoryPageScreenState();
}

class _CategoryPageScreenState extends ConsumerState<CategoryPageScreen> {
  late List<CategoryEntity> _categories = [];
  late final List<String> _shops = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUserData();
    });
  }

  void _loadUserData() async {
    await ref.read(categoryViewModelProvider.notifier).getAllCategories();
  }

  void _handleAddCategory(CategoryEntity category) {
    setState(() {
      _categories.add(
        category.copyWith(id: DateTime.now().millisecondsSinceEpoch.toString()),
      );
    });
    if (mounted) {
      Navigator.pop(context);
    }
  }

  void _handleUpdateCategory(CategoryEntity category) {
    setState(() {
      final index = _categories.indexWhere((cat) => cat.id == category.id);
      if (index != -1) {
        _categories[index] = category;
      }
    });
    if (mounted) {
      Navigator.pop(context);
    }
  }

  void _handleDeleteCategory(String id) {
    setState(() {
      _categories.removeWhere((category) => category.id == id);
    });
  }

  void _openCreateCategoryScreen() {
    AppRoutes.push(
      context,
      CreateCategoryScreen(
        onCategoryCreated: _handleAddCategory,
        shops: _shops,
      ),
    );
  }

  void _openUpdateCategoryScreen(CategoryEntity category) {
    AppRoutes.push(
      context,
      UpdateCategoryScreen(
        category: category,
        onCategoryUpdated: _handleUpdateCategory,
        shops: _shops,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final appColors = theme.extension<AppThemeColors>();

    ref.listen<CategoryState>(categoryViewModelProvider, (previous, next) {
      if (next.status == CategoryStatus.loaded) {
        setState(() {
          _categories = next.categories ?? [];
        });
      }
    });
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        title: Text(
          'My Categories',
          style: TextStyle(
            color: colorScheme.onSurface,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.arrow_back, color: colorScheme.onSurface),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: _categories.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.category_outlined,
                          size: 64,
                          color:
                              appColors?.mutedText ??
                              colorScheme.onSurface.withValues(alpha: 0.55),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No categories yet',
                          style: TextStyle(
                            fontSize: 16,
                            color:
                                appColors?.secondaryText ??
                                colorScheme.onSurface.withValues(alpha: 0.8),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Add a new category to get started',
                          style: TextStyle(
                            fontSize: 14,
                            color:
                                appColors?.mutedText ??
                                colorScheme.onSurface.withValues(alpha: 0.65),
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: _categories.length,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemBuilder: (context, index) {
                      final category = _categories[index];
                      return CategoryCard(
                        category: category,
                        allShops: _shops,
                        onLeftIconTap: () =>
                            _openUpdateCategoryScreen(category),
                        onDelete: () =>
                            _handleDeleteCategory(category.id ?? ''),
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _openCreateCategoryScreen,
                icon: const Icon(Icons.add),
                label: const Text('Add New Category'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
