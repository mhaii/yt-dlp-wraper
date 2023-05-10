import 'package:flutter/material.dart';

class FormatQualitySelector<E extends Enum> extends StatelessWidget {
  final bool isDisabled;
  final int quality;
  final E? format;
  final List<E> values;
  final ValueChanged<int>? onQualityChanged;
  final ValueChanged<E?>? onFormatChanged;

  const FormatQualitySelector({
    super.key,
    this.isDisabled = false,
    required this.quality,
    this.format,
    required this.values,
    this.onQualityChanged,
    this.onFormatChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        DropdownButton(
          isExpanded: true,
          alignment: Alignment.center,
          value: format ?? values[0],
          items: values
              .map(
                (value) => DropdownMenuItem(
                  value: value,
                  child: Text(value.name),
                ),
              )
              .toList(),
          onChanged: isDisabled ? null : onFormatChanged,
        ),
        Row(
          children: [
            Text(
              'Best',
              style: Theme.of(context).textTheme.labelMedium,
            ),
            Expanded(
              child: Slider(
                min: 0,
                max: 10,
                divisions: 9,
                value: quality.toDouble(),
                label: '$quality',
                onChanged: isDisabled || onQualityChanged == null
                    ? null
                    : (double value) => onQualityChanged?.call(value.toInt()),
              ),
            ),
            Text(
              'Worst',
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ],
        ),
      ],
    );
  }
}
