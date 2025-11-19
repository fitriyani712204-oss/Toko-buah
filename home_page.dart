import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/fruit_model.dart';
import 'purchase_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<FruitModel> allFruits = [];
  String selectedCategory = "All";
  String searchQuery = "";

  List<String> categories = ["All"];

  @override
  void initState() {
    super.initState();
    loadJsonData();
  }

  Future<void> loadJsonData() async {
    try {
      final data = await rootBundle.loadString("assets/data/fruits.json");
      final List result = json.decode(data);

      setState(() {
        allFruits = result.map((e) => FruitModel.fromJson(e)).toList();
        categories = ["All", ...{...allFruits.map((e) => e.category)}];
      });
    } catch (e) {
      debugPrint("JSON Error: $e");
    }
  }

  // FILTER
  List<FruitModel> get filteredFruits {
    return allFruits.where((fruit) {
      final matchCategory =
          selectedCategory == "All" || fruit.category == selectedCategory;
      final matchSearch =
          fruit.name.toLowerCase().contains(searchQuery.toLowerCase());
      return matchCategory && matchSearch;
    }).toList();
  }

  // CART BOTTOM SHEET
  void showCartBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      builder: (_) {
        return StatefulBuilder(builder: (context, setter) {
          List<FruitModel> cartItems =
              allFruits.where((item) => item.qty > 0).toList();

          double total =
              cartItems.fold(0, (sum, item) => sum + (item.qty * item.price));

          return Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Your Cart",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                const SizedBox(height: 10),

                ...cartItems.map((item) => ListTile(
                      title: Text("${item.name} x${item.qty}"),
                      subtitle:
                          Text("Rp ${(item.qty * item.price).toInt()}"),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                              icon: const Icon(Icons.remove_circle_outline),
                              onPressed: () {
                                if (item.qty > 0) {
                                  setState(() => item.qty--);
                                  setter(() {});
                                }
                              }),
                          IconButton(
                              icon: const Icon(Icons.add_circle_outline),
                              onPressed: () {
                                setState(() => item.qty++);
                                setter(() {});
                              }),
                        ],
                      ),
                    )),

                const Divider(),
                Text("Total: Rp ${total.toInt()}",
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),

                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // close modal
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => PurchasePage(items: cartItems)));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    minimumSize: const Size(double.infinity, 45),
                  ),
                  child: const Text("Checkout"),
                ),
                const SizedBox(height: 10),
              ],
            ),
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
  title: const Text("OMAH BUAH"),
  backgroundColor: const Color.fromARGB(255, 4, 111, 199), // disamakan
  actions: [
    IconButton(
      icon: const Icon(Icons.shopping_cart),
      onPressed: showCartBottomSheet,
    )
  ],
),


      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            // 🔎 SEARCH
            TextField(
              decoration: const InputDecoration(
                hintText: "Search fruits...",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12))),
              ),
              onChanged: (value) => setState(() => searchQuery = value),
            ),
            const SizedBox(height: 10),

            // 🔘 CATEGORY FILTER
            SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (_, index) {
                  String cat = categories[index];
                  return Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: ChoiceChip(
                      label: Text(cat),
                      selected: selectedCategory == cat,
                      onSelected: (_) =>
                          setState(() => selectedCategory = cat),
                      selectedColor: Colors.green,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),

            // 🛒 GRID LIST
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.only(top: 5),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.78,
                ),
                itemCount: filteredFruits.length,
                itemBuilder: (_, index) {
                  final fruit = filteredFruits[index];
                  return Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.green.shade50,
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          child: fruit.image.isNotEmpty
                              ? Image.asset(
                                  fruit.image,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) =>
                                      const Icon(Icons.image_not_supported,
                                          size: 50),
                                )
                              : const Icon(Icons.image_not_supported, size: 50),
                        ),
                        Text(fruit.name,
                            style: const TextStyle(fontWeight: FontWeight.bold)),
                        Text("Rp ${fruit.price.toInt()}"),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: () {
                                if (fruit.qty > 0) {
                                  setState(() => fruit.qty--);
                                }
                              },
                            ),
                            Text("${fruit.qty}"),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () {
                                bool firstAdd = fruit.qty == 0;
                                setState(() => fruit.qty++);
                                if (firstAdd) showCartBottomSheet();
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
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
