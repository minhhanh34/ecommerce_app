import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce_app/model/product_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:image_picker/image_picker.dart';

import '../../cubit/admin/admin_cubit.dart';
import '../../utils/alert_dialog.dart';
import '../../utils/generator.dart';
import '../../utils/price_format.dart';
import 'add_product_screen.dart';

class EditProductScreen extends StatefulWidget {
  const EditProductScreen(this.product, {super.key});
  final ProductModel product;
  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
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
  late TextEditingController weightController;
  late TextEditingController wifiController;
  late TextEditingController pinCapacityController;
  late TextEditingController pinTypeController;
  late TextEditingController cpuController;
  late TextEditingController cpuSpeedController;
  late TextEditingController displayTypeController;
  late TextEditingController gpuController;
  late TextEditingController brandController;

  // imageURL
  List<String> urls = [];
  //color options
  Color? pickerColor;
  File? colorOptionImagePicker;
  List<Map<String, dynamic>> colorOptions = [];
  // memory options
  late TextEditingController memoryOptionController;
  late TextEditingController priceOptionController;
  List<Map<String, dynamic>> memoryOptions = [];
  final formKey = GlobalKey<FormState>();
  late FocusScopeNode focusScope;

  //
  List<File> newFiles = [];
  List<Map<String, dynamic>> newColorOptions = [];

