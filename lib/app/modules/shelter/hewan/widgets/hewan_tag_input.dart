import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HewanTagInput extends StatefulWidget {
  final List<String> tags;
  final ValueChanged<List<String>> onChanged;

  const HewanTagInput({super.key, required this.tags, required this.onChanged});

  @override
  State<HewanTagInput> createState() => _HewanTagInputState();
}

class _HewanTagInputState extends State<HewanTagInput> {
  late List<String> _tags;

  @override
  void initState() {
    super.initState();
    _tags = List.from(widget.tags);
  }

  void _addTag(String tag) {
    if (tag.isNotEmpty && !_tags.contains(tag)) {
      setState(() => _tags.add(tag));
      widget.onChanged(_tags);
    }
  }

  void _removeTag(String tag) {
    setState(() => _tags.remove(tag));
    widget.onChanged(_tags);
  }

  void _showAddTagDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: const Text('Tambah Tag'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: 'mis. Lucu, Aktif...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF87537),
            ),
            onPressed: () {
              _addTag(controller.text.trim());
              Navigator.pop(context);
            },
            child: const Text('Tambah', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: [
        ..._tags.map(
          (tag) => GestureDetector(
            onTap: () => _removeTag(tag),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 7.h),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF3EC),
                borderRadius: BorderRadius.circular(50.r),
                border: Border.all(
                  color: const Color(0xFFF87537).withOpacity(0.4),
                ),
              ),
              child: Text(
                tag,
                style: textTheme.labelLarge?.copyWith(
                  color: const Color(0xFFF87537),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
        // Tombol + Tambah Tag
        GestureDetector(
          onTap: _showAddTagDialog,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 7.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(50.r),
              border: Border.all(color: const Color(0xFFE0E0E0)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.add, size: 14.sp, color: const Color(0xFFF87537)),
                SizedBox(width: 4.w),
                Text(
                  'Tambah Tag',
                  style: textTheme.labelLarge?.copyWith(
                    color: const Color(0xFFF87537),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
