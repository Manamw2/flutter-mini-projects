import 'package:flutter/material.dart';
import 'package:first_app/styled_text.dart';

class RollDicer extends StatefulWidget{
  const RollDicer({super.key});
  @override
  State<RollDicer> createState() {
    return _RollDicerState();
  }
}

class _RollDicerState extends State<RollDicer>{
  var imgUrl = 1;
  void rollDice(){
    setState(() {
      imgUrl = imgUrl == 6? 1: imgUrl + 1;
    });
}
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset('assets/images/dice-${imgUrl.toString()}.png', width: 200,),
        const StyledText("Hello World!"),
        const StyledText("Flutter is great framwork to create cross platform apps"),
        TextButton(
          onPressed: rollDice,
          style: TextButton.styleFrom(
          backgroundColor: Colors.amber,
          padding: const EdgeInsets.all(16.0),),
          child: const Text('Roll Dice'),
        ),
      ],
    );
  }
}
