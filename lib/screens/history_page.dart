import 'package:flutter/material.dart';
import '../data/app_data.dart';
import '../widgets/history_card.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() =>
      _HistoryPageState();
}

class _HistoryPageState
    extends State<HistoryPage> {

  String sortOrder =
      'Newest First';

  String selectedType =
      'All Types';

  List<String> getDeviceTypes() {
    final types =
    AppData.history
        .map(
          (e) =>
      e.deviceType,
    )
        .toSet()
        .toList();

    types.sort();

    return [
      'All Types',
      ...types,
    ];
  }

  List getFilteredHistory() {
    var history =
    AppData.history.toList();

    if (selectedType !=
        'All Types') {
      history =
          history.where(
                (item) =>
            item.deviceType ==
                selectedType,
          )
              .toList();
    }

    if (sortOrder ==
        'Newest First') {
      history.sort(
            (a, b) =>
            b.endTime.compareTo(
              a.endTime,
            ),
      );
    } else {
      history.sort(
            (a, b) =>
            a.endTime.compareTo(
              b.endTime,
            ),
      );
    }

    return history;
  }

  @override
  Widget build(BuildContext context) {

    final history =
    getFilteredHistory();

    return Column(
      children: [

        Padding(
          padding:
          const EdgeInsets.all(
            16,
          ),

          child: Row(
            children: [

              Expanded(
                child:
                DropdownButtonFormField<
                    String>(
                  value: sortOrder,
                  isExpanded: true,

                  decoration:
                  const InputDecoration(
                    labelText:
                    'Sort',
                  ),

                  items: const [

                    DropdownMenuItem(
                      value:
                      'Newest First',
                      child: Text(
                        'Newest First',
                      ),
                    ),

                    DropdownMenuItem(
                      value:
                      'Oldest First',
                      child: Text(
                        'Oldest First',
                      ),
                    ),
                  ],

                  onChanged:
                      (value) {
                    setState(() {
                      sortOrder =
                      value!;
                    });
                  },
                ),
              ),

              const SizedBox(
                width: 12,
              ),

              Expanded(
                child:
                DropdownButtonFormField<String>(
                  value: selectedType,
                  isExpanded: true,

                  decoration:
                  const InputDecoration(
                    labelText:
                    'Device Type',
                  ),

                  items:
                  getDeviceTypes()
                      .map(
                        (type) {
                      return DropdownMenuItem(
                        value:
                        type,

                        child:
                        Text(
                          type,
                        ),
                      );
                    },
                  ).toList(),

                  onChanged:
                      (value) {
                    setState(() {
                      selectedType =
                      value!;
                    });
                  },
                ),
              ),
            ],
          ),
        ),

        Expanded(
          child:
          history.isEmpty
              ? const Center(
            child: Text(
              'No Completed Sessions',
              style: TextStyle(
                color:
                Color(
                  0xFF94A3B8,
                ),
              ),
            ),
          )
              : ListView.builder(
            padding:
            const EdgeInsets.symmetric(
              horizontal:
              16,
            ),

            itemCount:
            history.length,

            itemBuilder:
                (
                context,
                index,
                ) {

              final item =
              history[index];

              return Padding(
                padding:
                const EdgeInsets.only(
                  bottom:
                  12,
                ),

                child:
                HistoryCard(
                  item:
                  item,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}