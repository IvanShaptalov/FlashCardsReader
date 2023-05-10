import 'package:flutter/material.dart';

class ParentStatefulWidget extends StatefulWidget {
  @override
  ParentStatefulWidgetState createState() => ParentStatefulWidgetState();
}

class ParentStatefulWidgetState<T extends ParentStatefulWidget>
    extends State<T> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Text('ParentStatefulWidgetState');
  }
}
