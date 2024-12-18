import 'package:flutter/material.dart';
import 'package:getwidget_plus/src/types/gf_animation_type.dart';

class GFAnimation extends StatefulWidget {
  /// Wrap any widget with [GFAnimation] to animate your widget. see [GFAnimationType] for types of animations.
  const GFAnimation({
    Key? key,
    required this.child,
    this.duration,
    this.alignment,
    this.curve,
    this.type,
    this.width,
    this.height,
    this.activeColor,
    this.color,
    this.padding,
    this.activeAlignment,
    this.onTap,
    this.margin,
    this.turnsAnimation,
    this.scaleAnimation,
    this.controller,
    this.textDirection,
    this.slidePosition,
    this.style,
    this.textAlign,
    this.textOverflow,
    this.maxLines,
    this.textWidthBasis,
    this.fontSize,
    this.fontWeight,
    this.changedWidth,
    this.changedHeight,
    this.reverseDuration,
  }) : super(key: key);

  /// The duration for animation to perform
  final Duration? duration;

  /// The duration for reverse animation to perform
  final Duration? reverseDuration;

  /// Defines how the animated widget is aligned during Animation.
  final Alignment? alignment;

  /// Defines how the animated widget is aligned(after the onTap) during Animation.
  final Alignment? activeAlignment;

  /// The child of type [Widget] to display animation effect.
  final Widget child;

  /// Determines the animation curve. Defaults to [Curves.linear].
  final Curve? curve;

  ///type of [GFAnimation] which takes the type ie, align, size, container,
  /// rotateTransition, scaleTransition, slideTransition, and textStyle for the [GFAnimation]
  final GFAnimationType? type;

  /// defines [AnimatedContainer] initial width
  final double? width;

  /// defines the width of [AnimatedContainer] upto which it can expand during animation
  final double? changedWidth;

  /// defines [AnimatedContainer] initial height
  final double? height;

  /// defines the height of [AnimatedContainer] upto which it can expand during animation
  final double? changedHeight;

  /// defines the color of [AnimatedContainer] when onTap triggers
  final Color? activeColor;

  /// defines the color of [AnimatedContainer]
  final Color? color;

  /// defines [child]'s or [AnimatedContainer] padding
  final EdgeInsetsGeometry? padding;

  /// defines [child]'s or [AnimatedContainer] margin
  final EdgeInsetsGeometry? margin;

  /// Called when the user taps the [child]
  final void Function()? onTap;

  /// For GFAnimationType.rotateTransition, customized turns animation can be added to [RotationTransition] widget
  final Animation<double>? turnsAnimation;

  /// For GFAnimationType.scaleTransition, customized scale animation can be added to [ScaleTransition] widget
  final Animation<double>? scaleAnimation;

  /// Type of [AnimationController], its a controller of an animation.
  final AnimationController? controller;

  /// Defines direction of the [AnimatedDefaultTextStyle] TextDirection i.e [ltr,rtl]
  final TextDirection? textDirection;

  /// For GFAnimationType.slideTransition, which animates the position of a widget.
  final Animation<Offset>? slidePosition;

  /// Defines the [TextStyle] of [AnimatedDefaultTextStyle]
  final TextStyle? style;

  /// Defines the [TextAlign] of [AnimatedDefaultTextStyle]
  final TextAlign? textAlign;

  /// Defines the [TextOverflow] of [AnimatedDefaultTextStyle]
  final TextOverflow? textOverflow;

  /// Defines the [maxLines] of [AnimatedDefaultTextStyle]
  final int? maxLines;

  /// Defines the [TextWidthBasis] of [AnimatedDefaultTextStyle]
  final TextWidthBasis? textWidthBasis;

  /// Defines the [fontSize] of [AnimatedDefaultTextStyle]
  final double? fontSize;

  /// Defines the [fontWeight] of [AnimatedDefaultTextStyle]
  final FontWeight? fontWeight;

  @override
  _GFAnimationState createState() => _GFAnimationState();
}

