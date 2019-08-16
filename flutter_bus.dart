class EventBus {
  static final EventBus _instance = new EventBus._internal();

  EventBus._internal() {}

  factory EventBus() => _instance;

  ///存放订阅者
  final List _subList = new List<Subscriber>();

  ///存放粘性事件
  ///key:粘性事件的类型
  final Map _sEventMap = new Map<String, List>();

  ///注册接收事件
  ///[target] 注册的对象，需要调用unRegister方法解除注册
  static void register<T>(Object target, SubscriberCall<T> call) {
    _instance.registerInternal<T>(target, call);
  }

  ///取消注册对象所有事件
  static void unRegister(Object target) {
    _instance.unRegisterInternal(target);
  }

  ///发送事件
  ///[sticky] 是否为粘性事件，默认为否
  static void post(event, [bool sticky = false]) {
    _instance.postInternal(event, sticky);
  }

  ///发送Sticky事件，请务必在事件不需要时调用removeSticky方法
  static void postSticky(event) {
    post(event, true);
  }

  ///移除Sticky事件
  static void removeSticky(event) {
    _instance.removeStickyInternal(event);
  }

  ///移除所有同类型的Sticky事件
  static void removeStickyAll(Type type) {
    _instance.removeStickyAllInternal(type);
  }

  void registerInternal<T>(Object target, SubscriberCall<T> call) {
    if (target == null || call == null) {
      return;
    }

    //检查是否为粘性事件
    String tag = T.toString();
    List eventList = _sEventMap[tag];
    var iterator;
    if (eventList != null) {
      iterator = eventList.iterator;
    }
    while (iterator != null && iterator.moveNext()) {
      call(iterator.current);//触发粘性事件
    }

    _subList.add(new Subscriber(target, tag, call));
  }

  void unRegisterInternal(Object target) {
    var iterator;
    if (_subList != null) {
      iterator = _subList.iterator;
    }
    while (iterator != null && iterator.moveNext()) {
      dynamic sb = iterator.current; //执行回调
      //匹配Owner
      if (sb.owner == target) {
        _subList.remove(sb);
      }
    }
  }

  void postInternal(event, bool sticky) {
    String tName = event.runtimeType.toString();
    if (sticky) {
      //添加粘性事件
      _sEventMap[tName] ??= new List();
      _sEventMap[tName].add(event);
    }

    var iterator;
    if (_subList != null) {
      iterator = _subList.iterator;
    }
    while (iterator != null && iterator.moveNext()) {
      dynamic sb = iterator.current; //执行回调
      //匹配Tag
      if (sb.tag == tName) {
        sb.call(event);
      }
    }
  }

  void removeStickyInternal(event) {
    String eventName = event.runtimeType.toString();
    List eventList = _sEventMap[eventName];
    if (eventList != null && eventList.contains(event)) {
      eventList.remove(event);
    }
  }

  void removeStickyAllInternal(Type type) {
    _sEventMap[type.toString()] = null;
  }
}

///订阅者
class Subscriber<T> {
  ///持有对象
  Object owner;

  ///事件Tag
  String tag;

  ///事件回调
  SubscriberCall<T> call;

  Subscriber(this.owner, this.tag, this.call);
}

///订阅者方法
///[T] 订阅的事件类型
typedef void SubscriberCall<T>(T arg);
