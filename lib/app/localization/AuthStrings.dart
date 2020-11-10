class AuthStrings {
  // Login
  final String password;
  final String forgotPassword;
  final String signInCap;
  final String dontHaveAnAccount;
  final String haveAnAccount;
  final String haveRegisterCode;
  final String inLogin;
  final String welcome;
  final String enterCompanyName;
  final String requiredField;
  final String saveCompanyDetails;
  final String setNewPassword;
  final String promotionText;
  final String signInWithMPIN;

  final String clickHere;
  final String moveToLogIn;

  final String successfullyPwdDesc;
  final String signInAsGuest;

// Forgot Password
  final String emailAddress;
  final String emaillbl;
  final String emailAndUname;

//Reset Passworg
  final String resetPwdDesc;
  final String backToLogin;
  final String backToHome;
  final String companyCode;
  final String oldPassword;

//Enter Mobile Number
  final String mobileNumber;
  final String searchHint;
  final String selectYourCountry;

// OTP Verification
  final String resendCodeIn;
  final String resendCode;
  final String dontReceiveCode;
  final String skype;
  final String whatsApp;

  // Create Profile
  final String firstName;
  final String lastName;
  final String middleName;
  final String name;
  final String confirmPassword;
  final String enterYour;
  final String details;
  final String registerCode;
  final String registerCodeDesc;
  final String uploadPhotoDesc;
  final String updateProfile;
  final String postalCode;
  final String addressLineOne;
  final String addressLineTwo;
  final String addressLineThree;

// Profile
  final String currentPasswordErr;
  final String passwordChanged;
  final String lblLogInErr;
  final String lblProfileSetup;
  final String lblProfileSetupDesc;

  // Personal Documents
  final String removeButton;

  // Change Password
  final String changePassword;
  final String personalDocuments;
  final String assignedAuto;
  final String currentPassword;
  final String newPassword;
  final String confirmNewPassword;

  final String logout;

  // Confirmation Popup
  final String logoutConfirmationMsg;

  // Account
  final String address;
  final String bankerName;
  final String accountNumber;
  final String ifscCode;
  final String natureofOrganization;
  final String designation;
  final String nameofDesignation;
  final String businessRelationshipPeriod;
  final String businessRegistrationNumbr;
  final String nameLable;
  final String uploadFile;
  final String reset;
  final String update;
  final String resetPwd;
  final String pwdReset;
  final String pwdChanged;
  final String gender;
  final String male;
  final String female;
  final String offlineFilter;
  final String searchInventory;
  final String pleaseEnterCustomerOTP;
  final String pleaseEnterPickupOTP;
  final String pleaseEnterDeliveryOTP;

  // Drawer
  final String hoursAvailable;
  final String totalTrips;
  final String totalKMs;
  final String verifyNow;
  final String verified;
  final String verify;
  final String verifyMobileDesc;
  final String pinCode;

  //stoneDetail
  final String companyName;
  final String invoiceDate;
  final String confirmStoneDetail;

  final String editProfileTitle;

  final String passwordNotChange;

  final String rememberPassword;

  final String sendOTP;

  final String resendNow;

  final String didNotReceiveOTP;

  final String sendOTPToEmail;

  final String enterOTP;

  final String backToSignIn;

  final String passwordResetSuccessfully;

  final String signUp;
  final String termsAndCondition;
  final String mustAgreeTermsAndCondition;
  final String forgotPasswordTitle;

  // KYC
  final String uploadKYC;
  final String uploadKycDesc;
  final String hintPhotoIdentityProof;
  final String hintBussinerssProof;
  final String btnFileUpload;
  final String pleaseUploadPhotoProof;
  final String pleaseUploadBussinessProof;
  final String pleaseSelectFileFormat;
  final String kycSubmitted;
  final String kycSubmmittedDesc;
  final String btnMoveToHome;
  final String kYCRejected;
  final String kycRejectedDesc;

  const AuthStrings({
    // Login
    this.setNewPassword = "Set your new password and sign in again.",
    this.enterCompanyName = "Please enter Company Name.",
    this.pleaseEnterCustomerOTP = "Please enter customer ride code.",
    this.pleaseEnterPickupOTP = "Please enter customer pickup code.",
    this.pleaseEnterDeliveryOTP = "Please enter customer delivery code.",
    this.verified = "Verified",
    this.verify = "Verify",
    this.addressLineOne = "Address 1",
    this.addressLineTwo = "Address 2",
    this.addressLineThree = "Address 3",
    this.oldPassword = "Old Password",
    this.skype = "Skype",
    this.whatsApp = "Whatsapp*",
    this.pinCode = "PinCode*",
    this.verifyMobileDesc =
        "Please verify mobile number to update the profile.",
    this.verifyNow = 'Verify Now',
    this.password = "Password",
    this.backToHome = "Go to Home",
    this.forgotPassword = "Forgot Password?",
    this.signInCap = "Sign In",
    this.moveToLogIn = 'Move to Log In',
    this.dontHaveAnAccount = " to set up your account.",
    this.clickHere = "Click here",
    this.reset = "Reset",
    this.haveRegisterCode = "Have a registration code?",
    this.welcome = "Welcome Back!",
    this.signInAsGuest = "Sign In as Guest",
    this.editProfileTitle = "Edit Profile",
    // Forgot Password
    this.emaillbl = "Email",
    this.searchInventory = "Search product",
    this.emailAddress = "Email Address*",
    this.offlineFilter =
        "Unable to find the desired solitaire? We can help you get the best deal from our offline inventory.",
    //Enter Mobile Number
    this.mobileNumber = "Mobile",
    this.searchHint = "Search...",
    this.selectYourCountry = "Select Country",

    // OTP Verification
    this.resendCodeIn = "Resend code in",
    this.resendCode = " Resend",
    this.haveAnAccount = "Already have an account? ",
    this.dontReceiveCode = "If you didn't receive a code! ",
    this.inLogin = " to log in.",

    //Reset Password
    this.resetPwdDesc =
        "Add password and confirm password to reset your password.",
    this.backToLogin = "Back to Log In",

    // Create Profile
    this.firstName = "First Name*",
    this.name = "Username*",
    this.lastName = "Last Name*",
    this.middleName = "Middle Name*",
    this.confirmPassword = "Confirm Password",
    this.currentPasswordErr = "Current Password Error",
    this.passwordChanged = "Password Changed",
    this.lblLogInErr = "Log In Error",
    this.enterYour = "Enter your",
    this.details = "Details",
    this.registerCode = "Registration Code",
    this.registerCodeDesc =
        "Add a registration code to start your enrolment with 3eco.",
    this.uploadPhotoDesc =
        "Take a selfie of your self, face must be clearly visible and don't use side angles.Don't wear goggles while capturing a selfie.",
    this.updateProfile = "Update Profile",
    this.postalCode = "Postal Code*",

    // Personal Documents
    this.removeButton = "Remove",
    this.gender = "Gender",
    this.male = "Male",
    this.female = "Female",

    // Change Password
    this.changePassword = "Change Password",
    this.currentPassword = "Current Password*",
    this.newPassword = "New Password*",
    this.confirmNewPassword = "Confirm Password*",
    this.personalDocuments = 'Personal Documents',
    this.assignedAuto = 'Assigned Auto',
    this.logout = "Log Out",

    // Confirmation Popup
    this.logoutConfirmationMsg = "Are you sure you want to log out?",

    // Account
    this.address = "Address*",
    this.accountNumber = "Account Number",
    this.bankerName = "Bankers Name",
    this.nameLable = "Name",
    this.ifscCode = "IFSC code",
    this.businessRegistrationNumbr = "Business Registration Number",
    this.businessRelationshipPeriod = "Business Relationship Period (In Years)",
    this.designation = "Designation",
    this.nameofDesignation = "Name of ",
    this.natureofOrganization = "Nature of Organization",
    this.uploadFile = "No File Choosen",
    this.update = "UPDATE",
    this.resetPwd = "Reset Password",
    this.pwdReset = "Password reset",
    this.signInWithMPIN = "Sign In with MPIN",
    this.pwdChanged = "Password Changed",
    this.successfullyPwdDesc =
        "You have successfully reset your password. Please use your new password when logging in.",
    this.lblProfileSetup = "Your profile is set up",
    this.lblProfileSetupDesc =
        "We have received your profile details, our support team will activate your account soon. You will receive a notification for the same.",
    // Drawer
    this.hoursAvailable = "Total Shifttime",
    this.totalTrips = "Total\n Rides/Deliveries",
    this.totalKMs = "Total Incentive",
    //Stone detail
    this.confirmStoneDetail = "Confirm Stone Detail",
    this.companyName = "Company Name",
    this.invoiceDate = "Invoice Date",
    this.companyCode = "Company Code",
    this.saveCompanyDetails = "Save Company Details",
    this.passwordNotChange = "Password does not match",
    this.rememberPassword = "Remember Password?",
    this.sendOTP = "Send OTP",
    this.resendNow = "Resend Now",
    this.didNotReceiveOTP = "If you didn't receive an OTP!",
    this.sendOTPToEmail =
        "We will send an OTP to your entered email address or user name. Please enter the email address or user name.",
    this.enterOTP =
        "The OTP has been sent to your registered Email address. Please enter the OTP.",
    this.backToSignIn = "Back to Sign In",
    this.passwordResetSuccessfully = "Password reset successfully.",
    this.emailAndUname = "Email/UserName",
    this.signUp = "Sign Up",
    this.requiredField = "*",
    this.promotionText = "Promotional offers, newsletters and stock updates",
    this.termsAndCondition = "Terms and Condition",
    this.mustAgreeTermsAndCondition =
        "You must agree to terms and condition to Sign In as Guest User",
    this.forgotPasswordTitle = "Forgot Password",

    //KYC
    this.uploadKYC = "Upload KYC",
    this.uploadKycDesc =
        "Please upload your KYC documents to access full features.",
    this.hintPhotoIdentityProof = "Photo Identity Proof*",
    this.hintBussinerssProof = "Business Identity Proof*",
    this.btnFileUpload = "File Upload",
    this.pleaseUploadPhotoProof = "Please upload Photo Identity Proof.",
    this.pleaseUploadBussinessProof = "Please upload Business Identity Proof.",
    this.pleaseSelectFileFormat =
        "Please upload file in any of following formats : .jpg, .jpeg, .png and .pdf",
    this.kycSubmitted = "KYC Submitted",
    this.kycSubmmittedDesc = "Your KYC has been submitted successfully.",
    this.btnMoveToHome = "Move to Home",
    this.kYCRejected = "KYC Rejected",
    this.kycRejectedDesc =
        "Your KYC is rejected. Please upload your KYC documents to access full features.",
  });
}
