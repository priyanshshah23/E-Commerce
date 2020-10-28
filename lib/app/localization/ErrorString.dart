class ErrorString {
  final String enterEmailOrPhone;
  final String enterPassword;
  final String wrongPassword;
  final String enterConfirmPassword;
  final String enterRegisterCode;
  final String enterEmail;
  final String enterPhone;
  final String enterSkype;
  final String enterSamePassword;
  final String versionError;
  final String enterUsername;
  final String enterValidEmail;
  final String enterValidPhone;
  final String enterValidWhatsappPhone;
  final String enterValidPassword;
  final String mismatchPassword;
  final String enterAddress;
  final String enterValidAddress;
  final String enterPostalCode;
  final String enterValidPostalCode;
  final String enterFirstName;
  final String enterName;
  final String enterLastName;
  final String enterMiddleName;
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
  final String selectInvoiceDate;
  final String selectToDate;
  final String fromGreaterTo;
  final String enterTitle;
  final String enterDesc;
  final String selectCancellationReason;
  final String enteredCodeNotMatching;
  final String enterOTP;
  final String selectExpiryDate;
  final String pleaseEnterOTP;
  final String pleaseEnterCompanyName;
  final String pleaseEnterCompanyCode;
  final String pleaseEnterComment;
  final String pleaseEnterRemarks;
  final String enterPinCode;
  final String enterValidPinCode;
  final String fromValueGreateThanTo;
  final String toValueGreaterThanFrom;

  //Office view
  final String selectAppointmentDate;
  final String selectTimeSlot;
  final String selectVirtualType;
  final String enterComments;
  final String diamondSelectionError;
  final String diamondCompareRemove;
  final String accessDenide;

  const ErrorString({
    this.accessDenide='Access denied',
    this.diamondCompareRemove = 'At least 2 Stones are required to compare.',
    this.diamondSelectionError = 'Please select at least one stone.',
    this.pleaseEnterCompanyName = 'Please enter company name.',
    this.selectInvoiceDate = 'Select Invoice Date',
    this.pleaseEnterComment = 'Please enter comment.',
    this.pleaseEnterRemarks = 'Please enter remarks.',
    this.selectExpiryDate = 'Please select expiry date.',
    this.enterOTP = 'Please enter code',
    this.pleaseEnterOTP = 'Please enter verification code.',
    this.enteredCodeNotMatching = 'Entered code is not matching. Try again',
    this.selectCancellationReason = 'Please select reason for cancellation',
    this.enterDesc = 'Please enter description.',
    this.enterTitle = 'Please enter title.',
    this.enterEmailOrPhone = 'Please enter email/mobile.',
    this.enterPassword = "Password can't be empty. Please enter Password.",
    this.enterConfirmPassword = 'Please enter confirm password.',
    this.enterSkype = "Please Enter Skype.",
    this.enterRegisterCode = 'Please enter registration code',
    this.enterEmail = 'Please enter the Email address.',
    this.enterPhone = 'Please enter Mobile Number.',
    this.enterUsername = "Username can't be empty. Please enter Username.",
    this.enterValidEmail = 'Please enter the valid Email address.',
    this.enterValidPhone = 'Please enter the valid Mobile Number.',
    this.enterValidWhatsappPhone =
        'Please enter the valid WhatsApp Mobile Number.',
    this.enterValidPassword = 'Please enter 6 characters or long password.',
    this.mismatchPassword = 'Password and confirm password is not matching.',
    this.enterFirstName = 'Please enter the First Name.',
    this.enterMiddleName = 'Please enter the Middle Name.',
    this.enterPinCode = 'Please enter the Pin Code.',
    this.enterName = 'Please enter name.',
    this.enterLastName = 'Please enter Last Name.',
    this.enterAddress = 'Please enter address.',
    this.enterValidPinCode = "Enter Valid PinCode.",
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
    this.notEnterMorePassangerNo =
        'No. of passengers can not be more than seven.',
    this.drivingLicenseValidationText =
        'Please enter 15 digit alphanumeric driving licence number.',
    this.PANCardValidationText =
        'Please enter 10 digit alphanumeric PAN card number.',
    this.selectFromDate = 'Please select from date',
    this.selectToDate = 'Please select to date',
    this.fromGreaterTo = 'Selected date must be greater than current date',
    this.wrongPassword =
        "Password must contains, Minimum 8 characters, 1 uppercase alphabet, 1 lower case alphabet, 1 digit, 1 special charater",
    this.fromValueGreateThanTo =
        "From Value should be less than or equal to To value",
    this.toValueGreaterThanFrom =
        "To Value should be greater than or equal to From value",
    this.pleaseEnterCompanyCode = "Please enter company code",
    this.enterSamePassword =
        "Confirm Password does not match with New Password. Please enter confirm password same as New Password.",

    //Office
    this.selectAppointmentDate = "Please select appointment date",
    this.selectTimeSlot = "Please select tiem slot",
    this.enterComments = "Please enter comment",
    this.selectVirtualType = "Please select virtual type",
    this.versionError = "Version Error",
  });
}
