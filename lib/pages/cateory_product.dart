import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qk/firebase/database.dart';
import 'package:qk/pages/product_details.dart';

class CateoryProduct extends StatefulWidget {
  final String category;
  CateoryProduct({required this.category});

  @override
  State<CateoryProduct> createState() => _CateoryProductState();
}

class _CateoryProductState extends State<CateoryProduct> {
  Stream? CategoryStream;

  getProducts() async {
    CategoryStream = await DatabaseMethods().getProducts(widget.category);
    setState(() {});
  }

  @override
  void initState() {
    getProducts();
    super.initState();
  }

  Widget allProducts() {
    return StreamBuilder(
      stream: CategoryStream,
      builder: (context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.data.docs.isEmpty) {
          return Center(child: Text("No products found!"));
        }
        return GridView.builder(
          padding: EdgeInsets.all(10),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.6,
            mainAxisSpacing: 10.0,
            crossAxisSpacing: 10.0,
          ),
          itemCount: snapshot.data.docs.length,
          itemBuilder: (context, index) {
            DocumentSnapshot ds = snapshot.data.docs[index];

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductDetailsPage(ds: ds),
                  ),
                );
              },
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 5.0,
                      spreadRadius: 2.0,
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Image.network(
                        ds["Image"],
                        height: 120,
                        width: 120,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Icon(Icons.image_not_supported, size: 120),
                      ),
                    ),
                    SizedBox(height: 10),

                    /// FIX: Handle long text properly
                    Text(
                      ds["Name"] ?? "No Name",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      maxLines: 1, // Ensure single-line text
                      overflow: TextOverflow.ellipsis, // Add "..."
                    ),

                    SizedBox(height: 5),

                    Text(
                      "Location: ${ds["Location"] ?? "Unknown"}",
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),

                    SizedBox(height: 5),

                    Text(
                      "\৳${ds["Price"] ?? "0.00"}",
                      style: TextStyle(fontSize: 16, color: Colors.green),
                    ),

                    SizedBox(height: 5),

                    Text(
                      ds["Product Details"] ?? "No details available",
                      maxLines: 2, // Limit lines to avoid overflow
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                  ],
                ),

              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xffe3e6ff), Color(0xfff1f3ff), Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: Text(
                widget.category.replaceAll('_', ' '),
                style: TextStyle(color: Colors.black),
              ),
              iconTheme: IconThemeData(color: Colors.black),
            ),
            Expanded(child: allProducts()),
          ],
        ),
      ),
    );
  }
}


// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:qk/firebase/database.dart';
//
// class CateoryProduct extends StatefulWidget {
//   final String category;
//   CateoryProduct({required this.category});
//
//   @override
//   State<CateoryProduct> createState() => _CateoryProductState();
// }
//
// class _CateoryProductState extends State<CateoryProduct> {
//   Stream? CategoryStream;
//
//   getProducts() async {
//     CategoryStream = await DatabaseMethods().getProducts(widget.category);
//     setState(() {});
//   }
//
//   @override
//   void initState() {
//     getProducts();
//     super.initState();
//   }
//
//   Widget allProducts() {
//     return StreamBuilder(
//       stream: CategoryStream,
//       builder: (context, AsyncSnapshot snapshot) {
//         if (!snapshot.hasData) {
//           return Center(child: CircularProgressIndicator());
//         }
//         if (snapshot.data.docs.isEmpty) {
//           return Center(child: Text("No products found!"));
//         }
//         return GridView.builder(
//           padding: EdgeInsets.all(10),
//           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: 2,
//             childAspectRatio: 0.6,
//             mainAxisSpacing: 10.0,
//             crossAxisSpacing: 10.0,
//           ),
//           itemCount: snapshot.data.docs.length,
//           itemBuilder: (context, index) {
//             DocumentSnapshot ds = snapshot.data.docs[index];
//             return Container(
//               padding: EdgeInsets.all(10),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(10),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.grey.withOpacity(0.2),
//                     blurRadius: 5.0,
//                     spreadRadius: 2.0,
//                   )
//                 ],
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Center(
//                     child: Image.network(
//                       ds["Image"],
//                       height: 120,
//                       width: 120,
//                       fit: BoxFit.cover,
//                       errorBuilder: (context, error, stackTrace) =>
//                           Icon(Icons.image_not_supported, size: 120),
//                     ),
//                   ),
//                   SizedBox(height: 10),
//                   Text(ds["Name"],
//                       style: TextStyle(
//                           fontSize: 18, fontWeight: FontWeight.bold)),
//                   SizedBox(height: 5),
//                   Text("Location: ${ds["Location"]}",
//                       style: TextStyle(fontSize: 14, color: Colors.grey)),
//                   SizedBox(height: 5),
//                   Text("\$${ds["Price"]}",
//                       style: TextStyle(fontSize: 16, color: Colors.green)),
//                   SizedBox(height: 5),
//                   Text(
//                     ds["Product Details"],
//                     maxLines: 2,
//                     overflow: TextOverflow.ellipsis,
//                     style: TextStyle(fontSize: 14, color: Colors.black54),
//                   ),
//                 ],
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xfff2f2f2),
//       appBar: AppBar(
//         backgroundColor: Color(0xfff2f2f2),
//         title: Text(widget.category.replaceAll('_', ' ')),
//       ),
//       body: Container(child: Column(children: [Expanded(child: allProducts())])),
//     );
//   }
// }
