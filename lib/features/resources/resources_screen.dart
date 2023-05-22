import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:self_learning_app/features/resources/bloc/resources_bloc.dart';
import 'package:self_learning_app/features/subcategory/model/resources_model.dart';

class AllResourcesList extends StatefulWidget {
  final String rootId;

  const AllResourcesList({Key? key, required this.rootId}) : super(key: key);

  @override
  State<AllResourcesList> createState() => _AllResourcesListState();
}

class _AllResourcesListState extends State<AllResourcesList> {
  final ResourcesBloc resourcesBloc = ResourcesBloc();

  @override
  void initState() {
    resourcesBloc.add(LoadResourcesEvent(rootId: widget.rootId));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => resourcesBloc,
      child: Scaffold(
        appBar: AppBar(title: Text('Resources')),
        body: BlocConsumer<ResourcesBloc, ResourcesState>(
          listener: (context, state) {

          },
          builder: (context, state) {
            if(state is ResourcesLoading){
              return const Center(child: CircularProgressIndicator(),);
            }
            if (state is ResourcesLoaded) {
              return ListView.builder(
                shrinkWrap: true,
                itemCount: 3,
                itemBuilder: (context, index) {
                  return Text(
                      state.allResourcesModel.data!.record![index].content
                          .toString());
                },
              );
            }
            return const Text('someth9ng went wrong');
          },
        ),
      ),
    );
  }
}
