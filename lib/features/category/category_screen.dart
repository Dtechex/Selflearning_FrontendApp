import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:self_learning_app/features/category/bloc/category_bloc.dart';
import 'package:self_learning_app/features/category/bloc/category_state.dart';

class AllCateScreen extends StatelessWidget {
  const AllCateScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        if (state is CategoryLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is CategoryLoaded) {
          if (state.cateList.isNotEmpty) {
            return GridView.builder(
              itemCount: state.cateList.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2),
              itemBuilder: (context, index) {
                return Center(
                  child: Text(state.cateList[index].name.toString()),
                );
              },
            );
          } else {
            return  const Text('No Category Found');
          }
        } else {
          return const Center(
            child: Text('Something went wrong'),
          );
        }
        return SizedBox();
      },

    );

  }

}
