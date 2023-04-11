import 'package:equatable/equatable.dart';

class Cell extends Equatable {
  final int row;
  final int col;

  const Cell(this.row, this.col);

  @override
  List<Object?> get props => [row, col];
}
