part of 'categories_bloc.dart';

abstract class CategoriesState {
  List<Category>? categories;

  CategoriesState(this.categories);

  @override
  List<Object?> get props => [categories];
}

class CategoriesInitial extends CategoriesState {
  CategoriesInitial() : super(null);
}

class CategoriesSuccess extends CategoriesState {
  CategoriesSuccess(List<Category>? categories) : super(categories);
}

class CategoriesError extends CategoriesState {
  final String error;

  CategoriesError(List<Category>? categories, this.error) : super(categories);
  
  @override
  List<Object?> get props => [categories, error];
}
