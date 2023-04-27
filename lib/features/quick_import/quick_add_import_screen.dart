import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:self_learning_app/features/dashboard/dashboard_screen.dart';
import 'package:self_learning_app/features/quick_import/bloc/quick_add_bloc.dart';
import 'package:self_learning_app/utilities/extenstion.dart';

import '../../utilities/colors.dart';
import '../category/bloc/category_bloc.dart';
import '../category/bloc/category_state.dart';

class QuickAddImportScreen extends StatefulWidget {
  final String title;
  final String quickAddId;
  const QuickAddImportScreen({Key? key,required this.title, required this.quickAddId}) : super(key: key);

  @override
  State<QuickAddImportScreen> createState() => _QuickAddImportScreenState();
}


class _QuickAddImportScreenState extends State<QuickAddImportScreen> {

  @override
  void initState() {
    context.read<QuickImportBloc>().add(LoadQuickTypeEvent());
    super.initState();
  }

  String ddvalue='';


  @override
  Widget build(BuildContext context) {
    print('build');
    return Scaffold(
        appBar: AppBar(title: Text(widget.title)),
        body: BlocConsumer<QuickImportBloc,QuickImportState>(
          listener: (context, state) {
            if(state is QuickImportSuccessfullyState){
              context.showSnackBar(const SnackBar(content: Text("added succesfuuly")));
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) {
                return const DashBoardScreen();
              },), (route) => false);
            }
          },
          builder: (context, state) {
            if (state is QuickImportLoadingState) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is QuickImportLoadedState) {
              if (state.list!.isNotEmpty) {
                return Container(
                  padding: const EdgeInsets.only(left: 20, right: 20,top: 50),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      const Text('Add to Category/ Subcategory.',style: TextStyle(
                          fontSize: 19,fontWeight: FontWeight.bold
                      ),),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: context.screenWidth,
                        child: DropdownButtonFormField2(
                          hint: const Text('Choose Category',style: TextStyle(
                            color: Colors.black
                          ),),
                          decoration: InputDecoration(
                            fillColor: Colors.grey,
                            contentPadding: const EdgeInsets.only(left: 10,top: 15,bottom: 15),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            //Add more decoration as you want here
                            //Add label If you want but add hint outside the decoration to be aligned in the button perfectly.
                          ),
                          key: UniqueKey(),
                          value: state.value,
                          items: state.list!.map<DropdownMenuItem<String?>>((e) {
                            return DropdownMenuItem<String>(
                              value: e.sId,
                              child: Text(e.name!),
                            );
                          }).toList(),
                          onChanged: (value) {
                            context.read<QuickImportBloc>().add(ChangeDropValue(title: value,list: state.list));
                          },
                        ),
                      ),
                      SizedBox(
                        height: context.screenHeight*0.2,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: ElevatedButton(onPressed: () {
                          context.read<QuickImportBloc>().add(ButtonPressedEvent(title: widget.title,quickAddId: widget.quickAddId));
                          context.read<CategoryBloc>().add(CategoryLoadEvent());
                        }, child: const Text('Save as Category')),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: ElevatedButton(onPressed: () {
                          context.read<QuickImportBloc>().add(ButtonPressedEvent(title: widget.title,quickAddId: widget.quickAddId,rootId: state.value));
                          context.read<CategoryBloc>().add(CategoryLoadEvent());
                        }, child: const Text('Save as Subcategory')),
                      )
                    ],
                  ),
                );
              } else {
                return const Text('No Category Found');
              }
            } else {
              return const Center(
                child: Text('Something went wrong'),
              );
            }
          },
        ));
  }
}