class _GFAnimationState extends State<GFAnimation>
    with SingleTickerProviderStateMixin {
  bool selected = false;
  AnimationController? controller;
  Animation<double>? animation;
  late Animation<Offset> offsetAnimation;

  @override
  void initState() {
    if (widget.type == GFAnimationType.rotateTransition) {
      controller = widget.controller ??
          AnimationController(
              duration: widget.duration ?? const Duration(seconds: 2),
              vsync: this);
      animation = widget.turnsAnimation ??
          Tween<double>(begin: 0, end: 20).animate(controller!);
      if (widget.turnsAnimation == null) {
        controller?.forward();
      }
    } else if (widget.type == GFAnimationType.scaleTransition) {
      controller = widget.controller ??
          AnimationController(
              duration: widget.duration ?? const Duration(seconds: 2),
              vsync: this);
      animation = widget.scaleAnimation ??
          CurvedAnimation(
              parent: controller!, curve: widget.curve ?? Curves.ease);
      controller?.forward();
    } else if (widget.type == GFAnimationType.slideTransition) {
      controller = AnimationController(
          duration: widget.duration ?? const Duration(seconds: 2), vsync: this)
        ..repeat(reverse: true);
      offsetAnimation = Tween<Offset>(
        begin: Offset.zero,
        end: const Offset(1.5, 0),
      ).animate(CurvedAnimation(
        parent: controller!,
        curve: Curves.linear,
      ));
    }
    super.initState();
  }

  // @override
  // void dispose() {
  //   controller.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) => getAnimatedTypeWidget();

  Widget buildAnimatedContainerWidget() => GestureDetector(
        onTap: () {
          if (mounted) {
            setState(() {
              selected = !selected;
            });
          }
        },
        child: AnimatedContainer(
          margin: widget.margin ?? const EdgeInsets.all(0),
          padding: widget.padding ?? const EdgeInsets.all(8),
          width:
              selected ? widget.changedWidth ?? 200.0 : widget.width ?? 100.0,
          height:
              selected ? widget.changedHeight ?? 200.0 : widget.height ?? 100.0,
          color: selected
              ? widget.activeColor ?? Colors.red
              : widget.color ?? Colors.blue,
          alignment: selected
              ? widget.activeAlignment ?? Alignment.center
              : widget.alignment ?? Alignment.center,
          duration: widget.duration ?? const Duration(milliseconds: 2000),
          curve: widget.curve ?? Curves.linear,
          child: widget.child,
        ),
      );

  Widget buildAnimatedAlignWidget() => GestureDetector(
        onTap: () {
          if (widget.onTap == null) {
            if (mounted) {
              setState(() {
                selected = !selected;
              });
            }
          } else {
            widget.onTap!();
          }
        },
        child: Container(
          margin: widget.margin ?? const EdgeInsets.all(0),
          padding: widget.padding ?? const EdgeInsets.all(0),
          child: AnimatedAlign(
            curve: widget.curve ?? Curves.linear,
            alignment: selected
                ? widget.activeAlignment ?? Alignment.center
                : widget.alignment ?? Alignment.topCenter,
            duration: widget.duration ?? const Duration(seconds: 2),
            child: widget.child,
          ),
        ),
      );

  Widget buildAnimatedSizeWidget() => GestureDetector(
        onTap: () {
          if (widget.onTap == null) {
            if (mounted) {
              setState(() {
                selected = !selected;
              });
            }
          } else {
            widget.onTap!();
          }
        },
        child: AnimatedSize(
          alignment: widget.alignment ?? Alignment.center,
          curve: widget.curve ?? Curves.linear,
          reverseDuration:
              widget.reverseDuration ?? const Duration(milliseconds: 2000),
          duration: widget.duration ?? const Duration(milliseconds: 2000),
          child: Container(
              margin: widget.margin ?? const EdgeInsets.all(0),
              padding: widget.padding ?? const EdgeInsets.all(0),
              color: widget.color ?? Colors.white,
              height: selected ? widget.height ?? 200 : widget.height ?? 100,
              width: selected ? widget.width ?? 200 : widget.width ?? 100,
              child: widget.child),
        ),
      );

  Widget buildRotationTransitionWidget() {
    if (animation != null && widget.alignment != null) {
      return RotationTransition(
        turns: animation!,
        child: widget.child,
        alignment: widget.alignment!,
      );
    }

    throw Exception('neither animation nor alignment cannot be null');
  }

  Widget buildScaleTransitionWidget() {
    if (animation != null) {
      return ScaleTransition(
        child: widget.child,
        scale: animation!,
        alignment: widget.alignment ?? Alignment.center,
      );
    }

    throw Exception('animation cannot be null');
  }

  Widget buildSlideTransitionWidget() => SlideTransition(
        child: widget.child,
        textDirection: widget.textDirection ?? TextDirection.ltr,
        position: widget.slidePosition ?? offsetAnimation,
      );

  Widget buildAnimatedDefaultTextStyleWidget() => GestureDetector(
        onTap: widget.onTap,
        child: AnimatedDefaultTextStyle(
          maxLines: widget.maxLines,
          style: widget.style ??
              TextStyle(
                  fontWeight: widget.fontWeight ?? FontWeight.normal,
                  fontSize: widget.fontSize ?? 16,
                  color: widget.color ?? Colors.blue),
          textWidthBasis: widget.textWidthBasis ?? TextWidthBasis.parent,
          textAlign: widget.textAlign ?? TextAlign.start,
          curve: widget.curve ?? Curves.linear,
          duration: widget.duration ?? const Duration(seconds: 2),
          child: widget.child,
        ),
      );

  Widget getAnimatedTypeWidget() {
    switch (widget.type) {
      case GFAnimationType.align:
        return buildAnimatedAlignWidget();

      case GFAnimationType.container:
        return buildAnimatedContainerWidget();

      case GFAnimationType.size:
        return buildAnimatedSizeWidget();

      case GFAnimationType.rotateTransition:
        return buildRotationTransitionWidget();

      case GFAnimationType.scaleTransition:
        return buildScaleTransitionWidget();

      case GFAnimationType.slideTransition:
        return buildSlideTransitionWidget();

      case GFAnimationType.textStyle:
        return buildAnimatedDefaultTextStyleWidget();

      default:
        return buildAnimatedContainerWidget();
    }
  }
}
