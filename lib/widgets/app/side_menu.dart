import 'package:flutter/material.dart';
import 'package:yes_broker/constants/colors.dart';
import 'package:yes_broker/constants/constants.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SideMenuState createState() => _SideMenuState();
}

List<bool> selected = [true, false, false, false, false, false];

class _SideMenuState extends State<SideMenu> {
  void select(int n) {
    for (int i = 0; i < 6; i++) {
      if (i == n) {
        selected[i] = true;
      } else {
        selected[i] = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        // padding: const EdgeInsets.only(top: 30),
        height: MediaQuery.of(context).size.height,
        width: 201.0,
        alignment: Alignment.center,
        // decoration: const BoxDecoration(
        //   color: Colors.black,
        // ),
        child: SingleChildScrollView(
          child: Container(
            alignment: Alignment.center,
            // margin: const EdgeInsets.only(top: 100),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: sideBarIcons
                  .map(
                    (e) => Center(
                      child: NavBarItem(
                        icon: e,
                        selected: selected[sideBarIcons.indexOf(e)],
                        onTap: () {
                          setState(() {
                            select(sideBarIcons.indexOf(e));
                          });
                        },
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      ),
    );
  }
}

class NavBarItem extends StatefulWidget {
  final IconData icon;
  final Function onTap;
  final bool selected;
  const NavBarItem({
    super.key,
    required this.icon,
    required this.onTap,
    required this.selected,
  });
  @override
  // ignore: library_private_types_in_public_api
  _NavBarItemState createState() => _NavBarItemState();
}

class _NavBarItemState extends State<NavBarItem> with TickerProviderStateMixin {
  late AnimationController _controller1;
  late AnimationController _controller2;

  // late Animation<double> _anim1;
  // late Animation<double> _anim2;
  // late Animation<double> _anim3;
  // late Animation<Color?> _color;

  bool hovered = false;

  @override
  void initState() {
    super.initState();
    _controller1 = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _controller2 = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 275),
    );

    // _anim1 = Tween(begin: 101.0, end: 75.0).animate(_controller1);
    // _anim2 = Tween(begin: 101.0, end: 25.0).animate(_controller2);
    // _anim3 = Tween(begin: 101.0, end: 50.0).animate(_controller2);
    // _color = ColorTween(end: const Color(0xff332a7c), begin: Colors.white)
    //     .animate(_controller2);

    _controller1.addListener(() {
      setState(() {});
    });
    _controller2.addListener(() {
      setState(() {});
    });
  }

  @override
  void didUpdateWidget(NavBarItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!widget.selected) {
      Future.delayed(const Duration(milliseconds: 10), () {
        //_controller1.reverse();
      });
      _controller1.reverse();
      _controller2.reverse();
    } else {
      _controller1.forward();
      _controller2.forward();
      Future.delayed(const Duration(milliseconds: 10), () {
        //_controller2.forward();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () {
          widget.onTap();
        },
        child: MouseRegion(
          onEnter: (value) {
            setState(() {
              hovered = true;
            });
          },
          onExit: (value) {
            setState(() {
              hovered = false;
            });
          },
          child: Container(
            width: 40,
            height: 40,
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: hovered && !widget.selected
                    ? AppColor.secondary
                    : Colors.transparent),
            child: Center(
              child: Icon(
                widget.icon,
                color: !widget.selected ? Colors.black : AppColor.primary,
                size: !widget.selected ? 23 : 28,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CurvePainter extends CustomPainter {
  final double value1; // 200
  final double animValue1; // static value1 = 50.0
  final double animValue2; //static value1 = 75.0
  final double animValue3; //static value1 = 75.0

  CurvePainter({
    required this.value1,
    required this.animValue1,
    required this.animValue2,
    required this.animValue3,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Path path = Path();
    Paint paint = Paint();

    path.moveTo(101, value1);
    path.quadraticBezierTo(101, value1 + 20, animValue3,
        value1 + 20); // have to use animValue3 for x2
    path.lineTo(animValue1, value1 + 20); // have to use animValue1 for x
    path.quadraticBezierTo(animValue2, value1 + 20, animValue2,
        value1 + 40); // animValue2 = 25 // have to use animValue2 for both x
    path.lineTo(101, value1 + 40);
    // path.quadraticBezierTo(25, value1 + 60, 50, value1 + 60);
    // path.lineTo(75, value1 + 60);
    // path.quadraticBezierTo(101, value1 + 60, 101, value1 + 80);
    path.close();

    path.moveTo(101, value1 + 80);
    path.quadraticBezierTo(101, value1 + 60, animValue3, value1 + 60);
    path.lineTo(animValue1, value1 + 60);
    path.quadraticBezierTo(animValue2, value1 + 60, animValue2, value1 + 40);
    path.lineTo(101, value1 + 40);
    path.close();

    paint.color = Colors.white;
    paint.strokeWidth = 101.0;
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}
