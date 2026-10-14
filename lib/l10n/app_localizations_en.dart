// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get dashboard => 'Dashboard';

  @override
  String get dashboardLoadError => 'Dashboard Load Error';

  @override
  String get dashboardLoadErrorSubtitle =>
      'Unable to connect to the server. Please check your internet connection.';

  @override
  String get tryAgain => 'Try Again';

  @override
  String get upcomingAppointments => 'Upcoming Appointments';

  @override
  String get noAppointments => 'No Appointments';

  @override
  String get bookAppointmentSubtitle => 'Book an appointment with a doctor';

  @override
  String get bookAppointment => 'Book Appointment';

  @override
  String get patientDashboard => 'Patient Dashboard';

  @override
  String upcomingVisitsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count upcoming visits',
      one: '1 upcoming visit',
    );
    return '$_temp0';
  }

  @override
  String get findYour => 'Find Your';

  @override
  String get bestDoctorNearYou => 'Best Doctor Near You';

  @override
  String get searchNow => 'Search Now';

  @override
  String get noActiveToken => 'No Active Token';

  @override
  String get tokenAppearHere => 'Your token for today will appear here';

  @override
  String get tokenLabel => 'TOKEN';

  @override
  String get waiting => 'WAITING';

  @override
  String servingToken(String token) {
    return 'Serving: $token';
  }

  @override
  String patientsAhead(String count) {
    return '$count ahead';
  }

  @override
  String patientLabel(String name) {
    return 'Patient: $name';
  }

  @override
  String get patientSelf => 'Self';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageHindi => 'Hindi';

  @override
  String get changeLanguage => 'Change Language';

  @override
  String estimatedMinutes(String count) {
    return '$count mins';
  }

  @override
  String get unableToCancelAppointment => 'Unable to cancel appointment';

  @override
  String get appointmentCancelledSuccess =>
      'Appointment cancelled successfully';

  @override
  String get cancelAppointment => 'Cancel Appointment';

  @override
  String get cancelAppointmentConfirmation =>
      'Are you sure you want to cancel this appointment?\n\nThis action cannot be undone.';

  @override
  String get keepAppointment => 'Keep';

  @override
  String get close => 'Close';

  @override
  String get appointmentTitle => 'Appointment';

  @override
  String get detailsTitle => 'Details';

  @override
  String get appointmentInformation => 'Appointment Information';

  @override
  String get clinicInformation => 'Clinic Information';

  @override
  String get clinicAddress => 'Clinic Address';

  @override
  String get patientInfoLabel => 'Patient';

  @override
  String get dateLabel => 'Date';

  @override
  String get timeSlotLabel => 'Time Slot';

  @override
  String get tokenNumberLabel => 'Token';

  @override
  String get clinicLabel => 'Clinic';

  @override
  String get feeLabel => 'Fee';

  @override
  String get cityLabel => 'City';

  @override
  String get experienceLabel => 'Experience';

  @override
  String experienceYears(String count) {
    return '$count Yrs';
  }
}
