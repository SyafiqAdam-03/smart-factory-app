import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Handles the sign-in request and exposes loading / error / success
/// through [AsyncValue].
class SignInController extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      // TODO: call the API tier, e.g.
      // await ref.read(authRepositoryProvider).signIn(email, password);
      await Future<void>.delayed(const Duration(milliseconds: 800));
    });
  }
}

final signInControllerProvider =
    AsyncNotifierProvider<SignInController, void>(SignInController.new);