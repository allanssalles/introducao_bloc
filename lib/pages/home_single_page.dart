import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:introducao_bloc/pages/state_single_class/home_state.dart';

import 'state_single_class/home_single_class_controller.dart';

class HomeSinglePage extends StatefulWidget {
  const HomeSinglePage({super.key});

  @override
  State<HomeSinglePage> createState() => _HomeSinglePageState();
}

class _HomeSinglePageState extends State<HomeSinglePage> {
  final homeController = HomeSingleClassController();

  final formKey = GlobalKey<FormState>();
  final cepEC = TextEditingController();
  var loadingOpen = false;

  @override
  void dispose() {
    cepEC.dispose();
    super.dispose();
  }

  void showLoading() {
    if (!loadingOpen) {
      loadingOpen = true;
      showDialog(
          context: context,
          builder: (context) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          });
    }
  }

  void hideLoader() {
    if (loadingOpen) {
      loadingOpen = false;
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeSingleClassController, HomeState>(
      bloc: homeController,
      listener: (context, state) {
        state.status.matchAny(
            any: () {
              hideLoader();
            },
            loading: () => showLoading(),
            failure: () {
              hideLoader();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Erro ao buscar Endereço'),
                ),
              );
            });
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('CEP Single Class'),
        ),
        body: SingleChildScrollView(
          child: Form(
              key: formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: cepEC,
                    validator: ((value) {
                      if (value == null || value.isEmpty) {
                        return 'CEP Obrigatório';
                      }
                      return null;
                    }),
                  ),
                  ElevatedButton(
                    onPressed: (() async {
                      final valid = formKey.currentState?.validate() ?? false;
                      if (valid) {
                        homeController.findCep(cepEC.text);
                      }
                    }),
                    child: const Text('Buscar'),
                  ),
                  // BlocBuilder<HomeSingleClassController, HomeState>(
                  //   bloc: homeController,
                  //   builder: (context, state) {
                  //     return Visibility(
                  //       visible: state.status == HomeStatus.loading,
                  //       child: const CircularProgressIndicator(),
                  //     );
                  //   },
                  // ),
                  BlocBuilder<HomeSingleClassController, HomeState>(
                    bloc: homeController,
                    builder: (context, state) {
                      if (state.status == HomeStatus.loaded ||
                          state.enderecoModel != null) {
                        return Text(
                            '${state.enderecoModel?.logradouro} ${state.enderecoModel?.complemento} ${state.enderecoModel?.cep}');
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
