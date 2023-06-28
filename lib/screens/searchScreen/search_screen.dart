import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:reals/screens/ProfileScreen/profile_screen.dart';
import 'package:reals/utils/colors.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isShowUser = false;

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: TextFormField(
          controller: _searchController,
          decoration: const InputDecoration(
            labelText: 'Search',
          ),
          onFieldSubmitted: (String _) {
            setState(() {
              _isShowUser = true;
            });
          },
        ),
      ),
      body: _isShowUser
          ? FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .where('username',
                      isGreaterThanOrEqualTo: _searchController.text)
                  .get(),
              builder: (context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ProfileScreen(
                            uid: snapshot.data!.docs[index]['uid'],
                          ),
                        ));
                      },
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                              snapshot.data!.docs[index]['photoUrl']),
                        ),
                        title: Text(snapshot.data!.docs[index]['username']),
                      ),
                    );
                  },
                );
              })
          : FutureBuilder(
              future: FirebaseFirestore.instance.collection('post').get(),
              builder: (context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return InkWell(
                  onTap: () {},
                  child: MasonryGridView.builder(
                      scrollDirection: Axis.vertical,
                      gridDelegate:
                          const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2),
                      itemCount: snapshot.data!.docs.length,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      itemBuilder: (context, index) {
                        return ClipRRect(
                          child: Image.network(
                              snapshot.data!.docs[index]['postUrl']),
                        );
                      }),
                );
              }),
    );
  }
}
