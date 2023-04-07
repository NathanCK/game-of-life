import 'package:conway_game_of_life/bloc/game_board_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GameControllerBar extends StatelessWidget {
  final double hight = 40; // TODO: should resize based on screen size.
  final double wight = 160;
  final GameBoardBloc _gameBoardBloc;

  const GameControllerBar({super.key, required GameBoardBloc gameBoardBloc})
      : _gameBoardBloc = gameBoardBloc;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: hight,
      width: wight,
      decoration: BoxDecoration(
        color: const Color(0xFFB19E6D),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _ControlButton(
            iconWidget: const Icon(
              Icons.play_arrow,
            ),
            onPressed: () {},
          ),
          _ControlButton(
            iconWidget: const Icon(
              Icons.pause,
            ),
            onPressed: () {
              _gameBoardBloc.add(GamePauseRequested());
            },
          ),
          _ControlButton(
            iconWidget: SvgPicture.asset(
              'assets/icons/reset.svg',
            ),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}

class _ControlButton extends StatelessWidget {
  static const double _iconSize = 25;
  static const double _iconButtonSize = 30;
  final void Function()? onPressed;
  final Widget iconWidget;

  const _ControlButton({
    this.onPressed,
    required this.iconWidget,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: EdgeInsets.zero,
      iconSize: _iconButtonSize,
      splashRadius: 2,
      onPressed: onPressed,
      icon: Center(
        child: Container(
          padding: EdgeInsets.zero,
          height: _iconButtonSize,
          width: _iconButtonSize,
          decoration: BoxDecoration(
            color: const Color(0xFFD9D9D9),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.black),
          ),
          child:
              SizedBox(height: _iconSize, width: _iconSize, child: iconWidget),
        ),
      ),
    );
  }
}
