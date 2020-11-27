import 'package:DocTruyenOnline/basecomicbytypescreen.dart';
import 'package:DocTruyenOnline/detailscreen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  var _listComic = [];
  var listPage = [
    BaseComicByTypeScreen(link: 'http://www.nettruyen.com/'),
    BaseComicByTypeScreen(link: 'http://www.nettruyen.com/tim-truyen/action'),
    BaseComicByTypeScreen(
        link: 'http://www.nettruyen.com/tim-truyen/truong-thanh'),
    BaseComicByTypeScreen(
        link: 'http://www.nettruyen.com/tim-truyen/adventure'),
    BaseComicByTypeScreen(link: 'http://www.nettruyen.com/tim-truyen/anime'),
    BaseComicByTypeScreen(
        link: 'http://www.nettruyen.com/tim-truyen/chuyen-sinh'),
    BaseComicByTypeScreen(link: 'http://www.nettruyen.com/tim-truyen/comedy'),
    BaseComicByTypeScreen(link: 'http://www.nettruyen.com/tim-truyen/comic'),
    BaseComicByTypeScreen(link: 'http://www.nettruyen.com/tim-truyen/cooking'),
    BaseComicByTypeScreen(link: 'http://www.nettruyen.com/tim-truyen/co-dai'),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllCommic();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: this.listPage.length,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(text: 'Hot'),
                Tab(text: 'Hành động'),
                Tab(text: 'Trưởng thành'),
                Tab(text: 'Phiêu lưu'),
                Tab(text: 'Anime'),
                Tab(text: 'Chuyển sinh'),
                Tab(text: 'Comedy'),
                Tab(text: 'Hài hước'),
                Tab(text: 'Nấu ăn'),
                Tab(text: 'Cổ đại'),
              ],
              isScrollable: true,
            ),
            title: Text('Truyện Tranh'),
            leading: IconButton(
              icon: Icon(Icons.menu),
              tooltip: 'Navigation menu',
            ),
            actions: <Widget>[
              IconButton(icon: Icon(Icons.search), onPressed: null)
            ],
          ),
          body: TabBarView(
            children: this.listPage,
          ),
        ),
      ),
    );
  }

  Future<void> getAllCommic() async {
    var url = 'http://www.nettruyen.com/';
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
