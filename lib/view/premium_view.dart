import 'package:flutter/material.dart';
import 'package:spotify_clone/widgets/custom_bottom_sheet.dart';

class PremiumView extends StatefulWidget {
  const PremiumView({super.key});

  @override
  State<PremiumView> createState() => _PremiumViewState();
}

class _PremiumViewState extends State<PremiumView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(

      ),
      body: ListView(
        children: [
          Container(color: Colors.amber,height: 100,),
          SizedBox(height: 20,),
          Container(color: Colors.amber,height: 100,),
          SizedBox(height: 20,),
          Container(color: Colors.amber,height: 100,),
          SizedBox(height: 20,),
          Container(color: Colors.amber,height: 100,),
          SizedBox(height: 20,),
          Container(color: Colors.amber,height: 100,),
          SizedBox(height: 20,),
          Container(color: Colors.amber,height: 100,),
        ],

      ),
    );
  }
}