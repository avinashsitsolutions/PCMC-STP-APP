import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DropDownMultiSelect extends StatelessWidget {
  final List<String> options;
  final List<String> selectedValues;
  final String whenEmpty;
  final ValueChanged<List<String>> onChanged;
  final InputDecoration? decoration;
  final int maxLines;

  const DropDownMultiSelect({
    super.key,
    required this.options,
    required this.selectedValues,
    required this.onChanged,
    this.whenEmpty = "Select options",
    this.decoration,
    this.maxLines = 2,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final RxList<String> tempSelected =
            List<String>.from(selectedValues).obs;
        final RxString searchQuery = "".obs;

        await showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              title: Text(whenEmpty),
              content: Obx(() {
                // 🔍 Filter options
                final filteredOptions = options
                    .where((option) => option
                        .toLowerCase()
                        .contains(searchQuery.value.toLowerCase()))
                    .toList();

                // 🔥 Reorder: selected first
                final reorderedOptions = [
                  ...filteredOptions.where((opt) => tempSelected.contains(opt)),
                  ...filteredOptions
                      .where((opt) => !tempSelected.contains(opt)),
                ];

                return SizedBox(
                  width: double.maxFinite,
                  height: MediaQuery.of(context).size.height *
                      0.5, // 🔥 cap height to avoid overflow
                  child: Column(
                    children: [
                      // 🔍 Search bar
                      TextField(
                        decoration: const InputDecoration(
                          hintText: "Search...",
                          prefixIcon: Icon(Icons.search),
                        ),
                        onChanged: (value) => searchQuery.value = value,
                      ),
                      const SizedBox(height: 10),

                      // ✅ If no results
                      if (reorderedOptions.isEmpty)
                        const Expanded(
                          child: Center(
                            child: Text(
                              "No results found",
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        )
                      else
                        // ✅ Scrollable bounded list
                        Expanded(
                          child: ListView.builder(
                            itemCount: reorderedOptions.length,
                            itemBuilder: (context, index) {
                              final option = reorderedOptions[index];
                              final isSelected = tempSelected.contains(option);
                              return CheckboxListTile(
                                title: Text(
                                  option,
                                  style: TextStyle(
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    color:
                                        isSelected ? Colors.blue : Colors.black,
                                  ),
                                ),
                                value: isSelected,
                                onChanged: (bool? value) {
                                  if (value == true) {
                                    tempSelected.add(option);
                                  } else {
                                    tempSelected.remove(option);
                                  }
                                },
                              );
                            },
                          ),
                        ),
                    ],
                  ),
                );
              }),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () {
                    onChanged(List<String>.from(tempSelected));
                    Navigator.pop(ctx);
                  },
                  child: const Text("OK"),
                ),
              ],
            );
          },
        );
      },
      child: InputDecorator(
        decoration: decoration ??
            const InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              suffixIcon: Icon(Icons.arrow_drop_down), // ⬇️ dropdown icon
            ),
        child: Text(
          selectedValues.isEmpty ? whenEmpty : selectedValues.join(", "),
          maxLines: maxLines,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
