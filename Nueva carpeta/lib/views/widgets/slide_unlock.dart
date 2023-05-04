import 'dart:math';
import 'package:flutter/material.dart';
import 'package:motorhome/utils/theme.dart';
import 'package:motorhome/utils/utils.dart';

/// Slider call to action component
class SlideUnlock extends StatefulWidget {
  /// The offset on the y axis of the slider icon
  final double sliderButtonYOffset;

  /// If the slider icon rotates
  final bool sliderRotate;

  /// The height of the component
  final double height;

  /// The color of the inner circular button, of the tick icon of the text.
  /// If not set, this attribute defaults to primaryIconTheme.
  final Color? innerColor;

  /// The color of the external area and of the arrow icon.
  /// If not set, this attribute defaults to accentColor from your theme.
  final Color? outerColor;

  /// Text style which is applied on the Text widget.
  ///
  /// By default, the text is colored using [innerColor].
  // final TextStyle? textStyle;

  /// The borderRadius of the sliding icon and of the background
  final double borderRadius;

  /// Callback called on submit
  /// If this is null the component will not animate to complete
  final VoidCallback? onSubmit;

  /// The widget to render instead of the default icon
  final Widget? sliderButtonIcon;

  /// The widget to render instead of the default submitted icon
  final Widget? submittedIcon;

  /// The duration of the animations
  final Duration animationDuration;

  /// If true the widget will be reversed
  final bool reversed;

  /// the alignment of the widget once it's submitted
  final Alignment alignment;

  /// Create a new instance of the widget
  const SlideUnlock({
    Key? key,
    this.sliderButtonYOffset = 0,
    this.sliderRotate = true,
    this.height = 60,
    this.outerColor,
    this.borderRadius = 10,
    this.animationDuration = const Duration(milliseconds: 300),
    this.reversed = false,
    this.alignment = Alignment.center,
    this.submittedIcon,
    this.onSubmit,
    this.innerColor,
    // this.textStyle,
    this.sliderButtonIcon,
  }) : super(key: key);
  @override
  SlideUnlockState createState() => SlideUnlockState();
}