  @override
  void initState() {
    super.initState();
    final product = widget.product;
    nameController = TextEditingController(text: product.name);
    priceController = TextEditingController(text: product.price.toString());
    modelController = TextEditingController(text: product.model);
    ramController = TextEditingController(text: product.ram);
    frontCameraController = TextEditingController(text: product.fontCamera);
    rearCameraController = TextEditingController(text: product.rearCamera);
    resolutionController = TextEditingController(text: product.resolution);
    romController = TextEditingController(text: product.rom);
    displayController = TextEditingController(text: product.screenSize);
    simsController = TextEditingController(text: product.sims);
    sizeController = TextEditingController(text: product.size);
    weightController = TextEditingController(text: product.weight);
    wifiController = TextEditingController(text: product.wifi);
    pinCapacityController =
        TextEditingController(text: product.batteryCapacity);
    pinTypeController = TextEditingController(text: product.batteryType);
    cpuController = TextEditingController(text: product.cpu);
    cpuSpeedController = TextEditingController(text: product.cpuSpeed);
    displayTypeController = TextEditingController(text: product.displayType);
    gpuController = TextEditingController(text: product.gpu);
    brandController = TextEditingController(text: product.brand);
    memoryOptionController = TextEditingController();
    priceOptionController = TextEditingController();
    // urls = [...product.imageURL.values];
    for (int i = 0; i < product.imageURL.keys.length; i++) {
      urls.add(product.imageURL['image${i + 1}']);
    }
    colorOptions = [...product.colorOption];
    memoryOptions = [...product.memoryOption];
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
    weightController.dispose();
    wifiController.dispose();
    pinCapacityController.dispose();
    pinTypeController.dispose();
    cpuController.dispose();
    cpuSpeedController.dispose();
    displayTypeController.dispose();
    gpuController.dispose();
    brandController.dispose();
    memoryOptionController.dispose();
    priceOptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    focusScope = FocusScope.of(context);
    final adminCubit = context.read<AdminCubit>();
    return Scaffold(
      backgroundColor: Colors.blue.shade100,
      appBar: AppBar(
        elevation: 0,
        title: const Text('Thêm sản phẩm'),
      ),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                    label: 'Kích thước màn hình',
                    controller: displayController),
                const SizedBox(height: 8.0),
                TextFieldWithController(
                    label: 'sims', controller: simsController),
                const SizedBox(height: 8.0),
                TextFieldWithController(
                    label: 'kích thước', controller: sizeController),
                const SizedBox(height: 8.0),
                TextFieldWithController(
                    label: 'Nặng', controller: weightController),
                const SizedBox(height: 8.0),
                TextFieldWithController(
                    label: 'wifi', controller: wifiController),
                const SizedBox(height: 8.0),
                TextFieldWithController(
                    label: 'Dung lượng Pin', controller: pinCapacityController),
                const SizedBox(height: 8.0),
                TextFieldWithController(
                    label: 'Loại Pin', controller: pinTypeController),
                const SizedBox(height: 8.0),
                TextFieldWithController(
                    label: 'CPU', controller: cpuController),
                const SizedBox(height: 8.0),
                TextFieldWithController(
                    label: 'Tốc độ CPU', controller: cpuSpeedController),
                const SizedBox(height: 8.0),
                TextFieldWithController(
                    label: 'Loại màn hình', controller: displayTypeController),
                const SizedBox(height: 8.0),
                TextFieldWithController(
                    label: 'GPU', controller: gpuController),
                const SizedBox(height: 8.0),
                const SizedBox(height: 8.0),
                buildSingleLabel('Ảnh*'),
                buildPickedImages(),
                const SizedBox(height: 8.0),
                Visibility(
                  visible: urls.isEmpty,
                  child: buildPickImages(ImagePickType.multiple),
                ),
                buildSingleLabel('Tùy chọn màu'),
                const SizedBox(height: 8.0),
                buildAddedColorOption(),
                const SizedBox(height: 8.0),
                buildChooseColorOption(),
                const SizedBox(height: 8.0),
                buildSingleLabel('Tùy chọn bộ nhớ'),
                const SizedBox(height: 8.0),
                buildAddedMemoryOptions(),
                const SizedBox(height: 16.0),
                buildInputMemoryOptions(),
                const SizedBox(height: 8.0),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      FocusScope.of(context).unfocus();
                      bool isValid = formKey.currentState?.validate() ?? false;
                      if (!isValid) return;
                      if ((colorOptions.isEmpty && newColorOptions.isEmpty) ||
                          memoryOptions.isEmpty ||
                          (newFiles.isEmpty && urls.isEmpty)) {
                        builder(context) => const CustomAlertDialog(
                              title: 'không hợp lệ!',
                              content:
                                  'Không được bỏ trống ảnh và tùy chọn màu',
                              actions: ['Ok'],
                            );
                        showDialog(context: context, builder: builder);
                        return;
                      }
                      bool confirm = await showDialog(
                        context: context,
                        builder: (context) => const CustomAlertDialog(
                          title: 'Xác nhận',
                          content: 'Bạn có chắc muốn cập nhật sản phẩm?',
                        ),
                      );
                      if (!confirm) return;
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (_) {
                          return const AlertDialog(
                            title: Text('Đang cập nhật sản phẩm...'),
                            content: SizedBox(
                              height: 120.0,
                              child: Center(child: CircularProgressIndicator()),
                            ),
                          );
                        },
                      );
                      if (!mounted) return;
                      final ref = FirebaseStorage.instance
                          .ref()
                          .child(nameController.text);
                      final imageUrls = [...urls];
                      for (var image in newFiles) {
                        final imageRef = ref.child(Generator.generateString());
                        await imageRef.putFile(image);
                        imageUrls.add(await imageRef.getDownloadURL());
                      }
                      final imageURL = <String, dynamic>{};
                      for (int i = 0; i < imageUrls.length; i++) {
                        imageURL.addAll({
                          'image${i + 1}': imageUrls[i],
                        });
                      }
                      final colorOption = <Map<String, dynamic>>[
                        ...colorOptions
                      ];
                      for (var option in newColorOptions) {
                        final imageOptionRef =
                            ref.child(Generator.generateString());
                        await imageOptionRef.putFile(option['image']);
                        final url = await imageOptionRef.getDownloadURL();
                        colorOption.add({
                          'color':
                              '0xff${(option['color'] as Color).value.toRadixString(16)}',
                          'imageURL': url,
                        });
                      }
                      final newProduct = widget.product.copyWith(
                        name: nameController.text,
                        imageURL: imageURL,
                        price: int.tryParse(priceController.text) ?? 0,
                        batteryCapacity: pinCapacityController.text,
                        batteryType: pinTypeController.text,
                        brand: brandController.text,
                        colorOption: colorOption,
                        cpu: cpuController.text,
                        cpuSpeed: cpuSpeedController.text,
                        displayType: displayTypeController.text,
                        fontCamera: frontCameraController.text,
                        gpu: gpuController.text,
                        grade: 4,
                        memoryOption: memoryOptions,
                        model: modelController.text,
                        ram: ramController.text,
                        rearCamera: rearCameraController.text,
                        resolution: resolutionController.text,
                        rom: romController.text,
                        screenSize: displayController.text,
                        sims: simsController.text,
                        size: sizeController.text,
                        sold: 0,
                        weight: weightController.text,
                        wifi: wifiController.text,
                      );

