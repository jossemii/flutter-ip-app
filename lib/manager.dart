// Isolates with run function
import 'dart:isolate';

void startManagerIsolated() async {
  Isolate.run(_managerLogic);
}

void _managerLogic() async {
  await Future.delayed(const Duration(seconds: 2));
}