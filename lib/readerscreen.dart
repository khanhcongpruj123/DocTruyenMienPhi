import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;

class ReaderScreen extends StatefulWidget {
  final String link;

  ReaderScreen({Key key, @required this.link}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ReaderScreenState(link: link);
  }
}

class _ReaderScreenState extends State<ReaderScreen> {
  var _chapTitle = '';
  var _listUrlPage = [];
  final String link;

  _ReaderScreenState({@required this.link}) : super();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPageChap();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          tooltip: 'Go back',
          onPressed: () => {Navigator.pop(context)},
        ),
        title: Text('${_chapTitle}'),
      ),
      body: Container(
        child: Column(
          children: [
            Flexible(
              child: ListView.builder(
                  itemCount: _listUrlPage.length,
                  itemBuilder: (context, index) {
                      var url = _listUrlPage[index];
                       var urlValid = validUrl(url);
                      var header = {
                        'Referer': 'http://www.nettruyen.com/',
                      };
                      var image = NetworkImage(urlValid, headers: header);
                      return FadeInImage(placeholder: AssetImage('assets/ic_app.png'), image: image);
                  }),
            )
          ],
        ),
      ),
    );
  }

  String validUrl(String url) {
    var isValid = url.contains('https://') || url.contains('http://');
    if (isValid)
      return url;
    else {
      var cat = url.replaceFirst(new RegExp('//'), '');
      return 'http://${cat}';
    }
  }

  Future<void> getPageChap() async {
    if (link.isEmpty) return;
    var url = link;
  var response = await http.get(url);
    if (response.statusCode == 200) {
      var htmlStr = response.body;
      var docHtml = parse(htmlStr);

      var listPageHtml = docHtml.getElementsByClassName('page-chapter');
      var listUrl = [];
      listPageHtml.forEach((element) {
        var url = element.children[0].attributes['data-original'];
        listUrl.add(url);
      });
      setState(() {
        _listUrlPage = listUrl;
      });
    }
  }
}
