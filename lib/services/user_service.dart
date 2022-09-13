import '../model/user_model.dart';
import '../repository/repository_interface.dart';

abstract class UserService {
  Future<UserModel> getUser(String uid);
  Future<bool> updateUserInfo(UserModel user);
}

class UserServiceIml implements UserService {
  Repository<UserModel> repository;
  UserServiceIml(this.repository);

  @override
  Future<UserModel> getUser(String uid) async {
    final users = await repository.list();
    final user = users.firstWhere((user) => user.uid == uid);
    return user;
  }

  @override
  Future<bool> updateUserInfo(UserModel userModel) async {
    final docSnap = await repository.getQueryDocumentSnapshot(userModel.uid);
    return await repository.update(docSnap.id, userModel);
  }
}
