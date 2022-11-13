import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce_app/model/user_model.dart';
import 'package:ecommerce_app/utils/generator.dart';
import 'package:ecommerce_app/utils/libs.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../utils/consts.dart';

class InfoEditionScreen extends StatefulWidget {
  const InfoEditionScreen(this.user, {super.key});
  final UserModel user;
  @override
  State<InfoEditionScreen> createState() => _InfoEditionScreenState();
}

enum AvatarType { display, update }

class _InfoEditionScreenState extends State<InfoEditionScreen> {
  final formKey = GlobalKey<FormState>();
  late TextEditingController nameController;
  late TextEditingController addressController;
  late TextEditingController phoneController;
  late TextEditingController mailController;
  late TextEditingController genderController;
  late TextEditingController dateController;
  Image? image;
  File? file;

  @override
  void initState() {
    super.initState();
    final birthDay = widget.user.birthDay;
    dateController = TextEditingController(
      text: birthDay != null ? DateFormat('dd/MM/yyyy').format(birthDay) : '',
    );
    nameController = TextEditingController(text: widget.user.name);
    addressController = TextEditingController(text: widget.user.address);
    phoneController = TextEditingController(text: widget.user.phone);
    mailController = TextEditingController(text: widget.user.email);
    genderController = TextEditingController(text: widget.user.gender);
  }

  @override
  void dispose() {
    dateController.dispose();
    nameController.dispose();
    addressController.dispose();
    phoneController.dispose();
    mailController.dispose();
    genderController.dispose();
    super.dispose();
  }

  String getAvatarUrl(UserModel user) {
    if (user.url != null) return user.url!;
    if (user.gender?.toLowerCase() == 'nam') return maleAvatarUrl;
    return femaleAvatarUrl;
  }

