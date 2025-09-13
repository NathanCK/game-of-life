import 'package:conway_game_of_life/cubit/game_control_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GameControllerBar extends StatelessWidget {
  final Color buttonColor;
  const GameControllerBar({super.key, required this.buttonColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 2,
      ),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFB19E6D),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 4.0,
            children: [
              _PlayButton(
                color: buttonColor,
              ),
              _ControlButton(
                color: buttonColor,
                iconWidget: SvgPicture.asset(
                  'assets/icons/reset.svg',
                  colorFilter: ColorFilter.mode(
                    buttonColor,
                    BlendMode.srcIn,
                  ),
                ),
                onPressed: () {
                  context.read<GameControlCubit>().resetGame();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PlayButton extends StatefulWidget {
  final Color color;

  const _PlayButton({required this.color});

  @override
  State<_PlayButton> createState() => _PlayButtonState();
}

class _PlayButtonState extends State<_PlayButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);

    if (context.read<GameControlCubit>().state.running) {
      _controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GameControlCubit, GameControlState>(
      listener: (context, state) {
        if (state.running) {
          _controller.forward();
        } else {
          _controller.reverse();
        }
      },
      builder: (context, state) {
        final onPressed = state.running
            ? context.read<GameControlCubit>().stopGame
            : context.read<GameControlCubit>().startGame;

        return _ControlButton(
          color: widget.color,
          iconWidget: AnimatedIcon(
            icon: AnimatedIcons.play_pause,
            progress: _animation,
          ),
          onPressed: onPressed,
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class _ControlButton extends StatelessWidget {
  static const double _iconSize = 25;
  static const double _iconButtonSize = 30;
  final void Function()? onPressed;
  final Widget iconWidget;
  final Color color;

  const _ControlButton({
    this.onPressed,
    required this.iconWidget,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: EdgeInsets.zero,
      iconSize: _iconButtonSize,
      splashRadius: 2,
      onPressed: onPressed,
      color: color,
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
