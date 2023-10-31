import 'package:flutter_test/flutter_test.dart';

import '../lib/unique_key_mutex.dart';

void main() {
  test('UniqueKeyMutex test', () async {
    // Create two instances with the same key and one with a different key.
    final mutex1 = UniqueKeyMutex(key: 'key1');
    final mutex2 = UniqueKeyMutex(key: 'key1');
    final mutex3 = UniqueKeyMutex(key: 'key2');

    await mutex1.acquire();
    expect(mutex2.isLocked && mutex1.isLocked && !mutex3.isLocked, true);
    mutex2.release();
    expect(!mutex2.isLocked && !mutex1.isLocked && !mutex3.isLocked, true);
    await mutex2.acquire();
    expect(mutex2.isLocked && mutex1.isLocked && !mutex3.isLocked, true);
    mutex1.release();
    expect(!mutex2.isLocked && !mutex1.isLocked && !mutex3.isLocked, true);
    await mutex3.acquire();
    expect(!mutex2.isLocked && !mutex1.isLocked && mutex3.isLocked, true);
  });
}
