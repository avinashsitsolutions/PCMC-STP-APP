import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';
import 'package:tankerpcmc/builder/builderservices.dart';
import 'package:tankerpcmc/widgets/appbar.dart';
import 'package:tankerpcmc/widgets/drawerWidget.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';

class ReportBuilder extends StatefulWidget {
  const ReportBuilder({super.key});

  @override
  State<ReportBuilder> createState() => _ReportBuilderState();
}

class _ReportBuilderState extends State<ReportBuilder> {
  var dropdownValue;
  List<dynamic> _dataList = [];
  bool isLoading = false;
  int _selectedOptionId = 0;
  List<Map<String, dynamic>> bcpList = [];
  final TextEditingController _typeAheadController = TextEditingController();
  String _selectedOption = '';

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _dateController1 = TextEditingController();
  final TextEditingController _dateController2 = TextEditingController();

  void fetchBCPList() {
    Builderservices.bcplist().then((data1) {
      setState(() {
        isLoading = true;
        List<dynamic> data = data1['data'];
        bcpList = data.map((item) => item as Map<String, dynamic>).toList();
        isLoading = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    fetchBCPList();

    // Default To Date = today
    DateTime now = DateTime.now();
    String formattedDate = "${now.day}-${now.month}-${now.year}";
    _dateController2.text = formattedDate;
  }

  void _onSubmitPressed() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      if (_selectedOption.isNotEmpty) {
        Builderservices.builderrrport(_selectedOptionId.toString(),
                _dateController1.text, _dateController2.text)
            .then((data) {
          setState(() {
            _dataList = data['data'];
            isLoading = false;
          });
        });
      } else {
        Builderservices.builderrrportall(
                _dateController1.text, _dateController2.text)
            .then((data) {
          setState(() {
            _dataList = data['data'];
            isLoading = false;
          });
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Appbarwid(),
      ),
      endDrawer: const DrawerWid(),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.green[50],
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            children: [
              const SizedBox(height: 20),
              const Text(
                "Reports",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              // Date Labels Row
              Row(
                children: const [
                  Expanded(
                    child: Text(
                      "From Date:",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      "To Date:",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Date Pickers
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            readOnly: true,
                            controller: _dateController1,
                            decoration: const InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              labelText: 'Date',
                              suffixIcon: Icon(Icons.calendar_today),
                            ),
                            validator: (value) =>
                                value!.isEmpty ? 'Please enter date' : null,
                            onTap: () {
                              DatePicker.showDatePicker(
                                context,
                                showTitleActions: true,
                                minTime: DateTime(2020, 1, 1),
                                maxTime: DateTime(2025, 12, 31),
                                onConfirm: (date) {
                                  _dateController1.text =
                                      '${date.day}-${date.month}-${date.year}';
                                },
                                currentTime: DateTime.now(),
                                locale: LocaleType.en,
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: TextFormField(
                            readOnly: true,
                            controller: _dateController2,
                            decoration: const InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              labelText: 'Date',
                              suffixIcon: Icon(Icons.calendar_today),
                            ),
                            validator: (value) =>
                                value!.isEmpty ? 'Please enter date' : null,
                            onTap: () {
                              DatePicker.showDatePicker(
                                context,
                                showTitleActions: true,
                                minTime: DateTime(2020, 1, 1),
                                maxTime: DateTime(2025, 12, 31),
                                onConfirm: (date) {
                                  _dateController2.text =
                                      '${date.day}-${date.month}-${date.year}';
                                },
                                currentTime: DateTime.now(),
                                locale: LocaleType.en,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // TypeAhead Field
                    TypeAheadField(
                      textFieldConfiguration: TextFieldConfiguration(
                        decoration: const InputDecoration(
                          hintText: "Select Commecement No First",
                          prefixIcon: Icon(Icons.search,
                              color: Color.fromRGBO(0, 0, 0, 1)),
                          hintStyle: TextStyle(color: Colors.black),
                        ),
                        controller: _typeAheadController,
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      suggestionsCallback: (pattern) {
                        return bcpList
                            .where((item) =>
                                item['ni_bcp_no'] != null &&
                                item['ni_bcp_no']
                                    .toString()
                                    .toLowerCase()
                                    .contains(pattern.toLowerCase()))
                            .map((item) => item['ni_bcp_no'].toString())
                            .toList();
                      },
                      itemBuilder: (context, suggestion) {
                        return ListTile(title: Text(suggestion));
                      },
                      onSuggestionSelected: (suggestion) {
                        setState(() {
                          _selectedOption = suggestion;
                          _typeAheadController.text = suggestion;
                          _selectedOptionId = bcpList.firstWhere((item) =>
                              item['ni_bcp_no'].toString() ==
                              suggestion)['id'] as int;
                        });
                      },
                      noItemsFoundBuilder: (context) {
                        return const ListTile(title: Text('No item found'));
                      },
                    ),
                    const SizedBox(height: 30),

                    ElevatedButton(
                      onPressed: _onSubmitPressed,
                      child: const Text('Submit'),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Results
              Expanded(
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _dataList.isEmpty
                        ? const Center(
                            child: Text(
                              "No Reports Available",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          )
                        : ListView.builder(
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemCount: _dataList.length,
                            itemBuilder: (context, index) {
                              final data = _dataList[index];
                              String dateString = data['updated_at'];
                              final status = data['status'];
                              DateTime date = DateTime.parse(dateString);
                              String formattedDate =
                                  DateFormat('dd-MM-yyyy').format(date);

                              return Column(
                                children: [
                                  const SizedBox(height: 20),
                                  buildDataRow("Serial No:", "${index + 1}"),
                                  buildDataRow(
                                      "Project Name:", data['ni_project_name']),
                                  buildDataRow(
                                      "Order Completed On:", formattedDate),
                                  buildDataRow("Water Quantity:",
                                      "${data['ni_water_capacity']} Liter"),
                                  buildDataRow("Tanker No:",
                                      data['ni_tanker_no'].toString()),
                                  buildDataRow("Site Address:",
                                      data['address'].toString()),
                                  buildDataRow("STP Name:",
                                      data['ni_nearest_stp'].toString()),
                                  buildDataRow(
                                      "Distance:", "${data['ni_distance']} Km"),
                                  buildDataRow("Amount:",
                                      "₹ ${data['ni_estimated_amount']}"),
                                  if (status.toString() == "false")
                                    buildDataRow("Status:", "Pending"),
                                  if (status.toString() == "null")
                                    buildDataRow("Status:", "Cancelled"),
                                  if (status.toString() == "true")
                                    buildDataRow("Status:", "Complete"),
                                  const Divider(
                                      thickness: 1, color: Colors.grey),
                                ],
                              );
                            },
                          ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/bottomimage.png'),
          ),
        ),
        height: 70,
      ),
    );
  }
}

// ✅ Responsive Data Row
Widget buildDataRow(String label, String? value) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(
        flex: 2,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Text(
            label,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      Expanded(
        flex: 3,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          child: Text(
            value ?? '',
            style: const TextStyle(fontSize: 17),
          ),
        ),
      ),
    ],
  );
}
