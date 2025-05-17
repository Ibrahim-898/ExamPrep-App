import 'package:flutter/material.dart';

class Routine extends StatefulWidget {
  const Routine({super.key});

  @override
  State<Routine> createState() => _RoutineState();
}

class _RoutineState extends State<Routine> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF1F5F6),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);  
          },
          icon: Icon(Icons.arrow_back),  
        ),
        centerTitle: true,
        title: Text("UniRoutine Question Bank"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,  
          children: List.generate(10, (index) {
            return GestureDetector(
              onTap: (){

              },
            child:  Container(
              margin: EdgeInsets.only(bottom: 10),  
              width: double.infinity, 
              height: 50,  
              color:  const Color.fromARGB(255, 133, 133, 171) ,  
              child: Center(
                child: Text(
                  'Year ${index + 1}', 
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
            );
          }),
        ),
      ),
    );
  }
}
