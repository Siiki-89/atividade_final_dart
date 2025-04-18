import 'dart:io';
import 'package:atividade_final_dart/relatorio_temperatura.dart';

void main (){
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
        chamarMetodos('SC');
        chamarMetodos('SP');
        continuar=false;
        break;
      case '2':
        //relatorioUmidade();
        continuar=false;
        break;
      case '3':
        //relatorioDirecaoVento();
        continuar=false;
        break;
      default:
        print('RESPONDA 1, 2 OU 3 ');

    }
    
  }
}
