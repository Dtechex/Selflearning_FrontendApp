import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:self_learning_app/features/dashboard/dashboard_screen.dart';
import 'package:self_learning_app/promt/bloc/promt_bloc.dart';

class PromtsScreen extends StatefulWidget {
  final String promtId;
  const PromtsScreen({Key? key, required this.promtId}) : super(key: key);

  @override
  State<PromtsScreen> createState() => _PromtsScreenState();
}

class _PromtsScreenState extends State<PromtsScreen> {
  final PromtBloc promtBloc = PromtBloc();
  final PageController _pageController = PageController();
  int _currentPage = 0;
  int _promtModelLength = 0;

  @override
  void initState() {
    promtBloc.add(LoadPromtEvent(promtId: widget.promtId));
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Widget buildSliderIndicator(int index) {
    return Container(
      width: 10,
      height: 10,
      margin: EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: index == _currentPage ? Colors.blue : Colors.grey,
      ),
    );
  }

  bool isLastPage() {
    return _currentPage == _promtModelLength - 1;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => promtBloc,
      child: Scaffold(

        appBar: AppBar(title: Text('Promts')),
        body: Scaffold(
          bottomSheet: Container(
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
              //  SizedBox(width: 30,),
                ElevatedButton(
                  onPressed: () {
                    if (isLastPage()) {
                      // Handle Finish button press
                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) {
                        return const DashBoardScreen();
                      },), (route) => false);
                    } else {
                      _pageController.nextPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.ease,
                      );
                    }
                  },
                  child: Text(isLastPage() ? 'Finish' : 'Next'),
                ),
              //  SizedBox(width: 30,),

              ],
            ),
          ),
          body: BlocConsumer<PromtBloc, PromtState>(
            listener: (context, state) {},
            builder: (context, state) {
              print(state);
              if (state is PromtLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is PromtError) {
                return Center(
                  child: Text(state.error!),
                );
              } else if (state is PromtLoaded) {
                if (state.promtModel.isEmpty) {
                  return const Center(child: Text('No promts found'),);
                } else {
                  _promtModelLength = state.promtModel.length;
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [

                    Padding(padding: EdgeInsets.only(left: 30,top: 30),child:  Align(
                      alignment: Alignment.topLeft,
                      child:  FloatingActionButton(onPressed: () {

                      },child: Text(_currentPage.toString()),),),),
                      Expanded(
                        child: PageView.builder(
                          controller: _pageController,
                          itemCount: _promtModelLength,
                          onPageChanged: (index) {
                            setState(() {
                              _currentPage = index;
                            });
                          },
                          itemBuilder: (context, index) {
                            return Center(child: Text(state.promtModel[index].content.toString()));
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(_promtModelLength, (index) {
                            return buildSliderIndicator(index);
                          }),
                        ),
                      ),
                    ],
                  );
                }
              }
              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }
}
