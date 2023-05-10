import 'package:flutter/material.dart';

class FileSelector extends StatefulWidget {
  final String? label;
  final String? value;
  final String? errorMsg;
  final VoidCallback onPressed;
  final ValueChanged<String> onChanged;

  const FileSelector({
    super.key,
    required this.onPressed,
    required this.onChanged,
    this.label,
    this.value,
    this.errorMsg,
  });

  @override
  State<FileSelector> createState() => _FileSelectorState();
}

class _FileSelectorState extends State<FileSelector> {
  late final TextEditingController textFieldController;

  @override
  void initState() {
    super.initState();
    textFieldController = TextEditingController(text: widget.value);
  }

  @override
  void dispose() {
    textFieldController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant FileSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != textFieldController.value.text) {
      textFieldController.text = widget.value ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: TextFormField(
            controller: textFieldController,
            decoration: InputDecoration(
              border: const UnderlineInputBorder(),
              labelText: widget.label ?? 'Input text',
              errorText: widget.errorMsg,
            ),
            onChanged: widget.onChanged,
          ),
        ),
        const SizedBox(width: 12),
        IconButton(
          onPressed: widget.onPressed,
          splashRadius: 24,
          icon: const Icon(Icons.folder_open),
        )
      ],
    );
  }
}
