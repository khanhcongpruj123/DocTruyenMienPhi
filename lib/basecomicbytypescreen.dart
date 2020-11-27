import 'package:DocTruyenOnline/detailscreen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;

class BaseComicByTypeScreen extends StatefulWidget {
  var link;

  BaseComicByTypeScreen({Key key, @required this.link}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _BaseComicByTypeScreenState(link: this.link);
  }
}

class _BaseComicByTypeScreenState extends State<BaseComicByTypeScreen> {
  var _listComic = [];
  var link;

  _BaseComicByTypeScreenState({@required this.link}) : super();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllCommic();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: Column(
        children: [
          Flexible(
              child: ListView.builder(
                  itemCount: _listComic.length,
                  itemBuilder: (context, index) {
                    var item = _listComic[index];
                    return Card(
                      child: InkWell(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    DetailScreen(link: item['linkDetail']))),
                        child: Container(
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: FadeInImage(
                                    placeholder:
                                        AssetImage('assets/ic_app.png'),
                                    image: NetworkImage(
                                        'https:' + item['thumbUrl']),
                                    height: 100,
                                    width: 100,
                                    fit: BoxFit.fill),
                              ),
                              Container(
                                  margin: EdgeInsets.only(left: 10),
                                  child: Row(
                                    children: [
                                      Text(
                                        item['title'],
                                        overflow: TextOverflow.ellipsis,
                                      )
                                    ],
                                  ))
                            ],
                          ),
                        ),
                      ),
                    );
                  }))
        ],
      ),
    ));
  }

  Future<void> getAllCommic() async {
    var url = this.link;
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var htmlStr = response.body;
      var docHtml = parse(htmlStr);
      var bodyHtml = docHtml.body;
      var itemsHtml = bodyHtml.getElementsByClassName("items")[0];
      var listItemHtml = itemsHtml.getElementsByClassName("item");
      var listComic = [];
      listItemHtml.forEach((element) {
        var imgTag = element.getElementsByTagName("img")[0];

        var thumbUrl = imgTag.attributes["data-original"];
        var title = element.getElementsByClassName("jtip")[0].text;

        var linkDetail =
            element.getElementsByTagName('a')[0].attributes['href'];

        var comic = {
          'title': title,
          'thumbUrl': thumbUrl,
          'linkDetail': linkDetail
        };
        listComic.add(comic);
      });
      setState(() {
        _listComic = listComic;
      });
    }
  }
}
