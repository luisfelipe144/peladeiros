import 'package:flutter/material.dart';
import 'game_controller.dart';

class JogadorController extends ChangeNotifier {
  GameController? gameController;
  List<String> participantes = [];
  List<String> jogadoresQueJaJogaram = [];

  List<String> get todosOsJogadores => participantes;

  void adicionarParticipante(String jogador) {
    participantes.add(jogador);
    _notify();
  }

  void removerParticipante(String jogador) {
    participantes.remove(jogador);
    _notify();
  }

  void adicionarJogadorQueJaJogou(String jogador) {
    jogadoresQueJaJogaram.add(jogador);
    _notify();
  }

  void _notify() {
    notifyListeners();
    gameController?.notify();
  }
}
