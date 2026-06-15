import 'package:flutter/material.dart';

class Usersearch extends SearchDelegate {
  
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = ''; // সার্চ বক্স ক্লিয়ার করবে
          },
          icon: const Icon(Icons.clear))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, null); // সার্চ থেকে বের হয়ে যাবে
        },
        icon: const Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    // 🛠️ 'throw UnimplementedError();' কেটে এই রিটার্নটি দিন:
    return Center(
      child: Text(
        "Search Result for: $query",
        style: const TextStyle(fontSize: 20, color: Colors.black),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // 🛠️ 'throw UnimplementedError();' কেটে এই রিটার্নটি দিন:
    return const Center(
      child: Text(
        "Search users by name...",
        style: TextStyle(color: Colors.grey),
      ),
    );
  }
}