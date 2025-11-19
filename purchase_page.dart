import 'package:flutter/material.dart';
import '../models/fruit_model.dart';

class PurchasePage extends StatelessWidget {
  final List<FruitModel> items;
  const PurchasePage({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    double total = items.fold(0, (sum, item) => sum + (item.price * item.qty));

    return Scaffold(
      appBar: AppBar(
        title: const Text("Purchase Details"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Customer Name"),
            TextField(decoration: const InputDecoration(border: OutlineInputBorder())),
            const SizedBox(height: 10),
            const Text("Address"),
            TextField(maxLines: 2, decoration: const InputDecoration(border: OutlineInputBorder())),
            const SizedBox(height: 10),
            const Text("Payment Method"),
            DropdownButtonFormField(
              items: const [
                DropdownMenuItem(value: "Cash", child: Text("Cash")),
                DropdownMenuItem(value: "Transfer", child: Text("Transfer Bank")),
                DropdownMenuItem(value: "QRIS", child: Text("QRIS")),
              ],
              onChanged: (v) {},
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),
            const SizedBox(height: 10),
            const Text("Items Summary"),
            Expanded(
              child: ListView(
                children: items.map((e) {
                  return ListTile(
                    title: Text("${e.name} x${e.qty}"),
                    trailing: Text("Rp ${(e.qty * e.price).toInt()}"),
                  );
                }).toList(),
              ),
            ),
            Text("Total: Rp ${total.toInt()}",
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: const Size(double.infinity, 45),
              ),
              child: const Text("Confirm Purchase"),
            )
          ],
        ),
      ),
    );
  }
}
