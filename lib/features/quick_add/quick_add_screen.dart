import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:self_learning_app/features/quick_add/data/bloc/quick_add_bloc.dart';
import 'package:self_learning_app/features/quick_add/data/repo/quick_add_repo.dart';
import 'package:self_learning_app/features/quick_import/quick_add_import_screen.dart';
import 'package:self_learning_app/utilities/extenstion.dart';

class QuickTypeScreen extends StatelessWidget {
  const QuickTypeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Quick Adds')),
        body: BlocConsumer<QuickAddBloc, QuickAddState>(
          builder: (context, state) {
            if (state is QuickAddLoadingState) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is QuickAddLoadedState) {
              var list = state.list!.reversed.toList();
              return ListView.builder(
                padding: const EdgeInsets.only(left: 5, right: 5, top: 10, bottom: 5),
                shrinkWrap: true,
                itemCount: list.length,
                itemBuilder: (context, index) {
                  return Slidable(
                    key: const ValueKey(0),
                    startActionPane: ActionPane(
                      motion: const ScrollMotion(),
                      dismissible: DismissiblePane(onDismissed: () {
                        QuickAddRepo.deletequickAdd(
                            id: list[index].sId!, context: context);
                        context.read<QuickAddBloc>().add(LoadQuickTypeEvent());
                      }),
                      children: [
                        SlidableAction(
                          onPressed: (context) {
                            QuickAddRepo.deletequickAdd(
                                id: list[index].sId!, context: context);
                            context
                                .read<QuickAddBloc>()
                                .add(LoadQuickTypeEvent());},
                          backgroundColor: Color(0xFFFE4A49),
                          foregroundColor: Colors.white,
                          icon: Icons.delete,
                          label: 'Delete',
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        padding: const EdgeInsets.only(top: 7, bottom: 7),
                        decoration: BoxDecoration(
                            color: Colors.blue[50],
                            borderRadius: BorderRadius.circular(10)),
                        //height: context.screenHeight*0.08,
                        child: Center(
                          child: ListTile(
                              title: Text(list[index].content ?? 'Image Type'),
                              trailing: SizedBox(
                                width: context.screenWidth / 3.5,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        Navigator.push(context,
                                            CupertinoPageRoute(
                                          builder: (context) {
                                            return QuickAddImportScreen(
                                              quickAddId: list[index].sId!,
                                              title: list[index].content ??
                                                  'Image Type',
                                            );
                                          },
                                        ));
                                      },
                                      icon: Icon(Icons.add),
                                    ),
                                    Column(
                                      children: const [
                                        Icon(Icons.arrow_right_alt),
                                        Icon(Icons.delete),
                                      ],
                                    ),
                                  ],
                                ),
                              )),
                        ),
                      ),
                    ),
                  );
                },
              );
            }
            return const Center(
              child: Text('Something Went Wrong'),
            );
          },
          listener: (BuildContext context, Object? state) {},
        ));
  }
}
