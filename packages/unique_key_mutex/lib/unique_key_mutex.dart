library unique_key_mutex;

import 'package:mutex/mutex.dart';

// Import the 'unique_key_mutex' library to use the UniqueKeyMutex class.

// Define an immutable class for creating mutexes with unique keys.
class UniqueKeyMutex {
  // Private constructor that creates an instance of UniqueKeyMutex.
  UniqueKeyMutex._({required String key})
      : _key = key,
        _mutex = Mutex() {
    // Add the created instance to a list of instances for future retrieval.
    _instances.add(this);
  }

  final String _key; // The unique key associated with this mutex.
  final Mutex _mutex; // Mutex used for synchronization.

  // A list to store all created instances of UniqueKeyMutex.
  static final List<UniqueKeyMutex> _instances = [];

  // Factory constructor for creating or retrieving instances of UniqueKeyMutex.
  factory UniqueKeyMutex({required String key}) {
    // Check if an instance with the same key already exists; return it if found.
    for (var instance in _instances) {
      if (instance._key == key) return instance;
    }
    // If no instance with the same key exists, create a new one and return it.
    return UniqueKeyMutex._(key: key);
  }

  // Asynchronously acquire the mutex for the current instance.
  Future<void> acquire() async => await _mutex.acquire();

  // Release the acquired mutex for the current instance.
  void release() => _mutex.release();

  // is mutex acquired
  bool get isLocked => _mutex.isLocked;
}
