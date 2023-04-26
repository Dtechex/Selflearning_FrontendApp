
abstract class SubCategory1Event {}


class SubCategory1LoadEvent extends SubCategory1Event{
  final String? rootId;

  SubCategory1LoadEvent({this.rootId});
}

class SubCategory1LoadingEvent extends SubCategory1Event{
  SubCategory1LoadingEvent();
}








