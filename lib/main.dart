import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List records = []; // Initialized as an empty list
  bool isLoading = true;
  String errorMessage = '';

  Future<void> _fetch() async {
    String url =
        "https://api.airtable.com/v0/app3sfMxHIczFdfyS/User%20Info?maxRecords=3&view=Grid%20view";
    Map<String, String> header = {
      "Authorization":
          "Bearer patIK44qWWciZPUdC.c2acd98c5fa3871447de3b15a9d2f8864ebfd536bfa24323efc0e9a3319c49b4"
    };

    try {
      Response res = await http.get(Uri.parse(url), headers: header);

      if (res.statusCode == 200) {
        Map<String, dynamic> result = json.decode(res.body);
        records = result['records'] ?? []; // Ensure non-null response
        log("Records: ${records.toString()}");
      } else {
        errorMessage = 'Failed to load data. Status code: ${res.statusCode}';
        log("Error: $errorMessage");
      }
    } catch (e) {
      errorMessage = 'Error: $e';
      log("Exception: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('User Info')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage))
              : ListView.separated(
                  itemCount: records.length,
                  itemBuilder: (context, index) {
                    return Container(
                      height: 200,
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        records[index]['fields']['Name'].toString(),
                        style: const TextStyle(fontSize: 18),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 10),
                ),
    );
  }
}
