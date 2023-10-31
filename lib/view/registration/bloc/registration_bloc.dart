import 'package:authentikate/model/network/network_helper.dart';
import 'package:authentikate/model/registration/registration_response.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'registration_event.dart';

part 'registration_state.dart';

class RegistrationBloc extends Bloc<RegistrationEvent, RegistrationState> {
  RegistrationResponse? registrationResponse;
  ApiCall apiCall;

  RegistrationBloc(this.apiCall) : super(RegistrationInitial()) {
    on<GetRegistration>((event, emit) async {
      emit(RegistrationLoading());

      try {
        registrationResponse = await apiCall.createUser(
          event.fullName,
          event.email,
          event.phone,
          event.password,
        );
        emit(RegistrationLoaded(registrationResponse!));
      }
      catch (e) {
        emit (RegistrationError(e.toString()));
      }
    });
  }
}