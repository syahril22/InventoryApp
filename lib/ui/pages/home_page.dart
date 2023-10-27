import 'package:flutter/material.dart';
import 'package:inventory_app/helper/shared_pref.dart';
import 'package:inventory_app/provider/item_provider.dart';
import 'package:inventory_app/ui/pages/form_page.dart';
import 'package:inventory_app/ui/pages/login_page.dart';
import 'package:inventory_app/ui/pages/search_page.dart';
import 'package:inventory_app/ui/widgets/grid_item_widgets.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  static const routeName = '/homepage';

  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final itemProvider = Provider.of<ItemProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Inventory App"),
        actions: [
          IconButton(
              onPressed: () {
                final route =
                    MaterialPageRoute(builder: (context) => SearchPage());
                Navigator.push(context, route);
              },
              icon: Icon(Icons.search)),
          IconButton(
              onPressed: () async {
                final sharedPref = SharedPref();
                await sharedPref.remove('login');
                Navigator.pushReplacementNamed(context, LoginPage.routeName);
              },
              icon: Icon(Icons.logout))
        ],
      ),
      body: Center(
        child: itemProvider.isFetching
            ? const CircularProgressIndicator()
            : GridView.builder(
                itemCount: itemProvider.listBarang.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemBuilder: (context, index) {
                  final barang = itemProvider.listBarang[index];
                  return GestureDetector(
                      onTap: () {
                        final route = MaterialPageRoute(
                            builder: (context) => FormPage(
                                  itemBarang: barang,
                                ));
                        Navigator.push(context, route);
                      },
                      child: GridItemWidgets(barang: barang));
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final route = MaterialPageRoute(builder: (context) => FormPage());
          Navigator.push(context, route);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
