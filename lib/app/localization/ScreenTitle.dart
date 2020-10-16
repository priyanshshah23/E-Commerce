//import 'package:fluttertoast/generated/i18n.dart';

class ScreenTitle {
  final String searchDiamond;
  final String basic;
  final String advanced;
  final String stoneIdCertNo;
  final String welcomeTo;
  final String welcomeDesc;
  final String forgotPassword;
  final String forgotPasswordDesc;
  final String termsAndCondition;
  final String privacyPolicy;
  final String aboutUS;
  final String otpVerification;
  final String otpVerificationDelivery;
  final String otpVerificationDeliveryDone;
  final String enterOtp;
  final String recoveryCode;
  final String otpDesc;
  final String reset;
  final String yourPassword;
  final String editProfile;
  final String takeSignature;
  final String myProfile;
  final String helptopic;
  final String newRideSharingRequest;
  final String newRequest;
  final String otpVerifyDesc;
  final String diamondDetail;

//popUp
  final String enableLocationTitle;
  final String enableLocationDesc;
  final String enableLocationDescIOS;
  final String manualTime;
  final String changeVehicle;

  final String manualTimeDesc;
  final String enableLocationEndDesc;
  final String rideStartLocDesc;
  final String rideEndLocDesc;
  final String finishRideTitle;
  final String finishRideDeliveryTitle;
  final String endYourRideTitle;
  final String endYourShiftTitle;
  final String endYourAttendanceDescription;
  final String filterByDate;
  final String startResumeTitle;
  final String startResumeDescription;
  final String goToAttendance;
  final String endYourRideDescription;
  final String finishOnGoingRideDescription;
  final String finishOnGoingRideDeliveryDescription;
  final String finishEndLogTimeRideDescription;

// drawer
  final String logTimer;
  final String breakTimer;
  final String rideHistory;
  final String settings;
  final String rideSummary;
  final String notifications;
  final String myEarning;
  final String support;
  final String logout;
  final String skip;
  final String usingApp;
  final String changePassword;
  final String manualRide;
  final String about3eco;
  final String legal;
  final String dispute;
  final String myDispute;

  //fareDetails
  final String fareDetailsTitle;
  final String raiseDispute;
  final String fairAmt;
  final String noOfPassengers;
  final String remarks;
  final String orderNo;
  final String typeOfService;
  final String paymentType;

  // recently view
  final String recentlyView;
  final String uploadImgValidationText;
  final String drivingLicenseHintText;
  final String PANCARDHintText;
  final String drivingLicenceDesc;

//  Ride Screen
  final String viewRide;

  final String uploadBackImageText;
  final String uploadFrontUmgText;
  final String uploadPANCardImgText;
  final String saveContinue;
  final String threeby3;
  final String drivingLicense;
  final String PANCard;
  final String uploadYour;
  final String photo;
  final String remove;
  final String optional;

  // Settings
  final String myVehicle;
  final String personalDocument;
  final String help;
  final String about;
  final String bankDetails;
  final String contactUs;
  final String home;
  final String pending;
  final String rejected;
  final String uploadAgain;
  final String selfie;
  final String selfieDesc;
  final String PanDesc;
  final String expiryDate;
  final String MyAddress;

  //Disput

  final String title;
  final String description;

  //Menu Items
  final String enquiry;
  final String placeOrder;
  final String addToCart;
  final String comment;
  final String offer;
  final String officeView;
  final String hold;
  final String download;
  final String clearSelection;
  final String share;

//  Support
  final String accountAndPayment;

