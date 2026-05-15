// ignore_for_file: sort_constructors_first

enum UploadableFileType {
  image('image'),
  video('video'),
  doc('doc'),
  audio('audio'),
  file('file');

  const UploadableFileType(this.value);
  final String value;

  @override
  String toString() => value;

  factory UploadableFileType.fromString(String value) =>
      UploadableFileType.values.firstWhere(
        (UploadableFileType e) => e.value == value,
        orElse: () => throw ArgumentError('Unknown UploadableFileType: $value'),
      );
}
