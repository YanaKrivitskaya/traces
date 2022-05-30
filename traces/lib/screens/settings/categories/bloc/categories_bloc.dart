import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:traces/screens/settings/categories/repository/api_categories_repository.dart';
import 'package:traces/screens/settings/model/category.model.dart';

part 'categories_event.dart';
part 'categories_state.dart';

class CategoriesBloc extends Bloc<CategoriesEvent, CategoriesState> {
  final ApiCategoriesRepository _categoriesRepository;
  
  CategoriesBloc() : 
  _categoriesRepository = new ApiCategoriesRepository(),
  super(CategoriesInitial()) {
    on<GetCategories>(_onGetCategories);
    on<NewCategoryMode>(_onNewCategoryMode);
  }

    void _onGetCategories(GetCategories event, Emitter<CategoriesState> emit) async {
      List<Category>? categories = await _categoriesRepository.getCategories();
      emit(CategoriesSuccess(categories));    
    }

  void _onNewCategoryMode(NewCategoryMode event, Emitter<CategoriesState> emit) async {   
    emit(CategoriesEdit(state.categories, null));
  }
}
