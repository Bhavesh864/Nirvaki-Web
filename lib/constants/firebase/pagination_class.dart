import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PaginationStreamBuilder extends StatefulWidget {
  final Query query;

  const PaginationStreamBuilder({Key? key, required this.query}) : super(key: key);

  @override
  _PaginationStreamBuilderState createState() => _PaginationStreamBuilderState();
}

class _PaginationStreamBuilderState extends State<PaginationStreamBuilder> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: widget.query.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        final documents = snapshot.data!.docs;

        return ListView.builder(
          controller: _scrollController,
          itemCount: documents.length,
          itemBuilder: (context, index) {
            // Build your list item UI here
            return ListTile(
              title: Text(documents[index]['title']),
            );
          },
        );
      },
    );
  }

  void _onScroll() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      // Fetch more data when reaching the end of the list
      // You can implement your pagination logic here
      // For example, update the query to load the next set of documents
      // and append them to the existing list.
    }
  }
}
