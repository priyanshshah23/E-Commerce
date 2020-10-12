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

  final String clickHere;
  final String moveToLogIn;

  final String successfullyPwdDesc;
  final String signInAsGuest;

// Forgot Password
  final String emailAddress;
  final String emaillbl;

//Reset Passworg
  final String resetPwdDesc;
  final String backToLogin;
  final String backToHome;

//Enter Mobile Number
  final String mobileNumber;
  final String searchHint;
  final String selectYourCountry;

// OTP Verification
  final String resendCodeIn;
  final String resendCode;
  final String dontReceiveCode;

  // Create Profile
  final String firstName;
  final String lastName;
  final String name;
  final String confirmPassword;
  final String enterYour;
  final String details;
  final String registerCode;
  final String registerCodeDesc;
  final String uploadPhotoDesc;
  final String updateProfile;
  final String postalCode;

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

  const AuthStrings({
    // Login
    this.pleaseEnterCustomerOTP = "Please enter customer ride code.",
    this.pleaseEnterPickupOTP = "Please enter customer pickup code.",
    this.pleaseEnterDeliveryOTP = "Please enter customer delivery code.",
    this.verified = "Verified",
    this.verify = "Verify",
    this.verifyMobileDesc =
        "Please verify mobile number to update the profile.",
    this.verifyNow = 'Verify Now',
    this.password = "Password",
    this.backToHome = "Go to Home",
    this.forgotPassword = "Forgot Your Password?",
    this.signInCap = "Sign In",
    this.moveToLogIn = 'Move to Log In',
    this.dontHaveAnAccount = " to set up your account.",
    this.clickHere = "Click here",
    this.reset = "Reset",
    this.haveRegisterCode = "Have a registration code?",
    this.welcome = "Welcome Back!",
    this.signInAsGuest = "Sign In as Guest",

    // Forgot Password
    this.emaillbl = "Email",
    this.searchInventory = "Search product",
    this.emailAddress = "Email address*",
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
  });
}
