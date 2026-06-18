import 'package:flutter/material.dart';

class SearchBarBuilder extends StatefulWidget {
  const SearchBarBuilder({super.key});

  @override
  State<SearchBarBuilder> createState() => _SearchBarBuilderState();
}

class _SearchBarBuilderState extends State<SearchBarBuilder> {
  @override
  Widget build(BuildContext context) {
    return Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            decoration: InputDecoration(
              focusColor: Colors.transparent,
              prefixIcon: const Icon(Icons.search),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(24)),
              hintText: "Search",
            ),
          ),
        );
  }
}