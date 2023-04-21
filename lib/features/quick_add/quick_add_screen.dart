import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:self_learning_app/features/quick_add/data/bloc/quick_add_bloc.dart';
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
            print(state.list![0].type);
            print('state.list');
            return ListView.builder(
              shrinkWrap: true,
              itemCount: state.list!.length,
              itemBuilder: (context, index) {
                return Card(child: Padding(padding: const EdgeInsets.all(10),child: Text(state.list![index].content??'Image Type'),),);
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
