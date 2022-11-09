import 'package:flutter/material.dart';

class AdminOption extends StatelessWidget {
  final String _option;
  final Function _onPressed;
  final int _index;

  const AdminOption(this._option, this._onPressed, this._index);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: InkWell(
        onTap: () {
          _onPressed(_index);
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(),
          ),
          child: Center(
            child: Text(_option),
          ),
        ),
      ),
    );
  }
}
