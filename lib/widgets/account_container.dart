import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce_app/cubit/home/home_cubit.dart';
import 'package:ecommerce_app/cubit/home/home_state.dart';
import 'package:ecommerce_app/model/user_model.dart';
import 'package:ecommerce_app/screen/info_edition_screen.dart';
import 'package:ecommerce_app/screen/sign_in_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../screen/user_avatar_screen.dart';
import '../utils/consts.dart';

class AccountContainer extends StatefulWidget {
  const AccountContainer({Key? key}) : super(key: key);

  @override
  State<AccountContainer> createState() => _AccountContainerState();
}

class _AccountContainerState extends State<AccountContainer> {
  String getAvatarUrl(UserModel user) {
    if (user.url != null) return user.url!;
    if (user.gender?.toLowerCase() == 'nam') return maleAvatarUrl;
    return femaleAvatarUrl;
  }

  @override
  Widget build(BuildContext context) {
    final homeCubit = context.read<HomeCubit>();
    return BlocConsumer<HomeCubit, HomeState>(
      listener: (context, state) {
        if (state is LogoutState) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const SignInPage()),
            (route) => false,
          );
        }
        if (state is InfoEdition) {
          Navigator.of(context).push(CupertinoPageRoute(
              builder: (context) => InfoEditionScreen(state.user)));
        }
        if (state is AvatarView) {
          builder(context) => UserAvatarScreen(state.user);
          final route = MaterialPageRoute(builder: builder);
          Navigator.of(context).push(route);
        }
      },
      builder: (context, state) {
        if (state is LoadingState) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is AccountState) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.blue.shade100,
            ),
            width: double.infinity,
            height: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8.0),
                Text(
                  '  Tài khoản',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontSize: 24.0),
                ),
                Card(
                  margin: const EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 8.0,
                  ),
                  child: SizedBox(
                    height: 100.0,
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(width: 16.0),
                        InkWell(
                          onTap: () => homeCubit.onAvatarView(state.user),
                          child: CircleAvatar(
                            radius: 33.0,
                            child: Hero(
                              tag: state.user.name,
                              child: CircleAvatar(
                                backgroundImage: CachedNetworkImageProvider(
                                  getAvatarUrl(state.user),
                                ),
                                backgroundColor: Colors.white,
                                radius: 32.0,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 40.0),
                        Text(state.user.name,
                            style: const TextStyle(fontSize: 20.0)),
                        const Spacer(),
                        IconButton(
                          onPressed: () =>
                              context.read<HomeCubit>().editInfo(state.user),
                          icon: const Icon(Icons.edit, size: 28.0),
                        ),
                        const SizedBox(width: 16.0),
                      ],
                    ),
                  ),
                ),
                Card(
                  margin: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    children: [
                      InfoRow(label: 'Địa chỉ:', value: state.user.address),
                      const Divider(thickness: 1.5),
                      InfoRow(label: 'Số điện thoại:', value: state.user.phone),
                      const Divider(thickness: 1.5),
                      InfoRow(label: 'Email:', value: state.user.email ?? ''),
                      const Divider(thickness: 1.5),
                      InfoRow(
                          label: 'Giới tính:', value: state.user.gender ?? ''),
                      const Divider(thickness: 1.5),
                      InfoRow(
                        label: 'Ngày sinh:',
                        value: state.user.birthDay != null
                            ? DateFormat('dd/MM/yyyy')
                                .format(state.user.birthDay!)
                            : '',
                      ),
                    ],
                  ),
                ),
                Card(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 8.0),
                  child: ListTile(
                    onTap: context.read<HomeCubit>().logout,
                    leading: const Icon(Icons.logout, color: Colors.red),
                    title: const Text('Đăng xuất'),
                  ),
                ),
              ],
            ),
          );
        }
        return const SizedBox();
      },
    );
  }
}

class InfoRow extends StatelessWidget {
  const InfoRow({
    Key? key,
    required this.label,
    required this.value,
  }) : super(key: key);
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50.0,
      child: Row(
        children: [
          const SizedBox(width: 8.0),
          Expanded(flex: 2, child: Text(label)),
          Expanded(flex: 5, child: Text(value)),
        ],
      ),
    );
  }
}
