import 'package:flutter/material.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  bool toggle = false;
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        backgroundColor: Colors.amber[50],
        primarySwatch: Colors.purple,
        brightness: toggle ? Brightness.dark : Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: Colors.purple.shade100,
        appBar: AppBar(
          elevation: 0,
          title: const Text('Thêm sản phẩm'),
        ),
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          children: [
            const SizedBox(height: 8.0),
            TextFieldWithController(label: 'Tên', controller: controller),
            const SizedBox(height: 8.0),
            TextFieldWithController(label: 'Giá', controller: controller),
            const SizedBox(height: 8.0),
            TextFieldWithController(label: 'Model', controller: controller),
            const SizedBox(height: 8.0),
            TextFieldWithController(label: 'Ram', controller: controller),
            const SizedBox(height: 8.0),
            TextFieldWithController(
                label: 'Camera trước', controller: controller),
            const SizedBox(height: 8.0),
            TextFieldWithController(
                label: 'Camera sau', controller: controller),
            const SizedBox(height: 8.0),
            TextFieldWithController(
                label: 'Độ phân giải', controller: controller),
            const SizedBox(height: 8.0),
            TextFieldWithController(label: 'Rom', controller: controller),
            const SizedBox(height: 8.0),
            TextFieldWithController(label: 'Màn hình', controller: controller),
            const SizedBox(height: 8.0),
            TextFieldWithController(label: 'sims', controller: controller),
            const SizedBox(height: 8.0),
            TextFieldWithController(
                label: 'kích thước', controller: controller),
            const SizedBox(height: 8.0),
            TextFieldWithController(label: 'Đã bán', controller: controller),
            const SizedBox(height: 8.0),
            TextFieldWithController(label: 'Nặng', controller: controller),
            const SizedBox(height: 8.0),
            TextFieldWithController(label: 'wifi', controller: controller),
            const SizedBox(height: 8.0),
            TextFieldWithController(
                label: 'dung luong Pin', controller: controller),
            const SizedBox(height: 8.0),
            TextFieldWithController(label: 'loại Pin', controller: controller),
            const SizedBox(height: 8.0),
            TextFieldWithController(label: 'CPU', controller: controller),
            const SizedBox(height: 8.0),
            TextFieldWithController(
                label: 'tốc độ CPU', controller: controller),
            const SizedBox(height: 8.0),
            TextFieldWithController(
                label: 'Loại màn hình', controller: controller),
            const SizedBox(height: 8.0),
            TextFieldWithController(label: 'GPU', controller: controller),
            const SizedBox(height: 8.0),
            TextFieldWithController(label: 'Đánh giá', controller: controller),
            const SizedBox(height: 8.0),
            buildSingleLabel('Urls'),
            const SizedBox(height: 8.0),
            TextFieldWithController(
              label: 'url1',
              controller: controller,
            ),
            const SizedBox(height: 8.0),
            TextFieldWithController(
              label: 'url2',
              controller: controller,
            ),
            const SizedBox(height: 8.0),
            TextFieldWithController(
              label: 'url3',
              controller: controller,
            ),
            const SizedBox(height: 8.0),
            TextFieldWithController(
              label: 'url4',
              controller: controller,
            ),
            const SizedBox(height: 8.0),
            TextFieldWithController(
              label: 'url5',
              controller: controller,
            ),
            buildSingleLabel('Tùy chọn màu'),
            const SizedBox(height: 8.0),
            TextFieldWithController(
              label: 'I',
              controller: controller,
            ),
            const SizedBox(height: 8.0),
            TextFieldWithController(
              label: 'II',
              controller: controller,
            ),
            const SizedBox(height: 8.0),
            TextFieldWithController(
              label: 'III',
              controller: controller,
            ),
            buildSingleLabel('Tùy chọn bộ nhớ'),
            const SizedBox(height: 8.0),
            TextFieldWithController(
              label: 'I',
              controller: controller,
            ),
            const SizedBox(height: 8.0),
            TextFieldWithController(
              label: 'II',
              controller: controller,
            ),
            const SizedBox(height: 8.0),
            TextFieldWithController(
              label: 'III',
              controller: controller,
            ),
            const SizedBox(height: 8.0),
          ],
        ),
      ),
    );
  }

  Widget buildSingleLabel(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        label,
        style: Theme.of(context)
            .textTheme
            .titleMedium
            ?.copyWith(color: Colors.blueGrey.shade500),
      ),
    );
  }
}

class TextFieldWithController extends StatelessWidget {
  const TextFieldWithController({
    Key? key,
    required this.label,
    required this.controller,
  }) : super(key: key);
  final String label;
  final TextEditingController controller;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Expanded(
        //   flex: 1,
        //   child: Text(
        //     label,
        //     style: Theme.of(context)
        //         .textTheme
        //         .titleMedium
        //         ?.copyWith(color: Colors.blueGrey.shade500),
        //     textAlign: TextAlign.center,
        //   ),
        // ),
        Expanded(
          flex: 3,
          child: TextFormField(
            textInputAction: TextInputAction.next,
            controller: controller,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              labelText: label,
            ),
          ),
        ),
      ],
    );
  }
}
