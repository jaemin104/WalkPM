import 'package:flutter/material.dart';

/// 고정된 너비를 가진 아이콘 버튼 위젯
/// [width] 버튼의 너비
/// [icon] 표시할 아이콘
/// [onPressed] 버튼 클릭 시 실행할 콜백
class SizedIconButton extends StatelessWidget {
  final double width;
  final IconData icon;
  final VoidCallback onPressed;

  const SizedIconButton({
    super.key,
    required this.width,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: IconButton(
        icon: Icon(icon),
        onPressed: onPressed,
      ),
    );
  }
}
