// import 'package:flutter/material.dart';
// import 'package:examprep/Admin/liveexamQuestion.dart';

// class LiveExamFormPage extends StatefulWidget {
//   @override
//   _LiveExamFormPageState createState() => _LiveExamFormPageState();
// }

// class _LiveExamFormPageState extends State<LiveExamFormPage> {
//   final _formKey = GlobalKey<FormState>();

//   String? _examType;
//   String? _examName;
//   String? _password;
//   int? _duration;
//   DateTime? _selectedDate;
//   TimeOfDay? _selectedTime;
//   DateTime? _endTime;

//   final List<String> examTypes = ["Varsity", "Medical", "Engineering"];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Set Live Exam"),
//         backgroundColor: Colors.blueGrey[900],
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: ListView(
//             children: [
//               // Exam Type Dropdown
//               DropdownButtonFormField<String>(
//                 decoration: InputDecoration(labelText: "Exam Type"),
//                 value: _examType,
//                 items: examTypes
//                     .map((type) => DropdownMenuItem<String>(
//                           value: type,
//                           child: Text(type),
//                         ))
//                     .toList(),
//                 onChanged: (value) {
//                   setState(() {
//                     _examType = value;
//                   });
//                 },
//                 validator: (value) =>
//                     value == null ? 'Please select an exam type' : null,
//               ),
//               SizedBox(height: 16),

//               // Exam Name
//               TextFormField(
//                 decoration: InputDecoration(labelText: 'Exam Name'),
//                 onSaved: (value) => _examName = value,
//                 validator: (value) =>
//                     value == null || value.isEmpty ? 'Enter exam name' : null,
//               ),
//               SizedBox(height: 16),

//               // Password
//               TextFormField(
//                 decoration: InputDecoration(labelText: 'Password'),
//                 obscureText: true,
//                 onSaved: (value) => _password = value,
//                 validator: (value) =>
//                     value == null || value.isEmpty ? 'Enter password' : null,
//               ),
//               SizedBox(height: 16),

//               // Date Picker
//               ListTile(
//                 title: Text("Select Exam Date"),
//                 subtitle: Text(_selectedDate == null
//                     ? 'Pick a date'
//                     : _selectedDate!.toLocal().toString().split(' ')[0]),
//                 onTap: () async {
//                   final pickedDate = await showDatePicker(
//                     context: context,
//                     initialDate: DateTime.now(),
//                     firstDate: DateTime(2023),
//                     lastDate: DateTime(2101),
//                   );
//                   if (pickedDate != null) {
//                     setState(() {
//                       _selectedDate = pickedDate;
//                     });
//                   }
//                 },
//               ),
//               SizedBox(height: 16),

//               // Time Picker
//               ListTile(
//                 title: Text("Select Start Time"),
//                 subtitle: Text(_selectedTime == null
//                     ? 'Pick a time'
//                     : _selectedTime!.format(context)),
//                 onTap: () async {
//                   final pickedTime = await showTimePicker(
//                     context: context,
//                     initialTime: TimeOfDay.now(),
//                   );
//                   if (pickedTime != null) {
//                     setState(() {
//                       _selectedTime = pickedTime;
//                     });
//                   }
//                 },
//               ),
//               SizedBox(height: 16),

//               // Duration
//               TextFormField(
//                 decoration: InputDecoration(labelText: 'Duration (minutes)'),
//                 keyboardType: TextInputType.number,
//                 onSaved: (value) => _duration = int.tryParse(value ?? ''),
//                 validator: (value) =>
//                     value == null || value.isEmpty ? 'Enter duration' : null,
//               ),
//               SizedBox(height: 20),

//               // Submit Button
//               ElevatedButton(
//                 onPressed: () {
//                   if (_formKey.currentState!.validate()) {
//                     if (_selectedDate == null || _selectedTime == null) {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(
//                             content: Text(
//                                 'Please select both date and time for the exam')),
//                       );
//                       return;
//                     }

//                     _formKey.currentState!.save();

//                     // Combine date and time to form startTime
//                     final DateTime startTime = DateTime(
//                       _selectedDate!.year,
//                       _selectedDate!.month,
//                       _selectedDate!.day,
//                       _selectedTime!.hour,
//                       _selectedTime!.minute,
//                     );

//                     // Calculate end time
//                     _endTime = startTime.add(Duration(minutes: _duration!));

//                     // Navigate to LiveExamQuestion page with all data
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => Liveexamquestion(
//                           examName: _examName!,
//                           examType: _examType!,
//                           password: _password!,
//                           startTime: startTime,
//                           duration: _duration!,
//                           endTime: _endTime!,
//                         ),
//                       ),
//                     );
//                   }
//                 },
//                 child: Text('Set Exam'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'liveexamQuestion.dart';

class LiveExamFormPage extends StatefulWidget {
  const LiveExamFormPage({super.key});

  @override
  _LiveExamFormPageState createState() => _LiveExamFormPageState();
}

class _LiveExamFormPageState extends State<LiveExamFormPage> {
  final _formKey = GlobalKey<FormState>();

  String? _examType;
  String? _examName;
  String? _password;
  int? _duration;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  DateTime? _endTime;

  final List<String> examTypes = ["Varsity", "Medical", "Engineering"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Set Live Exam"),
        backgroundColor: Colors.blueGrey[900],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: "Exam Type"),
                value: _examType,
                items: examTypes
                    .map((type) => DropdownMenuItem(
                          value: type,
                          child: Text(type),
                        ))
                    .toList(),
                onChanged: (value) => setState(() => _examType = value),
                validator: (value) =>
                    value == null ? 'Please select an exam type' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(labelText: 'Exam Name'),
                onSaved: (value) => _examName = value,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter exam name' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                onSaved: (value) => _password = value,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter password' : null,
              ),
              SizedBox(height: 16),
              ListTile(
                title: Text("Select Exam Date"),
                subtitle: Text(_selectedDate == null
                    ? 'Pick a date'
                    : _selectedDate!.toLocal().toString().split(' ')[0]),
                onTap: () async {
                  final pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2023),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null) {
                    setState(() => _selectedDate = pickedDate);
                  }
                },
              ),
              SizedBox(height: 16),
              ListTile(
                title: Text("Select Start Time"),
                subtitle: Text(_selectedTime == null
                    ? 'Pick a time'
                    : _selectedTime!.format(context)),
                onTap: () async {
                  final pickedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (pickedTime != null) {
                    setState(() => _selectedTime = pickedTime);
                  }
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(labelText: 'Duration (minutes)'),
                keyboardType: TextInputType.number,
                onSaved: (value) =>
                    _duration = int.tryParse(value ?? '0') ?? 0,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter duration' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    if (_selectedDate == null || _selectedTime == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(
                                'Please select both date and time for the exam')),
                      );
                      return;
                    }

                    _formKey.currentState!.save();

                    final startTime = DateTime(
                      _selectedDate!.year,
                      _selectedDate!.month,
                      _selectedDate!.day,
                      _selectedTime!.hour,
                      _selectedTime!.minute,
                    );
                    _endTime = startTime.add(Duration(minutes: _duration!));

                    await Supabase.instance.client.from('live_exams').insert({
                      'exam_name': _examName,
                      'exam_type': _examType,
                      'password': _password,
                      'start_time': startTime.toIso8601String(),
                      'end_time': _endTime!.toIso8601String(),
                      'duration': _duration,
                    });

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LiveExamQuestionPage(
                          examName: _examName!,
                        ),
                      ),
                    );
                  }
                },
                child: Text('Set Exam'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
