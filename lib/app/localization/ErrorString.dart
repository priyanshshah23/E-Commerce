class ErrorString {
  final String enterEmailOrPhone;
  final String enterPassword;
  final String enterConfirmPassword;
  final String enterRegisterCode;
  final String enterEmail;
  final String enterPhone;
  final String enterValidEmail;
  final String enterValidPhone;
  final String enterValidPassword;
  final String mismatchPassword;
  final String enterAddress;
  final String enterValidAddress;
  final String enterPostalCode;
  final String enterValidPostalCode;
  final String enterFirstName;
  final String enterName;
  final String enterLastName;
  final String enterCurrentPassword;
  final String enterNewPassword;
  final String enterFareAmount;
  final String enterOrderNO;
  final String enterPaymentType;
  final String enterServiceType;
  final String enterValidFareAmount;
  final String enterPassangerNo;
  final String enterValidPassangerNo;
  final String notEnterMorePassangerNo;
  final String drivingLicenseValidationText;
  final String PANCardValidationText;
  final String selectFromDate;
  final String selectToDate;
  final String fromGreaterTo;
  final String enterTitle;
  final String enterDesc;
  final String selectCancellationReason;
  final String enteredCodeNotMatching;
  final String enterOTP;
  final String selectExpiryDate;
  final String pleaseEnterOTP;

  const ErrorString({
    this.selectExpiryDate = 'Please select expiry date.',
    this.enterOTP = 'Please enter code',
    this.pleaseEnterOTP = 'Please enter verification code.',
    this.enteredCodeNotMatching = 'Entered code is not matching. Try again',
    this.selectCancellationReason = 'Please select reason for cancellation',
    this.enterDesc = 'Please enter description.',
    this.enterTitle = 'Please enter title.',
    this.enterEmailOrPhone = 'Please enter email/mobile.',
    this.enterPassword = 'Please enter password.',
    this.enterConfirmPassword = 'Please enter confirm password.',
    this.enterRegisterCode = 'Please enter registration code',
    this.enterEmail = 'Please enter email.',
    this.enterPhone = 'Please enter mobile.',
    this.enterValidEmail = 'Please enter valid email.',
    this.enterValidPhone = 'Please enter 10 digit mobile number.',
    this.enterValidPassword = 'Please enter 6 characters or long password.',
    this.mismatchPassword = 'Password and confirm password is not matching.',
    this.enterFirstName = 'Please enter first name.',
    this.enterName = 'Please enter name.',
    this.enterLastName = 'Please enter last name.',
    this.enterAddress = 'Please enter address.',
    this.enterValidAddress = 'Please enter 10 characters or long address.',
    this.enterPostalCode = 'Please enter postal code.',
    this.enterValidPostalCode = 'Please enter 6 digit numeric postal code.',
    this.enterCurrentPassword = 'Please enter current password.',
    this.enterNewPassword = 'Please enter new password.',
    this.enterFareAmount = 'Please enter sales amount.',
    this.enterOrderNO = 'Please enter order no.',
    this.enterServiceType = 'Please select type of service.',
    this.enterPaymentType = 'Please select payment type.',
    this.enterValidFareAmount = 'Sales amount can not be zero.',
    this.enterPassangerNo = 'Please enter no. of passengers.',
    this.enterValidPassangerNo = 'No. of passengers can not be zero.',
    this.notEnterMorePassangerNo = 'No. of passengers can not be more than seven.',
    this.drivingLicenseValidationText =
        'Please enter 15 digit alphanumeric driving licence number.',
    this.PANCardValidationText =
    'Please enter 10 digit alphanumeric PAN card number.',
    this.selectFromDate = 'Please select from date',
    this.selectToDate = 'Please select to date',
    this.fromGreaterTo = 'To date must be greater than from date',
  });
}
