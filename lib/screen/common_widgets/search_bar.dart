import 'package:flutter/material.dart';
import 'package:flutter_hotelapp/common/styles/styles.dart';

class SearchBar extends SearchDelegate {
  List<String> searchResult = [];

  @override
  List<Widget> buildActions(BuildContext context) {
    return [IconButton(icon: Icon(Icons.clear), onPressed: () => query = "")];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow, // animate back icon effect
          progress: transitionAnimation,
        ),
        onPressed: () {
          // close context when clicked
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    // clear the old search list
    searchResult.clear();
    // find the elements that starts with the same query letters
    // allNames is a list that contains all your data (you can replace it here by an http request or a query from database)
    searchResult =
        searchList.where((input) => input.startsWith(query)).toList();

    // view a list view with the search result
    return Container(
      padding: EdgeInsets.all(kDefaultPadding),
      child: ListView(
          padding: EdgeInsets.only(top: 8, bottom: 8),
          scrollDirection: Axis.vertical,
          children: List.generate(searchResult.length, (index) {
            var item = searchResult[index];
            return Card(
              color: Colors.white,
              child: Container(
                padding: EdgeInsets.all(16),
                child: Text(item),
              ),
            );
          })),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // This method is called everytime the search term changes.
    // If you want to add search suggestions as the user enters their search term, this is the place to do that.
    final suggestionList = query.isEmpty
        ? recentSuggest
        : searchList.where((input) => input.startsWith(query)).toList();

    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) => ListTile(
        onTap: () {
          if (query.isEmpty) {
            query = recentSuggest[index];
          }
        },
        leading: Icon(query.isEmpty ? Icons.history : Icons.search),
        title: RichText(
            text: TextSpan(
                // 獲取輸入的字符，設置其顏色並加粗
                text: suggestionList[index].substring(0, query.length),
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                children: [
              TextSpan(
                //获取剩下的字符串，并让它变成灰色
                text: suggestionList[index].substring(query.length),
                style: TextStyle(color: Colors.grey),
              )
            ])),
      ),
    );
  }
}

// demo data
const searchList = [
  "Hong Kong Orchid Tree",
  "Fountain Tree",
  "Kassod tree",
  "Campanula grandiflora"
];

const recentSuggest = ["Hong Kong Orchid Tree", "Fountain Tree"];
