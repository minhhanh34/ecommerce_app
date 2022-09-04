import 'package:ecommerce_app/cubit/home/home_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/home/home_cubit.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(builder: (context, state) {
      return BottomNavigationBar(
        enableFeedback: true,
        type: BottomNavigationBarType.fixed,
        onTap: (index) => context.read<HomeCubit>().onNavTap(index),
        currentIndex: context.read<HomeCubit>().navIndex,
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
    });
  }
}
