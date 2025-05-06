
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EmptyView extends StatelessWidget {
  const EmptyView({super.key, required this.reload, required this.title});
  final VoidCallback reload;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(title),
          IconButton(
            onPressed: reload,
            icon: Icon(CupertinoIcons.arrow_counterclockwise),
          ),
        ],
      ),
    );
  }
}
