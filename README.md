# FlutterBus
A Flutter (Dart) event bus which support post sticky event.

# Usage

First of all, define event:

```
class TestEvent {

}
```

register（usually put in initState method）

```
EventBus.register(this, onEvent);

void onEvent(TestEvent e){
  print(e);
}
```

emit event anywhere:

```
EventBus.post(new TestEvent());
```

unregister（Usually put in dispose method）
```
EventBus.unRegister(this);
```

# Sticky Event

```
// use postSticky will be sticky event
EventBus.postSticky(new TestEvent());

// remove one
EventBus.removeSticky(eventObj);

// all event with one type
EventBus.removeStickyAll(TestEvent.runtimeType);
```
