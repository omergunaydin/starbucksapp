import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:starbucksapp/constants/values/colors.dart';
import 'package:starbucksapp/models/product.dart';

import '../constants/dimens/uihelper.dart';
import '../constants/values/constants.dart';

class ReusableSizeSelector extends StatefulWidget {
  List<SizeOption> sizeOptions;
  int selectedSizeIndex;
  Function(int) changeSelectedSizeIndex;
  ReusableSizeSelector({Key? key, required this.sizeOptions, required this.selectedSizeIndex, required this.changeSelectedSizeIndex}) : super(key: key);

  @override
  State<ReusableSizeSelector> createState() => _ReusableSizeSelectorState();
}

class _ReusableSizeSelectorState extends State<ReusableSizeSelector> with SingleTickerProviderStateMixin {
  void changeSelected(int index) {
    print(index);
    setState(() {
      widget.selectedSizeIndex = index;
      widget.changeSelectedSizeIndex(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: UiHelper.horizontalSymmetricPadding3x,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: widget.sizeOptions.asMap().entries.map((entry) {
          final index = entry.key;
          final sizeOption = entry.value;
          if (index == widget.selectedSizeIndex) {
            return SizeItem(size: sizeOption.size!, selected: true, index: index, changeSelected: changeSelected);
          } else {
            return SizeItem(size: sizeOption.size!, selected: false, index: index, changeSelected: changeSelected);
          }
        }).toList(),
      ),
    );
  }
}

class SizeItem extends StatefulWidget {
  String size;
  bool selected;
  int index;
  Function(int) changeSelected;
  SizeItem({Key? key, required this.size, required this.selected, required this.index, required this.changeSelected}) : super(key: key);

  @override
  State<SizeItem> createState() => _SizeItemState();
}

class _SizeItemState extends State<SizeItem> with SingleTickerProviderStateMixin {
  late AnimationController animateController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    animateController = AnimationController(duration: const Duration(milliseconds: 300), vsync: this);
  }

