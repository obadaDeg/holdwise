import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:holdwise/app/config/colors.dart';
import 'package:holdwise/app/cubits/theme_cubit/theme_cubit.dart';
import 'package:intl/intl.dart';
import 'package:holdwise/features/sensors/data/models/orientation_data.dart';

/// An enum representing filter options.
enum ViolationFilter { day, week, month }

/// A Cubit to manage the filter state.
class FilterCubit extends Cubit<ViolationFilter> {
  FilterCubit() : super(ViolationFilter.day);

  void updateFilter(ViolationFilter filter) => emit(filter);
}

/// A widget that shows a scatter chart of violations.
class ViolationScatterChart extends StatefulWidget {
  final List<OrientationData> violations;
  final DateTime referenceDate;
  final bool displayFilter;

  const ViolationScatterChart({
    Key? key,
    required this.violations,
    required this.referenceDate,
    this.displayFilter = true,
  }) : super(key: key);

  @override
  _ViolationScatterChartState createState() => _ViolationScatterChartState();
}

class _ViolationScatterChartState extends State<ViolationScatterChart> {
  // Tolerance for touch detection (in chart units)
  final double tolerance = 1.0;
  late FilterCubit filterCubit;

  @override
  void initState() {
    super.initState();
    filterCubit = FilterCubit();
  }

  @override
  void dispose() {
    filterCubit.close();
    super.dispose();
  }

  /// Groups the violations based on the selected filter.
  Map<String, List<OrientationData>> _groupViolations(ViolationFilter filter) {
    final grouped = <String, List<OrientationData>>{};

    for (var violation in widget.violations) {
      DateTime dt = DateTime.fromMillisecondsSinceEpoch(violation.timestamp);
      String key = "";
      switch (filter) {
        case ViolationFilter.day:
          // Only include violations for the reference day.
          if (dt.year == widget.referenceDate.year &&
              dt.month == widget.referenceDate.month &&
              dt.day == widget.referenceDate.day) {
            key = "${dt.hour}-${dt.minute}";
          }
          
          break;
        case ViolationFilter.week:
          // Only include violations in the week of the reference date.
          DateTime monday = widget.referenceDate
              .subtract(Duration(days: widget.referenceDate.weekday - 1));
          DateTime sunday = monday.add(const Duration(days: 6));
          if (dt.isAfter(monday.subtract(const Duration(seconds: 1))) &&
              dt.isBefore(sunday.add(const Duration(days: 1)))) {
            key = "${dt.weekday}-${dt.hour}-${dt.minute}";
          }
          break;
        case ViolationFilter.month:
          // Only include violations in the reference month.
          if (dt.year == widget.referenceDate.year &&
              dt.month == widget.referenceDate.month) {
            key = "${dt.day}-${dt.hour}-${dt.minute}";
          }
          break;
      }
      if (key.isNotEmpty) {
        grouped.putIfAbsent(key, () => []).add(violation);
      }
    }
    return grouped;
  }

  /// Creates scatter spots based on the grouped violations.
  List<ScatterSpot> _createScatterSpots(
    Map<String, List<OrientationData>> groupedViolations,
    ViolationFilter filter,
  ) {
    final spots = <ScatterSpot>[];

    groupedViolations.forEach((key, violationsList) {
      DateTime dt =
          DateTime.fromMillisecondsSinceEpoch(violationsList.first.timestamp);
      double x = 0, y = 0;
      switch (filter) {
        case ViolationFilter.day:
          x = dt.hour.toDouble();
          y = dt.minute.toDouble();
          break;
        case ViolationFilter.week:
          x = dt.weekday.toDouble();
          y = dt.hour + dt.minute / 60.0;
          break;
        case ViolationFilter.month:
          x = dt.day.toDouble();
          y = dt.hour + dt.minute / 60.0;
          break;
      }
      spots.add(
        ScatterSpot(
          x,
          y,
          // Increase dot radius for easier tap detection.
          dotPainter: FlDotCirclePainter(
            radius: 8,
            color: AppColors.primary500,
          ),
          xError: FlErrorRange(lowerBy: tolerance, upperBy: tolerance),
          yError: FlErrorRange(lowerBy: tolerance, upperBy: tolerance),
        ),
      );
    });

    return spots;
  }

