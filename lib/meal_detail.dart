import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MealDetail extends StatefulWidget {
  final String idMeal;

  const MealDetail(this.idMeal);

  @override
  _MealDetailState createState() => _MealDetailState();
}

class Details {
  final String strMeal;
  final String strMealThumb;
  final String strCategory;
  final String strInstructions;

  Details(
      this.strMeal, this.strMealThumb, this.strCategory, this.strInstructions);
}

class _MealDetailState extends State<MealDetail> {
  Future<List<Details>> getDetails() async {
    String query = widget.idMeal;

    var data = await http
        .get("https://www.themealdb.com/api/json/v1/1/lookup.php?i=$query");

    var jsonData = json.decode(data.body);

    var detailData = jsonData['meals'];

    List<Details> detail = [];

    for (var data in detailData) {
      Details meal = Details(data['strMeal'], data['strMealThumb'],
          data['strCategory'], data['strInstructions']);

      detail.add(meal);
    }

    return detail;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Detail")),
      body: Container(
        child: FutureBuilder(
            future: getDetails(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.data == null) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        child: Container(
                          padding: EdgeInsets.only(left: 15, right: 15),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.only(top: 20),
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: Image.network(
                                        snapshot.data[index].strMealThumb,
                                        height: 300,
                                        width: 300,
                                        fit: BoxFit.fitWidth,
                                      )),
                                ),
                                SizedBox(height: 30),
                                Text(
                                  "Meal:",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  snapshot.data[index].strMeal,
                                  style: TextStyle(fontSize: 16),
                                ),
                                SizedBox(height: 20),
                                Text(
                                  "Category:",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  snapshot.data[index].strCategory,
                                  style: TextStyle(fontSize: 16),
                                ),
                                SizedBox(height: 20),
                                Text(
                                  "Instruction:",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  snapshot.data[index].strInstructions,
                                  style: TextStyle(fontSize: 16),
                                )
                              ]),
                        ),
                      );
                    });
              }
            }),
      ),
    );
  }
}
