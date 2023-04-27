import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:self_learning_app/features/quick_add/data/bloc/quick_add_bloc.dart';
import 'package:self_learning_app/features/quick_add/data/repo/quick_add_repo.dart';
import 'package:self_learning_app/utilities/extenstion.dart';

class QuickTypeScreen extends StatelessWidget {
  const QuickTypeScreen({Key? key}) : super(key: key);





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quick Adds')),
        body: BlocConsumer<QuickAddBloc,QuickAddState>(builder: (context, state) {
          if (state is QuickAddLoadingState) {
            return const Center(child: CircularProgressIndicator(),);
          } else if (state is QuickAddLoadedState) {
            var list=state.list!.reversed.toList();
            return ListView.builder(
              padding: EdgeInsets.only(left: 5,right: 5,top: 10,bottom: 5),
              shrinkWrap: true,
              itemCount: list.length,
              itemBuilder: (context, index) {
                return  Slidable(

                  // Specify a key if the Slidable is dismissible.
                  key: const ValueKey(0),

                  // The start action pane is the one at the left or the top side.
                  startActionPane: ActionPane(
                    // A motion is a widget used to control how the pane animates.
                    motion: const ScrollMotion(),

                    // A pane can dismiss the Slidable.
                    dismissible: DismissiblePane(

                        onDismissed: () {
                      QuickAddRepo.deletequickAdd(id: list[index].sId!, context: context);
                      context.read<QuickAddBloc>().add(LoadQuickTypeEvent());

                    }),

                    // All actions are defined in the children parameter.
                    children:  [
                      // A SlidableAction can have an icon and/or a label.
                      SlidableAction(
                        onPressed: (context) {
                          QuickAddRepo.deletequickAdd(id: list[index].sId!, context: context);
                          context.read<QuickAddBloc>().add(LoadQuickTypeEvent());
                        },
                        backgroundColor: Color(0xFFFE4A49),
                        foregroundColor: Colors.white,
                        icon: Icons.delete,
                        label: 'Delete',
                      ),
                      // SlidableAction(
                      //   onPressed: (context) {
                      //
                      //   },
                      //   backgroundColor: Color(0xFF21B7CA),
                      //   foregroundColor: Colors.white,
                      //   icon: Icons.share,
                      //   label: 'Share',
                      // ),
                    ],
                  ),

                  // The end action pane is the one at the right or the bottom side.
                  // endActionPane:  ActionPane(
                  //   motion: ScrollMotion(),
                  //   children: [
                  //     SlidableAction(
                  //       // An action can be bigger than the others.
                  //       flex: 2,
                  //       onPressed: (context) {
                  //
                  //       },
                  //       backgroundColor: Color(0xFF7BC043),
                  //       foregroundColor: Colors.white,
                  //       icon: Icons.archive,
                  //       label: 'Archive',
                  //     ),
                  //     SlidableAction(
                  //       onPressed: (context) {
                  //
                  //       },
                  //       backgroundColor: Color(0xFF0392CF),
                  //       foregroundColor: Colors.white,
                  //       icon: Icons.save,
                  //       label: 'Save',
                  //     ),
                  //   ],
                  // ),

                  // The child of the Slidable is what the user sees when the
                  // component is not dragged.
                  child:  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      padding: EdgeInsets.only(top: 7,bottom: 7),
                      decoration: BoxDecoration(
                          color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(10)
                      ),
                      //height: context.screenHeight*0.08,
                        child: Center(
                          child: ListTile(title: Text(list[index].content??'Image Type'),trailing:  Column(
                      children: [
                          Icon(Icons.arrow_right_alt),
                          Icon(Icons.delete),
                      ],
                    )),
                        ),),
                  ),
                );
                  //Card(child: Padding(padding: const EdgeInsets.all(10),child: Text(list[index].content??'Image Type'),),);
              },
            );
          }
          return const Center(child: Text('Something Went Wrong'),);
        }, listener: (BuildContext context, Object? state) {
          // print(state);
          // print('state');
          // if(state is QuickAddErrorState){
          //   ScaffoldMessenger.of(context)
          //     ..hideCurrentSnackBar()
          //     ..showSnackBar(
          //       const SnackBar(content: Text('Opps something went wrong')),
          //     );
          // }
        },));
  }
}
