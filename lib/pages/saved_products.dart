
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qk/pages/product_details.dart';

class SavedProducts extends StatefulWidget {
  const SavedProducts({super.key});

  @override
  State<SavedProducts> createState() => _SavedProductsState();
}

class _SavedProductsState extends State<SavedProducts> {
  final FirebaseAuth auth = FirebaseAuth.instance;

  // Get the user's saved products from Firestore
  Stream<QuerySnapshot> getSavedProducts() {
    String userId = auth.currentUser!.uid;
    return FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("Saved")
        .snapshots();
  }

  // Remove a saved product from Firestore
  void removeSavedProduct(String productId) {
    String userId = auth.currentUser!.uid;
    FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("Saved")
        .doc(productId)
        .delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(top: 60.0),
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xffe3e6ff), Color(0xfff1f3ff), Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            const Text(
              "Saved Products",
              style: TextStyle(
                color: Colors.black,
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20.0),
            Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  color: Colors.white,
                ),
                child: StreamBuilder<QuerySnapshot>(
                  stream: getSavedProducts(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(
                        child: Text(
                          "No saved products found!",
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      );
                    }

                    var savedProducts = snapshot.data!.docs;

                    return ListView.builder(
                      itemCount: savedProducts.length,
                      itemBuilder: (context, index) {
                        var product = savedProducts[index];

                        // 🔥 Use `.data()` safely with null-checking
                        var productData = product.data() as Map<String, dynamic>? ?? {};

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProductDetailsPage(ds: product),
                              ),
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.black, width: 2.0),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(Icons.location_on_outlined, color: Colors.blue),
                                        const SizedBox(width: 10.0),
                                        Text(
                                          productData["Location"] ?? "Unknown",  // ✅ Handle missing fields
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete, color: Colors.red),
                                      onPressed: () => removeSavedProduct(product.id),
                                    ),
                                  ],
                                ),
                                const Divider(),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: Image.network(
                                        productData["Image"] ?? "",  // ✅ Handle missing image
                                        height: 120,
                                        width: 120,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) =>
                                        const Icon(Icons.image_not_supported, size: 100),
                                      ),
                                    ),
                                    const SizedBox(width: 20.0),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: MediaQuery.of(context).size.width * 0.5, // Limit width
                                          child: Text(
                                            productData["Name"] ?? "Unknown Product",
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 23.0,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            overflow: TextOverflow.ellipsis, // ✅ Prevents overflow
                                            maxLines: 1, // ✅ Restricts to one line
                                          ),
                                        ),
                                        const SizedBox(height: 10.0),
                                        Text(
                                          "\৳${productData["Price"] ?? "0.00"}",
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 23.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),

                                  ],
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
            ),
          ],
        ),
      ),
    );
  }
}





// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
//
// class SavedProducts extends StatefulWidget {
//   const SavedProducts({super.key});
//
//   @override
//   State<SavedProducts> createState() => _SavedProductsState();
// }
//
// class _SavedProductsState extends State<SavedProducts> {
//   final FirebaseAuth auth = FirebaseAuth.instance;
//
//   // Get the user's saved products from Firestore
//   Stream<QuerySnapshot> getSavedProducts() {
//     String userId = auth.currentUser!.uid;
//     return FirebaseFirestore.instance
//         .collection("users")
//         .doc(userId)
//         .collection("Saved")
//         .snapshots();
//   }
//
//   // Remove a saved product from Firestore
//   void removeSavedProduct(String productId) {
//     String userId = auth.currentUser!.uid;
//     FirebaseFirestore.instance
//         .collection("users")
//         .doc(userId)
//         .collection("Saved")
//         .doc(productId)
//         .delete();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         padding: EdgeInsets.only(top: 60.0),
//         width: MediaQuery.of(context).size.width,
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: [Color(0xffe3e6ff), Color(0xfff1f3ff), Colors.white],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//         ),
//         child: Column(
//           children: [
//             Text(
//               "Saved Products",
//               style: TextStyle(
//                 color: Colors.black,
//                 fontSize: 25.0,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             SizedBox(height: 20.0),
//             Expanded(
//               child: Container(
//                 width: MediaQuery.of(context).size.width,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.only(
//                     topLeft: Radius.circular(20),
//                     topRight: Radius.circular(20),
//                   ),
//                   color: Colors.white,
//                 ),
//                 child: StreamBuilder<QuerySnapshot>(
//                   stream: getSavedProducts(),
//                   builder: (context, snapshot) {
//                     if (snapshot.connectionState == ConnectionState.waiting) {
//                       return Center(child: CircularProgressIndicator());
//                     }
//
//                     if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//                       return Center(
//                         child: Text("No saved products found!",
//                             style: TextStyle(fontSize: 18, color: Colors.grey)),
//                       );
//                     }
//
//                     var savedProducts = snapshot.data!.docs;
//
//                     return ListView.builder(
//                       itemCount: savedProducts.length,
//                       itemBuilder: (context, index) {
//                         var product = savedProducts[index];
//                         return GestureDetector(
//                           onTap: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => ProductDetailsPage(ds: product),
//                               ),
//                             );
//                           },
//                           child: Container(
//                             margin:
//                             EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
//                             padding: EdgeInsets.all(10),
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               border: Border.all(color: Colors.black, width: 2.0),
//                               borderRadius: BorderRadius.circular(20),
//                             ),
//                             child: Column(
//                               children: [
//                                 Row(
//                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Row(
//                                       children: [
//                                         Icon(Icons.location_on_outlined, color: Colors.blue),
//                                         SizedBox(width: 10.0),
//                                         Text(
//                                           product["Location"] ?? "Unknown",
//                                           style: TextStyle(
//                                             color: Colors.black,
//                                             fontSize: 18.0,
//                                             fontWeight: FontWeight.w500,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                     IconButton(
//                                       icon: Icon(Icons.delete, color: Colors.red),
//                                       onPressed: () => removeSavedProduct(product.id),
//                                     ),
//                                   ],
//                                 ),
//                                 Divider(),
//                                 Row(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     ClipRRect(
//                                       borderRadius: BorderRadius.circular(20),
//                                       child: Image.network(
//                                         product["Image"] ?? "",
//                                         height: 120,
//                                         width: 120,
//                                         fit: BoxFit.cover,
//                                         errorBuilder: (context, error, stackTrace) =>
//                                             Icon(Icons.image_not_supported, size: 100),
//                                       ),
//                                     ),
//                                     SizedBox(width: 20.0),
//                                     Column(
//                                       crossAxisAlignment: CrossAxisAlignment.start,
//                                       children: [
//                                         Text(
//                                           product["Name"] ?? "Unknown Product",
//                                           style: TextStyle(
//                                             color: Colors.black,
//                                             fontSize: 23.0,
//                                             fontWeight: FontWeight.w500,
//                                           ),
//                                         ),
//                                         SizedBox(height: 10.0),
//                                         Text(
//                                           "\$${product["Price"] ?? "0.00"}",
//                                           style: TextStyle(
//                                             color: Colors.black,
//                                             fontSize: 23.0,
//                                             fontWeight: FontWeight.bold,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                         );
//                       },
//                     );
//                   },
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// // Product details page (for navigation)
// class ProductDetailsPage extends StatelessWidget {
//   final DocumentSnapshot ds;
//
//   ProductDetailsPage({required this.ds});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text(ds["Name"] ?? "Product Details")),
//       body: Center(child: Text("Product Details Here")),
//     );
//   }
// }



//
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:qk/pages/product_details.dart';
// // Import ProductDetailsPage
//
// class SavedProducts extends StatefulWidget {
//   const SavedProducts({super.key});
//
//   @override
//   State<SavedProducts> createState() => _SavedProductsState();
// }
//
// class _SavedProductsState extends State<SavedProducts> {
//   final FirebaseAuth auth = FirebaseAuth.instance;
//
//   @override
//   Widget build(BuildContext context) {
//     String userId = auth.currentUser!.uid;
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Saved Products"),
//       ),
//       body: StreamBuilder(
//         stream: FirebaseFirestore.instance
//             .collection("users")
//             .doc(userId)
//             .collection("Saved")
//             .orderBy("Timestamp", descending: true)
//             .snapshots(),
//         builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           }
//
//           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             return Center(child: Text("No saved products"));
//           }
//
//           return ListView.builder(
//             itemCount: snapshot.data!.docs.length,
//             itemBuilder: (context, index) {
//               var product = snapshot.data!.docs[index];
//
//               return GestureDetector(
//                 onTap: () {
//                   // Navigate to ProductDetailsPage
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => ProductDetailsPage(ds: product),
//                     ),
//                   );
//                 },
//                 child: Card(
//                   margin: EdgeInsets.all(10),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(15),
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.all(10.0),
//                     child: Row(
//                       children: [
//                         ClipRRect(
//                           borderRadius: BorderRadius.circular(10),
//                           child: Image.network(
//                             product["Image"] ?? "",
//                             height: 80,
//                             width: 80,
//                             fit: BoxFit.cover,
//                             errorBuilder: (context, error, stackTrace) =>
//                                 Icon(Icons.image_not_supported, size: 80),
//                           ),
//                         ),
//                         SizedBox(width: 15),
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(product["Name"] ?? "No Name",
//                                 style: TextStyle(
//                                     fontSize: 18, fontWeight: FontWeight.bold)),
//                             SizedBox(height: 5),
//                             Text("Location: ${product["Location"] ?? "Unknown"}",
//                                 style: TextStyle(fontSize: 14, color: Colors.grey)),
//                             SizedBox(height: 5),
//                             Text("\$${product["Price"] ?? "0.00"}",
//                                 style: TextStyle(
//                                     fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green)),
//                           ],
//                         ),
//                         Spacer(),
//                         IconButton(
//                           icon: Icon(Icons.delete, color: Colors.red),
//                           onPressed: () {
//                             // Delete saved product
//                             FirebaseFirestore.instance
//                                 .collection("users")
//                                 .doc(userId)
//                                 .collection("Saved")
//                                 .doc(product.id)
//                                 .delete();
//                           },
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
