import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';




enum FourierTypes { square, sawtooth }

class BaseFourierSeriesVisualization extends StatelessWidget {
  const BaseFourierSeriesVisualization({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fourier Series Visualization'),
      ),
      body: const Center(
        child: BaseFourierPainterWidget(),
      ),
    );
  }
}

class BaseFourierPainterWidget extends StatefulWidget{
  const BaseFourierPainterWidget({super.key});

  @override
  State<BaseFourierPainterWidget> createState() => _BaseFourierPainterWidgetState();
}

class _BaseFourierPainterWidgetState extends State<BaseFourierPainterWidget> with SingleTickerProviderStateMixin {
  int terms = 1; // Number of terms in the Fourier series
  List<Offset> points = [];
  double previousValue = 0.0;
  // double deltaX = 0.0;
  FourierTypes? fourierType;

  late AnimationController _controller;
  late Animation<double> _animation;
  final TextEditingController dropDownSelectionController = TextEditingController();


  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: false)
      // ..addListener(() {
      //   // Get the current value and calculate deltaX (change in value)
      //   setState(() {
      //     deltaX = _controller.value - previousValue;
      //     previousValue = _controller.value;
      //   });
      // })
    ;

    fourierType = FourierTypes.square;

    _animation = Tween<double>(
      begin: 0,
      end: 2 * pi,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.linear));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Fourier series approximation for first $terms terms"),
            DropdownMenu<FourierTypes>(
              initialSelection: FourierTypes.square,
              controller: dropDownSelectionController,
              requestFocusOnTap: true,
              label: const Text('Fourier Type'),
              onSelected: (FourierTypes? color) {
                setState(() {
                  fourierType = color;
                });
              },
              dropdownMenuEntries: FourierTypes.values.map((e) {
                return DropdownMenuEntry( value: e, label: e.name.toString());
              }).toList(),
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return CustomPaint(
              size: const Size(1500, 750),
              painter: BaseFourierPainter(
                  terms,
                  _animation.value,
                  points,
                  fourierType
                  // deltaX
              ),
            );
          }
        ),
        Slider(
          min: 1,
          max: 20,
          value: terms.toDouble(),
          divisions: 19,
          label: '$terms terms',
          onChanged: (double value) {
            setState(() {
              terms = value.toInt();
            });
          },
        ),
      ],
    );
  }
}

class BaseFourierPainter extends CustomPainter {
  final int numTerms; // Number of terms  in fourier series
  final double angle;  // Current angle of the dot on the circle
  // double time = 0.0;
  final List<Offset> points; // List of points from parent class
  // final double deltaX;
  final FourierTypes? fourierType;

  BaseFourierPainter(this.numTerms, this.angle, this.points
      // , this.deltaX
      , this.fourierType
      );

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
        ..color = Colors.purple
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke
    ;

    double width = size.width;
    double height = size.height;
    // double xValueFourierWave;

    // Draw the axes
    paint.color = Colors.black;
    canvas.drawLine(Offset(width / 2, 0), Offset(width / 2, height), paint);
    canvas.drawLine(Offset(0, height / 2), Offset(width, height / 2), paint);

    Paint circlePaint = Paint()
      ..color = Colors.green
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
    ;

    Paint dotPaint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 2
      ..style = PaintingStyle.fill
    ;

    Paint accentPaint = Paint()
      ..color = Colors.blueAccent
      ..strokeWidth = 2
      ..style = PaintingStyle.fill
    ;

    Paint pathPaint = Paint()
      ..color = Colors.red
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
    ;

    // Main constants
    Offset center = Offset(width/6, height/2);
    double rightSideLineOffset = 100;
    double xValue = center.dx; //x and y coordinate of base of circle fir first term,
                               // to ve updated each iteration of the term
    double yValue = center.dy;

    double previousXValue = xValue;
    double previousYValue = yValue;

