import 'package:bloc/bloc.dart';
import 'package:introducao_bloc/models/endereco_model.dart';

import '../../repositories/cep_repository.dart';
import '../../repositories/cep_repository_impl.dart';
import 'home_state.dart';

class HomeController extends Cubit<HomeState> {
  final CepRepository cepRepository = CepRepositoryImpl();
  HomeController() : super(HomeInitial());

  Future<void> findCep(String cep) async {
    try {
      emit(HomeLoading());
      final enderecoModel = await cepRepository.getCep(cep);
      emit(HomeLoaded(enderecoModel: enderecoModel));
    } catch (e) {
      emit(HomeFailure());
    }
  }
}
