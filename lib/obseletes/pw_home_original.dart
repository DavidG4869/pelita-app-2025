// import 'package:flutter/material.dart';
// import 'package:pelita_app/models/enums.dart';
// import 'package:pelita_app/screens/wanita/renungan_screen.dart';
// import 'package:pelita_app/service_locator.dart';
// import 'package:pelita_app/services/renungan_svc.dart';
// import 'package:pelita_app/utils/widget_utils.dart';
// import 'package:pelita_app/widgets/app_bar.dart';
// import 'package:pelita_app/widgets/app_drawer.dart';
// import 'package:pelita_app/widgets/bottom_nav_bar.dart';
// import 'package:wordpress_api/wordpress_api.dart';
// import 'package:pelita_app/utils/post_schema_utils.dart';
// import 'package:provider/provider.dart';
// import 'package:pelita_app/provider/dark_theme_provider.dart';

// class PWanitaHome extends StatefulWidget {
//   const PWanitaHome({Key key}) : super(key: key);

//   @override
//   _PWanitaHomeState createState() => _PWanitaHomeState();
// }

// class _PWanitaHomeState extends State<PWanitaHome> {
//   RenunganService _service;
//   List<PostSchema> _allPosts;
//   Future<List<PostSchema>> _initialLoad;

//   bool _isLoadingPost = false;
//   bool _noMorePosts = false;

//   @override
//   void initState() {
//     _service = svc<RenunganService>();
//     _initialLoad = _service.loadMore(initial: true);
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _service.clear();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//         child: Scaffold(
//             appBar: PelitaAppBar(screenType: ScreenType.pelita_wanita, screenTitle: 'Pelita Wanita'),
//             bottomNavigationBar: PelitaBottomNavBar(),
//             endDrawer: AppDrawer(
//               screenType: ScreenType.pelita_wanita,
//             ),
//             body: _buildLayout()));
//   }

//   Widget _buildRenunganItem(BuildContext context, int index, PostSchema post) {
//     return Card(
//       margin: const EdgeInsets.symmetric(vertical: 7),
//       clipBehavior: Clip.antiAliasWithSaveLayer,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
//       elevation: 2,
//       child: ListTile(
//         onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => RenunganScreen(id: post.id))),
//         leading: Container(
//             padding: EdgeInsets.all(5),
//             decoration:
//                 BoxDecoration(borderRadius: BorderRadius.circular(7), border: Border.all(color: Color(0xffDEDEDE))),
//             child: Icon(
//               Icons.play_arrow,
//               size: 40,
//             )),
//         title: Text(post.getTitle(), style: TextStyle(fontSize: 14)),
//         subtitle: Text(post.getDate(addDay: const Duration(days: 1)),
//             style: TextStyle(fontSize: 12, color: Theme.of(context).hintColor)),
//         trailing: Text('Detail', style: TextStyle(fontSize: 12, color: Color(0xffA458AA))),
//       ),
//     );
//   }

//   Widget _buildLayout() {
//     final themeChange = Provider.of<DarkThemeProvider>(context);
//     return SingleChildScrollView(
//       child: Column(children: <Widget>[
//         Container(
//             height: 100,
//             padding: EdgeInsets.only(bottom: 25),
//             decoration: BoxDecoration(
//                 image: DecorationImage(
//                     image:
//                         AssetImage(themeChange.darkTheme ? Resources.pelitaWanitaLogoDark : Resources.pelitaWanitaLogo),
//                     fit: BoxFit.contain))),
//         FutureBuilder(
//           future: _initialLoad,
//           builder: (context, AsyncSnapshot<List<PostSchema>> snapshot) {
//             if (snapshot.hasData) {
//               this._allPosts = snapshot.data;
//               return Container(
//                 width: MediaQuery.of(context).size.width * .90,
//                 child: ListView.builder(
//                     shrinkWrap: true,
//                     physics: const NeverScrollableScrollPhysics(),
//                     itemCount: this._allPosts.length + 1,
//                     //controller: this._controller,
//                     itemBuilder: (context, index) {
//                       var posts = this._allPosts;
//                       return (index == (posts.length))
//                           ? (_isLoadingPost ? Center(child: RefreshProgressIndicator()) : _buildLoadMorebutton())
//                           : _buildRenunganItem(context, index, posts[index]);
//                     }),
//               );
//             } else if (snapshot.hasError) {
//               return Container(
//                   margin: EdgeInsets.only(top: 130),
//                   child: Center(heightFactor: 3, child: Text('Error happened ${snapshot.error}')));
//             }

//             return WidgetUtils.loadingIndicatorWithPaddingTop();
//           },
//         ),
//       ]),
//     );
//   }

//   Widget _buildLoadMorebutton() {
//     return Offstage(
//         offstage: _noMorePosts,
//         child: Container(
//           decoration: BoxDecoration(gradient: WidgetUtils.linearGradientByType(ScreenType.pelita_wanita)),
//           margin: EdgeInsets.only(bottom: 10),
//           child: FlatButton(
//             child: Text("Lebih lanjut", style: TextStyle(color: Colors.white)),
//             onPressed: () async {
//               setState(() => this._isLoadingPost = true);
//               var posts = await _service.loadMore();

//               setState(() {
//                 _noMorePosts = !_service.hasMore;
//                 this._isLoadingPost = false;
//                 this._allPosts = posts;
//               });
//             },
//           ),
//         ));
//   }
// }
