import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:simpsonsviewer/datamodel/wireviewer_datamodel.dart' as dmodel;
import 'package:simpsonsviewer/providers/data_list_provider.dart';
import 'package:simpsonsviewer/ui/detail_screen.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  bool typing = false;
  TextEditingController searchtext = TextEditingController();
  late List<dmodel.RelatedTopics> datalist;
  late List<dmodel.RelatedTopics> searchlist;

  @override
  void initState() {
    // TODO: implement initState
    getdata();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Container(
          alignment: Alignment.centerLeft,
          color: Colors.white,
          child: TextField(
            controller: searchtext,
            decoration: InputDecoration(
                border: InputBorder.none, hintText: 'Search'),
          ),
        ),

        leading: IconButton(
          icon: Icon(typing ? Icons.done : Icons.search),
          onPressed: () {
            Provider.of<DataListProvider>(context, listen: false)
                .updateQuery(searchtext.text);
          },
        ),
      ),
      body: Container(
        child: FutureBuilder(
          future: getdata(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasData) {
              return Consumer<DataListProvider>(
                  builder: (context, manger, child) {
                    List<dmodel.RelatedTopics>? list = manger.datalist;
                    return ListView(
                      children: List.generate(list.length, (index) {
                        return InkWell(
                          onTap: () {
                            if (!getDeviceType()) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DetailsScreen(
                                        url:
                                        getimageurl("${list[index].icon!.uRL}"),
                                        title: gettitle(list[index].text!),
                                        description:
                                        getdiscription(list[index].text!))),
                              );
                            }
                          },
                          child: Card(
                            elevation: 8,
                            child: Container(
                              margin: EdgeInsets.only(
                                left: 10,
                                right: 10,
                                top: 10,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CachedNetworkImage(
                                    imageUrl:
                                    getimageurl("${list[index].icon!.uRL}"),
                                    // placeholder: (context, url) => CircularProgressIndicator(),

                                    progressIndicatorBuilder:
                                        (context, url, downloadProgress) =>
                                        CircularProgressIndicator(
                                            value: downloadProgress.progress),
                                    //   errorWidget: (context, url, error) => Icon(Icons.error),
                                  ),
                                  Text(
                                    gettitle(list[index].text!),
                                    style: TextStyle(
                                        fontSize: 22, fontWeight: FontWeight.w800),
                                  ),
                                  (getDeviceType())
                                      ? Text(getdiscription(list[index].text!))
                                      : Container()
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                    );
                  });
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }

  getdata() async {
    final response = await http.get(Uri.parse(
        'http://api.duckduckgo.com/?q=simpsons+characters&format=json'));
    if (response.statusCode == 200) {
      datalist = dmodel.WireviewerDatamodel.fromJson(jsonDecode(response.body))
          .relatedTopics!;
      if (context.mounted) {
        Provider.of<DataListProvider>(context, listen: false)
            .updateDataList(datalist);
      }
      return datalist;
    } else {
      throw Exception('Failed to load album');
    }
  }

  gettitle(String text) {
    var parts = text.split(' - ');
    return parts[0].toString();
  }

  getdiscription(String text) {
    var parts = text.split('-');

    var desc = (parts.length > 1) ? '\n ${parts[1]}' : '';
    return desc;
  }

  getimageurl(String url) {
    if (url != "") {
      return "https://duckduckgo.com${url}";
    } else {
      return "http://via.placeholder.com/350x150";
    }
  }

 

  getDeviceType() {
    var shortestSide = MediaQuery.of(context).size.shortestSide;
    return shortestSide < 600 ? false : true;
  }
}
