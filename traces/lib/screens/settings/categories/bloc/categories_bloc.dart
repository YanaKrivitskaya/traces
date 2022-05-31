import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:traces/screens/settings/categories/repository/api_categories_repository.dart';
import 'package:traces/screens/settings/model/category-usage.model.dart';
import 'package:traces/screens/settings/model/category.model.dart';
import 'package:traces/utils/api/customException.dart';

part 'categories_event.dart';
part 'categories_state.dart';

class CategoriesBloc extends Bloc<CategoriesEvent, CategoriesState> {
  final ApiCategoriesRepository _categoriesRepository;
  
  CategoriesBloc() : 
  _categoriesRepository = new ApiCategoriesRepository(),
  super(CategoriesInitial()) {
    on<GetCategories>(_onGetCategories);
    on<NewCategoryMode>(_onNewCategoryMode);
    on<IconUpdated>(_onIconUpdated);
    on<ColorUpdated>(_onColorUpdated);
    on<CategoryUpdated>(_onCategoryUpdated);
    on<UpdateCategoryMode>(_onUpdateCategoryMode);
    on<GetCategoryUsage>(_onGetCategoryUsage);
    on<DeleteCategory>(_onDeleteCategory);
  }

  void _onGetCategories(GetCategories event, Emitter<CategoriesState> emit) async {
    List<Category>? categories = await _categoriesRepository.getCategories();
    emit(CategoriesSuccess(categories));    
  }

  void _onGetCategoryUsage(GetCategoryUsage event, Emitter<CategoriesState> emit) async {
    var currentState = state;
    emit(CategoriesLoading(state.categories, state.selectedCategory));
    try{
      var categoryUsage = await _categoriesRepository.getCategoryUsage(event.category.id!);

      emit(CategoryToDelete(currentState.categories, categoryUsage));
    }on CustomException catch(e){      
      return emit(CategoriesError(currentState.categories, currentState.selectedCategory, e.toString()));
    }
  }

  void _onNewCategoryMode(NewCategoryMode event, Emitter<CategoriesState> emit) async {
    emit(CategoriesEdit(state.categories, null, null, null));
  }

  void _onUpdateCategoryMode(UpdateCategoryMode event, Emitter<CategoriesState> emit) async {
    emit(CategoriesEdit(state.categories, event.category, null, null));
  }

  void _onIconUpdated(IconUpdated event, Emitter<CategoriesState> emit) async {
    var currentState = state;
    emit(CategoriesLoading(state.categories, state.selectedCategory));
    emit(CategoriesEdit(currentState.categories, currentState.selectedCategory, event.icon, (currentState as CategoriesEdit).selectedColor));
  }

  void _onColorUpdated(ColorUpdated event, Emitter<CategoriesState> emit) async {
    var currentState = state;
    emit(CategoriesLoading(state.categories, state.selectedCategory));
    emit(CategoriesEdit(currentState.categories, currentState.selectedCategory, (currentState as CategoriesEdit).selectedIcon, event.color ));
  }

  void _onCategoryUpdated(CategoryUpdated event, Emitter<CategoriesState> emit) async {
    var currentState = state;
    emit(CategoriesLoading(state.categories, state.selectedCategory));

    try{
      if(event.category.id != null){
        await _categoriesRepository.updateCategory(event.category);
      }else{
        await _categoriesRepository.createCategory(event.category);
      }
      
      emit(CategoryUpdatedState(currentState.categories, currentState.selectedCategory));
    }on CustomException catch(e){      
      return emit(CategoriesError(currentState.categories, currentState.selectedCategory, e.toString()));
    }    
  }

  void _onDeleteCategory(DeleteCategory event, Emitter<CategoriesState> emit) async {
    var currentState = state;
    emit(CategoriesLoading(state.categories, state.selectedCategory));

    var newCategory = event.newCategory;

    try{
      if(event.category.id != null){
        if(newCategory!= null && newCategory!.id == null){
          newCategory = await _categoriesRepository.createCategory(newCategory!);
        }
        await _categoriesRepository.deleteCategory(event.category.id!, newCategory?.id);
      }else{
        return emit(CategoriesError(currentState.categories, currentState.selectedCategory, "Category Id not defined"));
      }
      
      return emit(CategoryUpdatedState(currentState.categories, currentState.selectedCategory));
    }on CustomException catch(e){      
      return emit(CategoriesError(currentState.categories, currentState.selectedCategory, e.toString()));
    }    
  }
}
