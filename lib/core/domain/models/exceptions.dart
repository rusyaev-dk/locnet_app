import 'package:locnet_app/app/app.dart';

abstract class DomainException extends AppException {
  DomainException({required super.message, super.error, super.stackTrace});
}
