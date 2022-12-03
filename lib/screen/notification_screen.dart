import 'package:ecommerce_app/cubit/notification/notification_cubit.dart';
import 'package:ecommerce_app/cubit/notification/notification_state.dart';
import 'package:ecommerce_app/utils/libs.dart';
import 'package:intl/intl.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade400,
        title: const Text('Thong bao'),
        elevation: 0,
      ),
      backgroundColor: Colors.grey.shade200,
      body: SafeArea(
        child: BlocBuilder<NotificationCubit, NotificationState>(
          builder: (context, state) {
            if (state is NotificationInitial) {
              context.read<NotificationCubit>().onNotification();
            }
            if (state is NotificationLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state is AllNotification) {
              return RefreshIndicator(
                onRefresh: () => context.read<NotificationCubit>().refresh(),
                child: ListView.builder(
                  itemCount: state.notifications.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: () => context.read<NotificationCubit>().update(
                            state.notifications[index].id!,
                            state.notifications[index].copyWith(
                              seen: !state.notifications[index].seen!,
                            ),
                          ),
                      leading: CircleAvatar(
                        child: Stack(
                          children: [
                            const Icon(Icons.notifications_rounded),
                            Visibility(
                              visible: !state.notifications[index].seen!,
                              child: Positioned(
                                top: 0,
                                right: 0,
                                child: Container(
                                  width: 12.0,
                                  height: 12.0,
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      tileColor: state.notifications[index].seen ?? false
                          ? Colors.white
                          : Colors.grey.shade300,
                      title: Text(state.notifications[index].title ?? ''),
                      subtitle: Text(state.notifications[index].message ?? ''),
                      trailing: Text(
                        DateFormat('dd/MM - hh:mm')
                            .format(state.notifications[index].time!),
                      ),
                    );
                  },
                ),
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}
