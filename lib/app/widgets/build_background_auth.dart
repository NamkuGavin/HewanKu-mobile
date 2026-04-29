import 'package:flutter/material.dart';

import '../common/contant/assets.dart';

class BuildBackgroundAuth extends StatelessWidget {
  final Widget child;
  final bool scrollable;
  final EdgeInsetsGeometry padding;

  const BuildBackgroundAuth({
    super.key,
    required this.child,
    this.scrollable = false,
    this.padding = const EdgeInsets.symmetric(horizontal: 30),
  });

  @override
  Widget build(BuildContext context) {
    Widget content;

    if (scrollable) {
      content = Padding(
        padding: padding,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom + 24),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: child,
              ),
            );
          },
        ),
      );
    } else {
      content = Padding(padding: padding, child: child);
    }

    return SizedBox.expand(
      child: DecoratedBox(
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage(ImageAsset.bgOnboarding), fit: BoxFit.cover),
        ),
        child: content,
      ),
    );
  }
}
