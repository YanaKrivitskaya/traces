part of 'categories_bloc.dart';

@immutable
abstract class CategoriesEvent {
  List<Object?> get props => [];
}

class GetCategories extends CategoriesEvent {}

class NewCategoryMode extends CategoriesEvent {}

class UpdateCategoryMode extends CategoriesEvent {
  final Category category;
 
  UpdateCategoryMode(this.category);

  List<Object?> get props => [category];
}

class CategoryUpdated extends CategoriesEvent {
  final Category category;
 
  CategoryUpdated(this.category);

  List<Object?> get props => [category];
}

class IconUpdated extends CategoriesEvent {
  final IconData icon;
 
  IconUpdated(this.icon);

  List<Object?> get props => [icon];
}

class ColorUpdated extends CategoriesEvent {
  final Color color;
 
  ColorUpdated(this.color);

  List<Object?> get props => [color];
}

class GetCategoryDetails extends CategoriesEvent {
  final int categoryId;
 
  GetCategoryDetails(this.categoryId);

  List<Object?> get props => [categoryId];
}
