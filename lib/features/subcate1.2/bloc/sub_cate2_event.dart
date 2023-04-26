
abstract class SubCategory2Event {}


class SubCategory2LoadEvent extends SubCategory2Event{
  final String? rootId;

  SubCategory2LoadEvent({this.rootId});
}

class SubCategory2LoadingEvent extends SubCategory2Event{
  SubCategory2LoadingEvent();
}








