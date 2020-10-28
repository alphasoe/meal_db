import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:meal_db/meals_category.dart';

void main() {
  runApp(MyApp());
}

class Categories {
  final String strCategory;
  final String strCategoryThumb;

  Categories(this.strCategory, this.strCategoryThumb);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("Categories")),
        body: HomePage(),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<List<Categories>> getCategories() async {
    var data = await http
        .get("https://www.themealdb.com/api/json/v1/1/categories.php");

    var jsonData = json.decode(data.body);

    var categoryData = jsonData['categories'];

    List<Categories> categories = [];

    for (var data in categoryData) {
      Categories category =
          Categories(data['strCategory'], data['strCategoryThumb']);

      categories.add(category);
    }

    return categories;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
          future: getCategories(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return GridView.builder(
                  //gridView column number
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () {
                        String category = snapshot.data[index].strCategory;

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MealsCategory(category)));
                      },
                      child: Card(
                        child: Container(
                          padding: EdgeInsets.all(5),
                          margin: EdgeInsets.all(5),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Image.network(
                                  snapshot.data[index].strCategoryThumb,
                                  height: 130,
                                  width: 130,
                                  fit: BoxFit.fitWidth,
                                ),
                                Text(snapshot.data[index].strCategory)
                              ]),
                        ),
                      ),
                    );
                  });
            }
          }),
    );
  }
}
