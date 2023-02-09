import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:introducao_bloc/pages/state_subclass/home_controller.dart';
import 'package:introducao_bloc/pages/state_subclass/home_state.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final homeController = HomeController();

  final formKey = GlobalKey<FormState>();
  final cepEC = TextEditingController();

  @override
  void dispose() {
    cepEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeController, HomeState>(
      bloc: homeController,
      listener: (context, state) {
        if (state is HomeFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Erro ao buscar Endereço'),
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Buscar CEP'),
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
                  BlocBuilder<HomeController, HomeState>(
                    bloc: homeController,
                    builder: (context, state) {
                      return Visibility(
                        visible: state is HomeLoading,
                        child: const CircularProgressIndicator(),
                      );
                    },
                  ),
                  BlocBuilder<HomeController, HomeState>(
                    bloc: homeController,
                    builder: (context, state) {
                      if (state is HomeLoaded) {
                        return Text(
                            '${state.enderecoModel.logradouro} ${state.enderecoModel.complemento} ${state.enderecoModel.cep}');
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
