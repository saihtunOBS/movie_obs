import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:movie_obs/utils/colors.dart';
import 'package:movie_obs/utils/dimens.dart';

class ExpandableText extends StatefulWidget {
  final String text;
  final int trimLength;
  final TextStyle? style;
  final TextStyle? linkStyle;

  const ExpandableText({
    super.key,
    required this.text,
    this.trimLength = 300,
    this.style,
    this.linkStyle,
  });

  @override
  State<ExpandableText> createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final isTrimmed = widget.text.length > widget.trimLength;
    final visibleText =
        !_isExpanded && isTrimmed
            ? widget.text.substring(0, widget.trimLength)
            : widget.text;

    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: RichText(
        text: TextSpan(
          style: widget.style ?? DefaultTextStyle.of(context).style,
          children: [
            TextSpan(text: visibleText),
            if (isTrimmed)
              TextSpan(
                text: _isExpanded ? ' See Less' : '... See More',
                style:
                    widget.linkStyle ??
                    const TextStyle(
                      color: kThirdColor,
                      fontWeight: FontWeight.w500,
                      fontSize: kTextSmall,
                    ),
                recognizer:
                    TapGestureRecognizer()
                      ..onTap = () {
                        setState(() => _isExpanded = !_isExpanded);
                      },
              ),
          ],
        ),
      ),
    );
  }
}
