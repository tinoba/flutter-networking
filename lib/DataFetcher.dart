import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:http/http.dart' as http;
import 'package:improvment_day_app/Photo.dart';

class DataFetcher extends StatefulWidget {
  @override
  State createState() => FetchDataState();
}

class FetchDataState extends State<DataFetcher> {
  FlutterBlue flutterBlue = FlutterBlue.instance;
  var scanSubscription;
  var scanning = false;
  List<Photo> list = List();
  var isLoading = false;
  final Set<String> set = new Set<String>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Fetch data"),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(8.0),
          child: RaisedButton(
            child: new Text("Fetch"),
            onPressed: _fetchData,
          ),
        ),
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemCount: list.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    contentPadding: EdgeInsets.all(10.0),
                    title: new Text(list[index].title),
                    trailing: new Image.network(
                      list[index].url,

                      fit: BoxFit.cover,
                      height: 50.0,
                      width: 50.0,
                    ),
                  );
                }));
  }

  _scan() {
    if(scanning){
      scanning = false;
      scanSubscription.cancel();
      set.forEach((it) => debugPrint(it));
    }else {
      scanning = true;
      scanSubscription = flutterBlue.scan().listen((scanResult) {
        // do something with scan result
        set.add(scanResult.device.name);
        debugPrint(scanResult.device.id.toString());
      });
    }
  }

  _fetchData() async {
    setState(() {
      isLoading = true;
    });
    final response =
        await http.get("https://jsonplaceholder.typicode.com/photos");
    if (response.statusCode == 200) {
      list = (json.decode(response.body) as List)
          .map((response) => new Photo.fromJson(response))
          .toList();
      setState(() {
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load photos');
    }
  }
}