  void changeSelected() {
    setState(() {
      widget.selected = !widget.selected;
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return ZoomIn(
      manualTrigger: true,
      controller: (controller) => animateController = controller,
      child: InkWell(
        onTap: () {
          changeSelected();
          widget.changeSelected(widget.index);
          animateController.reset();
          animateController.forward();
        },
        child: () {
          if (widget.size == 'Short') {
            return Container(
              padding: UiHelper.allPadding1x,
              decoration: BoxDecoration(
                borderRadius: UiHelper.borderRadiusCircular2x,
                color: widget.selected ? UiColorHelper.mainGreen : Colors.white,
              ),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: UiHelper.borderRadiusCircular2x,
                    child: Image.asset(widget.selected ? Constants.shortSelectedPath : Constants.shortUnSelectedPath, width: 50),
                  ),
                  const SizedBox(height: 5),
                  Text('Short', style: textTheme.button!.copyWith(color: widget.selected ? Colors.white : Colors.black)),
                  Text('8 fl oz', style: textTheme.caption!.copyWith(color: widget.selected ? Colors.white : Colors.black)),
                ],
              ),
            );
          } else if (widget.size == 'Tall') {
            return Container(
              padding: UiHelper.allPadding1x,
              decoration: BoxDecoration(
                borderRadius: UiHelper.borderRadiusCircular2x,
                color: widget.selected ? UiColorHelper.mainGreen : Colors.white,
              ),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: UiHelper.borderRadiusCircular2x,
                    child: Image.asset(widget.selected ? Constants.tallSelectedPath : Constants.tallUnSelectedPath, width: 50),
                  ),
                  const SizedBox(height: 5),
                  Text('Tall', style: textTheme.button!.copyWith(color: widget.selected ? Colors.white : Colors.black)),
                  Text('12 fl oz', style: textTheme.caption!.copyWith(color: widget.selected ? Colors.white : Colors.black)),
                ],
              ),
            );
          } else if (widget.size == 'Grande') {
            return Container(
              padding: UiHelper.allPadding1x,
              decoration: BoxDecoration(
                borderRadius: UiHelper.borderRadiusCircular2x,
                color: widget.selected ? UiColorHelper.mainGreen : Colors.white,
              ),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: UiHelper.borderRadiusCircular2x,
                    child: Image.asset(widget.selected ? Constants.grandeSelectedPath : Constants.grandeUnSelectedPath, width: 50),
                  ),
                  const SizedBox(height: 5),
                  Text('Grande', style: textTheme.button!.copyWith(color: widget.selected ? Colors.white : Colors.black)),
                  Text('16 fl oz', style: textTheme.caption!.copyWith(color: widget.selected ? Colors.white : Colors.black)),
                ],
              ),
            );
          } else if (widget.size == 'Venti') {
            return Container(
              padding: UiHelper.allPadding1x,
              decoration: BoxDecoration(
                borderRadius: UiHelper.borderRadiusCircular2x,
                color: widget.selected ? UiColorHelper.mainGreen : Colors.white,
              ),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: UiHelper.borderRadiusCircular2x,
                    child: Image.asset(widget.selected ? Constants.ventiSelectedPath : Constants.ventiUnSelectedPath, width: 50),
                  ),
                  const SizedBox(height: 5),
                  Text('Venti', style: textTheme.button!.copyWith(color: widget.selected ? Colors.white : Colors.black)),
                  Text('20 fl oz', style: textTheme.caption!.copyWith(color: widget.selected ? Colors.white : Colors.black)),
                ],
              ),
            );
          } else if (widget.size == 'Solo') {
            return Container(
              padding: UiHelper.allPadding1x,
              decoration: BoxDecoration(
                borderRadius: UiHelper.borderRadiusCircular2x,
                color: widget.selected ? UiColorHelper.mainGreen : Colors.white,
              ),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: UiHelper.borderRadiusCircular2x,
                    child: Image.asset(widget.selected ? Constants.shortSelectedPath : Constants.shortUnSelectedPath, width: 50),
                  ),
                  const SizedBox(height: 5),
                  Text('Solo', style: textTheme.button!.copyWith(color: widget.selected ? Colors.white : Colors.black)),
                  Text('0.75 fl oz', style: textTheme.caption!.copyWith(color: widget.selected ? Colors.white : Colors.black)),
                ],
              ),
            );
          } else if (widget.size == 'Doppio') {
            return Container(
              padding: UiHelper.allPadding1x,
              decoration: BoxDecoration(
                borderRadius: UiHelper.borderRadiusCircular2x,
                color: widget.selected ? UiColorHelper.mainGreen : Colors.white,
              ),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: UiHelper.borderRadiusCircular2x,
                    child: Image.asset(widget.selected ? Constants.shortSelectedPath : Constants.shortUnSelectedPath, width: 50),
                  ),
                  const SizedBox(height: 5),
                  Text('Doppio', style: textTheme.button!.copyWith(color: widget.selected ? Colors.white : Colors.black)),
                  Text('1.5 fl oz', style: textTheme.caption!.copyWith(color: widget.selected ? Colors.white : Colors.black)),
                ],
              ),
            );
          } else if (widget.size == 'Triple') {
            return Container(
              padding: UiHelper.allPadding1x,
              decoration: BoxDecoration(
                borderRadius: UiHelper.borderRadiusCircular2x,
                color: widget.selected ? UiColorHelper.mainGreen : Colors.white,
              ),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: UiHelper.borderRadiusCircular2x,
                    child: Image.asset(widget.selected ? Constants.shortSelectedPath : Constants.shortUnSelectedPath, width: 50),
                  ),
                  const SizedBox(height: 5),
                  Text('Triple', style: textTheme.button!.copyWith(color: widget.selected ? Colors.white : Colors.black)),
                  Text('2.25 fl oz', style: textTheme.caption!.copyWith(color: widget.selected ? Colors.white : Colors.black)),
                ],
              ),
            );
          } else if (widget.size == 'Quad') {
            return Container(
              padding: UiHelper.allPadding1x,
              decoration: BoxDecoration(
                borderRadius: UiHelper.borderRadiusCircular2x,
                color: widget.selected ? UiColorHelper.mainGreen : Colors.white,
              ),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: UiHelper.borderRadiusCircular2x,
                    child: Image.asset(widget.selected ? Constants.shortSelectedPath : Constants.shortUnSelectedPath, width: 50),
                  ),
                  const SizedBox(height: 5),
                  Text('Quad', style: textTheme.button!.copyWith(color: widget.selected ? Colors.white : Colors.black)),
                  Text('3 fl oz', style: textTheme.caption!.copyWith(color: widget.selected ? Colors.white : Colors.black)),
                ],
              ),
            );
          }
        }(),
      ),
    );

    return const SizedBox.shrink();
  }
}