/// Use a GlobalKey to access the state. This is the only way to call [SlideUnlockState.reset]
class SlideUnlockState extends State<SlideUnlock>
    with TickerProviderStateMixin {
  final GlobalKey _containerKey = GlobalKey();
  final GlobalKey _sliderKey = GlobalKey();
  double _dx = 0;
  double _maxDx = 0;
  double get _progress => _dx == 0 ? 0 : _dx / _maxDx;
  double _endDx = 0;
  double _dz = 1;
  double? _initialContainerWidth, _containerWidth;
  double _checkAnimationDx = 0;
  bool submitted = false;
  late AnimationController _checkAnimationController,
      _shrinkAnimationController,
      _resizeAnimationController,
      _cancelAnimationController;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: widget.alignment,
      child: Transform(
        alignment: Alignment.center,
        transform: Matrix4.rotationY(widget.reversed ? pi : 0),
        child: Container(
          key: _containerKey,
          height: widget.height,
          width: _containerWidth,
          constraints: _containerWidth != null
              ? null
              : BoxConstraints.expand(height: widget.height),
          child: Container(
            // elevation: widget.elevation,
            // color: submitted ? MHColors.blueLight : MHColors.blueLightSlide,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  (submitted ? MHColors.blueLight : MHColors.blueDark),
                  MHColors.blueLightSlide
                ],
                stops: [_progress, 0]
              ),
              borderRadius: submitted ? BorderRadius.circular(50) : BorderRadius.circular(widget.borderRadius)
            ),
            // borderRadius: submitted ? BorderRadius.circular(50) : BorderRadius.circular(widget.borderRadius),
            child: submitted
                ? Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.rotationY(widget.reversed ? pi : 0),
                    child: Center(
                      child: Stack(
                        clipBehavior: Clip.antiAlias,
                        children: <Widget>[





                          Padding(
                            padding: const EdgeInsets.all(1.0),
                            child: widget.submittedIcon ??
                              svgIcon(
                                MHIcons.unlock,
                                size: 25,
                                color: Colors.white
                              ),
                          ),
                          Positioned.fill(
                            right: 0,
                            child: 
                            Transform(
                              transform: Matrix4.rotationY(
                                  _checkAnimationDx * (pi / 2)),
                              alignment: Alignment.centerRight,
                              child: Container(
                                color: MHColors.blueLight,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : Stack(
                    alignment: Alignment.center,
                    clipBehavior: Clip.none,
                    children: <Widget>[
                      Positioned(
                        left: widget.sliderButtonYOffset,
                        child: Transform.scale(
                          scale: _dz,
                          origin: Offset(_dx, 0),
                          child: Transform.translate(
                            offset: Offset(_dx, 0),
                            child: Container(
                              key: _sliderKey,
                              child: GestureDetector(
                                onHorizontalDragUpdate: onHorizontalDragUpdate,
                                onHorizontalDragEnd: (details) async {
                                  _endDx = _dx;
                                  if (_progress <= 0.98 ||
                                      widget.onSubmit == null) {
                                    _cancelAnimation();
                                  } else {
                                    await _resizeAnimation();

                                    await _shrinkAnimation();

                                    await _checkAnimation();

                                    widget.onSubmit!();
                                  }
                                },
                                child: 
                                // Padding(
                                //   padding: const EdgeInsets.symmetric(horizontal: 0.0),
                                //   child: 
                                  
                                  // Material(
                                  //   borderRadius: BorderRadius.circular(10),
                                  //   color: widget.innerColor ??
                                  //       Theme.of(context)
                                  //           .primaryIconTheme
                                  //           .color,
                                  //   child: 
                                    
                                    Container(
                                      height: widget.height,
                                      width: widget.height,
                                      decoration: BoxDecoration(
                                        color: MHColors.blueDark,
                                        borderRadius: BorderRadius.all(Radius.circular(widget.borderRadius))
                                      ),



                                      // padding: EdgeInsets.all(widget.sliderButtonIconPadding),
                                      child: 
                                      // Transform.rotate(
                                        // angle: widget.sliderRotate
                                            // ? -pi * _progress
                                            // : 0,
                                        // child: 
                                        
                                        Center(
                                          child: svgIcon(
                                            MHIcons.lock,
                                            size: 30,
                                            color: Colors.white
                                          )
                                          
                                          
                                          // Icon(
                                          //       Icons.lock,
                                          //       size: 35,
                                          //       color: Colors.white
                                          //     ),
                                        ),
                                      // ),
                                    ),
                                  // ),
                                // ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  void onHorizontalDragUpdate(DragUpdateDetails details) {
    setState(() {
      _dx = (_dx + details.delta.dx).clamp(0.0, _maxDx);
    });
  }

  /// Call this method to revert the animations
  Future reset() async {
    await _checkAnimationController.reverse().orCancel;

    submitted = false;

    await _shrinkAnimationController.reverse().orCancel;

    await _resizeAnimationController.reverse().orCancel;

    await _cancelAnimation();
  }

  Future _checkAnimation() async {
    _checkAnimationController.reset();

    final animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _checkAnimationController,
      curve: Curves.slowMiddle,
    ));

    animation.addListener(() {
      if (mounted) {
        setState(() {
          _checkAnimationDx = animation.value;
        });
      }
    });
    await _checkAnimationController.forward().orCancel;
  }

  Future _shrinkAnimation() async {
    _shrinkAnimationController.reset();

    final diff = _initialContainerWidth! - widget.height;
    final animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _shrinkAnimationController,
      curve: Curves.easeOutCirc,
    ));

    animation.addListener(() {
      if (mounted) {
        setState(() {
          _containerWidth = _initialContainerWidth! - (diff * animation.value);
        });
      }
    });

    setState(() {
      submitted = true;
    });
    await _shrinkAnimationController.forward().orCancel;
  }

  Future _resizeAnimation() async {
    _resizeAnimationController.reset();

    final animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _resizeAnimationController,
      curve: Curves.easeInBack,
    ));

    animation.addListener(() {
      if (mounted) {
        setState(() {
          _dz = 1 - animation.value;
        });
      }
    });
    await _resizeAnimationController.forward().orCancel;
  }

  Future _cancelAnimation() async {
    _cancelAnimationController.reset();
    final animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _cancelAnimationController,
      curve: Curves.fastOutSlowIn,
    ));

    animation.addListener(() {
      if (mounted) {
        setState(() {
          _dx = (_endDx - (_endDx * animation.value));
        });
      }
    });
    _cancelAnimationController.forward().orCancel;
  }

  @override
  void initState() {
    super.initState();

    _cancelAnimationController = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );
    _checkAnimationController = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );
    _shrinkAnimationController = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );

    _resizeAnimationController = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final RenderBox containerBox =
          _containerKey.currentContext!.findRenderObject() as RenderBox;
      _containerWidth = containerBox.size.width;
      _initialContainerWidth = _containerWidth;

      final RenderBox sliderBox =
          _sliderKey.currentContext!.findRenderObject() as RenderBox;
      final sliderWidth = sliderBox.size.width;

      _maxDx = _containerWidth! -
          (sliderWidth / 2) -
          30 -
          widget.sliderButtonYOffset;
    });
  }

  @override
  void dispose() {
    _cancelAnimationController.dispose();
    _checkAnimationController.dispose();
    _shrinkAnimationController.dispose();
    _resizeAnimationController.dispose();
    super.dispose();
  }
}
