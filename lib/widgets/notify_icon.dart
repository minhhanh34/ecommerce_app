// ignore: unused_import

import 'package:ecommerce_app/cubit/notification/notification_cubit.dart';
import 'package:ecommerce_app/cubit/notification/notification_state.dart';
import 'package:ecommerce_app/utils/libs.dart';

class NotifyIcon extends StatefulWidget {
  const NotifyIcon({Key? key}) : super(key: key);

  @override
  State<NotifyIcon> createState() => _NotifyIconState();
}

class _NotifyIconState extends State<NotifyIcon> {
  @override
  Widget build(BuildContext context) {
    final homeCubit = context.read<HomeCubit>();
    final notificationCubit = context.read<NotificationCubit>();
    return Stack(
      alignment: Alignment.center,
      children: [
        IconButton(
          onPressed: () => homeCubit.toNotificationScreen(),
          icon: const Icon(Icons.notifications_rounded),
        ),
        Positioned(
          top: 5.0,
          right: 0.0,
          child: BlocBuilder<NotificationCubit, NotificationState>(
            builder: (context, state) {
              if (state is NotificationInitial) {
                notificationCubit.onNotification();
                return const SizedBox();
              }
              if (state is NotificationLoading) {
                return Container(
                  width: 24.0,
                  height: 24.0,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: Colors.red,
                    ),
                  ),
                );
              }
              if (state is AllNotification) {
                final newNotification = state.notifications
                    .where((element) => element.seen == false)
                    .toList();
                return Visibility(
                  visible: newNotification.isNotEmpty,
                  child: Container(
                    constraints: const BoxConstraints(
                      maxHeight: 24.0,
                      maxWidth: 24.0,
                      minHeight: 16.0,
                      minWidth: 16.0,
                    ),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        state.notifications
                            .where((element) => element.seen == false)
                            .length
                            .toString(),
                      ),
                    ),
                  ),
                );
              }
              return const SizedBox();
            },
          ),
        ),
      ],
    );
  }
}
