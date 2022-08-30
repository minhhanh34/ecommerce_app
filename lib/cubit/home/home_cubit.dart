import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/home/home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(MainState());

  void favoriteTab() {
    emit(FavoriteState());
  }

  void mainTab() {
    emit(MainState());
  }

  void orderTab() {
    emit(OrderState());
  }

  void historyTab() {
    emit(HistoryState());
  }

  void accountTab() {
    emit(AccountState());
  }

  void logout() {
    emit(LoadingState());
    emit(LogoutState());
  }
}
