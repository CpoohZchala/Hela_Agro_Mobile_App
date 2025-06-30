import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:farmeragriapp/api/cultivation_api.dart';
import 'package:farmeragriapp/data/cultivation_data.dart';
import 'package:farmeragriapp/models/cultivation_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CultivationalAddScreen extends StatefulWidget {
  final dynamic existingData;

  const CultivationalAddScreen({super.key, this.existingData});

  @override
  State<CultivationalAddScreen> createState() => _CultivationalAddScreenState();
}

class _CultivationalAddScreenState extends State<CultivationalAddScreen> {
  final storage = const FlutterSecureStorage();
  String? _selectedCategory;
  String? _selectedCrop;
  String? _selectedDistrict;
  String? _selectedCity;
  String? _selectedYieldSize;
  DateTime? _selectedDate;
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController memberIdController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController nicController = TextEditingController();
  bool _isSubmitting = false;

  // List of crop yield size options
  final List<String> _yieldSizeOptions = [
    'අක්කර 1/4 ',
    'අක්කර 1/2',
    'අක්කර 3/4',
    'අක්කර 1',
    'අක්කර 2',
    'අක්කර 3',
    'අක්කර 4',
    'අක්කර 5',
    'අක්කර 6',
    'අක්කර 7',
    'අක්කර 8',
    'අක්කර 9',
    'අක්කර 10',
    'අක්කර 11',
    'අක්කර 12',
    'අක්කර 13',
    'අක්කර 14',
    'අක්කර 15',
    'අක්කර 16',
    'අක්කර 17',
    'අක්කර 18',
    'අක්කර 19',
    'අක්කර 20'
  ];

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    final userId = await storage.read(key: "userId");
    memberIdController.text = userId ?? '';

