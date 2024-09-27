enum AdStatus {
  none,
  loading,
  loaded,
  failed,
}

extension AdStatusExtension on AdStatus {
  bool isInvalid() => this != AdStatus.loaded;
}
