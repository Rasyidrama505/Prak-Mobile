import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:online_shop/user.dart';
 // Import ProductModel

class AddProduct extends StatefulWidget {
  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProduct> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  String? _selectedImage;

  final List<String> _imageList = [
    'assets/images/image1.jpg',
    'assets/images/image2.jpg',
    'assets/images/image3.jpg',
  ];

  // Fungsi untuk menyimpan data ke Hive
  Future<void> _saveProductToHive() async {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text.trim();
      final price = double.tryParse(_priceController.text.trim()) ?? 0.0;
      final description = _descriptionController.text.trim();

      if (_selectedImage != null) {
        // Buat instance ProductModel
        final product = ProductModel(
          name: name,
          price: price,
          description: description,
          imagePath: _selectedImage!,
        );

        // Simpan ke Hive box
        final box = Hive.box<ProductModel>('products');
        await box.add(product);

        // Tampilkan pesan sukses
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Produk berhasil ditambahkan!')),
        );

        // Reset form setelah menyimpan
        _formKey.currentState!.reset();
        setState(() {
          _selectedImage = null;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Harap pilih gambar produk!')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Produk'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Input untuk nama produk
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Nama Produk'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nama produk tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Input untuk harga produk
                TextFormField(
                  controller: _priceController,
                  decoration: InputDecoration(labelText: 'Harga Produk'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Harga produk tidak boleh kosong';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Masukkan harga yang valid';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Input untuk deskripsi produk
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(labelText: 'Deskripsi Produk'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Deskripsi produk tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Pilihan gambar dari assets/images
                GestureDetector(
                  onTap: () {
                    _showImagePicker(context);
                  },
                  child: _selectedImage == null
                      ? Container(
                          color: Colors.grey[200],
                          height: 200,
                          width: double.infinity,
                          child: Center(
                            child: Icon(Icons.add_a_photo, size: 50, color: Colors.blue),
                          ),
                        )
                      : Image.asset(
                          _selectedImage!,
                          width: double.infinity,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                ),
                const SizedBox(height: 16),

                // Tombol simpan produk
                ElevatedButton(
                  onPressed: _saveProductToHive,
                  child: Text('Simpan Produk'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Menampilkan dialog untuk memilih gambar
  void _showImagePicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Pilih Gambar Produk'),
          content: Container(
            height: 200,
            width: double.maxFinite,
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: _imageList.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedImage = _imageList[index];
                    });
                    Navigator.pop(context);
                  },
                  child: Image.asset(
                    _imageList[index],
                    fit: BoxFit.cover,
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
