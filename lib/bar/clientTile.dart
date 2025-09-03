// import 'dart:math';

// import 'package:flutter/material.dart';
// import 'package:pintarr/after/afterNavi.dart';
// import 'package:pintarr/clientBloc.dart';
// import 'package:pintarr/model/agent.dart';
// import 'package:pintarr/model/client.dart';
// import 'package:pintarr/widget/tile.dart';
// import 'package:provider/provider.dart';

// class ClientTile extends StatefulWidget {
//   // final control;
//   // final tap;
//   final Client client;
//   // final int index;
//   // final bool init;
//   ClientTile(
//     this.client,
//   );
//   @override
//   _ClientTileState createState() => _ClientTileState();
// }

// class _ClientTileState extends State<ClientTile> with TickerProviderStateMixin {
//   AnimationController _headController;
//   Animation<double> turn;
//   AnimationController _bodyController;
//   Animation<double> open;
//   bool opened = false;

//   @override
//   void initState() {
//     _headController = AnimationController(
//       duration: const Duration(milliseconds: 250),
//       vsync: this,
//     );

//     turn = Tween<double>(begin: 0, end: pi / 2).animate(_headController);

//     _bodyController =
//         AnimationController(vsync: this, duration: Duration(milliseconds: 500));
//     open = CurvedAnimation(
//       parent: _bodyController,
//       curve: Curves.fastOutSlowIn,
//     );

//     super.initState();
//   }

//   @override
//   void dispose() {
//     _headController.dispose();
//     _bodyController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final navi = Provider.of<AfterNavi>(context);
//     final bloc = Provider.of<ClientBloc>(context);
//     final agent = Provider.of<Agent?>(context);
//     if ((bloc.cid ?? agent.cid) == widget.client.id) {
//       _headController.forward();
//       _bodyController.forward();
//       opened = true;
//     }
//     if (bloc.cid != widget.client.id && opened) {
//       _headController.reverse();
//       _bodyController.reverse();
//       opened = false;
//     }

//     return Tile(
//       color: Colors.white,
//       selectedColor: Colors.grey[200],
//       tap: () {
//         bloc.updateCid(widget.client.id);
//         // navi.updatePage(navi.page, widget.client.id);
//         // widget.tap(widget.index);
//       },
//       selected: (bloc.cid ?? agent.cid) == widget.client.id,
//       title: Column(
//         children: [
//           Container(
//             height: 40,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Expanded(
//                   child: Text(
//                     widget.client.name.toUpperCase(),
//                     style: TextStyle(fontSize: 18),
//                   ),
//                 ),

//                 AnimatedBuilder(
//                   animation: turn,
//                   builder: (context, child) {
//                     return Container(
//                       child: Transform.rotate(
//                         angle: turn.value,
//                         child: Container(
//                           // transform: Transform.rotate(angle: 1.5708),
//                           width: 50,
//                           child: Icon(
//                             Icons.arrow_forward_ios,
//                             color: Colors.black,
//                             size: 15,
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//                 // SizedBox()
//               ],
//             ),
//           ),
//           SizeTransition(
//             axisAlignment: 1.0,
//             sizeFactor: open,
//             child: Container(
//               width: double.infinity,
//               child: Column(
//                 children: [
//                   Tile(
//                     lead: Icon(Icons.home),
//                     title: Text('Home'),
//                     tap: () {
//                       navi.updatePage(AfterPages.dashboard);
//                     },
//                     selected: navi.page == AfterPages.dashboard,
//                     selectedColor: Colors.grey[300],
//                     bar: true,
//                   ),
//                   Tile(
//                     lead: Icon(Icons.ac_unit),
//                     title: Text('Units'),
//                     tap: () {
//                       navi.updatePage(AfterPages.unit);
//                     },
//                     selected: navi.page == AfterPages.unit,
//                     selectedColor: Colors.grey[300],
//                     bar: true,
//                   ),
//                   Tile(
//                     lead: Icon(Icons.topic),
//                     title: Text('Reports'),
//                     tap: () {
//                       navi.updatePage(AfterPages.report);
//                     },
//                     selected: navi.page == AfterPages.report,
//                     selectedColor: Colors.grey[300],
//                     bar: true,
//                   ),
//                   Tile(
//                     lead: Icon(Icons.people),
//                     title: Text('Users'),
//                     tap: () {
//                       navi.updatePage(AfterPages.user);
//                     },
//                     selected: navi.page == AfterPages.user,
//                     selectedColor: Colors.grey[300],
//                     bar: true,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
