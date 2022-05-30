part of 'categories_bloc.dart';

@immutable
abstract class CategoriesEvent {
  List<Object?> get props => [];
}

class GetCategories extends CategoriesEvent {}

class CreateCategory extends CategoriesEvent {
  final Category category;
 
  CreateCategory(this.category);

  List<Object?> get props => [category];
}
