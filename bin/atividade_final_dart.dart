import 'dart:io';
import 'package:atividade_final_dart/relatorio_temperatura.dart';
import 'package:atividade_final_dart/relatorio_umidade_do_ar.dart';
import 'package:atividade_final_dart/relatorio_vento.dart';
void main () async {
  bool continuar = true;
  print('OLÁ, LEANDRO. QUE RELATÓRIO VOCÊ PRECISA? '
    '\n1 - TEMPERATURA '
    '\n2 - UMIDADE '
    '\n3 - DIREÇÃO DO VENTO ');
  while(continuar){
    
    stdout.write('DIGITE O NÚMERO DA OPÇÃO DESEJADA: ');
    final resposta = stdin.readLineSync();

    switch (resposta){
      case '1':
        print('\n');
        chamarMetodosTemperatura('SC');
        chamarMetodosTemperatura('SP');
        continuar=false;
        break;
      case '2':
        print('\n');
        chamarMetodosUmidade('SC');
        chamarMetodosUmidade('SP');
        continuar=false;
        break;
      case '3':
        print('\n');
        chamarMetodosVento('SC');
        chamarMetodosVento('SP');
        continuar=false;
        break;
      default:
        print('RESPONDA 1, 2 OU 3 ');

    }
    
  }
}