                      await adminCubit.updateProduct(newProduct);
                      if (!mounted) return;
                      Navigator.of(context).pop();
                      showDialog(
                        context: context,
                        builder: (context) {
                          return const CustomAlertDialog(
                            title: 'Trạng thái',
                            content: 'Cập nhật sản phẩm thành công!',
                            actions: ['Ok'],
                          );
                        },
                      );
                    },
                    child: const Text('Cập nhật'),
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

  Widget buildPickImages(ImagePickType type) {
    return InkWell(
      onTap: () async {
        if (type == ImagePickType.multiple) {
          newFiles.addAll(await pickImages());
          setState(() {});
          return;
        }
        if (type == ImagePickType.single) {
          colorOptionImagePicker = await pickImage();
          if (pickerColor != null && colorOptionImagePicker != null) {
            newColorOptions.add({
              'color': pickerColor,
              'image': colorOptionImagePicker,
            });
            pickerColor = null;
            colorOptionImagePicker = null;
          }
          focusScope.unfocus();
          setState(() {});
          return;
        }
      },
      child: Container(
        width: 100.0,
        height: 100.0,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Center(
          child: Builder(builder: (context) {
            if (type == ImagePickType.single &&
                colorOptionImagePicker != null) {
              return Image.file(colorOptionImagePicker!);
            }
            return const Icon(Icons.add);
          }),
        ),
      ),
    );
  }

  Future<List<File>> pickImages() async {
    List<File> images = [];
    final imagePicker = ImagePicker();
    final xFiles = await imagePicker.pickMultiImage();
    for (var xFile in xFiles) {
      final file = File(xFile.path);
      images.add(file);
    }
    return images;
  }

  Widget buildPickedImages() {
    return Visibility(
      visible: urls.isNotEmpty,
      child: SizedBox(
        height: 100,
        width: double.infinity,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            for (var url in urls) buildPickedImage(url),
            buildNewPickedImages(),
            buildPickImages(ImagePickType.multiple),
          ],
        ),
      ),
    );
  }

  Widget buildPickedImage(String url) {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.only(right: 8.0),
          width: 100.0,
          height: 100.0,
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: CachedNetworkImage(
            imageUrl: url,
          ),
        ),
        Positioned(
          right: -10.0,
          top: -14.0,
          child: IconButton(
            onPressed: () {
              setState(() {
                urls.remove(url);
              });
            },
            icon: const Icon(
              Icons.remove_circle_rounded,
              color: Colors.red,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildAddedColorOption() {
    return Visibility(
      visible: colorOptions.isNotEmpty,
      child: Column(
        children: [
          for (var option in colorOptions)
            Container(
              margin: const EdgeInsets.only(top: 8.0),
              child: Row(
                children: [
                  Container(
                    width: 100.0,
                    height: 100.0,
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: option['imageURL'],
                    ),
                  ),
                  const SizedBox(width: 40.0),
                  Container(
                    width: 100.0,
                    height: 100.0,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Center(
                      child: SizedBox(
                        width: 28.0,
                        height: 28.0,
                        child: CircleAvatar(
                          radius: 14.0,
                          backgroundColor: Colors.black,
                          child: CircleAvatar(
                            backgroundColor: Color(int.parse(option['color'])),
                            radius: 14.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 40),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        colorOptions.remove(option);
                      });
                    },
                    icon: const Icon(
                      Icons.remove_circle_rounded,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          buildNewAddedColorOptions(),
        ],
      ),
    );
  }

  Future<File?> pickImage() async {
    final imagePicker = ImagePicker();
    final xfile = await imagePicker.pickImage(source: ImageSource.gallery);
    focusScope.unfocus();
    if (xfile == null) return null;
    return File(xfile.path);
  }

  Widget buildChooseColorOption() {
    return Visibility(
      visible: colorOptionImagePicker == null || pickerColor == null,
      child: Row(
        children: [
          buildPickImages(ImagePickType.single),
          const SizedBox(width: 40.0),
          buildColorPicker(),
        ],
      ),
    );
  }

  Widget buildColorPicker() {
    return InkWell(
      onTap: () {
        builder(context) => AlertDialog(
              title: const Text('Chọn màu!'),
              content: SingleChildScrollView(
                child: MaterialPicker(
                  pickerColor: const Color(0xff123123),
                  onColorChanged: (value) {
                    pickerColor = value;
                  },
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    focusScope.unfocus();
                    Navigator.of(context).pop();
                  },
                  child: const Text('Hủy'),
                ),
                TextButton(
                  onPressed: () {
                    if (colorOptionImagePicker != null && pickerColor != null) {
                      newColorOptions.add({
                        'color': pickerColor,
                        'image': colorOptionImagePicker,
                      });
                      pickerColor = null;
                      colorOptionImagePicker = null;
                    }
                    focusScope.unfocus();
                    Navigator.of(context).pop();
                    setState(() {});
                  },
                  child: const Text('Ok'),
                ),
              ],
            );
        showDialog(context: context, builder: builder);
      },
      child: Container(
        width: 100.0,
        height: 100.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: Colors.white,
        ),
        child: Builder(
          builder: (context) {
            if (pickerColor != null) {
              return Padding(
                padding: const EdgeInsets.all(36.0),
                child: CircleAvatar(
                  radius: 14.0,
                  backgroundColor: Colors.black,
                  child: CircleAvatar(
                    radius: 13.0,
                    backgroundColor: pickerColor,
                  ),
                ),
              );
            }
            return const Icon(Icons.border_color);
          },
        ),
      ),
    );
  }

  Widget buildInputMemoryOptions() {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            validator: (value) {
              if (memoryOptions.isEmpty) {
                return 'Không được bỏ trống';
              }
              return null;
            },
            controller: memoryOptionController,
            // keyboardType: TextInputType.name,
            decoration: InputDecoration(
              labelText: 'RAM - ROM',
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8.0),
        Expanded(
          child: TextFormField(
            keyboardType: TextInputType.number,
            validator: (value) {
              if (memoryOptions.isEmpty) {
                return 'Không được bỏ trống';
              }
              return null;
            },
            controller: priceOptionController,
            decoration: InputDecoration(
              labelText: 'Giá',
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8.0),
        IconButton(
          onPressed: () {
            if (memoryOptionController.text.isNotEmpty &&
                priceOptionController.text.isNotEmpty) {
              memoryOptions.add({
                'memory': memoryOptionController.text,
                'price': int.parse(priceOptionController.text),
              });

              setState(() {
                memoryOptionController.clear();
                priceOptionController.clear();
              });
              return;
            }
            formKey.currentState?.validate();
          },
          icon: const Icon(Icons.check),
        ),
      ],
    );
  }

  Widget buildAddedMemoryOptions() {
    const style = TextStyle(
      fontSize: 18.0,
      fontWeight: FontWeight.bold,
    );
    return Column(
      children: [
        for (var option in memoryOptions)
          Row(
            children: [
              Expanded(
                child: Text(option['memory'], style: style),
              ),
              Expanded(
                child: Text(
                  PriceHealper.format(option['price']),
                  style: style,
                ),
              ),
              Expanded(
                child: IconButton(
                  onPressed: () {
                    setState(() {
                      memoryOptions.remove(option);
                    });
                  },
                  icon: const Icon(
                    Icons.remove_circle_rounded,
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          ),
      ],
    );
  }

  Widget buildNewPickedImages() {
    return Row(
      children: [
        for (var file in newFiles)
          Stack(
            children: [
              Container(
                margin: const EdgeInsets.only(right: 8.0),
                width: 100.0,
                height: 100.0,
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Image.file(file),
              ),
              Positioned(
                right: -10.0,
                top: -14.0,
                child: IconButton(
                  onPressed: () {
                    setState(() {
                      newFiles.remove(file);
                    });
                  },
                  icon: const Icon(
                    Icons.remove_circle_rounded,
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          ),
      ],
    );
  }

  Widget buildNewAddedColorOptions() {
    return Column(
      children: [
        for (var option in newColorOptions)
          Container(
            margin: const EdgeInsets.only(top: 8.0),
            child: Row(
              children: [
                Container(
                  width: 100.0,
                  height: 100.0,
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Image.file(option['image']),
                ),
                const SizedBox(width: 40.0),
                Container(
                  width: 100.0,
                  height: 100.0,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Center(
                    child: SizedBox(
                      width: 28.0,
                      height: 28.0,
                      child: CircleAvatar(
                        radius: 14.0,
                        backgroundColor: Colors.black,
                        child: CircleAvatar(
                          backgroundColor: option['color'],
                          radius: 14.0,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 40),
                IconButton(
                  onPressed: () {
                    setState(() {
                      newColorOptions.remove(option);
                    });
                  },
                  icon: const Icon(
                    Icons.remove_circle_rounded,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