  /// Opens a bottom sheet modal to allow filter selection.
  void _openFilterModal() {
    final themeCubit = context.read<ThemeCubit>();
    final isDarkMode = themeCubit.state == ThemeMode.dark;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allows flexible sizing
      backgroundColor: Colors.transparent, // To show rounded corners
      builder: (BuildContext context) {
        // Provide the FilterCubit so the bottom sheet can update filter state.
        return BlocProvider.value(
          value: filterCubit,
          child: FractionallySizedBox(
            widthFactor: 1,
            heightFactor: 0.7, // Adjust as needed
            child: Container(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
                bottom: MediaQuery.of(context).padding.bottom + 20,
              ),
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.grey[850] : Colors.white,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Select Filter",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 16),
                  BlocBuilder<FilterCubit, ViolationFilter>(
                    builder: (context, selectedFilter) {
                      return Wrap(
                        spacing: 8,
                        children: ViolationFilter.values.map((filterValue) {
                          String filterText;
                          switch (filterValue) {
                            case ViolationFilter.day:
                              filterText = "Day";
                              break;
                            case ViolationFilter.week:
                              filterText = "Week";
                              break;
                            case ViolationFilter.month:
                              filterText = "Month";
                              break;
                          }
                          return ChoiceChip(
                            label: Text(filterText),
                            selected: selectedFilter == filterValue,
                            onSelected: (bool selected) {
                              if (selected) {
                                context
                                    .read<FilterCubit>()
                                    .updateFilter(filterValue);
                              }
                            },
                          );
                        }).toList(),
                      );
                    },
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      setState(() {
                        // Trigger rebuild when a new filter is applied.
                      });
                    },
                    child: const Text("Apply"),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// Displays a dialog with details for a group of violations.
  void _showViolationDetails(List<OrientationData> violationsList) {
    final count = violationsList.length;
    final averageTilt = violationsList
            .map((v) => v.tiltAngle)
            .reduce((a, b) => a + b) /
        count;
    final minTilt = violationsList
        .map((v) => v.tiltAngle)
        .reduce((a, b) => a < b ? a : b);
    final maxTilt = violationsList
        .map((v) => v.tiltAngle)
        .reduce((a, b) => a > b ? a : b);

    showDialog(
      context: context,
      builder: (context) {
        final isDarkMode =
            context.watch<ThemeCubit>().state == ThemeMode.dark;
        return AlertDialog(
          backgroundColor: isDarkMode ? Colors.grey[850] : Colors.white,
          title: Text(
            "Violation Details ($count)",
            style: TextStyle(
                color: isDarkMode ? Colors.white : Colors.black),
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Summary:",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text("Average Tilt: ${averageTilt.toStringAsFixed(1)}°"),
                Text("Min Tilt: ${minTilt.toStringAsFixed(1)}°"),
                Text("Max Tilt: ${maxTilt.toStringAsFixed(1)}°"),
                const SizedBox(height: 10),
                const Text("Individual Violations:",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const Divider(),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: violationsList.length,
                  itemBuilder: (context, index) {
                    final v = violationsList[index];
                    final dt = DateTime.fromMillisecondsSinceEpoch(v.timestamp);
                    final formattedTime =
                        DateFormat('yyyy-MM-dd HH:mm:ss').format(dt);
                    return ListTile(
                      title:
                          Text("Tilt: ${v.tiltAngle.toStringAsFixed(1)}°"),
                      subtitle: Text("Time: $formattedTime"),
                    );
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Wrap the UI with a BlocProvider that provides the FilterCubit.
    return BlocProvider.value(
      value: filterCubit,
      // Use a Builder to obtain a context that is a descendant of the FilterCubit provider.
      child: Builder(
        builder: (context) {
          final themeCubit = context.watch<ThemeCubit>();
          final isDarkMode = themeCubit.state == ThemeMode.dark;
          final currentFilter = context.watch<FilterCubit>().state;
          final groupedViolations = _groupViolations(currentFilter);
          final scatterSpots = _createScatterSpots(groupedViolations, currentFilter);

          // Set axis ranges based on the selected filter.
          double minX, maxX, minY, maxY;
          switch (currentFilter) {
            case ViolationFilter.day:
              minX = 0;
              maxX = 23;
              minY = 0;
              maxY = 59;
              break;
            case ViolationFilter.week:
              minX = 1;
              maxX = 7;
              minY = 0;
              maxY = 24;
              break;
            case ViolationFilter.month:
              minX = 1;
              maxX = 31;
              minY = 0;
              maxY = 24;
              break;
          }
          
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Filter button row (aligned to the end)
              widget.displayFilter ?
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "Filter: ${currentFilter.toString().split('.').last}",
                    style: TextStyle(
                        color: isDarkMode ? Colors.white : Colors.black),
                  ),
                  IconButton(
                    icon: Icon(Icons.filter_list,
                        color: isDarkMode ? Colors.white : Colors.black),
                    onPressed: _openFilterModal,
                  ),
                ],
              )
              : const SizedBox(),
              // The scatter chart container.
              Container(
                height: 300,
                padding: const EdgeInsets.all(8),
                child: ScatterChart(
                  ScatterChartData(
                    scatterSpots: scatterSpots,
                    minX: minX,
                    maxX: maxX,
                    minY: minY,
                    maxY: maxY,
                    borderData: FlBorderData(show: true),
                    gridData: FlGridData(show: true),
                    titlesData: FlTitlesData(
                      rightTitles:
                          AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      topTitles:
                          AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 20,
                          getTitlesWidget: (value, meta) => Text(
                            value.toStringAsFixed(0),
                            style: TextStyle(
                                color: isDarkMode ? Colors.white : Colors.black),
                          ),
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 20,
                          getTitlesWidget: (value, meta) {
                            String label = value.toStringAsFixed(0);
                            if (currentFilter == ViolationFilter.week) {
                              const weekdays = [
                                "Mon",
                                "Tue",
                                "Wed",
                                "Thu",
                                "Fri",
                                "Sat",
                                "Sun"
                              ];
                              int index = value.toInt() - 1;
                              if (index >= 0 && index < weekdays.length) {
                                label = weekdays[index];
                              }
                            }
                            return Text(
                              label,
                              style: TextStyle(
                                  color:
                                      isDarkMode ? Colors.white : Colors.black),
                            );
                          },
                        ),
                      ),
                    ),
                    scatterTouchData: ScatterTouchData(
                      enabled: true,
                      handleBuiltInTouches: true,
                      touchTooltipData: ScatterTouchTooltipData(
                        getTooltipColor: (ScatterSpot touchedSpot) =>
                            AppColors.primary500,
                        getTooltipItems: (ScatterSpot touchedSpot) {
                          String? keyFound;
                          groupedViolations.forEach((key, violationsList) {
                            DateTime dt = DateTime.fromMillisecondsSinceEpoch(
                                violationsList.first.timestamp);
                            double spotX = 0, spotY = 0;
                            switch (currentFilter) {
                              case ViolationFilter.day:
                                spotX = dt.hour.toDouble();
                                spotY = dt.minute.toDouble();
                                break;
                              case ViolationFilter.week:
                                spotX = dt.weekday.toDouble();
                                spotY = dt.hour + dt.minute / 60.0;
                                break;
                              case ViolationFilter.month:
                                spotX = dt.day.toDouble();
                                spotY = dt.hour + dt.minute / 60.0;
                                break;
                            }
                            if ((spotX - touchedSpot.x).abs() < tolerance &&
                                (spotY - touchedSpot.y).abs() < tolerance) {
                              keyFound = key;
                            }
                          });

                          if (keyFound != null) {
                            final violations = groupedViolations[keyFound]!;
                            final count = violations.length;
                            final avgAngle = violations
                                    .map((v) => v.tiltAngle)
                                    .reduce((a, b) => a + b) /
                                count;
                            final dt = DateTime.fromMillisecondsSinceEpoch(
                                violations.first.timestamp);
                            return ScatterTooltipItem(
                              "Violations: $count\nTime: ${dt.toString()}\nAvg Tilt: ${avgAngle.toStringAsFixed(1)}°",
                              textStyle: const TextStyle(color: Colors.white),
                            );
                          }
                          return ScatterTooltipItem("");
                        },
                      ),
                      touchCallback:
                          (FlTouchEvent event, ScatterTouchResponse? touchResponse) {
                        if (touchResponse?.touchedSpot != null &&
                            event is! FlPanEndEvent &&
                            event is! FlLongPressEnd) {
                          final touchedSpot = touchResponse!.touchedSpot!;
                          String? keyFound;
                          groupedViolations.forEach((key, violationsList) {
                            DateTime dt = DateTime.fromMillisecondsSinceEpoch(
                                violationsList.first.timestamp);
                            double spotX = 0, spotY = 0;
                            switch (currentFilter) {
                              case ViolationFilter.day:
                                spotX = dt.hour.toDouble();
                                spotY = dt.minute.toDouble();
                                break;
                              case ViolationFilter.week:
                                spotX = dt.weekday.toDouble();
                                spotY = dt.hour + dt.minute / 60.0;
                                break;
                              case ViolationFilter.month:
                                spotX = dt.day.toDouble();
                                spotY = dt.hour + dt.minute / 60.0;
                                break;
                            }
                            if ((spotX - touchedSpot.spotIndex).abs() < tolerance &&
                                (spotY - touchedSpot.spotIndex).abs() < tolerance) {
                              keyFound = key;
                            }
                          });
                          if (keyFound != null) {
                            final violationsList = groupedViolations[keyFound]!;
                            _showViolationDetails(violationsList);
                          }
                        }
                      },
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