    if (widget.existingData != null) {
      setState(() {
        _selectedCategory = widget.existingData['cropCategory'] ??
            widget.existingData['category'];
        _selectedCrop =
            widget.existingData['cropName'] ?? widget.existingData['crop'];
        _selectedDistrict = widget.existingData['district'];
        _selectedCity = widget.existingData['city'];
        addressController.text = widget.existingData['address'] ?? '';
        nicController.text = widget.existingData['nic'] ?? '';
        final yieldValue = widget.existingData['cropYieldSize']?.toString();
        if (yieldValue != null && _yieldSizeOptions.contains(yieldValue)) {
          _selectedYieldSize = yieldValue;
        } else {
          _selectedYieldSize = null;
        }

        if (widget.existingData['startDate'] != null) {
          try {
            _selectedDate = DateTime.parse(widget.existingData['startDate']);
            _dateController.text =
                "${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}";
          } catch (e) {
            print("Error parsing date: $e");
          }
        }
      });
    }
  }

  Future<void> _pickDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
        _dateController.text =
            "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
      });
    }
  }

  bool _validateForm() {
    return _selectedCategory != null &&
        _selectedCrop != null &&
        _selectedDate != null &&
        _selectedDistrict != null &&
        _selectedCity != null &&
        addressController.text.isNotEmpty &&
        memberIdController.text.isNotEmpty &&
        nicController.text.isNotEmpty &&
        _selectedYieldSize != null;
  }

  Future<void> _submitData() async {
    if (!_validateForm()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('please_fill_required'.tr()),
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final cultivation = Cultivation(
        memberId: memberIdController.text,
        cropCategory: _selectedCategory!,
        cropName: _selectedCrop!,
        address: addressController.text,
        startDate: _selectedDate!.toIso8601String(),
        district: _selectedDistrict!,
        city: _selectedCity!,
        nic: nicController.text,
        cropYieldSize: _parseAcreToNum(_selectedYieldSize),
        id: widget.existingData?['_id'],
      );

      final api = CultivationApi();
      final message = await api.submitOrUpdateCultivation(
        cultivation,
        isUpdate: widget.existingData != null,
      );

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                ClipPath(
                  clipper: ArcClipper(),
                  child: Container(
                    height: 190,
                    color: const Color.fromRGBO(87, 164, 91, 0.8),
                  ),
                ),
                Positioned(
                  top: 40,
                  left: 10,
                  child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
                  ),
                ),
                Positioned(
                  top: 50,
                  left: 50,
                  right: 0,
                  child: Text(
                    'edit_your_details'.tr(),
                    style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Positioned(
                  top: 40,
                  right: 20,
                  child: Image.asset(
                    "assets/icons/man.png",
                    width: 35,
                    height: 35,
                  ),
                ),
                Positioned(
                  bottom: 20,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Text(
                      widget.existingData != null
                          ? 'edit_cultivation'.tr()
                          : 'add_cultivation'.tr(),
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildTextField('member_id'.tr(), memberIdController,
                      enabled: false),
                  const SizedBox(height: 16),
                  _buildDropdown(
                      'select_category'.tr(), cropCategories.keys.toList(), (val) {
                    setState(() {
                      _selectedCategory = val;
                      _selectedCrop = null;
                    });
                  }, value: _selectedCategory),
                  const SizedBox(height: 16),
                  _buildDropdown(
                    'select_crop'.tr(),
                    _selectedCategory != null
                        ? cropCategories[_selectedCategory]!
                        : [],
                    (val) => setState(() => _selectedCrop = val),
                    value: _selectedCrop,
                    enabled: _selectedCategory != null,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _dateController,
                    decoration: InputDecoration(
                      labelText: 'start_date'.tr(),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.calendar_month),
                        onPressed: _pickDate,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    readOnly: true,
                  ),
                  const SizedBox(height: 16),
                  _buildDropdown(
                    'select_district'.tr(),
                    districtCities.keys.toList(),
                    (val) => setState(() {
                      _selectedDistrict = val;
                      _selectedCity = null;
                    }),
                    value: _selectedDistrict,
                  ),
                  const SizedBox(height: 16),
                  _buildDropdown(
                    'select_city'.tr(),
                    _selectedDistrict != null
                        ? districtCities[_selectedDistrict]!
                        : [],
                    (val) => setState(() => _selectedCity = val),
                    value: _selectedCity,
                    enabled: _selectedDistrict != null,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField('location_address'.tr(), addressController),
                  const SizedBox(height: 16),
                  _buildTextField('nic'.tr(), nicController),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'crop_yield_size'.tr(),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    value: _selectedYieldSize,
                    onChanged: (val) =>
                        setState(() => _selectedYieldSize = val),
                    items: _yieldSizeOptions.map((String item) {
                      return DropdownMenuItem<String>(
                        value: item,
                        child: Text(item),
                      );
                    }).toList(),
                    validator: (value) =>
                        value == null ? 'required_field_error'.tr() : null,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isSubmitting ? null : _submitData,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(87, 164, 91, 1),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: _isSubmitting
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text(
                              widget.existingData != null
                                  ? 'update'.tr()
                                  : 'submit'.tr(),
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
           
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {bool enabled = true}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      enabled: enabled,
    );
  }

  Widget _buildDropdown(
      String label, List<String> items, Function(String?) onChanged,
      {String? value, bool enabled = true}) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      value: value,
      onChanged: enabled ? onChanged : null,
      items: items.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item),
        );
      }).toList(),
      validator: (value) => value == null ? 'This field is required' : null,
    );
  }

  String _parseAcreValue(String? value) {
    if (value == null || value.isEmpty) return '';

    // Add "අක්කර" prefix to the value
    return "අක්කර ${value.trim()}";
  }

  num _parseAcreToNum(String? value) {
    if (value == null || value.isEmpty) return 0;
    // Remove 'අක්කර' and whitespace, then parse the number
    final cleaned = value.replaceAll('අක්කර', '').trim();
    // Handle fractions like '1/2'
    if (cleaned.contains('/')) {
      final parts = cleaned.split('/');
      if (parts.length == 2) {
        final numerator = num.tryParse(parts[0].trim()) ?? 0;
        final denominator = num.tryParse(parts[1].trim()) ?? 1;
        if (denominator != 0) {
          return numerator / denominator;
        }
      }
    }
    return num.tryParse(cleaned) ?? 0;
  }
}