  @override
  Widget build(BuildContext context) {
    final nav = Navigator.of(context);
    final homeCubit = context.read<HomeCubit>();
    return Scaffold(
      backgroundColor: Colors.blue.shade100,
      body: SafeArea(
        child: Column(
          children: [
            Stack(
              alignment: Alignment.topLeft,
              children: [
                Container(
                  width: double.infinity,
                  height: 200,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      transform: GradientRotation(2),
                      colors: [
                        Colors.red,
                        Colors.blue,
                        Colors.orange,
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 0.0,
                  left: 0.0,
                  child: IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.white,
                    ),
                  ),
                ),
                Positioned(
                  top: 40.0,
                  left: 16.0,
                  child: InkWell(
                    onTap: () async {
                      final type = await showModalBottomSheet<AvatarType>(
                        context: context,
                        backgroundColor: Colors.white,
                        constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.height * 0.4,
                        ),
                        builder: (context) {
                          return ListView(
                            children: [
                              ListTile(
                                onTap: () => nav.pop(AvatarType.update),
                                title: const Text('Ảnh đại diện mới'),
                              ),
                              ListTile(
                                onTap: () => nav.pop(AvatarType.display),
                                title: const Text('Xem ảnh đại diện'),
                              ),
                            ],
                          );
                        },
                      );
                      if (type == AvatarType.display) {
                        homeCubit.onAvatarView(widget.user);
                        return;
                      }
                      if (type == AvatarType.update) {
                        final imagePicker = ImagePicker();
                        final xfile = await imagePicker.pickImage(
                          source: ImageSource.gallery,
                        );
                        file = File(xfile!.path);
                        image = Image.file(file!);
                        setState(() {});
                        return;
                      }
                    },
                    child: Hero(
                      tag: widget.user.name,
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 40.0,
                        backgroundImage: image == null
                            ? CachedNetworkImageProvider(
                                getAvatarUrl(widget.user),
                              )
                            : image!.image,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 16.0,
                  top: 130.0,
                  child: _HeadName(nameController),
                ),
              ],
            ),
            Expanded(
              child: Form(
                key: formKey,
                child: ListView(
                  children: [
                    const SizedBox(height: 16.0),
                    buildTextField(
                        'Địa chỉ', widget.user.address, addressController),
                    const SizedBox(height: 16.0),
                    buildTextField(
                      'Số điện thoại',
                      widget.user.phone,
                      phoneController,
                      TextInputType.number,
                    ),
                    const SizedBox(height: 16.0),
                    buildDateField(
                        'Năm sinh', widget.user.birthDay, dateController),
                    const SizedBox(height: 16.0),
                    buildTextField(
                        'email', widget.user.email ?? '', mailController),
                    const SizedBox(height: 16.0),
                    buildTextField(
                      'Giới tính',
                      widget.user.gender ?? '',
                      genderController,
                    ),
                    const SizedBox(height: 16.0),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: ElevatedButton(
                          onPressed: () async {
                            FocusScope.of(context).unfocus();
                            bool isValidate =
                                formKey.currentState?.validate() ?? false;
                            if (!isValidate) return;

                            final homeCubit = context.read<HomeCubit>();
                            // await FirebaseStorage.instance.ref(widget.user.url).delete();
                            final ref = FirebaseStorage.instance
                                .ref()
                                .child('avatars')
                                .child(Generator.generateString());
                            await ref.putFile(file!);
                            final url = await ref.getDownloadURL();
                            final upUser = widget.user.copyWith(
                                address: addressController.text,
                                birthDay: DateFormat('dd/MM/yyyy')
                                    .parse(dateController.text),
                                email: mailController.text,
                                gender: genderController.text,
                                name: nameController.text,
                                phone: phoneController.text,
                                url: url,
                                password: widget.user.password);
                            if (!mounted) return;
                            bool confirm = await showAlertDialog(
                                    context,
                                    'Xác nhận',
                                    'Bạn có chắc muốn thay đổi?',
                                    ['Yes', 'No']) ??
                                false;
                            if (!confirm) {
                              nav.pop();
                              return;
                            }
                            String message = 'Cập nhật thất bại!';
                            if (await homeCubit.updateInfo(upUser)) {
                              message = 'Cập nhật thành công!';
                              homeCubit.userRefresh();
                            }
                            if (mounted) {
                              await showAlertDialog(
                                context,
                                'Trạng thái',
                                message,
                                ['OK'],
                              );
                            }
                            nav.pop();
                          },
                          child: const Text('Cập nhật'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool?> showAlertDialog(BuildContext context, String title,
      String content, List<String> actions) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            for (var action in actions)
              TextButton(
                onPressed: () {
                  if (action.toLowerCase() == 'yes') {
                    Navigator.of(context).pop(true);
                  } else {
                    Navigator.of(context).pop(false);
                  }
                },
                child: Text(action),
              ),
          ],
        );
      },
    );
  }

  Widget buildDateField(
      String label, DateTime? date, TextEditingController controller) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.black54,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: TextFormField(
            controller: controller,
            readOnly: true,
            validator: (value) {
              return null;
            },
            decoration: InputDecoration(
              fillColor: Colors.white,
              filled: true,
              suffixIcon: buildDateSelection(context),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildTextField(
      String label, String value, TextEditingController controller,
      [TextInputType? inputType]) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.black54,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: TextFormField(
            keyboardType: inputType,
            controller: controller,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Không được bỏ trống';
              }
              return null;
            },
            decoration: const InputDecoration(
              fillColor: Colors.white,
              filled: true,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildDateSelection(BuildContext context) {
    return InkWell(
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1950),
          lastDate: DateTime(2050),
        );
        if (date != null) {
          dateController.text = DateFormat('dd/MM/yyyy').format(date);
        }
      },
      child: const Icon(Icons.date_range),
    );
  }
}

class _HeadName extends StatefulWidget {
  const _HeadName(this.nameController, {Key? key}) : super(key: key);
  final TextEditingController nameController;
  @override
  State<_HeadName> createState() => __HeadNameState();
}

class __HeadNameState extends State<_HeadName> {
  bool isEditingName = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        isEditingName
            ? SizedBox(
                width: 240.0,
                child: TextFormField(
                  controller: widget.nameController,
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              )
            : Text(
                widget.nameController.text,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(color: Colors.white),
              ),
        IconButton(
          onPressed: () {
            setState(() {
              isEditingName = !isEditingName;
            });
          },
          icon: isEditingName ? const Icon(Icons.done) : const Icon(Icons.edit),
        ),
      ],
    );
  }
}
