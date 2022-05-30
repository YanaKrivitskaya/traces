part of 'categories_bloc.dart';

@immutable
abstract class CategoriesEvent {
  List<Object?> get props => [];
}

class GetCategories extends CategoriesEvent {}

class NewCategoryMode extends CategoriesEvent {}

class CreateCategory extends CategoriesEvent {
  final Category category;
 
  CreateCategory(this.category);

  List<Object?> get props => [category];
}

class GetCategoryDetails extends CategoriesEvent {
  final int categoryId;
 
  GetCategoryDetails(this.categoryId);

  List<Object?> get props => [categoryId];
}
