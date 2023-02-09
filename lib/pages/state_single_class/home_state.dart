// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:introducao_bloc/models/endereco_model.dart';
import 'package:match/match.dart';

part 'home_state.g.dart';

@match
enum HomeStatus { initial, loading, loaded, failure }

class HomeState {
  final EnderecoModel? enderecoModel;
  final HomeStatus status;

  HomeState({
    this.status = HomeStatus.initial,
    this.enderecoModel,
  });

  HomeState copyWith({
    EnderecoModel? enderecoModel,
    HomeStatus? status,
  }) {
    return HomeState(
      enderecoModel: enderecoModel ?? this.enderecoModel,
      status: status ?? this.status,
    );
  }
}
