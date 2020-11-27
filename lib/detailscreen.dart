import 'dart:developer';

import 'package:DocTruyenOnline/readerscreen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;

class DetailScreen extends StatefulWidget {
  final String link;

  DetailScreen({Key key, @required this.link}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _DetailScreenState(link: link);
  }
}

class _DetailScreenState extends State<DetailScreen> {
  var _comic = {'title': '', 'thumbUrl': '', 'description': '', 'author': ''};

  var link = "";
  var _listChap = [];

  _DetailScreenState({@required this.link}) : super();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDetailComic();
    getAllChapter();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          tooltip: 'Go back',
          onPressed: () => {Navigator.pop(context)},
        ),
        title: Text('${this._comic['title']}'),
      ),
      body: Container(
        padding:
            const EdgeInsets.only(top: 30, left: 10, right: 10, bottom: 10),
        child: Column(
          children: [
            Container(
                margin: EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: FadeInImage(
                            image: NetworkImage('https:' + _comic['thumbUrl']),
                            placeholder: AssetImage('assets/ic_app.png'),
                            height: 70,
                            width: 70,
                            fit: BoxFit.cover)),
                    Container(
                      margin: EdgeInsets.only(left: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(children: [
                            Expanded(
                                child: Container(
                                    margin: EdgeInsets.only(left: 10),
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(_comic['title'],
                                              style: TextStyle(fontSize: 20),
                                              overflow: TextOverflow.ellipsis)
                                        ]))),
                          ]),
                          Row(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(right: 10),
                                child: Row(
                                  children: [
                                    Icon(Icons.person),
                                    Text('Tác giả')
                                  ],
                                ),
                              ),
                              Text(_comic['author'])
                            ],
                          ),
                          Column(
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.article),
                                  Text('Nội dung')
                                ],
                              ),
                              Text(_comic['description'])
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                )),
            Container(
              child: Flexible(
                  child: ListView.builder(
                      itemCount: _listChap.length,
                      itemBuilder: (context, index) {
                        var item = _listChap[index];
                        return Card(
                          child: InkWell(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ReaderScreen(link: item['url']))),
                            child: Container(
                              padding: EdgeInsets.all(10),
                              height: 50,
                              child: Row(
                                children: [
                                  Expanded(child: Text(item['title']))
                                ],
                              ),
                            ),
                          ),
                        );
                      })),
            )
          ],
        ),
      ),
    );
  }

  Future<void> getDetailComic() async {
    if (link.isEmpty) return;
    var url = link;
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var htmlStr = response.body;
      var docHtml = parse(htmlStr);

      var thumbUrl = docHtml
          .getElementsByClassName('col-xs-4 col-image')[0]
          .getElementsByTagName('img')[0]
          .attributes['src'];

      var title = docHtml.getElementsByClassName('title-detail')[0].text;

      // var author =
      //     docHtml.getElementsByClassName('col-xs-8')[2].children[0].text;

      // var description = docHtml
      //     .getElementsByClassName('detail-content')[0]
      //     .getElementsByTagName('p')[0]
      //     .text;

      var comic = {
        'title': title,
        'thumbUrl': thumbUrl,
        'description': '',
        'author': 'author'
      };

      log(comic.toString());

      setState(() {
        _comic = comic;
      });
    }
  }

  Future<void> getAllChapter() async {
    if (link.isEmpty) return;
    var url = link;
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var htmlStr = response.body;
      var docHtml = parse(htmlStr);

      var chapContainer = docHtml
          .getElementById('nt_listchapter')
          .getElementsByTagName('ul')[0];
      var listChapHtml = chapContainer.getElementsByClassName('row') +
          docHtml.getElementsByClassName('row less');

      var listChap = [];
      listChapHtml.removeAt(0);
      listChapHtml.forEach((element) {
        try {
          var title = element
              .getElementsByClassName('col-xs-5 chapter')[0]
              .children[0]
              .text;
          var url = element
              .getElementsByClassName('col-xs-5 chapter')[0]
              .children[0]
              .attributes['href'];
          var chap = {'title': title, 'url': url};
          // log('Chap: $chap');
          listChap.add(chap);
        } catch (e) {
          log('$e');
        }
      });

      log('${listChap}');

      setState(() {
        _listChap = listChap;
      });
    }
  }
}
