import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../data/datasources/lagu_remote_datasource.dart';
import '../data/models/lagu_response_model.dart';

class BeerListView extends StatefulWidget {
  const BeerListView({super.key});

  @override
  BeerListViewState createState() => BeerListViewState();
}

class BeerListViewState extends State<BeerListView> {
  final PagingController<int, Lagu> _pagingController =
      PagingController(firstPageKey: 1);

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final newItems = await LaguRemoteDatasource().getLaguDaerahPages(pageKey);
      final isLastPage = newItems.data.currentPage == newItems.data.lastPage;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems.data.data);
      } else {
        _pagingController.appendPage(newItems.data.data, ++pageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Lagu Daerah',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        elevation: 2,
        backgroundColor: Colors.blueGrey,
      ),
      body: PagedListView<int, Lagu>(
        pagingController: _pagingController,
        builderDelegate: PagedChildBuilderDelegate<Lagu>(
          itemBuilder: (context, item, index) {
            return Card(
              child: ListTile(
                title: Text(item.judul),
                subtitle: Text(item.daerah),
                leading: const CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.blueGrey,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}
