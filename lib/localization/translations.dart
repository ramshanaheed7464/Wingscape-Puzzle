import 'package:get/get.dart';

class AppTranslation extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en': {
          'sound': 'Sound',
          'music': 'Music',
          'rules': 'Rules',
          't1':
              'You will have to solve puzzles to collect combinations, using your attentiveness and making combinations of different lengths and shapes with the help of lines and identical symbols.',
          't2':
              'You need to connect the same symbols that are next to each other vertically, diagonally or horizontally from 3 to one combination. The more symbols in one combination, the more points you get. The main thing is that each subsequent symbol in the combination must be next to the previous one and exactly the same as it.\n',
          't3':
              'To start connecting a combination, just click on any symbol and start drawing a connecting line from it to the next symbol. As soon as you release your finger from the screen, the line will break. And if you have connected 3 symbols or more, they will disappear and the remaining symbols will fall.\n',
          't4':
              'If you connected timer symbols, you will get extra time. The bigger the combination, the more time you get.\n\n',
          't5':
              '"Wild" symbol can be any symbol and can be at the beginning of the combination, in the middle or at the end. It is important that Wild symbol, even if it is not one in the combination, has only one value and it coincides with the first symbol that was attached to the "Wild".',
          'level': 'Level',
          'go': 'Go',
          'score': 'Score',
          'summ': 'Summ',
          'pause': 'Pause',
          'bestScore': 'Best Score',
          'currentScore': 'Current Score',
        },
        'pt': {
          'sound': 'Som',
          'music': 'Música',
          'rules': 'Regras',
          't1':
              'Você terá que resolver quebra-cabeças para coletar combinações, usando sua atenção e fazendo combinações de diferentes comprimentos e formas com a ajuda de linhas e símbolos idênticos.',
          't2':
              'Você precisa conectar os mesmos símbolos que estão próximos uns dos outros verticalmente, diagonalmente ou horizontalmente de 3 para uma combinação. Quanto mais símbolos em uma combinação, mais pontos você ganha. O principal é que cada símbolo subsequente na combinação deve estar próximo ao anterior e exatamente igual a ele.\n',
          't3':
              'Para começar a conectar uma combinação, basta clicar em qualquer símbolo e começar a desenhar uma linha de conexão dele até o próximo símbolo. Assim que você tirar o dedo da tela, a linha será quebrada. E se você conectou 3 símbolos ou mais, eles desaparecerão e os símbolos restantes cairão.\n',
          't4':
              'Se você conectou símbolos de cronômetro, receberá tempo extra. Quanto maior a combinação, mais tempo você ganha.\n\n',
          't5':
              'O símbolo “Wild” pode ser qualquer símbolo e pode estar no início da combinação, no meio ou no final. É importante que o símbolo Wild, mesmo que não seja um na combinação, tenha apenas um valor e coincida com o primeiro símbolo que foi anexado ao “Wild”.',
          'level': 'Nível',
          'go': 'Ir',
          'score': 'Pontuação',
          'summ': 'Soma',
          'pause': 'Pausa',
        },
      };
}
