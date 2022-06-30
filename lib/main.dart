import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:greggs_prject/models/shopping_item.dart';
import 'package:greggs_prject/providers/global_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => GlobalProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Gregg's task",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<ShoppingItem> _shoppingItem;

  Future<ShoppingItem> fetchItems() async {
    try {
      String data = await DefaultAssetBundle.of(context).loadString("assets/data.json");
      final jsonResult = jsonDecode(data);
      return ShoppingItem.fromJson(jsonResult);
    } catch (e) {
      throw Exception("Failed to load data");
    }
  }

  @override
  void initState() {
    _shoppingItem = fetchItems();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            //push screen
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CartScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Center(
          child: FutureBuilder(
            future: _shoppingItem,
            builder: (BuildContext context, AsyncSnapshot<ShoppingItem> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return const Text('No connection');
                case ConnectionState.waiting:
                  return const CircularProgressIndicator();
                default:
                  if (snapshot.hasError) {
                    return Text('Error:- ${snapshot.error}');
                  } else {
                    ShoppingItem? item = snapshot.data!;
                    return ListView(
                      children: <Widget>[
                        Image.network(item.imageUri),
                        ElevatedButton(
                          onPressed: () => Provider.of<GlobalProvider>(context, listen: false).addToCart(item),
                          child: const Text('Add to cart'),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          item.articleName,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
                        ),
                        const SizedBox(height: 16),
                        Text('Eat Out Price: ${item.eatOutPrice}'),
                        Text('Eat In Price: ${item.eatInPrice}'),
                        Text('Day Parts: ${item.dayParts}'),
                        Text('Internal Description: ${item.internalDescription}'),
                        Text('Customer Description: ${item.customerDescription}'),
                      ],
                    );
                  }
              }
            },
          ),
        ),
      ),
    );
  }
}

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late double _cartTotal;

  @override
  void initState() {
    if (Provider.of<GlobalProvider>(context, listen: false).cartItems.isNotEmpty) {
      _cartTotal = Provider.of<GlobalProvider>(context, listen: false).cartItems[0].eatInPrice *
          Provider.of<GlobalProvider>(context, listen: false).cartItems.length.toDouble();
    } else {
      _cartTotal = 0.0;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Provider.of<GlobalProvider>(context, listen: false).cartItems.isEmpty
            ? const Text('Cart is empty')
            : Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        'ITEM',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'QUANTITY',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'PRICE',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Provider.of<GlobalProvider>(context, listen: false).cartItems.isEmpty
                      ? const Text('Cart is empty')
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Sausage roll',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            Text(Provider.of<GlobalProvider>(context, listen: false).cartItems[0].eatInPrice.toString()),
                            Text(Provider.of<GlobalProvider>(context, listen: false).cartItems.length.toString()),
                          ],
                        ),
                  const SizedBox(height: 40),
                  if (Provider.of<GlobalProvider>(context, listen: false).cartItems.isNotEmpty)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'TOTAL',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        Text(_cartTotal.toStringAsFixed(2)),
                      ],
                    ),
                ],
              ),
      ),
    );
  }
}
