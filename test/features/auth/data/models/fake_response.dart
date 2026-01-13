import 'package:dio/dio.dart';
import 'package:mocktail/mocktail.dart';

class FakeResponse extends Fake implements Response {
  FakeResponse({this.data});

  @override
  final dynamic data;
}
