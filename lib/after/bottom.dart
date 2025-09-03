import 'package:flutter/material.dart';
import 'package:pintarr/after/afterNavi.dart';
import 'package:pintarr/model/client.dart';
import 'package:provider/provider.dart';

class Bottom extends StatelessWidget {
  const Bottom({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final navi = Provider.of<AfterNavi>(context);
    final Client? client = Provider.of<Client?>(context);
    // print(current);
    final List<AfterPages> page = [
      AfterPages.dashboard,
      if (!client!.pintar) AfterPages.unit,
      if (!client.pintar) AfterPages.report,
      AfterPages.user,
    ];
    // print('currenttt');
    // final bloc = Provider.of<ClientBloc>(context);
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,

      currentIndex: page.indexWhere((element) => element == navi.page),
      // navi.page,
      onTap: (index) {
        navi.updatePage(page[index]);
        // setState(() {
        //   current = index;
        // });
        // print('current');
        // print(current);
      },

      // selectedItemColor: ,
      // unselectedItemColor: lightGrey,
      items: [
        const BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        if (!client.pintar)
          const BottomNavigationBarItem(
            icon: Icon(Icons.ac_unit),
            label: 'Units',
          ),
        if (!client.pintar)
          const BottomNavigationBarItem(
            icon: Icon(Icons.topic),
            label: 'Reports',
          ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.people),
          label: 'Users',
        ),
      ],
    );
  }
}
