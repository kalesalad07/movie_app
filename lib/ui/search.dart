// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:movie_app/services/api_services.dart';
import 'package:movie_app/utils/globals.dart';
import 'package:movie_app/utils/re_use_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utils/movie_container.dart';

class Search extends ConsumerWidget {
  TextEditingController searchController = TextEditingController();

  Search({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final moviesChangeNotifier = ref.watch(moviesChangeNotifierProvider);

    return Scaffold(
        appBar: AppBar(
          title: ReuseTextBox(
              "Search", Icons.keyboard_alt_rounded, false, searchController),
          actions: [
            IconButton(
                onPressed: () async {
                  var name = searchController.text;
                  print(name);
                  moviesChangeNotifier.empty();
                  moviesChangeNotifier
                      .add(await ApiService().getIdByName(name));
                },
                icon: const Icon(Icons.search))
          ],
        ),
        body: //(moviesChangeNotifier.movies.isNotEmpty)?
            ListView.builder(
          itemBuilder: (context, index) {
            return movieItem(context, moviesChangeNotifier.movies[index]);
          },
          itemCount: moviesChangeNotifier.movies.length,
        )
        //: Text('loading'),
        );
  }
}
