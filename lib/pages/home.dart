import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qk/pages/cateory_product.dart';
import 'package:qk/pages/product_details.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import FirebaseAuth to get current user

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String? userName; // Store the fetched username

  @override
  void initState() {
    super.initState();
    fetchUserName(); // Fetch the username when the screen loads
  }

  Future<void> fetchUserName() async {
    String? uid = FirebaseAuth.instance.currentUser?.uid; // Get current user ID

    if (uid != null) {
      DocumentSnapshot userDoc =
      await FirebaseFirestore.instance.collection("users").doc(uid).get();

      if (userDoc.exists) {
        setState(() {
          userName = userDoc["username"] ?? "User"; // Default to "User" if null
        });
      }
    }
  }

  List<String> categories = [
    "Tech_Essentials",
    "Mobile_Gadget",
    "Utility_Tools",
    "Electrical_Fixers"
  ];

  List<Map<String, String>> categoryData = [
    {"name": "Tech Essentials", "image": "images/laptop-screen.png"},
    {"name": "Mobile & Gadget", "image": "images/elec.png"},
    {"name": "Regular Utility Tools", "image": "images/plus.png"},
    {"name": "Electrical Fixers", "image": "images/device.png"}
  ];

  Future<List<DocumentSnapshot>> fetchAllProducts() async {
    List<DocumentSnapshot> allProducts = [];

    for (String category in categories) {
      QuerySnapshot snapshot =
      await FirebaseFirestore.instance.collection(category).get();
      allProducts.addAll(snapshot.docs);
    }
    return allProducts;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(top: 60.0, left: 20.0, right: 20.0),
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xffe3e6ff), Color(0xfff1f3ff), Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.location_on_outlined),
                Text("Sylhet",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20.0,
                        fontWeight: FontWeight.w500)),
              ],
            ),
            const SizedBox(height: 20.0),

            /// **Display Username Here**
            Text(
              "Hello, ${userName ?? "Loading..."}", // Show username or loading
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20.0),
            Container(
              margin: const EdgeInsets.only(right: 20.0),
              padding: const EdgeInsets.only(left: 20.0),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(10)),
              child: const TextField(
                decoration: InputDecoration(
                    suffixIcon: Icon(Icons.search),
                    border: InputBorder.none,
                    hintText: "Search a Product"),
              ),
            ),
            const SizedBox(height: 30.0),

            /// **Category ListView**
            SizedBox(
              height: 180,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categoryData.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              CateoryProduct(category: categories[index]),
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 20.0),
                      child: Material(
                        elevation: 3.0,
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          width: 190,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(categoryData[index]["image"]!,
                                  height: 50, width: 50, fit: BoxFit.cover),
                              const SizedBox(height: 10),
                              Text(
                                categoryData[index]["name"]!,
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 18.0),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20.0),
            const Text("All Products",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 10.0),

            /// **Product List**
            Expanded(
              child: FutureBuilder<List<DocumentSnapshot>>(
                future: fetchAllProducts(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text("No products available"));
                  }

                  var products = snapshot.data!;

                  return ListView.builder(
                    padding: const EdgeInsets.all(10),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      var product = products[index];
                      var data = product.data() as Map<String, dynamic>?;
                      if (data == null) return const SizedBox.shrink();

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ProductDetailsPage(ds: product),
                            ),
                          );
                        },
                        child: Card(
                          margin: const EdgeInsets.only(bottom: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.horizontal(
                                    left: Radius.circular(15)),
                                child: Image.network(
                                  data["Image"] ?? "",
                                  height: 100,
                                  width: 100,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.image_not_supported,
                                      size: 100, color: Colors.grey),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(data["Name"] ?? "No Name",
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis),
                                      const SizedBox(height: 5),
                                      Text("৳${data["Price"] ?? "0.00"}",
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.green)),
                                      const SizedBox(height: 5),
                                      Text(data["Location"] ?? "No Location",
                                          style:
                                          const TextStyle(fontSize: 14)),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
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





// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:qk/pages/cateory_product.dart';
// import 'package:qk/pages/product_details.dart'; // Ensure this import is correct
//
// class Home extends StatefulWidget {
//   const Home({super.key});
//
//   @override
//   State<Home> createState() => _HomeState();
// }
//
// class _HomeState extends State<Home> {
//   List<String> categories = [
//     "Tech_Essentials",
//     "Mobile_Gadget",
//     "Utility_Tools",
//     "Electrical_Fixers"
//   ];
//
//   List<Map<String, String>> categoryData = [
//     {"name": "Tech Essentials", "image": "images/laptop-screen.png"},
//     {"name": "Mobile & Gadget", "image": "images/elec.png"},
//     {"name": "Regular Utility Tools", "image": "images/plus.png"},
//     {"name": "Electrical Fixers", "image": "images/device.png"}
//   ];
//
//   Future<List<DocumentSnapshot>> fetchAllProducts() async {
//     List<DocumentSnapshot> allProducts = [];
//
//     for (String category in categories) {
//       QuerySnapshot snapshot =
//       await FirebaseFirestore.instance.collection(category).get();
//       allProducts.addAll(snapshot.docs);
//     }
//     return allProducts;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         padding: const EdgeInsets.only(top: 60.0, left: 20.0, right: 20.0),
//         width: MediaQuery.of(context).size.width,
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             colors: [Color(0xffe3e6ff), Color(0xfff1f3ff), Colors.white],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Row(
//               children: [
//                 Icon(Icons.location_on_outlined),
//                 Text("Sylhet",
//                     style: TextStyle(
//                         color: Colors.black,
//                         fontSize: 20.0,
//                         fontWeight: FontWeight.w500)),
//               ],
//             ),
//             const SizedBox(height: 20.0),
//             const Text("Hello, XYZ",
//                 style: TextStyle(
//                     color: Colors.black,
//                     fontSize: 25.0,
//                     fontWeight: FontWeight.bold)),
//             const SizedBox(height: 20.0),
//             Container(
//               margin: const EdgeInsets.only(right: 20.0),
//               padding: const EdgeInsets.only(left: 20.0),
//               width: MediaQuery.of(context).size.width,
//               decoration: BoxDecoration(
//                   color: Colors.white, borderRadius: BorderRadius.circular(10)),
//               child: const TextField(
//                 decoration: InputDecoration(
//                     suffixIcon: Icon(Icons.search),
//                     border: InputBorder.none,
//                     hintText: "Search a Product"),
//               ),
//             ),
//             const SizedBox(height: 30.0),
//
//             // Category ListView
//             SizedBox(
//               height: 180,
//               child: ListView.builder(
//                 scrollDirection: Axis.horizontal,
//                 itemCount: categoryData.length,
//                 itemBuilder: (context, index) {
//                   return GestureDetector(
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) =>
//                               CateoryProduct(category: categories[index]),
//                         ),
//                       );
//                     },
//                     child: Container(
//                       margin: const EdgeInsets.only(right: 20.0),
//                       child: Material(
//                         elevation: 3.0,
//                         borderRadius: BorderRadius.circular(10),
//                         child: Container(
//                           width: 190,
//                           padding: const EdgeInsets.all(10),
//                           decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.circular(10)),
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Image.asset(categoryData[index]["image"]!,
//                                   height: 50, width: 50, fit: BoxFit.cover),
//                               const SizedBox(height: 10),
//                               Text(
//                                 categoryData[index]["name"]!,
//                                 style: const TextStyle(
//                                     color: Colors.black, fontSize: 18.0),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//             const SizedBox(height: 20.0),
//             const Text("All Products",
//                 style: TextStyle(
//                     color: Colors.black,
//                     fontSize: 20.0,
//                     fontWeight: FontWeight.bold)),
//             const SizedBox(height: 10.0),
//
//             // Product List
//             Expanded(
//               child: FutureBuilder<List<DocumentSnapshot>>(
//                 future: fetchAllProducts(),
//                 builder: (context, snapshot) {
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return const Center(child: CircularProgressIndicator());
//                   }
//                   if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                     return const Center(child: Text("No products available"));
//                   }
//
//                   var products = snapshot.data!;
//
//                   return ListView.builder(
//                     padding: const EdgeInsets.all(10),
//                     itemCount: products.length,
//                     itemBuilder: (context, index) {
//                       var product = products[index];
//                       var data = product.data() as Map<String, dynamic>?;
//                       if (data == null) return const SizedBox.shrink();
//
//                       return GestureDetector(
//                         onTap: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => ProductDetailsPage(ds: product),
//                             ),
//                           );
//                         },
//                         child: Card(
//                           margin: const EdgeInsets.only(bottom: 15),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(15),
//                           ),
//                           child: Row(
//                             children: [
//                               ClipRRect(
//                                 borderRadius:
//                                 const BorderRadius.horizontal(left: Radius.circular(15)),
//                                 child: Image.network(
//                                   data["Image"] ?? "",
//                                   height: 100,
//                                   width: 100,
//                                   fit: BoxFit.cover,
//                                   errorBuilder: (context, error, stackTrace) =>
//                                   const Icon(Icons.image_not_supported,
//                                       size: 100, color: Colors.grey),
//                                 ),
//                               ),
//                               Expanded(
//                                 child: Padding(
//                                   padding: const EdgeInsets.all(10.0),
//                                   child: Column(
//                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                     children: [
//                                       Text(data["Name"] ?? "No Name",
//                                           style: const TextStyle(
//                                               fontSize: 16,
//                                               fontWeight: FontWeight.bold),
//                                           maxLines: 1,
//                                           overflow: TextOverflow.ellipsis),
//                                       const SizedBox(height: 5),
//                                       Text("\৳${data["Price"] ?? "0.00"}",
//                                           style: const TextStyle(
//                                               fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green)),
//                                       const SizedBox(height: 5),
//                                       Text(data["Location"] ?? "No Location",
//                                           style: const TextStyle(fontSize: 14)),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       );
//                     },
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//


// import 'package:flutter/material.dart';
// import 'package:qk/pages/cateory_product.dart';
//
// class Home extends StatefulWidget {
//   const Home({super.key});
//
//   @override
//   State<Home> createState() => _HomeState();
// }
//
// class _HomeState extends State<Home> {
//   List category = [
//     "Tech_Essentials",
//     "Mobile_Gadget",
//     "Utility_Tools",
//     "Electrical_Fixers"
//   ];
//
//   List<Map<String, String>> categoryData = [
//     {"name": "Tech Essentials", "image": "images/laptop-screen.png"},
//     {"name": "Mobile & Gadget", "image": "images/elec.png"},
//     {"name": "Regular Utility Tools", "image": "images/plus.png"},
//     {"name": "Electrical Fixers", "image": "images/device.png"}
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         padding: EdgeInsets.only(top: 60.0, left: 20.0),
//         width: MediaQuery.of(context).size.width,
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: [Color(0xffe3e6ff), Color(0xfff1f3ff), Colors.white],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Icon(Icons.location_on_outlined),
//                 Text(
//                   "Sylhet",
//                   style: TextStyle(
//                       color: Colors.black,
//                       fontSize: 20.0,
//                       fontWeight: FontWeight.w500),
//                 ),
//               ],
//             ),
//             SizedBox(height: 20.0),
//             Text(
//               "Hello, XYZ",
//               style: TextStyle(
//                   color: Colors.black,
//                   fontSize: 25.0,
//                   fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 20.0),
//             Container(
//               margin: EdgeInsets.only(right: 20.0),
//               padding: EdgeInsets.only(left: 20.0),
//               width: MediaQuery.of(context).size.width,
//               decoration: BoxDecoration(
//                   color: Colors.white, borderRadius: BorderRadius.circular(10)),
//               child: TextField(
//                 decoration: InputDecoration(
//                     suffixIcon: Icon(Icons.search_off_outlined),
//                     border: InputBorder.none,
//                     hintText: "Search a Product"),
//               ),
//             ),
//             SizedBox(height: 30.0),
//             Container(
//               height: 180,
//               child: ListView.builder(
//                 scrollDirection: Axis.horizontal,
//                 itemCount: categoryData.length,
//                 itemBuilder: (context, index) {
//                   return GestureDetector(
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) =>
//                               CateoryProduct(category: category[index]),
//                         ),
//                       );
//                     },
//                     child: Container(
//                       margin: EdgeInsets.only(right: 20.0),
//                       child: Material(
//                         elevation: 3.0,
//                         borderRadius: BorderRadius.circular(10),
//                         child: Container(
//                           width: 190,
//                           padding: EdgeInsets.all(10),
//                           decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.circular(10)),
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Image.asset(categoryData[index]["image"]!,
//                                   height: 50, width: 50, fit: BoxFit.cover),
//                               SizedBox(height: 10),
//                               Text(
//                                 categoryData[index]["name"]!,
//                                 style: TextStyle(
//                                     color: Colors.black, fontSize: 18.0),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//             SizedBox(height: 20.0),
//             Text("All Products",
//                 style: TextStyle(
//                     color: Colors.black,
//                     fontSize: 20.0,
//                     fontWeight: FontWeight.bold)),
//           ],
//         ),
//       ),
//     );
//   }
// }
