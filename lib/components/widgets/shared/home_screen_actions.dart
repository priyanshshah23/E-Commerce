import 'package:flutter/material.dart';

import '../../../app/app.export.dart';

/// Builds a [PopupMenuButton] with actions for the [HomeScreen].
class HomeScreenActions extends StatelessWidget {
  const HomeScreenActions();

  Future<void> _searchUser(BuildContext context) async {
//    final User user = await showSearch<User>(
//      context: context,
//      delegate: UserSearchDelegate(),
//    );
//
//    if (user != null) {
//      NavigationUtilities.pushUserProfileScreen(user: user);
//    }
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      itemBuilder: (context) {
        return [
          PopupMenuItem(
            child: ListTile(
              leading: Icon(Icons.search),
              title: const Text("Search Users"),
              onTap: () async {
                await Navigator.of(context).maybePop();

                _searchUser(context);
              },
            ),
          ),
        ];
      },
    );
  }
}
