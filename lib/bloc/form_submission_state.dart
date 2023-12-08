abstract class FormSubmissionState {
  const FormSubmissionState();
}

class InitialFormState extends FormSubmissionState {
  const InitialFormState();
}

class FormSubmitting extends FormSubmissionState {}

class SubmissionSuccess extends FormSubmissionState {}

class RegisterSuccess extends FormSubmissionState {}

class SubmissionFailed extends FormSubmissionState {
  final String exception;

  const SubmissionFailed(this.exception);
}
