part of 'registration_bloc.dart';

abstract class RegistrationEvent {}

class GetRegistration extends RegistrationEvent {
  String fullName;
  String email;
  String phone;
  String password;

  GetRegistration(
      {required this.fullName,
      required this.email,
      required this.phone,
      required this.password});
}
