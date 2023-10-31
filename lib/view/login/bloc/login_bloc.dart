import 'package:authentikate/model/login/login_response.dart';
import 'package:authentikate/model/network/network_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'login_event.dart';

part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  // LoginBloc(super.initialState);
  LoginResponse? loginResponse;
  ApiCall apiCall;

  LoginBloc(this.apiCall) : super(LoginInitial()) {
    on<GetLogin>(
          (event, emit) async {
        emit(LoginLoading());

        try {
          loginResponse = await apiCall.signInUser(event.email, event.password);
          emit(LoginLoaded(loginResponse!));
        } catch (e) {
          emit(LoginError(e.toString()));
        }
      },
    );
  }
}
