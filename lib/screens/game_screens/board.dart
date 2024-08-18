import 'dart:math';

import 'package:flutter_svg/svg.dart';
import 'package:wingscape_puzzle/controllers/game_state_controller.dart';
import 'package:wingscape_puzzle/style/theme.dart';
import 'package:wingscape_puzzle/utils/icons.dart';
import 'package:wingscape_puzzle/utils/images.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../widgets/line_painter.dart';

class SymbolMatching extends StatefulWidget {
  final BoxConstraints constraints;
  final Function(List<String>, int) onMatch;

  const SymbolMatching(
      {Key? key, required this.onMatch, required this.constraints})
      : super(key: key);

  @override
  SymbolMatchingState createState() => SymbolMatchingState();
}

class SymbolMatchingState extends State<SymbolMatching>
    with TickerProviderStateMixin {
  final controller = Get.find<GameStateController>();

  final int rows = 7;
  final int columns = 5;
  List<List<String>> board = [];

  List<Offset> selectedPositions = [];
  String? selectedSymbolType;
  List<Offset> lineToDraw = [];

  final GlobalKey _gridkey = GlobalKey();
  late double cellSize;

  int score = 0;

  @override
  void initState() {
    super.initState();
    initializeBoard();
    cellSize = min(
      (widget.constraints.maxWidth - 1) / columns,
      (widget.constraints.maxHeight - 1) / rows,
    );
  }

  void initializeBoard() {
    board = List.generate(
        rows, (_) => List.generate(columns, (_) => GameIcons.getRandomIcon()));
  }

  void refreshBoard() {
    setState(() {
      initializeBoard();
    });
  }

  void regenerateBoard() {
    setState(() {
      initializeBoard();
      score = 0;
    });
  }

  void selectSymbol(Offset position) {
    int row = position.dy.toInt();
    int col = position.dx.toInt();

    if (row < 0 || row >= rows || col < 0 || col >= columns) return;

    if (selectedPositions.isEmpty) {
      setState(() {
        selectedSymbolType = board[row][col];
        selectedPositions.add(position);
        lineToDraw = [position];
      });
    } else if (isValidSelection(position)) {
      setState(() {
        if (selectedPositions.contains(position)) {
          // If we're backtracking, remove all positions after the current one
          int index = selectedPositions.indexOf(position);
          selectedPositions = selectedPositions.sublist(0, index + 1);
        } else {
          selectedPositions.add(position);
        }
        lineToDraw = List.from(selectedPositions);
      });
    }
  }

  bool isValidSelection(Offset newPosition) {
    if (selectedPositions.isEmpty) return true;

    Offset lastPosition = selectedPositions.last;
    int newRow = newPosition.dy.toInt();
    int newCol = newPosition.dx.toInt();
    int lastRow = lastPosition.dy.toInt();
    int lastCol = lastPosition.dx.toInt();

    // Check if the new position is adjacent horizontally or diagonally
    bool isAdjacent = (newRow == lastRow &&
            (newCol == lastCol - 1 || newCol == lastCol + 1)) ||
        ((newRow == lastRow - 1 || newRow == lastRow + 1) &&
            (newCol == lastCol - 1 ||
                newCol == lastCol ||
                newCol == lastCol + 1));

    if (!isAdjacent) return false;

    String newSymbol = board[newRow][newCol];

    // Count wild symbols in the current selection
    int wildCount = selectedPositions
        .where(
            (pos) => board[pos.dy.toInt()][pos.dx.toInt()] == AppImages.combo)
        .length;

    // If all selected symbols are wild, any new symbol is valid
    if (wildCount == selectedPositions.length) {
      return true;
    }

    // Find the first non-wild symbol in the selection
    String firstNonWild = selectedPositions
        .map((p) => board[p.dy.toInt()][p.dx.toInt()])
        .firstWhere((symbol) => symbol != AppImages.combo, orElse: () => '');

    // If we haven't found a non-wild symbol yet, any new symbol is valid
    if (firstNonWild.isEmpty) {
      return true;
    }

    // The new symbol must either be wild or match the first non-wild symbol
    return newSymbol == AppImages.combo || newSymbol == firstNonWild;
  }

  void handlePanStart(DragStartDetails details) {
    Offset position = _globalToLocalPosition(details.globalPosition);
    selectSymbol(position);
  }

  void handlePanUpdate(DragUpdateDetails details) {
    Offset position = _globalToLocalPosition(details.globalPosition);
    selectSymbol(position);
  }

  Offset _globalToLocalPosition(Offset globalPosition) {
    RenderBox gridRenderBox =
        _gridkey.currentContext!.findRenderObject() as RenderBox;
    Offset localPosition = gridRenderBox.globalToLocal(globalPosition);
    double col = (localPosition.dx / cellSize).clamp(0, columns - 1);
    double row = (localPosition.dy / cellSize).clamp(0, rows - 1);

    return Offset(col.floorToDouble(), row.floorToDouble());
  }

  void endDraw() {
    if (selectedPositions.length >= 3) {
      List<String> matchedSymbols = selectedPositions.map((position) {
        int row = position.dy.toInt();
        int col = position.dx.toInt();
        return board[row][col];
      }).toList();

      // Check if all selected symbols are Wild
      bool allWild =
          matchedSymbols.every((symbol) => symbol == AppImages.combo);

      if (!allWild) {
        drawLineAndRemoveCandies();
      }
    }
    selectedPositions.clear();
    selectedSymbolType = null;
    lineToDraw.clear();

    setState(() {});
  }

  void drawLineAndRemoveCandies() {
    int matchedCandies = selectedPositions.length;

    List<String> matchedImages = selectedPositions.map((position) {
      int row = position.dy.toInt();
      int col = position.dx.toInt();
      return board[row][col];
    }).toList();

    widget.onMatch(matchedImages, matchedCandies);
    removeCandies();
  }

  void removeCandies() {
    for (Offset position in selectedPositions) {
      int row = position.dy.toInt();
      int col = position.dx.toInt();
      board[row][col] = '';
    }
    fillEmptySpaces();
  }

  void fillEmptySpaces() {
    for (int col = 0; col < columns; col++) {
      List<String> column = [];
      for (int row = rows - 1; row >= 0; row--) {
        if (board[row][col].isNotEmpty) {
          column.add(board[row][col]);
        }
      }
      while (column.length < rows) {
        column.add(GameIcons.getRandomIcon());
      }
      for (int row = 0; row < rows; row++) {
        board[row][col] = column[rows - 1 - row];
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: handlePanStart,
      onPanUpdate: handlePanUpdate,
      onPanEnd: (_) => endDraw(),
      child: CustomPaint(
        painter: LinePainter(lineToDraw, cellSize),
        child: Wrap(
          key: _gridkey,
          children: List.generate(rows * columns, (index) {
            int row = index ~/ columns;
            int col = index % columns;
            return Container(
              width: cellSize,
              height: cellSize,
              decoration: BoxDecoration(
                border: Border.all(
                  color: selectedPositions
                          .contains(Offset(col.toDouble(), row.toDouble()))
                      ? AppTheme.pink.withOpacity(0.3)
                      : Colors.white.withOpacity(0.7),
                  width: selectedPositions
                          .contains(Offset(col.toDouble(), row.toDouble()))
                      ? 2
                      : 1,
                ),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Center(
                child: SvgPicture.asset(board[row][col],
                    height: context.width * 0.13, fit: BoxFit.fill),
              ),
            );
          }),
        ),
      ),
    );
  }
}
