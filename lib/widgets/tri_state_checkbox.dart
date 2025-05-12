import 'package:flutter/material.dart';

class TriStateCheckbox extends StatefulWidget {
  final bool? value;
  final ValueChanged<bool?>? onChanged;
  final List<Widget> children;
  final String? label;
  final bool isParent;

  const TriStateCheckbox({
    Key? key,
    this.value,
    this.onChanged,
    this.children = const [],
    this.label,
    this.isParent = false,
  }) : super(key: key);

  @override
  State<TriStateCheckbox> createState() => _TriStateCheckboxState();
}

class _TriStateCheckboxState extends State<TriStateCheckbox> {
  bool? _value;
  List<bool> _childValues = [];

  @override
  void initState() {
    super.initState();
    _value = widget.value;
    if (widget.isParent) {
      _childValues = List.filled(widget.children.length, false);
    }
  }

  void _updateParentState() {
    if (!widget.isParent) return;

    int checkedCount = _childValues.where((value) => value).length;
    if (checkedCount == 0) {
      _value = false;
    } else if (checkedCount == _childValues.length) {
      _value = true;
    } else {
      _value = null;
    }

    if (widget.onChanged != null) {
      widget.onChanged!(_value);
    }
  }

  void _handleChildChange(int index, bool? newValue) {
    if (newValue == null) return;
    setState(() {
      _childValues[index] = newValue;
      _updateParentState();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isParent) {
      return Checkbox(
        value: _value,
        onChanged: (bool? newValue) {
          setState(() {
            _value = newValue;
            if (widget.onChanged != null) {
              widget.onChanged!(_value);
            }
          });
        },
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              widget.label!,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
        Checkbox(
          value: _value,
          tristate: true,
          onChanged: (bool? newValue) {
            setState(() {
              _value = newValue;
              for (int i = 0; i < _childValues.length; i++) {
                _childValues[i] = newValue ?? false;
              }
              if (widget.onChanged != null) {
                widget.onChanged!(_value);
              }
            });
          },
        ),
        ...List.generate(
          widget.children.length,
          (index) => Padding(
            padding: const EdgeInsets.only(left: 32.0),
            child: Row(
              children: [
                Checkbox(
                  value: _childValues[index],
                  onChanged: (bool? newValue) => _handleChildChange(index, newValue),
                ),
                widget.children[index],
              ],
            ),
          ),
        ),
      ],
    );
  }
} 