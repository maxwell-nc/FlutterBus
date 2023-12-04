# FlutterBus
A Flutter (Dart) event bus which support post sticky event.

Support Null-Safety and Flutter 3.



# Usage

First of all, define event:

```dart
class TestEvent {

}
```

register（usually put in initState method）

```dart
EventBus.register(this, onEvent);

void onEvent(TestEvent e){
  print(e);
}
```

emit event anywhere:

```dart
EventBus.post(TestEvent());
```

unregister（Usually put in dispose method）

```dart
EventBus.unRegister(this);
```

# Sticky Event

```dart
// use postSticky will be sticky event
EventBus.postSticky(TestEvent());

// remove one
EventBus.removeSticky(eventObj);

// all event with one type
EventBus.removeStickyAll(TestEvent.runtimeType);
```

# Other

You can test it on the dartpad online.

