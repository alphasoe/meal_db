import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:meal_db/meal_detail.dart';

class MealsCategory extends StatefulWidget {
  final String mealCategory;

  const MealsCategory(this.mealCategory);

  @override
  _MealsCategoryState createState() => _MealsCategoryState();
}

class Meals {
  final String strMeal;
  final String strMealThumb;
  final String idMeal;

  Meals(this.strMeal, this.strMealThumb, this.idMeal);
}

class _MealsCategoryState extends State<MealsCategory> {

  Future<List<Meals>> getMeals() async {
    String query = widget.mealCategory;

    var data = await http
        .get("https://www.themealdb.com/api/json/v1/1/filter.php?c=$query");

    var jsonData = json.decode(data.body);

    var mealData = jsonData['meals'];

    List<Meals> meals = [];

    for (var data in mealData) {
      Meals meal = Meals(data['strMeal'], data['strMealThumb'], data['idMeal']);

      meals.add(meal);
    }

    return meals;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Meals")),
      body: Container(
        child: FutureBuilder(
            future: getMeals(),
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
                          String id = snapshot.data[index].idMeal;

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MealDetail(id)));
                        },
                        child: Card(
                          child: Container(
                            padding: EdgeInsets.all(5),
                            margin: EdgeInsets.all(5),
                            child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Image.network(
                                    snapshot.data[index].strMealThumb,
                                    height: 100,
                                    width: 100,
                                    fit: BoxFit.fitWidth,
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    snapshot.data[index].strMeal,
                                    softWrap: true,
                                  )
                                ]),
                          ),
                        ),
                      );
                    });
              }
            }),
      ),
    );
  }
}
