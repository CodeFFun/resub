import 'package:equatable/equatable.dart';
import 'package:resub/features/category/domain/entities/category_entity.dart';

enum CategoryStatus {
  initial,
  loading,
  created,
  updated,
  deleted,
  error,
  loaded,
}

class CategoryState extends Equatable {
  final CategoryStatus? status;
  final CategoryEntity? category;
  final List<CategoryEntity>? categories;
  final String? errorMessage;

  const CategoryState({
    this.status,
    this.category,
    this.categories,
    this.errorMessage,
  });

  CategoryState copyWith({
    CategoryStatus? status,
    CategoryEntity? category,
    List<CategoryEntity>? categories,
    String? errorMessage,
  }) {
    return CategoryState(
      status: status ?? this.status,
      category: category ?? this.category,
      categories: categories ?? this.categories,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, category, categories, errorMessage];
}
