import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Random Image',            
      home: RandomImage(),
      theme: ThemeData(
        primaryColor: Colors.indigoAccent
      ),
    );
  }
}

class RandomImage extends StatefulWidget {
  @override
  RandomImageState createState() => RandomImageState();
}

class RandomImageState extends State<RandomImage> {
  Future<String> imageUrl;

  Future<String> fetchImage() async {
    final response = await http.get('https://dog.ceo/api/breeds/image/random');
    return await json.decode(response.body)['message'];
  }

  @override
  void initState() {
    super.initState();
    imageUrl = fetchImage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: 
        FutureBuilder<String>(future: imageUrl, builder: (context, snapshot) {
          if(snapshot.hasData) {
            return Image.network(snapshot.data);
          } else {
            return Text("Loading...");
          }
        }),
      ),
      appBar: AppBar(
        title: const Text('Random dog image'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          setState(() {
            imageUrl = fetchImage();
          });
        },
        icon: Icon(Icons.refresh),
        label: Text('Refresh'),
        backgroundColor: Colors.indigoAccent,
      ),
    );
  }
}