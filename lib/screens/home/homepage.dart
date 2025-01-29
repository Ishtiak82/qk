import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:qk/screens/home/post.dart';
import 'package:qk/utils/utiils.dart';

import '../auth/login_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final auth = FirebaseAuth.instance;
  final ref = FirebaseDatabase.instance.ref('Products');
  final searchFilter = TextEditingController();
  final editController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Homepage Realtime'),
        actions: [
          IconButton(
            onPressed: () {
              auth.signOut().then((value) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              }).onError((error, stackTrace) {
                Utils().toastMessage(error.toString());
              });
            },
            icon: const Icon(Icons.logout),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: TextFormField(
              controller: searchFilter,
              decoration: const InputDecoration(
                hintText: 'Search',
                border: OutlineInputBorder(),
              ),
              onChanged: (String value) {
                setState(() {});
              },
            ),
          ),
          Expanded(
            child: FirebaseAnimatedList(
              query: ref, // Querying 'Products' table
              itemBuilder: (context, snapshot, animation, index) {
                final title = snapshot.child('title').value?.toString();
                final String id = snapshot.child('id').value?.toString() ?? '';

                if (searchFilter.text.isEmpty) {
                  return ListTile(
                    title: Text(
                      title ?? 'No Title',

                    ),
                    trailing:PopupMenuButton(
                      
                      icon: Icon(Icons.more_vert),
                      itemBuilder: (context)=>[
PopupMenuItem(
    value: 1,
    child: ListTile(
onTap: (){
Navigator.pop(context);
  showMyDialog(title ?? '' ,id);
},
      leading: Icon(Icons.edit),
      title: Text('edit'),
    )


),
                        PopupMenuItem(
                            value: 1,
                            child: ListTile(
onTap: (){
  Navigator.pop(context);
  ref.child(id).remove().then((_) {
    Utils().toastMessage('Deleted successfully');
  }).onError((error, stackTrace) {
    Utils().toastMessage(error.toString());
  });

},
                              leading: Icon(Icons.delete_outline),
                              title: Text('Delete'),
                            )


                        )
                      ],
                      
                    ),
                  );
                } else if (title != null &&
                    title
                        .toLowerCase()
                        .contains(searchFilter.text.toLowerCase())) {
                  return ListTile(
                    title: Text(
                      title,
                    ),
                  );
                } else {
                  return Container();
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddPostScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> showMyDialog(String title , String id)async{
editController.text = title;
    return showDialog(
        context: context,
        builder: (BuildContext context){
              return AlertDialog(

                title: Text('Update'),
                content: Container(

                  child: TextField(

                    controller: editController,
                    decoration: InputDecoration(

                      hintText: 'Edit'
                    ),

                  ),
                ),
                actions: [

                  TextButton(onPressed: (){

                    Navigator.pop(context);

                  }, child: Text('Cancel')),
                  TextButton(onPressed: (){

                    Navigator.pop(context);
ref.child(id).update({
  'title' : editController.text.toLowerCase()
}).then((Value){

  Utils().toastMessage('Updated');
                    }).onError((error , stackTrace){

  Utils().toastMessage(error.toString());
                    });
                  }, child: Text('Update')),
                ],
              );
        }
    );
  }
}

// Expanded(
// child: StreamBuilder(
// stream: ref.onValue, // Listening to 'Products' changes
// builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
// if (!snapshot.hasData) {
// return const Center(
// child: CircularProgressIndicator(), // Show loading indicator
// );
// } else if (snapshot.data!.snapshot.value == null) {
// return const Center(
// child: Text("No products found"), // Handle empty database
// );
// } else {
// // Convert Firebase snapshot to Map
// Map<dynamic, dynamic> map =
// snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
// List<dynamic> list = map.values.toList();
//
// return ListView.builder(
// itemCount: list.length, // Total items in the list
// itemBuilder: (context, index) {
// return ListTile(
// title: Text(
// list[index]['title'] ?? 'No Title', // Display title
// ),
// );
// },
// );
// }
// },
// ),
// ),