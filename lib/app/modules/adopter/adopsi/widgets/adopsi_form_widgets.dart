import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

const _orange = Color(0xFFF87537);

// ── Label dengan asterisk merah ──────────────────────────────────────────────
class FormLabel extends StatelessWidget {
  final String label;
  final bool required;
  const FormLabel({super.key, required this.label, this.required = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1A1A1A),
          ),
        ),
        if (required) ...[
          SizedBox(width: 3.w),
          Text(
            '*',
            style: TextStyle(
              color: Colors.red,
              fontSize: 13.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ],
    );
  }
}

// ── Text field ────────────────────────────────────────────────────────────────
class FormTextField extends StatelessWidget {
  final String label;
  final bool required;
  final TextEditingController controller;
  final String? hint;
  final TextInputType? keyboardType;

  const FormTextField({
    super.key,
    required this.label,
    this.required = false,
    required this.controller,
    this.hint,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FormLabel(label: label, required: required),
        SizedBox(height: 6.h),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          style: GoogleFonts.poppins(
            fontSize: 13.sp,
            color: const Color(0xFF1A1A1A),
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.poppins(
              fontSize: 13.sp,
              color: const Color(0xFFBBBBBB),
            ),
            contentPadding:
                EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: const BorderSide(color: _orange, width: 1.2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: const BorderSide(color: _orange, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}

// ── Dropdown ──────────────────────────────────────────────────────────────────
class FormDropdown extends StatelessWidget {
  final String label;
  final bool required;
  final String? value;
  final List<String> items;
  final String hint;
  final ValueChanged<String?> onChanged;

  const FormDropdown({
    super.key,
    required this.label,
    this.required = false,
    required this.value,
    required this.items,
    required this.hint,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FormLabel(label: label, required: required),
        SizedBox(height: 6.h),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: _orange, width: 1.2),
            borderRadius: BorderRadius.circular(8.r),
          ),
          padding: EdgeInsets.symmetric(horizontal: 14.w),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              hint: Text(
                hint,
                style: GoogleFonts.poppins(
                  fontSize: 13.sp,
                  color: const Color(0xFFBBBBBB),
                ),
              ),
              isExpanded: true,
              icon: const Icon(Icons.keyboard_arrow_down_rounded, color: _orange),
              style: GoogleFonts.poppins(
                fontSize: 13.sp,
                color: const Color(0xFF1A1A1A),
              ),
              items: items
                  .map((item) => DropdownMenuItem(value: item, child: Text(item)))
                  .toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}

// ── Checkbox option (multi-select) ───────────────────────────────────────────
class FormCheckboxOption extends StatelessWidget {
  final String label;
  final bool checked;
  final ValueChanged<bool?> onChanged;

  const FormCheckboxOption({
    super.key,
    required this.label,
    required this.checked,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!checked),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Checkbox(
            value: checked,
            onChanged: onChanged,
            activeColor: _orange,
            side: const BorderSide(color: Color(0xFFCCCCCC), width: 1.5),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            visualDensity: VisualDensity.compact,
          ),
          SizedBox(width: 4.w),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 13.sp,
              color: const Color(0xFF333333),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Checkbox group 2 kolom (multi-select) ────────────────────────────────────
class FormCheckboxGroup extends StatelessWidget {
  final String label;
  final bool required;
  final List<String> options;
  final Set<String> selected;
  final ValueChanged<String> onToggle;

  const FormCheckboxGroup({
    super.key,
    required this.label,
    this.required = false,
    required this.options,
    required this.selected,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FormLabel(label: label, required: required),
        SizedBox(height: 10.h),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 4.5,
          children: options
              .map((opt) => FormCheckboxOption(
                    label: opt,
                    checked: selected.contains(opt),
                    onChanged: (_) => onToggle(opt),
                  ))
              .toList(),
        ),
      ],
    );
  }
}

// ── Yes/No pair (radio behavior) ─────────────────────────────────────────────
class FormYesNo extends StatelessWidget {
  final String question;
  final bool? value; // null = belum dipilih
  final bool required;
  final ValueChanged<bool> onChanged;

  const FormYesNo({
    super.key,
    required this.question,
    required this.value,
    this.required = false,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                question,
                style: GoogleFonts.poppins(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1A1A1A),
                ),
              ),
            ),
            if (required)
              Text(
                ' *',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
          ],
        ),
        SizedBox(height: 10.h),
        Row(
          children: [
            FormCheckboxOption(
              label: 'Iya',
              checked: value == true,
              onChanged: (_) => onChanged(true),
            ),
            SizedBox(width: 32.w),
            FormCheckboxOption(
              label: 'Tidak',
              checked: value == false,
              onChanged: (_) => onChanged(false),
            ),
          ],
        ),
      ],
    );
  }
}

// ── Section header dengan tombol X ───────────────────────────────────────────
class FormSectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback onClose;

  const FormSectionHeader({
    super.key,
    required this.title,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(20.w, 14.h, 16.w, 14.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1A1A1A),
                  ),
                ),
              ),
              GestureDetector(
                onTap: onClose,
                child: Container(
                  width: 32.w,
                  height: 32.w,
                  decoration: BoxDecoration(
                    color: _orange.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.close_rounded, color: _orange, size: 18.sp),
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1, thickness: 1, color: Color(0xFFF0F0F0)),
      ],
    );
  }
}

// ── Bottom buttons: Kembali + action ─────────────────────────────────────────
class FormBottomButtons extends StatelessWidget {
  final String actionLabel;
  final VoidCallback onKembali;
  final VoidCallback onAction;

  const FormBottomButtons({
    super.key,
    required this.actionLabel,
    required this.onKembali,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 14.h, 20.w, 20.h),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: onKembali,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1A1A1A),
                minimumSize: Size(0, 48.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50.r),
                ),
              ),
              child: Text(
                'Kembali',
                style: GoogleFonts.poppins(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: ElevatedButton(
              onPressed: onAction,
              style: ElevatedButton.styleFrom(
                minimumSize: Size(0, 48.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50.r),
                ),
              ),
              child: Text(
                actionLabel,
                style: GoogleFonts.poppins(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}