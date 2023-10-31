part of 'registration_bloc.dart';

// import 'package:flutter/material.dart';

// @immutable

abstract class RegistrationState {}

class RegistrationInitial extends RegistrationState {}

class RegistrationLoading extends RegistrationState {}

class RegistrationLoaded extends RegistrationState {
  final RegistrationResponse registrationResponse;

  RegistrationLoaded(this.registrationResponse);
}

class RegistrationError extends RegistrationState {
  String? error;

  RegistrationError(this.error);
}
