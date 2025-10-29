import 'package:flutter/material.dart';
import 'package:lbef/model/routine_model.dart';
import 'package:lbef/resource/colors.dart';
import 'package:lbef/screen/student/class_routines/widgets/day_data.dart';
import 'package:lbef/screen/student/class_routines/widgets/no_class_routine.dart';
import 'package:lbef/widgets/no_data/no_data_widget.dart';
import 'package:provider/provider.dart';
import 'package:lbef/view_model/class_routine/class_routine_view_model.dart';

class ClassRoutines extends StatefulWidget {
  const ClassRoutines({super.key});

  @override
  State<ClassRoutines> createState() => _ClassRoutinesState();
}

class _ClassRoutinesState extends State<ClassRoutines> {
  int index = 0;

  final ScrollController _scrollController = ScrollController();
  final List<String> days = [
    'Saturday',
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
  ];

  final List<GlobalKey> _tabKeys = List.generate(7, (_) => GlobalKey());

  void fetch() async {
    await Provider.of<ClassRoutineViewModel>(context, listen: false)
        .fetch(context);
  }

  @override
  void initState() {
    super.initState();
    fetch();

    final today = DateTime.now()
        .weekday; // 1 = Mon, 2 = Tue, ..., 5 = Fri, 6 = Sat, 7 = Sun

    // Map Flutter weekday to days list index
    switch (today) {
      case 1: // Monday
        index = 2;
        break;
      case 2: // Tuesday
        index = 3;
        break;
      case 3: // Wednesday
        index = 4;
        break;
      case 4: // Thursday
        index = 5;
        break;
      case 5: // Friday
        index = 6; // Friday is at index 6
        break;
      case 6: // Saturday
        index = 0;
        break;
      case 7: // Sunday
        index = 1;
        break;
    }

    // Retry scrolling after the first frame to ensure tabs are rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToCenter(index);
    });
  }

  void _scrollToCenter(int tabIndex) {
    // Delay slightly to ensure the widget tree is fully built
    Future.delayed(Duration(milliseconds: 100), () {
      final keyContext = _tabKeys[tabIndex].currentContext;
      if (keyContext == null) {
        print(
            'Error: Tab context for index $tabIndex (${days[tabIndex]}) is null');
        // Retry after another frame if context is null
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollToCenter(tabIndex);
        });
        return;
      }

      final box = keyContext.findRenderObject() as RenderBox?;
      if (box == null) {
        print(
            'Error: RenderBox for index $tabIndex (${days[tabIndex]}) is null');
        return;
      }

      final position =
          box.localToGlobal(Offset.zero, ancestor: context.findRenderObject());
      final size = box.size;

      final screenWidth = MediaQuery.of(context).size.width;
      final offset = position.dx + size.width / 2 - screenWidth / 2;

      print(
          'Scrolling to ${days[tabIndex]}: offset=$offset, position.dx=${position.dx}, size.width=${size.width}, screenWidth=$screenWidth');

      _scrollController.animateTo(
        offset.clamp(0.0, _scrollController.position.maxScrollExtent),
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Class Routines",
          style: TextStyle(fontFamily: 'poppins'),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
          iconSize: 18,
        ),
        actions: const [
          Image(
            image: AssetImage('assets/images/lbef.png'),
            width: 70,
            height: 50,
            fit: BoxFit.contain,
          ),
          SizedBox(width: 14),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Consumer<ClassRoutineViewModel>(
                  builder: (context, viewModel, child) {
                    final List<Times>? times = viewModel.currentDetails?.times;
                    final Map<String, dynamic>? detail =
                        viewModel.currentDetails?.detail;
                    final List<DayItem>? days = viewModel.currentDetails?.days;

                    if (viewModel.isLoading) {
                      return const SkeletonLoader();
                    }

                    if (viewModel.currentDetails == null ||
                        times == null ||
                        detail == null ||
                        days == null) {
                      return Column(
                        children: [
                          _buildDayTabs(),
                          const SizedBox(height: 10),
                          SizedBox(
                            height: 100,
                            child: BuildNoData(
                              size,
                              "No Routine available",
                              Icons.calendar_month,
                            ),
                          ),
                        ],
                      );
                    }

                    return Column(
                      children: [
                        _buildDayTabs(),
                        const SizedBox(height: 10),
                        DayDetails(
                          day: this.days[index],
                          times: times,
                          days: days,
                          detail: detail,
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDayTabs() {
    return SingleChildScrollView(
      controller: _scrollController,
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: List.generate(days.length, (i) {
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: InkWell(
              key: _tabKeys[i],
              onTap: () {
                setState(() {
                  index = i;
                });
                _scrollToCenter(i);
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: index == i ? AppColors.primary : Colors.white,
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: AppColors.primary),
                ),
                child: Text(
                  days[i],
                  style: TextStyle(
                    color: index == i ? Colors.white : AppColors.primary,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

// ----------- Skeleton Loader ------------

class SkeletonLoader extends StatelessWidget {
  const SkeletonLoader({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(7, (index) {
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Container(
                  width: 80,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: const Center(child: ShimmerEffect()),
                ),
              );
            }),
          ),
        ),
        const SizedBox(height: 10),
        const Row(
          children: [
            SizedBox(
                width: 80,
                child: Center(child: ShimmerEffect(width: 60, height: 16))),
            Expanded(
                child: Center(child: ShimmerEffect(width: 80, height: 16))),
          ],
        ),
        const SizedBox(height: 20),
        ...List.generate(3, (index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              children: [
                SizedBox(
                    width: 80, child: ShimmerEffect(width: 60, height: 16)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShimmerEffect(width: size.width * 0.5, height: 16),
                      const SizedBox(height: 4),
                      ShimmerEffect(width: size.width * 0.4, height: 12),
                      const SizedBox(height: 4),
                      ShimmerEffect(width: size.width * 0.3, height: 12),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}

class ShimmerEffect extends StatelessWidget {
  final double width;
  final double height;

  const ShimmerEffect({super.key, this.width = 100, this.height = 16});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