  const ScreenTitle({
    this.searchDiamond = "Search Diamond",
    this.basic = "Basic",
    this.advanced = "Advanced",
    this.stoneIdCertNo = "StoneID/Cert No",
    this.takeSignature = 'Take Signature',
    this.optional = 'Optional',
    this.MyAddress = "My Address",
    this.expiryDate = 'Expiry Date',
    this.drivingLicenceDesc = 'Your driving licence picture',
    this.PanDesc = 'Your PAN card picture',
    this.selfie = 'Selfie',
    this.selfieDesc = 'Your selfie picture',
    this.pending = 'Pending',
    this.rejected = 'Rejected',
    this.uploadAgain = 'Upload',
    this.remove = "Remove",
    this.title = "Title",
    this.description = "Description",
    this.uploadYour = "Upload your",
    this.raiseDispute = "Tell us about it",
    this.drivingLicense = "Driving Licence",
    this.PANCard = 'PAN Card',
    this.threeby3 = "3/3",
    this.saveContinue = "Save and Continue",
    this.uploadFrontUmgText = "Upload Front Side Image",
    this.uploadPANCardImgText = "Upload PAN Card Image",
    this.uploadBackImageText = "Upload Back Side Image",
    this.helptopic = "Help Topics",
    this.newRideSharingRequest = "New Ride Sharing Requests",
    this.newRequest = "New Requests",
    this.welcomeTo = "Welcome to",
    this.welcomeDesc = "Login to your existing account of Mani Jewel",
    this.forgotPassword = "Forgot your",
    this.forgotPasswordDesc =
        "Enter your registered mobile number to recover your password.",
    this.termsAndCondition = "Terms & Conditions",
    this.privacyPolicy = "Privacy Policy",
    this.aboutUS = "About Us",
     this.otpVerification = "Verify Ride Code",
    this.otpVerificationDelivery = "Verify Pickup Code",
    this.otpVerificationDeliveryDone = "Verify Delivery Code",
    this.enterOtp = "Enter 4-digit",
    this.recoveryCode = "Recovery code",
    this.editProfile = "Edit Profile",
    this.myProfile = "My Profile",
    this.skip = "Skip",
    this.reset = "Reset",
    this.yourPassword = "Your Password",
    this.photo = "Photo",
    this.otpDesc =
        "The recovery code was sent to your mobile number. Please enter the code.",
    this.otpVerifyDesc =
        "The verification code was sent to your mobile number. Please enter the code.",
    this.diamondDetail = "Diamond Detail",

    //popup
    this.enableLocationTitle = 'Enable Location Access',
    this.enableLocationDesc = 'Enable location to start shift'
        ' and allow 3eco to access your '
        'location even when you are'
        ' not using the app.',
    this.enableLocationDescIOS =
        'Enable location to start shift and allow 3eco to access your location.',
    this.manualTime = 'Update Setting',
    this.changeVehicle = "Change Vehicle",
    this.manualTimeDesc =
        'Please check your timezone, set it to GMT+5:30 and time must be automatic.',
    this.enableLocationEndDesc =
        'Enable location to end shift and allow 3eco to access your location even when you are not using the app?',
    this.rideStartLocDesc =
        'Enable location to start log timer and allow 3eco to access your location even when you are not using the app?',
    this.rideEndLocDesc =
        'Enable location to end log timer and allow 3eco to access your location even when you are not using the app?',
    this.finishRideTitle = 'Finish Ride',
    this.finishRideDeliveryTitle = 'Finish Ride/Delivery',
    this.finishOnGoingRideDescription = 'You have a ongoing ride.'
        ' Finish ride to start a break.',
    this.finishOnGoingRideDeliveryDescription =
        'You have a ongoing ride/delivery.'
            ' Finish ride/delivery to start a manual ride/delivery.',
    this.finishEndLogTimeRideDescription =
        'You can not end your shift before finishing ongoing ride.',
    this.endYourRideTitle = 'End Ride',
    this.endYourShiftTitle = 'End Shift',
    this.filterByDate = 'Select Filter',
    this.startResumeTitle = 'Start/Resume Shift',
    this.startResumeDescription =
        'Start shift or resume shift to start a ride.',
    this.goToAttendance = 'Go to Timesheet',
    this.endYourAttendanceDescription = 'Are you sure want to end shift?',
    this.endYourRideDescription = 'Are you sure want to end ride?',
    // drawer
    this.logTimer = 'Shift Time',
    this.breakTimer = 'Break Time',
    this.rideHistory = "Ride/Delivery History",
    this.settings = "Settings",
    this.rideSummary = "Ride/Delivery Summary",
    this.notifications = "Notifications",
    this.logout = "Logout",
    this.usingApp = "Using the app",
    this.myEarning = "My Earnings",
    this.support = "Support",
    this.changePassword = "Change Password",
    this.manualRide = "Manual Ride/Delivery",
    this.about3eco = "About 3eco",
    this.legal = "Legal",
    this.dispute = "Dispute",
    this.myDispute = "My Disputes",

    //fairDetails
    this.fareDetailsTitle = 'Enter Sales Details',
    this.fairAmt = 'Sales Amount',
    this.noOfPassengers = 'No. of Passengers',
    this.remarks = 'Remarks',
    this.orderNo = 'Order No.',
    this.typeOfService = 'Type of Service',
    this.paymentType = 'Payment Type*',

    // recently View
    this.recentlyView = "Recently View",
    this.uploadImgValidationText =
        "Upload file must be .jpg, .jpeg, .png or .pdf having size 5 mb or less.",
    this.drivingLicenseHintText = "Driving Licence Number",
    this.PANCARDHintText = "PAN Card Number",

//    Ride Screen
    this.viewRide = "View Rides",

// Settings
    this.myVehicle = "My Vehicle",
    this.personalDocument = "Personal Documents",
    this.help = "HELP",
    this.about = "About",
    this.bankDetails = "Bank Details",
    this.contactUs = "Contact Us",
    this.home = "Home",

//    Support
    this.accountAndPayment = "Account and Payment",

    //More Menu
    this.enquiry = "Enquiry",
    this.download = "Download",
    this.addToCart = "Add to Cart",
    this.clearSelection = "Clear Selection",
    this.comment = "Comment",
    this.hold = "Hold",
    this.offer = "Offer",
    this.officeView = "Office View",
    this.placeOrder = "Place Order",
    this.share = "Share",
  });
}
