import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:page_transition/page_transition.dart';
import '../constants/dimens/uihelper.dart';
import '../constants/values/colors.dart';
import '../pages/cart/cart_page.dart';

class CustomNavBar extends StatefulWidget {
  int selectedIndex;
  Function function;
  static final GlobalKey<_CustomNavBarState> globalKey = GlobalKey();

  CustomNavBar({Key? key, required this.selectedIndex, required this.function}) : super(key: globalKey);

  @override
  State<CustomNavBar> createState() => _CustomNavBarState();
}

class _CustomNavBarState extends State<CustomNavBar> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  late AnimationController animateController;
  final GlobalKey<_NavBarItemState> _childWidgetKey1 = GlobalKey();
  final GlobalKey<_NavBarItemState> _childWidgetKey2 = GlobalKey();
  final GlobalKey<_NavBarItemState> _childWidgetKey3 = GlobalKey();
  final GlobalKey<_NavBarItemState> _childWidgetKey4 = GlobalKey();
  final GlobalKey<_NavBarItemState> _childWidgetKey5 = GlobalKey();
  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex;
    animateController = AnimationController(duration: const Duration(milliseconds: 300), vsync: this);
  }

  void changeSelectedIndex(int index) {
    setState(() {
      if (index == 4) {
        Navigator.push(
          context,
          PageTransition(type: PageTransitionType.bottomToTop, child: CartPage()),
        );
      } else {
        _selectedIndex = index;
        widget.function(_selectedIndex);
      }
    });
  }

  void changeIndex(int index) {
    setState(() {
      _selectedIndex = index;
      if (_selectedIndex == 0) {
        _childWidgetKey1.currentState?.playAnimation();
      } else if (_selectedIndex == 1) {
        _childWidgetKey2.currentState?.playAnimation();
      } else if (_selectedIndex == 2) {
        _childWidgetKey3.currentState?.playAnimation();
      } else if (_selectedIndex == 3) {
        _childWidgetKey4.currentState?.playAnimation();
      } else if (_selectedIndex == 4) {
        _childWidgetKey5.currentState?.playAnimation();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.height;
    final double height = MediaQuery.of(context).size.height;
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: UiHelper.allPadding4x,
      child: Container(
        padding: UiHelper.allPadding3x,
        decoration: BoxDecoration(
          borderRadius: UiHelper.borderRadiusCircular3x,
          color: UiColorHelper.mainGreen,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            NavBarItem(itemIndex: 0, selectedIndex: _selectedIndex, changeFunction: changeSelectedIndex, key: _childWidgetKey1),
            NavBarItem(itemIndex: 1, selectedIndex: _selectedIndex, changeFunction: changeSelectedIndex, key: _childWidgetKey2),
            NavBarItem(itemIndex: 2, selectedIndex: _selectedIndex, changeFunction: changeSelectedIndex, key: _childWidgetKey3),
            NavBarItem(itemIndex: 3, selectedIndex: _selectedIndex, changeFunction: changeSelectedIndex, key: _childWidgetKey4),
            NavBarItem(itemIndex: 4, selectedIndex: _selectedIndex, changeFunction: changeSelectedIndex, key: _childWidgetKey5),
          ],
        ),
      ),
    );
  }
}

class NavBarItem extends StatefulWidget {
  int selectedIndex;
  int itemIndex;
  Function(int) changeFunction;

  NavBarItem({Key? key, required this.itemIndex, required this.selectedIndex, required this.changeFunction}) : super(key: key);

  @override
  State<NavBarItem> createState() => _NavBarItemState();
}

class _NavBarItemState extends State<NavBarItem> with SingleTickerProviderStateMixin {
  late AnimationController animateController;
  late int itemIndex;

  @override
  void initState() {
    super.initState();
    animateController = AnimationController(duration: const Duration(milliseconds: 300), vsync: this);
    itemIndex = widget.itemIndex;
  }

  void playAnimation() {
    animateController.reset();
    animateController.forward();
    print('play animation çalıştı:D');
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return ZoomIn(
      manualTrigger: true,
      controller: (controller) => animateController = controller,
      child: InkWell(
        onTap: () {
          animateController.reset();
          animateController.forward();
          setState(() {
            widget.selectedIndex = itemIndex;
            widget.changeFunction(widget.selectedIndex);
          });
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            () {
              if (itemIndex == 0) {
                return Icon(MdiIcons.homeOutline, color: widget.selectedIndex == 0 ? Colors.white : Colors.white70);
              } else if (itemIndex == 1) {
                return Icon(MdiIcons.coffeeOutline, color: widget.selectedIndex == 1 ? Colors.white : Colors.white70);
              } else if (itemIndex == 2) {
                return Icon(MdiIcons.foodOutline, color: widget.selectedIndex == 2 ? Colors.white : Colors.white70);
              } else if (itemIndex == 3) {
                return Icon(MdiIcons.beerOutline, color: widget.selectedIndex == 3 ? Colors.white : Colors.white70);
              } else if (itemIndex == 4) {
                return Icon(MdiIcons.cartOutline, color: widget.selectedIndex == 4 ? Colors.white : Colors.white70);
              }
              return const SizedBox.shrink();
            }(),
            //const Icon(MdiIcons.homeOutline, color: Colors.white),
            () {
              if (itemIndex == 0) {
                return Text('Home', style: textTheme.caption!.copyWith(color: widget.selectedIndex == 0 ? Colors.white : Colors.white70));
              } else if (itemIndex == 1) {
                return Text('Drinks', style: textTheme.caption!.copyWith(color: widget.selectedIndex == 1 ? Colors.white : Colors.white70));
              } else if (itemIndex == 2) {
                return Text('Foods', style: textTheme.caption!.copyWith(color: widget.selectedIndex == 2 ? Colors.white : Colors.white70));
              } else if (itemIndex == 3) {
                return Text('Goods', style: textTheme.caption!.copyWith(color: widget.selectedIndex == 3 ? Colors.white : Colors.white70));
              } else if (itemIndex == 4) {
                return Text('Cart', style: textTheme.caption!.copyWith(color: widget.selectedIndex == 4 ? Colors.white : Colors.white70));
              }
              return const SizedBox.shrink();
            }(),
            //Text('Home', style: textTheme.caption!.copyWith(color: Colors.white)),
          ],
        ),
      ),
    );
  }
}
