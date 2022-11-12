import 'package:ecommerce_app/cubit/admin/admin_cubit.dart';
import 'package:ecommerce_app/model/product_model.dart';
import 'package:ecommerce_app/utils/alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddAndEditProductScreen extends StatefulWidget {
  const AddAndEditProductScreen({super.key, this.product});
  final ProductModel? product;

  @override
  State<AddAndEditProductScreen> createState() =>
      _AddAndEditProductScreenState();
}

class _AddAndEditProductScreenState extends State<AddAndEditProductScreen> {
  late TextEditingController nameController;
  late TextEditingController priceController;
  late TextEditingController modelController;
  late TextEditingController ramController;
  late TextEditingController frontCameraController;
  late TextEditingController rearCameraController;
  late TextEditingController resolutionController;
  late TextEditingController romController;
  late TextEditingController displayController;
  late TextEditingController simsController;
  late TextEditingController sizeController;
  late TextEditingController soldController;
  late TextEditingController weightController;
  late TextEditingController wifiController;
  late TextEditingController pinCapacityController;
  late TextEditingController pinTypeController;
  late TextEditingController cpuController;
  late TextEditingController cpuSpeedController;
  late TextEditingController displayTypeController;
  late TextEditingController gpuController;
  late TextEditingController gradeController;
  late TextEditingController url1Controller;
  late TextEditingController url2Controller;
  late TextEditingController url3Controller;
  late TextEditingController url4Controller;
  late TextEditingController url5Controller;
  late TextEditingController colorOption1Controller;
  late TextEditingController colorOption1UrlController;
  late TextEditingController colorOption2Controller;
  late TextEditingController colorOption2UrlController;
  late TextEditingController colorOption3Controller;
  late TextEditingController colorOption3UrlController;
  late TextEditingController memoryOption1Controller;
  late TextEditingController memoryOption1PriceController;
  late TextEditingController memoryOption2Controller;
  late TextEditingController memoryOption2PriceController;
  late TextEditingController memoryOption3Controller;
  late TextEditingController memoryOption3PriceController;
  late TextEditingController brandController;

  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.product == null) {
      nameController = TextEditingController();
      priceController = TextEditingController();
      modelController = TextEditingController();
      ramController = TextEditingController();
      frontCameraController = TextEditingController();
      rearCameraController = TextEditingController();
      resolutionController = TextEditingController();
      romController = TextEditingController();
      displayController = TextEditingController();
      simsController = TextEditingController();
      sizeController = TextEditingController();
      soldController = TextEditingController();
      weightController = TextEditingController();
      wifiController = TextEditingController();
      pinCapacityController = TextEditingController();
      pinTypeController = TextEditingController();
      cpuController = TextEditingController();
      cpuSpeedController = TextEditingController();
      displayTypeController = TextEditingController();
      gpuController = TextEditingController();
      gradeController = TextEditingController();
      url1Controller = TextEditingController();
      url2Controller = TextEditingController();
      url3Controller = TextEditingController();
      url4Controller = TextEditingController();
      url5Controller = TextEditingController();
      colorOption1Controller = TextEditingController();
      colorOption2Controller = TextEditingController();
      colorOption3Controller = TextEditingController();
      memoryOption1Controller = TextEditingController();
      memoryOption2Controller = TextEditingController();
      memoryOption3Controller = TextEditingController();
      brandController = TextEditingController();
      colorOption1UrlController = TextEditingController();
      colorOption2UrlController = TextEditingController();
      colorOption3UrlController = TextEditingController();
      memoryOption1PriceController = TextEditingController();
      memoryOption2PriceController = TextEditingController();
      memoryOption3PriceController = TextEditingController();
      return;
    }

    //
    final product = widget.product;
    nameController = TextEditingController(text: product?.name);
    priceController = TextEditingController(text: product?.price.toString());
    modelController = TextEditingController(text: product?.model);
    ramController = TextEditingController(text: product?.ram);
    frontCameraController = TextEditingController(text: product?.fontCamera);
    rearCameraController = TextEditingController(text: product?.rearCamera);
    resolutionController = TextEditingController(text: product?.resolution);
    romController = TextEditingController(text: product?.rom);
    displayController = TextEditingController(text: product?.screenSize);
    simsController = TextEditingController(text: product?.sims);
    sizeController = TextEditingController(text: product?.size);
    soldController = TextEditingController(text: product?.sold.toString());
    weightController = TextEditingController(text: product?.weight);
    wifiController = TextEditingController(text: product?.wifi);
    pinCapacityController =
        TextEditingController(text: product?.batteryCapacity);
    pinTypeController = TextEditingController(text: product?.batteryType);
    cpuController = TextEditingController(text: product?.cpu);
    cpuSpeedController = TextEditingController(text: product?.cpuSpeed);
    displayTypeController = TextEditingController(text: product?.displayType);
    gpuController = TextEditingController(text: product?.gpu);
    gradeController = TextEditingController(text: product?.grade.toString());
    url1Controller = TextEditingController(text: product?.imageURL['image1']);
    url2Controller = TextEditingController(text: product?.imageURL['image2']);
    url3Controller = TextEditingController(text: product?.imageURL['image3']);
    url4Controller = TextEditingController(text: product?.imageURL['image4']);
    url5Controller = TextEditingController(text: product?.imageURL['image5']);
    colorOption1Controller =
        TextEditingController(text: product?.colorOption?[0]['color']);
    colorOption2Controller =
        TextEditingController(text: product?.colorOption?[1]['color']);
    colorOption3Controller =
        TextEditingController(text: product?.colorOption?[2]['color']);
    memoryOption1Controller =
        TextEditingController(text: product?.memoryOption?[0]['memory']);
    memoryOption2Controller =
        TextEditingController(text: product?.memoryOption?[1]['memory']);
    memoryOption3Controller =
        TextEditingController(text: product?.memoryOption?[2]['memory']);
    brandController = TextEditingController(text: product?.brand);
    colorOption1UrlController =
        TextEditingController(text: product?.colorOption?[0]['imageURL']);
    colorOption2UrlController =
        TextEditingController(text: product?.colorOption?[1]['imageURL']);
    colorOption3UrlController =
        TextEditingController(text: product?.colorOption?[2]['imageURL']);
    memoryOption1PriceController = TextEditingController(
        text: product?.memoryOption?[0]['price'].toString());
    memoryOption2PriceController = TextEditingController(
        text: product?.memoryOption?[1]['price'].toString());
    memoryOption3PriceController = TextEditingController(
        text: product?.memoryOption?[2]['price'].toString());
  }

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    modelController.dispose();
    ramController.dispose();
    frontCameraController.dispose();
    rearCameraController.dispose();
    resolutionController.dispose();
    romController.dispose();
    displayController.dispose();
    simsController.dispose();
    sizeController.dispose();
    soldController.dispose();
    weightController.dispose();
    wifiController.dispose();
    pinCapacityController.dispose();
    pinTypeController.dispose();
    cpuController.dispose();
    cpuSpeedController.dispose();
    displayTypeController.dispose();
    gpuController.dispose();
    gradeController.dispose();
    url1Controller.dispose();
    url2Controller.dispose();
    url3Controller.dispose();
    url4Controller.dispose();
    url5Controller.dispose();
    colorOption1Controller.dispose();
    colorOption2Controller.dispose();
    colorOption3Controller.dispose();
    memoryOption1Controller.dispose();
    memoryOption2Controller.dispose();
    memoryOption3Controller.dispose();
    brandController.dispose();
    colorOption1UrlController.dispose();
    colorOption2UrlController.dispose();
    colorOption3UrlController.dispose();
    memoryOption1PriceController.dispose();
    memoryOption2PriceController.dispose();
    memoryOption3PriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade100,
      appBar: AppBar(
        elevation: 0,
        title: Text(
            widget.product == null ? 'Thêm sản phẩm' : 'Cập nhật sản phẩm'),
      ),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                const SizedBox(height: 8.0),
                TextFieldWithController(
                  label: 'Tên*',
                  controller: nameController,
                  hasValidate: true,
                ),
                const SizedBox(height: 8.0),
                TextFieldWithController(
                  label: 'Thương hiệu*',
                  controller: brandController,
                  hasValidate: true,
                ),
                const SizedBox(height: 8.0),
                TextFieldWithController(
                  label: 'Giá*',
                  controller: priceController,
                  hasValidate: true,
                ),
                const SizedBox(height: 8.0),
                TextFieldWithController(
                    label: 'Model', controller: modelController),
                const SizedBox(height: 8.0),
                TextFieldWithController(
                    label: 'Ram', controller: ramController),
                const SizedBox(height: 8.0),
                TextFieldWithController(
                    label: 'Camera trước', controller: frontCameraController),
                const SizedBox(height: 8.0),
                TextFieldWithController(
                    label: 'Camera sau', controller: rearCameraController),
                const SizedBox(height: 8.0),
                TextFieldWithController(
                    label: 'Độ phân giải', controller: resolutionController),
                const SizedBox(height: 8.0),
                TextFieldWithController(
                    label: 'Rom', controller: romController),
                const SizedBox(height: 8.0),
                TextFieldWithController(
                    label: 'Màn hình', controller: displayController),
                const SizedBox(height: 8.0),
                TextFieldWithController(
                    label: 'sims', controller: simsController),
                const SizedBox(height: 8.0),
                TextFieldWithController(
                    label: 'kích thước', controller: sizeController),
                const SizedBox(height: 8.0),
                TextFieldWithController(
                    label: 'Đã bán', controller: soldController),
                const SizedBox(height: 8.0),
                TextFieldWithController(
                    label: 'Nặng', controller: weightController),
                const SizedBox(height: 8.0),
                TextFieldWithController(
                    label: 'wifi', controller: wifiController),
                const SizedBox(height: 8.0),
                TextFieldWithController(
                    label: 'dung luong Pin', controller: pinCapacityController),
                const SizedBox(height: 8.0),
                TextFieldWithController(
                    label: 'loại Pin', controller: pinTypeController),
                const SizedBox(height: 8.0),
                TextFieldWithController(
                    label: 'CPU', controller: cpuController),
                const SizedBox(height: 8.0),
                TextFieldWithController(
                    label: 'tốc độ CPU', controller: cpuSpeedController),
                const SizedBox(height: 8.0),
                TextFieldWithController(
                    label: 'Loại màn hình', controller: displayTypeController),
                const SizedBox(height: 8.0),
                TextFieldWithController(
                    label: 'GPU', controller: gpuController),
                const SizedBox(height: 8.0),
                TextFieldWithController(
                    label: 'Đánh giá', controller: gradeController),
                const SizedBox(height: 8.0),
                buildSingleLabel('Urls*'),
                const SizedBox(height: 8.0),
                TextFieldWithController(
                  label: 'url1',
                  controller: url1Controller,
                  hasValidate: true,
                ),
                const SizedBox(height: 8.0),
                TextFieldWithController(
                  label: 'url2',
                  controller: url2Controller,
                  hasValidate: true,
                ),
                const SizedBox(height: 8.0),
                TextFieldWithController(
                  label: 'url3',
                  controller: url3Controller,
                  hasValidate: true,
                ),
                const SizedBox(height: 8.0),
                TextFieldWithController(
                  label: 'url4',
                  controller: url4Controller,
                  hasValidate: true,
                ),
                const SizedBox(height: 8.0),
                TextFieldWithController(
                  label: 'url5',
                  controller: url5Controller,
                  hasValidate: true,
                ),
                buildSingleLabel('Tùy chọn màu'),
                const SizedBox(height: 8.0),
                TextFieldWithController(
                  label: 'Mã màu I',
                  controller: colorOption1Controller,
                ),
                const SizedBox(height: 8.0),
                TextFieldWithController(
                  label: 'Url I',
                  controller: colorOption1UrlController,
                ),
                const SizedBox(height: 8.0),
                TextFieldWithController(
                  label: 'Mã màu II',
                  controller: colorOption2Controller,
                ),
                const SizedBox(height: 8.0),
                TextFieldWithController(
                  label: 'Url II',
                  controller: colorOption2UrlController,
                ),
                const SizedBox(height: 8.0),
                TextFieldWithController(
                  label: 'Mã màu III',
                  controller: colorOption3Controller,
                ),
                const SizedBox(height: 8.0),
                TextFieldWithController(
                  label: 'Url III',
                  controller: colorOption3UrlController,
                ),
                buildSingleLabel('Tùy chọn bộ nhớ'),
                const SizedBox(height: 8.0),
                TextFieldWithController(
                  label: 'Tùy chọn I',
                  controller: memoryOption1Controller,
                ),
                const SizedBox(height: 8.0),
                TextFieldWithController(
                  label: 'Giá I',
                  controller: memoryOption1PriceController,
                ),
                const SizedBox(height: 8.0),
                TextFieldWithController(
                  label: 'Tùy chọn II',
                  controller: memoryOption2Controller,
                ),
                const SizedBox(height: 8.0),
                TextFieldWithController(
                  label: 'Giá II',
                  controller: memoryOption2PriceController,
                ),
                const SizedBox(height: 8.0),
                TextFieldWithController(
                  label: 'Tùy chọn III',
                  controller: memoryOption3Controller,
                ),
                const SizedBox(height: 8.0),
                TextFieldWithController(
                  label: 'Giá III',
                  controller: memoryOption3PriceController,
                ),
                const SizedBox(height: 8.0),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      bool isValid = formKey.currentState?.validate() ?? false;
                      if (!isValid) return;
                      FocusScope.of(context).unfocus();
                      bool confirm = await showDialog(
                        context: context,
                        builder: (context) => const CustomAlertDialog(
                          title: 'Xác nhận',
                          content: 'Bạn có chắc muốn thêm?',
                        ),
                      );
                      if (!confirm) return;
                      if (!mounted) return;
                      final product = ProductModel(
                        name: nameController.text,
                        imageURL: {
                          'image1': url1Controller.text,
                          'image2': url2Controller.text,
                          'image3': url3Controller.text,
                          'image4': url4Controller.text,
                          'image5': url5Controller.text,
                        },
                        price: int.tryParse(priceController.text) ?? 0,
                        batteryCapacity: pinCapacityController.text,
                        batteryType: pinTypeController.text,
                        brand: brandController.text,
                        colorOption: [
                          {
                            'color': colorOption1Controller.text,
                            'imageURL': colorOption1UrlController.text,
                          },
                          {
                            'color': colorOption2Controller.text,
                            'imageURL': colorOption2UrlController.text,
                          },
                          {
                            'color': colorOption3Controller.text,
                            'imageURL': colorOption3UrlController.text,
                          }
                        ],
                        cpu: cpuController.text,
                        cpuSpeed: cpuSpeedController.text,
                        displayType: displayTypeController.text,
                        fontCamera: frontCameraController.text,
                        gpu: gpuController.text,
                        grade: int.tryParse(gradeController.text) ?? 0,
                        memoryOption: [
                          {
                            'memory': memoryOption1Controller.text,
                            'price': memoryOption1PriceController.text,
                          },
                          {
                            'memory': memoryOption2Controller.text,
                            'price': memoryOption2PriceController.text,
                          },
                          {
                            'memory': memoryOption3Controller.text,
                            'price': memoryOption3PriceController.text,
                          },
                        ],
                        model: modelController.text,
                        ram: ramController.text,
                        rearCamera: rearCameraController.text,
                        resolution: resolutionController.text,
                        rom: romController.text,
                        screenSize: displayController.text,
                        sims: simsController.text,
                        size: sizeController.text,
                        sold: int.tryParse(soldController.text) ?? 0,
                        weight: weightController.text,
                        wifi: wifiController.text,
                      );
                      if (widget.product == null) {
                        context.read<AdminCubit>().addProduct(product);
                        return;
                      }
                      context.read<AdminCubit>().updateProduct(product);
                    },
                    child: Text(widget.product == null ? 'Thêm' : 'Cập nhật'),
                  ),
                ),
              ],
            ),
          ),
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
    this.hasValidate = false,
  }) : super(key: key);
  final String label;
  final TextEditingController controller;
  final bool hasValidate;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: TextFormField(
            validator: (value) {
              if (hasValidate && (value == null || value.isEmpty)) {
                return 'Bắt buộc';
              }
              return null;
              // return null;
            },
            textInputAction: TextInputAction.next,
            controller: controller,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              labelText: label,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
