import 'dart:convert';
import 'package:fitelevate/src/constants/color_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'FoodDetailPage.dart';
import '../../../utils/date_utils.dart';

class FoodSearchPage extends StatefulWidget {
  @override
  _FoodSearchPageState createState() => _FoodSearchPageState();
}

class _FoodSearchPageState extends State<FoodSearchPage> {
  List<Map<String, dynamic>> _foods = [];

  Future<void> _searchFood(String query) async {
    var headers = {
      'x-app-id': dotenv.env['NUTRITIONIX_APP_ID'] ?? '',
      'x-app-key': dotenv.env['NUTRITIONIX_APP_KEY'] ?? '',
      'x-remote-user-id': dotenv.env['NUTRITIONIX_REMOTE_USER_ID'] ?? '',
      'Content-Type': 'application/json'
    };

    var request = http.Request(
      'POST',
      Uri.parse('https://trackapi.nutritionix.com/v2/natural/nutrients'),
    );

    request.body = json.encode({
      "query": query,
      "timezone": "US/Eastern"
    });

    request.headers.addAll(headers);

    try {
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        String responseBody = await response.stream.bytesToString();
        Map<String, dynamic> jsonResponse = json.decode(responseBody);

        if (jsonResponse.containsKey("foods")) {
          List<Map<String, dynamic>> foods = List<Map<String, dynamic>>.from(jsonResponse['foods']);

          // Check for "full_nutrients" in each food item and remove it
          foods.forEach((food) {
            food.remove("full_nutrients");
          });

          setState(() {
            _foods = foods;
          });
        }
      } else {
        setState(() {
          _foods = [];
        });
      }
    } catch (e) {
      setState(() {
        _foods = [];
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Food Search'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              onChanged: (value) {
                if (value.isNotEmpty) {
                  _searchFood(value);
                } else {
                  setState(() {
                    _foods = [];
                  });
                }
              },
              decoration: InputDecoration(
                labelText: 'Search for food',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: _foods.isEmpty
                  ? Center(child: Text('No results found'))
                  : ListView.builder(
                itemCount: _foods.length,
                itemBuilder: (context, index) {
                  final food = _foods[index];
                  final foodName = food['food_name'] ?? 'Unknown';
                  return ListTile(
                    title: Text(capitalizeFirstLetter(foodName)),
                    trailing: Icon(Icons.add, color: ColorConstants.primaryColor),
                      onTap: () async {
                        final foodData = await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => FoodDetailPage(food: food)),
                        );
                        if (foodData != null) {
                          print('Food data received in FoodSearchPage: $foodData'); // Debug print statement
                          Navigator.pop(context, foodData);
                        }
                      },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
