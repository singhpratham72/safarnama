import 'package:flutter/material.dart';

class GearSize extends StatefulWidget {
  final List gearSizes;
  final Function(String) onSelected;
  GearSize({this.gearSizes, this.onSelected});

  @override
  _GearSizeState createState() => _GearSizeState();
}

class _GearSizeState extends State<GearSize> {
  int _selected = 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 8.0,
      ),
      child: Row(
        children: [
          for (var i = 0; i < widget.gearSizes.length; i++)
            GestureDetector(
              onTap: () {
                widget.onSelected("${widget.gearSizes[i]}");
                setState(() {
                  _selected = i;
                });
              },
              child: Container(
                width: 42.0,
                height: 42.0,
                decoration: BoxDecoration(
                  color: _selected == i
                      ? Theme.of(context).colorScheme.secondary
                      : Color(0xFFDCDCDC),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                alignment: Alignment.center,
                margin: EdgeInsets.only(
                  right: 12.0,
                ),
                child: Text(
                  "${widget.gearSizes[i]}",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: _selected == i ? Colors.white : Colors.black,
                    fontSize: 16.0,
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }
}
