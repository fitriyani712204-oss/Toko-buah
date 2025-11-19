import 'package:flutter/material.dart';
import '../models/fruit_model.dart';

class DetailPage extends StatelessWidget {
  final FruitModel fruit;

  const DetailPage({super.key, required this.fruit});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(fruit.name),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
              child: Hero(
                tag: fruit.name,
                child: Image.asset(
                  'assets/images/${fruit.image}',
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(height: 20),

            /// Nama Buah
            Text(
              fruit.name,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            /// Harga
            Text(
              "Rp ${fruit.price}",
              style: TextStyle(
                fontSize: 22,
                color: Colors.grey.shade800,
              ),
            ),

            const SizedBox(height: 30),

            /// Tombol Beli
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Berhasil membeli ${fruit.name}!"),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "BELI SEKARANG",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
