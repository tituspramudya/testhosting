import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:example/bloc/form_submission_state.dart';
import 'package:example/bloc/login_event.dart';
import 'package:example/bloc/login_state.dart';
import 'package:example/repository/login_repository.dart';
import 'package:example/repository/register_repository.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginRepository loginRepository = LoginRepository();
  final RegisterRepository registerRepository = RegisterRepository();

  LoginBloc() : super(LoginState()) {
    on<isPasswordVisibleChanged>(
        (event, emit) => _onIsPasswordVisibleChanged(event, emit));
    on<FormSubmitted>((event, emit) => _onFormSubmitted(event, emit));
    on<FormRegisterSubmitted>(
        (event, emit) => _onFormRegisterSubmitted(event, emit));
  }

  void _onIsPasswordVisibleChanged(
      isPasswordVisibleChanged event, Emitter<LoginState> emit) {
    emit(state.copyWith(
      isPasswordVisible: !state.isPasswordVisible,
      formSubmissionState: const InitialFormState(),
    ));
  }

  void _onFormSubmitted(FormSubmitted event, Emitter<LoginState> emit) async {
    emit(state.copyWith(formSubmissionState: FormSubmitting()));
    try {
      await loginRepository.login(event.username, event.password);
      emit(state.copyWith(formSubmissionState: SubmissionSuccess()));
    } on FailedLogin catch (e) {
      emit(state.copyWith(
          formSubmissionState: SubmissionFailed(e.errorMessage())));
    } on String catch (e) {
      emit(state.copyWith(formSubmissionState: SubmissionFailed(e)));
    } catch (e) {
      emit(state.copyWith(formSubmissionState: SubmissionFailed(e.toString())));
    }
  }

  void _onFormRegisterSubmitted(
      FormRegisterSubmitted event, Emitter<LoginState> emit) async {
    emit(state.copyWith(formSubmissionState: FormSubmitting()));
    try {
      await registerRepository.register(event.name, event.email, event.password,
          event.telepon, event.tanggalLahir, event.usia);
      emit(state.copyWith(formSubmissionState: RegisterSuccess()));
    } on String catch (e) {
      emit(state.copyWith(formSubmissionState: SubmissionFailed(e)));
    } catch (e) {
      emit(state.copyWith(formSubmissionState: SubmissionFailed(e.toString())));
    }
  }
}
