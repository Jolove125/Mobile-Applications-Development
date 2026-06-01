// Latasha Glover
// lzg0069@auburn.edu
// COMP 6790: Mobile Applications Development
// Assignment 2: UI Fundamentals
// Pizza Ordering App

import 'dart:async';  // time synchronize
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class Pizza {
  String name;
  double price;
  String imagePath;
  int quantity;
  bool extraCheese;
  double size;

  Pizza({
    required this.name,
    required this.price,
    required this.imagePath,
    this.quantity = 0,
    this.extraCheese = false,
    this.size = 10,
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //debugShowCheckedModeBanner: false,
      title: 'Midnight Slice',
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.indigo),
      ),
      home: const SplashPage(),
    );
  }
}

// Splash Screen
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const MyHomePage(title: "Midnight Slice"),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    body: Stack(
      children: [
        SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Image.asset(
            "assets/images/background_splash1.png",
            fit: BoxFit.cover,
          ),
        ),

        // Dark overlay
        Container(
          color: Colors.black.withValues(alpha: 0.4),
        ),

        // Center content
        Center(
          child: Column(
            mainAxisAlignment: .center,
            children: [
              Image.asset(
                "assets/images/MidnightSlicet_logo2.png",
                height: 250,
                width: 250,
              ),

              const SizedBox(height: 40),

              const CircularProgressIndicator(),

              const SizedBox(height: 40),

              const Text(
                "Loading Menu...",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
    List<Pizza> pizzas = [
    Pizza(
      name: "Cheese Pizza", 
      price: 10.99,
      imagePath: "assets/images/cheese_pizza.png",
      ),
    Pizza(
      name: "Veggie Pizza", 
      price: 13.99,
      imagePath: "assets/images/veggie_pizza.png",
      ),
    Pizza(
      name: "Pepperoni Pizza", 
      price: 12.99,
      imagePath: "assets/images/pepperoni_pizza.png",
      ),
    Pizza(
      name: "Supreme Pizza", 
      price: 17.99,
      imagePath: "assets/images/supreme_pizza.png",
      ),    
    Pizza(
      name: "BBQ Chicken Pizza", 
      price: 14.99,
      imagePath: "assets/images/bbq_pizza.png",
      ),
    Pizza(
      name: "\"All the Meats\" Pizza", 
      price: 15.99,
      imagePath: "assets/images/meat_pizza.png"),
  ];

  //Tip Logic
  bool addTip = false;
  int selectedTip = 10;
  List<int> tipOptions = [10, 15, 20, 25, 30];

  // Size and cost logic
  double sizeCost(double size) {
    if (size == 10) return 0;
    if (size == 12) return 2;
    return 4;
  }

  String sizeLabel(double size) {
    if (size == 10) return "Small (10\")";
    if (size == 12) return "Medium (12\")";
    return "Large (14\")";
  }

  // Total Calculations
  double subtotal() {
    double total = 0;

    for (var p in pizzas) {
      double item = p.price;

      if (p.extraCheese) item += 1.0;
      item += sizeCost(p.size);

      total += item * p.quantity;
    }

    return total;
  }

  double tipAmount() {
    if (!addTip) return 0;
    return subtotal() * selectedTip / 100;
  }

  double finalTotal() {
    return subtotal() + tipAmount();
  }

  // Order Reset

  void resetOrder() {
    setState(() {
      for (var p in pizzas) {
        p.quantity = 0;
        p.extraCheese = false;
        p.size = 10;
      }
      addTip = false;
      selectedTip = 10;
    });
  }

  // Order Confirmation
  void confirmOrder() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Order Confirmed"),
          content: Text(
            "Subtotal: \$${subtotal().toStringAsFixed(2)}\n"
            "Tip: \$${tipAmount().toStringAsFixed(2)}\n\n"
            "Total: \$${finalTotal().toStringAsFixed(2)}",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            )
          ],
        );
      },
    );
  }

  // Pizza Card
  Widget pizzaCard(Pizza p) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            ListTile(
              leading: Image.asset(
                p.imagePath,
                width: 50,
                height: 50,
                ),
              title: Text(
                p.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                  color: Color(0xFF0A2342),
                ),
                ),
              subtitle: Text(
                "\$${p.price.toStringAsFixed(2)}",
                style: const TextStyle(
                  color: Colors.indigoAccent,
                  fontWeight: FontWeight.w600,
                ),
                ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        if (p.quantity > 0) p.quantity--;
                      });
                    },
                    icon: const Icon(Icons.remove),
                  ),
                  Text(
                    "${p.quantity}",
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                    ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        p.quantity++;
                      });
                    },
                    icon: const Icon(Icons.add),
                  ),
                ],
              ),
            ),

            SwitchListTile(
              title: const Text("Extra Cheese (+\$1.00)"),
              value: p.extraCheese,
              onChanged: (val) {
                setState(() {
                  p.extraCheese = val;
                });
              },
            ),

            // This is the new UI Element used.
            // The Slider widget is used to select pizza size (Small, Medium, or Large).
            Slider(
              value: p.size,
              min: 10,
              max: 14,
              divisions: 2,
              label: sizeLabel(p.size),
              onChanged: (val) {
                setState(() {
                  p.size = val;
                });
              },
            ),

            Text(
              "Size: ${sizeLabel(p.size)}  (+\$${sizeCost(p.size).toStringAsFixed(2)})",
            ),
          ],
        ),
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        backgroundColor: const Color(0xFF0A2342),
        title: Row(
          children: [
            Image.asset(
              "assets/images/MidnightSlice_logo1.png",
              height: 95,
              ),
              const SizedBox(width: 10),
              const Text(
                "Checkout",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  ),
                  ),
                  ],
                  ),
                  ),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [

          Image.asset(
            "assets/images/hero_2.png",
            height: 280,
            width: double.infinity,
            fit: BoxFit.cover,
          ),

          const SizedBox(height: 15),

          const Text(
            "Pizza Menu",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 28, 
              fontWeight: FontWeight.bold,
              color: Color(0xFFFFA63D),
              ),            
          ),

          const SizedBox(height: 10),

          ...pizzas.map(pizzaCard),

          // Tip Section
          Card(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  SwitchListTile(
                    title: const Text("Add Tip?"),
                    value: addTip,
                    onChanged: (val) {
                      setState(() {
                        addTip = val;
                      });
                    },
                  ),

                  if (addTip)
                    Wrap(
                      spacing: 8,
                      children: tipOptions.map((tip) {
                        return ChoiceChip(
                          label: Text("$tip%"),
                          selected: selectedTip == tip,
                          onSelected: (val) {
                            setState(() {
                              selectedTip = tip;
                            });
                          },
                        );
                      }).toList(),
                    ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 10),

          // Total Section
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                "Total: \$${finalTotal().toStringAsFixed(2)}",
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0A2342),
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),

          ElevatedButton(
            onPressed: resetOrder,
            child: const Text("Reset Order"),
          ),

          const SizedBox(height: 10),

          ElevatedButton(
            onPressed: finalTotal() > 0 ? confirmOrder : null,
            child: const Text("Confirm Order"),
          ),
        ],
      ),
    );
  }
}