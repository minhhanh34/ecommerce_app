import 'package:ecommerce_app/blocs/home/home_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int index = 0;

  void onTap(int index) {
    final homeCubit = BlocProvider.of<HomeCubit>(context);
    if (index == 0) {
      homeCubit.mainTab();
    } else if (index == 1) {
      homeCubit.favoriteTab();
    } else if (index == 2) {
      homeCubit.orderTab();
    } else if (index == 3) {
      homeCubit.historyTab();
    } else if (index == 4) {
      homeCubit.accountTab();
    }
    setState(() {
      this.index = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      enableFeedback: true,
      type: BottomNavigationBarType.fixed,
      onTap: onTap,
      currentIndex: index,
      elevation: 100,
      backgroundColor: Colors.white,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home_rounded),
          label: 'Trang chủ',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite_outline),
          activeIcon: Icon(Icons.favorite_rounded),
          label: 'Yêu thích',
        ),
        BottomNavigationBarItem(
          icon: Icon(CupertinoIcons.archivebox),
          activeIcon: Icon(CupertinoIcons.archivebox_fill),
          label: 'Đơn hàng',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.work_history_outlined),
          activeIcon: Icon(Icons.work_history_rounded),
          label: 'Lich sử',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          activeIcon: Icon(Icons.person_rounded),
          label: 'Tài khoản',
        ),
      ],
    );
  }
}
