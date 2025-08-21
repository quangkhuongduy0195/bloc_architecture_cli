class WidgetTextFieldCustomGenerator {
  static String gen() {
    return '''
import 'package:flutter/services.dart';

import '../core/config.dart';

class FormGroup extends StatelessWidget {
  const FormGroup({
    super.key,
    required this.title,
    required this.child,
    this.subtitle,
    this.subtitleColor,
  });

  final String title;
  final String? subtitle;
  final Widget child;
  final Color? subtitleColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextApp(
              title,
              color: context.appColor.subtitleColor,
              type: TextType.sm,
            ),
            if (subtitle != null) ...[
              WidthBox(4.w),
              Flexible(
                child: TextApp(
                  subtitle!,
                  type: TextType.sm,
                  color: subtitleColor ?? context.appColor.labelColor,
                  textAlign: TextAlign.end,
                  maxLines: 1,
                ),
              ),
            ],
          ],
        ),
        HeightBox(4.h),
        child,
      ],
    );
  }
}

class TextFieldCustom extends HookWidget {
  const TextFieldCustom({
    super.key,
    this.controller,
    this.hintText,
    this.fontSize = 14,
    this.radius = 30,
    this.keyboardType = TextInputType.text,
    this.errorText,
    this.textAlign = TextAlign.start,
    this.suffixIcon,
    this.onTap,
    this.readOnly = false,
    this.autofocus = false,
    this.obscureText = false,
    this.onChanged,
    this.fontWeight = FontWeight.w400,
    this.validator,
    this.prefixIcon,
    this.fillColor,
    this.inputFormatters,
    this.maxLines = 1,
    this.minLines = 1,
    this.maxLength,
    this.onTapOutside,
    this.showFocusedBorder = false,
    this.padding,
    this.isDense = false,
    this.prefixIconConstraints,
    this.suffixIconConstraints,
    this.isError = false,
    this.trimOnUnfocus = false,
    this.onUnfocus,
    this.isUnfocusValidate = false,
    this.filled = true,
  });

  final List<TextInputFormatter>? inputFormatters;

  /// A text field that can be customized with different styles.
  /// [TextEditingController] is a controller for the text field.
  final TextEditingController? controller;

  /// The font size and radius of the text field.
  final double fontSize, radius;

  /// The font weight of the text field.
  /// The default value is [FontWeight.w400].
  final FontWeight fontWeight;

  /// The hint text and error text of the text field.
  final String? hintText, errorText;

  /// The type of the keyboard of the text field.
  /// The default value is [TextInputType.text].
  final TextInputType keyboardType;

  /// The text alignment of the text field.
  /// The default value is [TextAlign.start].
  final TextAlign textAlign;

  /// The boolean value that determines whether the text field is read-only.
  /// The default value is [false].
  final bool readOnly;

  /// The boolean value that determines whether the text field is autofocus.
  /// The default value is [false].
  final bool autofocus;

  /// The boolean value that determines whether the text field is a password.
  /// The default value is [false].
  final bool obscureText;

  /// The suffix icon of the text field.
  final Widget? suffixIcon;

  /// The prefix icon of the text field.
  final Widget? prefixIcon;

  /// The callback function when the text field is tapped.
  /// return the current state of the text field.
  /// Use the [didChange] function of the current state to change the text field.
  final Function(FormFieldState<String> state)? onTap;

  /// The callback function when the text field is changed.
  final ValueChanged<String>? onChanged;

  /// The validator function of the text field.
  final String? Function(String? value)? validator;

  /// The callback function when the text field is tapped outside.
  final VoidCallback? onTapOutside;

  final Color? fillColor;

  /// The maximum and minimum lines of the text field.
  final int maxLines, minLines;

  /// The maximum length of the text field.
  final int? maxLength;

  /// The boolean value that determines whether the text field show border when focus.
  /// The default value is [false].
  final bool showFocusedBorder;

  /// The padding of the text field. The default value is [EdgeInsets.fromLTRB(10.h, 10.w, 0, 10.h)].
  final EdgeInsets? padding;

  /// The boolean value that determines whether the text field is dense.
  final bool isDense;

  /// The constraints of the prefix icon.
  final BoxConstraints? prefixIconConstraints;

  /// The constraints of the suffix icon.
  final BoxConstraints? suffixIconConstraints;

  /// The boolean value that determines whether the text field is an error.
  /// Set border color to primary color when the text field is an error.
  final bool isError;

  /// Trim the text field when the text field is unfocused.
  /// The default value is [false].
  final bool trimOnUnfocus;

  /// The callback function when the text field is unfocused.
  final VoidCallback? onUnfocus;

  /// The boolean value that determines whether the text field is unfocused validate.
  final bool isUnfocusValidate;

  /// The boolean value that determines whether the text field is filled.
  final bool filled;
  @override
  Widget build(BuildContext context) {
    /// The current state of the text field.
    FormFieldState<String>? currentState;

    /// Create a focus node for the text field.
    final focusNode = useFocusNode();

    useEffect(
      () {
        controller?.addListener(() {
          /// Set the current state of the text field.
          /// Call the [didChange] function of the current state.
          /// The [didChange] function is called when the text field is changed.
          currentState?.didChange(controller?.text);
        });

        /// Add a listener to the focus node.
        /// Call the [validate] function of the current state when the focus node does not have focus.
        /// The [validate] function is called when the text field is not focused.
        focusNode.addListener(() {
          if (!focusNode.hasFocus) {
            onUnfocus?.call();
            if (trimOnUnfocus) {
              controller?.text = controller?.text.trim() ?? '';
            }
            if (isUnfocusValidate) currentState?.validate();
          }
        });
        return null;
      },
      [controller, focusNode, onUnfocus, isUnfocusValidate],
    );

    final obscureTextState = useState(obscureText);

    final style = context.textTheme.titleMedium?.copyWith(
      fontSize: fontSize,
      color: context.onSurface,
    );
    return FormField(
      initialValue: controller?.text,
      validator: validator,
      builder: (state) {
        /// Set the current state of the text field.
        currentState ??= state;
        final border = OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(radius)),
          borderSide:
              (state.errorText ?? errorText).isNotEmptyAndNotNull || isError
                  ? BorderSide(color: context.error, width: 1)
                  : BorderSide.none,
        );
        final borderFocus = OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(radius)),
          borderSide: showFocusedBorder
              ? BorderSide(
                  color: context.primary,
                  width: 1,
                )
              : BorderSide.none,
        );
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: controller,
              style: style,
              textAlign: textAlign,
              keyboardType: keyboardType,
              obscureText: obscureTextState.value,
              autofocus: autofocus,
              obscuringCharacter: '＊',
              readOnly: readOnly,
              inputFormatters: inputFormatters,
              minLines: minLines,
              maxLines: maxLines,
              maxLength: maxLength,
              decoration: InputDecoration(
                contentPadding: padding ??
                    EdgeInsets.fromLTRB(
                      10,
                      (obscureTextState.value ? 10 : 5),
                      10,
                      10,
                    ),
                hintStyle: style?.copyWith(
                  fontWeight: FontWeight.normal,
                  color: hintColor,
                  fontStyle: FontStyle.italic,
                ),
                hintText: hintText,
                filled: filled,
                isDense: isDense,
                fillColor: fillColor,
                prefixIconConstraints: prefixIconConstraints ??
                    const BoxConstraints(
                      minWidth: 44,
                      minHeight: 40,
                    ),
                suffixIconConstraints: suffixIconConstraints ??
                    const BoxConstraints(
                      minWidth: 44,
                      minHeight: 40,
                    ),
                prefixIconColor: context.appColor.labelColor,
                prefixIcon: prefixIcon == null
                    ? null
                    : Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: SizedBox.square(
                          dimension: 24,
                          child: Center(child: prefixIcon),
                        ),
                      ),
                suffixIcon: suffixIcon ??
                    (obscureText
                        ? IconButton(
                            icon: obscureTextState.value
                                ? Assets.iconsVisibility.svg()
                                : Assets.iconsVisibilityOff.svg(),
                            onPressed: () {
                              obscureTextState.value = !obscureTextState.value;
                            },
                          )
                        : null),
                focusedBorder: showFocusedBorder ? borderFocus : border,
                enabledBorder: border,
                errorBorder: border,
                focusedErrorBorder: border,
                counterText: '',
              ),
              onTap: () => onTap?.call(state),
              onChanged: (value) {
                state.didChange(value);
                onChanged?.call(value);
              },
              onTapOutside: (event) {
                onTapOutside?.call();
                FocusScope.of(context).unfocus();
              },
              onFieldSubmitted: (value) {
                FocusScope.of(context).unfocus();
              },
              focusNode: focusNode,
            ),
            Offstage(
              offstage: !state.hasError && errorText.isEmptyOrNull,
              child: Padding(
                padding: const EdgeInsets.only(top: 2),
                child: TextApp(
                  (state.errorText ?? errorText) ?? '',
                  color: context.error,
                  type: TextType.xs,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
''';
  }
}
