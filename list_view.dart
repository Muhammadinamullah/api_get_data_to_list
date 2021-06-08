import 'dart:convert';
import 'dart:ffi';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';

class ListViewPage extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<ListViewPage> {
  List users = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    this.fetchUser();
  }

  fetchUser() async {
    String url = 'https://randomuser.me/api/?results=100';
    var parsedUrl = Uri.parse(url);
    var response = await http.get(parsedUrl);
    if (response.statusCode == 200) {
      var items = json.decode(response.body)['results'];
      setState(() {
        users = items;
      });
    } else {
      setState(() {
        users = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List'),
      ),
      body: getBody(),
    );
  }

  Widget getBody() {
    if (users.contains(null) || users.length < 0 || isLoading) {
      return Center(
        child: CircularProgressIndicator(
          valueColor: new AlwaysStoppedAnimation(Colors.blue),
        ),
      );
    }
    return ListView.builder(
        // scrollDirection: Axis.vertical,
        itemCount: users.length,
        itemBuilder: (context, index) {
          return getCard(users[index]);
        });
  }

  Widget getCard(index) {
    var fullName = index['name']['title'] +
        ' ' +
        index['name']['first'] +
        ' ' +
        index['name']['last'];
    var email = index['email'];
    var profile = index['picture']['large'];
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Card(
        child: ListTile(
          title: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(profile.toString()),
                  ),
                ),
              ),
              SizedBox(
                width: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    fullName.toString(),
                    style: TextStyle(fontSize: 12),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    email.toString(),
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
