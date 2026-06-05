// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'teacher_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(teacherService)
final teacherServiceProvider = TeacherServiceProvider._();

final class TeacherServiceProvider
    extends $FunctionalProvider<TeacherService, TeacherService, TeacherService>
    with $Provider<TeacherService> {
  TeacherServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'teacherServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$teacherServiceHash();

  @$internal
  @override
  $ProviderElement<TeacherService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  TeacherService create(Ref ref) {
    return teacherService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TeacherService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TeacherService>(value),
    );
  }
}

String _$teacherServiceHash() => r'545c0d743119dacb1c16cb58e398b8c81a641ef2';
