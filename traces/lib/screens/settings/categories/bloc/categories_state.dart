part of 'categories_bloc.dart';

abstract class CategoriesState {
  List<Category>? categories;
  Category? selectedCategory;

  CategoriesState(this.categories, this.selectedCategory);

  @override
  List<Object?> get props => [categories, selectedCategory];
}

class CategoriesInitial extends CategoriesState {
  CategoriesInitial() : super(null, null);
}

class CategoriesLoading extends CategoriesState {
  CategoriesLoading(List<Category>? categories,  Category? category) : super(categories, category);
}

class CategoriesSuccess extends CategoriesState {
  CategoriesSuccess(List<Category>? categories) : super(categories, null);
}

class CategoriesEdit extends CategoriesState {
  final Category? category;
  final IconData? selectedIcon;
  final Color? selectedColor;

  CategoriesEdit(List<Category>? categories, this.category, this.selectedIcon, this.selectedColor) : super(categories, category);

  @override
  List<Object?> get props => [categories, category, selectedIcon, selectedColor];
}

class CategoryToDelete extends CategoriesState {
    final CategoryUsage? categoryUsage; 

  CategoryToDelete(List<Category>? categories, this.categoryUsage) : super(categories, null);

  @override
  List<Object?> get props => [categories, categoryUsage];
}

class CategoryUpdatedState extends CategoriesState {
  CategoryUpdatedState(List<Category>? categories,  Category? category) : super(categories, category);
}

class CategoriesError extends CategoriesState {
  final String error;

  CategoriesError(List<Category>? categories, Category?  selectedCategory, this.error) : super(categories, selectedCategory);
  
  @override
  List<Object?> get props => [categories, selectedCategory, error];
}