    for (var nTerm = 0; nTerm < numTerms ; nTerm++) {
      // print(" Start term $nTerm, previousXValue $previousXValue, previousYValue $previousYValue, xValue $xValue, yValue $yValue ");

      // for Sawtooth
      //  double n = nTerm + 1, opposite wave from the wikipedia page
      // double nValue = nTerm * 2 + 1;
      double nValue;
      double angleConstant;

      if (fourierType == FourierTypes.square) {
        nValue = nTerm * 2 + 1;
        angleConstant = 0;
      } else if (fourierType == FourierTypes.sawtooth) {
        nValue = nTerm + 1 ;
        angleConstant = pi; // as pattern is reverse of one in wikipedia,
                            // adding constant to move the starting point of the pattern
      } else {
        nValue = nTerm + 1; // keep default in case of enum non exhaustive implementation
        angleConstant = 0;
      }

      // Main circle
      double radius = 100 * (4 / (nValue * pi));
      canvas.drawCircle(Offset(previousXValue, previousYValue), radius, circlePaint);

      // Moving Dot calculations
      double dotX = previousXValue + radius * cos(nValue * angle + angleConstant);  // x = r * cos(θ)
      double dotY = previousYValue + radius * sin(nValue * angle + angleConstant);  // y = r * sin(θ)
      // print("dotX is $dotX, dotY is $dotY");
      // print(" nTerm * angle is ${nTerm * angle}, cos(nValue * angle) is ${cos(nValue * angle)}, radius is $radius, radius * cos(nValue * angle) is ${radius * cos(nValue * angle)}");

      // print(" Mid 1 term $nTerm, previousXValue $previousXValue, previousYValue $previousYValue, xValue $xValue, yValue $yValue ");

      // For Sawtooth Waveform
      xValue = dotX;
      yValue = dotY;

      Offset dotOffset = Offset(dotX, dotY);

      // print(" Mid 2 term $nTerm, previousXValue $previousXValue, previousYValue $previousYValue, xValue $xValue, yValue $yValue ");

      // Draw the dot at the calculated position
      canvas.drawCircle(dotOffset, 5, dotPaint);

      Offset intermediateDotOffset = Offset(xValue, yValue);

      // Line connecting center and moving dot
      canvas.drawLine(Offset(previousXValue, previousYValue), intermediateDotOffset, paint);
      // print("term $nTerm Offset(previousXValue, previousYValue), intermediateDotOffset are ${Offset(previousXValue, previousYValue)} amd ${intermediateDotOffset}");

      previousXValue = xValue;
      previousYValue = yValue;

      // print("End term $nTerm, previousXValue $previousXValue, previousYValue $previousYValue, xValue $xValue, yValue $yValue ");
    }

    Offset dotOffset = Offset(xValue, yValue);

    // Line connecting center and moving dot
    canvas.drawLine(center, dotOffset, pathPaint);

    // Line on right hand side
    double rightSideLineXCoordinates = center.dx + (100 * 4 / (pi)) + rightSideLineOffset;
//     canvas.drawLine(Offset(rightSideLineXCoordinates, center.dy + radius), Offset(rightSideLineXCoordinates, center.dy - radius), paint);
    canvas.drawLine(Offset(rightSideLineXCoordinates, double.infinity), Offset(rightSideLineXCoordinates, - double.infinity), paint);

    // Line joining right hand side and the dot horizontally
    canvas.drawLine(dotOffset, Offset(rightSideLineXCoordinates, dotOffset.dy), accentPaint);

    Path path = Path();
    path.moveTo(rightSideLineXCoordinates, dotOffset.dy);

    // // Append the new point on right line to points list at the start
    if (points.isEmpty) {
      points.insert(0, Offset(rightSideLineXCoordinates, dotOffset.dy));
      // points.insert(1, Offset(rightSideLineXCoordinates, dotOffset.dy));
    } else {
      // points.map((point) => point = Offset(point.dx +1, point.dy));
      points.insert(0, Offset(points[0].dx + 1, dotOffset.dy));
      // points.insert(1, points[1]);
    }

    points.map((point) {
      path.lineTo(point.dx, point.dy);
    });
    canvas.drawPath(path, accentPaint..color=Colors.amber);


    // print("${"*"* 20}");
    // print(points);
    // print(deltaX);

    double rightLineOffset = points[0].dx;

    List<Offset> wavePoints = points.map((point) {
      return Offset(rightSideLineXCoordinates + rightLineOffset - point.dx, point.dy);
    }).toList();

    if (points.length > 800) {
      points.removeRange(800, points.length);
    }

    // Start drawing the Fourier series approximation
    // Path path = Path();
    // path.moveTo(rightSideLineXCoordinates, center.dy);
    // for (Offset point in points) {
    //   path.moveTo(point.dx, point.dy);
    //   print("new movement is to ${point.dx}, $point.dy}");
    // }

    // canvas.drawPath(path, accentPaint);
    canvas.drawPoints(PointMode.lines,  wavePoints, dotPaint);


    // time += 0.01;
    // print("time is $time");
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
  
}
