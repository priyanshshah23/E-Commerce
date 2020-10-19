//import 'package:fluttertoast/generated/i18n.dart';

class ScreenTitle {
  final String searchDiamond;
  final String signup;
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

// drawer
  final String settings;
  final String notifications;
  final String myEarning;
  final String support;
  final String logout;
  final String skip;
  final String usingApp;
  final String changePassword;

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
  final String addToWatchList;
  final String comment;
  final String offer;
  final String officeView;
  final String hold;
  final String download;
  final String clearSelection;
  final String share;
  final String expDiscPer;
  final String todayDiscPer;


//  Support
  final String accountAndPayment;

  final String searchResult;

  const ScreenTitle({
    this.signup = "Sign up",
    this.expDiscPer = "Exp Disc%",
    this.todayDiscPer = "Today's Disc%",
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

    // drawer
    this.settings = "Settings",
    this.notifications = "Notifications",
    this.logout = "Logout",
    this.usingApp = "Using the app",
    this.myEarning = "My Earnings",
    this.support = "Support",
    this.changePassword = "Change Password",

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
    this.addToWatchList = "Add to Watchlist",
    this.clearSelection = "Clear Selection",
    this.comment = "Comments",
    this.hold = "Hold",
    this.offer = "Offer",
    this.officeView = "Office View",
    this.placeOrder = "Place Order",
    this.share = "Share",
    this.searchResult = "Search Result",
  });
}
