import 'dart:io';
import 'package:booze_app/data/beer.dart';
import 'package:booze_app/data/firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class BeerFormScreen extends StatefulWidget {
  final FirebaseService firebaseService;
  final Beer? beer;

  const BeerFormScreen({super.key, this.beer, required this.firebaseService});

  @override
  State<BeerFormScreen> createState() => _BeerFormScreenState();
}

class _BeerFormScreenState extends State<BeerFormScreen> {
  final _formKey = GlobalKey<FormState>();
  // Controllers for the new fields
  late TextEditingController _nameController;
  late TextEditingController _breweryController;
  late TextEditingController _countryController;
  late TextEditingController _styleController;
  late TextEditingController _abvController;
  late TextEditingController _flavourController;
  late TextEditingController _notesController;

  // State variables
  late int _rating;
  File? _image;
  String? _existingImageUrl;
  final _picker = ImagePicker();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // If a beer is provided (edit mode), initialize fields with its data
    final isEditMode = widget.beer != null;
    _nameController = TextEditingController(
      text: isEditMode ? widget.beer!.name : '',
    );
    _breweryController = TextEditingController(
      text: isEditMode ? widget.beer!.brewery : '',
    );
    _countryController = TextEditingController(
      text: isEditMode ? widget.beer!.country : '',
    );
    _styleController = TextEditingController(
      text: isEditMode ? widget.beer!.style : '',
    );
    _abvController = TextEditingController(
      text: isEditMode ? widget.beer!.abv.toString() : '',
    );
    _flavourController = TextEditingController(
      text: isEditMode ? widget.beer!.flavour : '',
    );
    _notesController = TextEditingController(
      text: isEditMode ? widget.beer!.notes : '',
    );
    _rating = isEditMode ? widget.beer!.rating : 3;
    _existingImageUrl = isEditMode ? widget.beer!.imageUrl : null;
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  Future<void> _saveBeer() async {
    if (!_formKey.currentState!.validate()) return;

    // An image is required only when adding a new beer
    if (widget.beer == null && _image == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Please select an image.')));
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      String imageUrl = _existingImageUrl ?? '';

      // If a new image was picked, upload it and delete the old one if it exists
      if (_image != null) {
        // Delete the old image if we are editing and an old image url exists
        if (widget.beer != null &&
            _existingImageUrl != null &&
            _existingImageUrl!.isNotEmpty) {
          try {
            await widget.firebaseService.deleteBeerImage(_existingImageUrl!);
          } catch (e) {
            // It's okay if deletion fails (e.g., file doesn't exist), log it
            print("Failed to delete old image: $e");
          }
        }

        imageUrl = await widget.firebaseService.uploadImage(_image!);
      }
      final beerData = Beer(
        id: widget.beer?.id ?? '',
        name: _nameController.text,
        brewery: _breweryController.text,
        country: _countryController.text,
        style: _styleController.text,
        abv: double.tryParse(_abvController.text) ?? 0.0,
        flavour: _flavourController.text,
        notes: _notesController.text,
        imageUrl: imageUrl,
        rating: _rating,
        createdAt: widget.beer?.createdAt != null
            ? widget.beer!.createdAt
            : DateTime.now(),
      );

      if (widget.beer != null) {
        // Update existing beer
        widget.firebaseService.updateBeer(beerData);
      } else {
        // Add new beer
        widget.firebaseService.createBeer(beerData);
      }

      // Pop twice to get back to the home screen after editing
      if (mounted) {
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to save beer: $e')));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    // Dispose controllers to free up resources
    _nameController.dispose();
    _breweryController.dispose();
    _countryController.dispose();
    _styleController.dispose();
    _abvController.dispose();
    _flavourController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.beer != null ? 'Edit Beer' : 'Add a New Beer'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Beer Name'),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter a name' : null,
                ),
                TextFormField(
                  controller: _breweryController,
                  decoration: InputDecoration(labelText: 'Brewery'),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter a brewery' : null,
                ),
                TextFormField(
                  controller: _countryController,
                  decoration: InputDecoration(labelText: 'Country'),
                ),
                TextFormField(
                  controller: _styleController,
                  decoration: InputDecoration(
                    labelText: 'Style (e.g., IPA, Stout)',
                  ),
                ),
                TextFormField(
                  controller: _abvController,
                  decoration: InputDecoration(labelText: 'ABV (%)'),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                ),
                TextFormField(
                  controller: _flavourController,
                  decoration: InputDecoration(labelText: 'Flavour Profile'),
                ),
                TextFormField(
                  controller: _notesController,
                  decoration: InputDecoration(labelText: 'Notes'),
                  maxLines: 3,
                ),
                SizedBox(height: 20),
                Text('Rating: $_rating / 5'),
                Slider(
                  value: _rating.toDouble(),
                  onChanged: (newRating) {
                    setState(() => _rating = newRating.round());
                  },
                  min: 0,
                  max: 5,
                  divisions: 5,
                  label: _rating.toString(),
                ),
                SizedBox(height: 20),
                // Image display logic
                Container(
                  alignment: Alignment.center,
                  child: _image != null
                      ? Image.file(_image!, height: 150, fit: BoxFit.cover)
                      : (_existingImageUrl != null
                            ? Image.network(
                                _existingImageUrl!,
                                height: 150,
                                fit: BoxFit.cover,
                              )
                            : Text('No image selected.')),
                ),
                Center(
                  child: TextButton.icon(
                    onPressed: _pickImage,
                    icon: Icon(Icons.image),
                    label: Text('Select Image'),
                  ),
                ),
                SizedBox(height: 20),
                if (_isLoading)
                  Center(child: CircularProgressIndicator())
                else
                  Center(
                    child: ElevatedButton(
                      onPressed: _saveBeer,
                      child: Text('Save Beer'),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
