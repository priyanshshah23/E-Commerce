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
  final String myAccount;

// drawer
  final String home;
  final String search;
  final String quickSearch;
  final String newArrival;
  final String exclusiveDiamonds;
  final String diamondOnAuction;
  final String stoneOfTheDays;

  final String myEnquiry;
  final String upcoming;
  final String myCart;
  final String myComments;
  final String myComment;
  final String myReminder;
  final String reminder;

  final String myWatchlist;
  final String myBid;
  final String myHold;
  final String myOrder;
  final String confirmStone;
  final String myOffice;
  final String myOffer;
  final String myPurchased;
  final String mySavedSearch;
  final String myDemand;
  final String manageAddress;
  final String aboutUs;
  final String contactUs;
  final String changePassword;
  final String logout;

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
  final String delete;

  //Menu Items
  final String enquiry;
  final String placeOrder;
  final String buyNow;
  final String cancelStone;
  final String compare;
  final String compareStones;
  final String addToCart;
  final String addToWatchList;
  final String finalCalculation;
  final String bookOffice;
  final String comment;
  final String offer;
  final String offeredDisc;
  final String offeredPriceCt;
  final String officeView;
  final String hold;
  final String download;
  final String clearSelection;
  final String share;
  final String expDiscPer;
  final String todayDiscPer;
  final String addOffer;
  final String addDemand;
  final String addComment;
  final String addEnquiry;
  final String addToOffice;
  final String hours;
  final String note;
  final String offerMsg;
  final String orderMsg;
  final String finalOffer;
  final String finalDisc;
  final String finalRate;
  final String finalValue;
  final String bidStone;
  final String bidDisc;
  final String bidValue;
  final String bidPricePerCt;

  final String statusHold;
  final String statusOnMemo;
  final String statusAvailable;
  final String statusNew;
  final String statusOffer;
  final String statusMyHold;

//  Support
  final String accountAndPayment;

  final String searchResult;

  // HOme
  final String watchlist;
  final String exclusive;
  final String featuredStones;
  final String stoneOfDay;
  final String savedSearch;
  final String savedAndSearch;
  final String matchPair;
  final String recentSearch;
  final String viewAll;
  final String salesPersonDetail;

  final String searchTitle;
  final String enterSearchTitle;
  final String timeSlots;
  final String selectCustomDate;
  final String availableSlot;
  final String reqOfficeView;
  final String declaimer;

  final String shareStone;
  final String addRemider;
  final String addedInWatchList;
  final String addedInCart;
  final String addedInOffer;
  final String addedInBid;
  final String placeAnOffer;

  const ScreenTitle({
    this.placeAnOffer = "Place an Offer",
    this.addedInWatchList = "Added in Watchlist",
    this.addedInOffer = "Offer Submitted",
    this.addedInCart = "Added in Cart",
    this.addedInBid = "Added in Bid",
    this.myEnquiry = "My Enquiry",
    this.delete = "Delete",
    this.addDemand = "Add Demand",
    this.matchPair = "Match Pair",
    this.savedAndSearch = "Save & Search",
    this.upcoming = "Upcoming",
    this.bidPricePerCt = "Bid Price / Ct",
    this.bidDisc = "Bid Disc",
    this.bidValue = "Bid Value",
    this.bidStone = "Bid Stone",
    this.myCart = "My Cart",
    this.myComment = "My Notes",
    this.compare = "Compare",
    this.compareStones = "Compare Stones",
    this.statusHold = "Hold",
    this.statusOnMemo = "On Memo",
    this.statusAvailable = "Available",
    this.statusNew = "New",
    this.statusOffer = "Offer",
    this.statusMyHold = "My Hold",
    this.signup = "Sign up",
    this.addToOffice = "Add To Office",
    this.addComment = "Add Comment",
    this.addEnquiry = "Add Enquiry",
    this.finalOffer = "Final Offer",
    this.finalDisc = "Final Disc",
    this.finalRate = "Final Rate",
    this.finalValue = "Final Value",
    this.orderMsg =
        "1) The prices mentioned over here are fixed and hence not negotiable. \n2) The grading, parameters mentioned on our website beyond GIA's Grading.",
    this.offerMsg =
        "Offered stone will directly be confirmed if the price gets approved so we request you to be sure before offering. Any stone(s) put in Offer list is not kept on hold for you as it is available for other customer's as well.",
    this.note = "Note",
    this.hours = "Hours",
    this.offeredDisc = "Offered Dis%",
    this.offeredPriceCt = "Offered Pr/Ct",
    this.addOffer = "Add Offer",
    this.expDiscPer = "Expected Discount%",
    this.todayDiscPer = "Today's Disc%",
    this.searchDiamond = "Search Result",
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
    this.reset = "Reset",
    this.yourPassword = "Your Password",
    this.photo = "Photo",
    this.otpDesc =
        "The recovery code was sent to your mobile number. Please enter the code.",
    this.otpVerifyDesc =
        "The verification code was sent to your mobile number. Please enter the code.",
    this.diamondDetail = "Diamond Detail",

    // drawer
    this.home = "Home",
    this.search = "Search",
    this.quickSearch = "Quick Search",
    this.newArrival = "New Arrival",
    this.exclusiveDiamonds = "Exclusive Diamonds",
    this.diamondOnAuction = "Diamond On Auction",
    this.stoneOfTheDays = "Stones of the Day",
    this.myWatchlist = "My Watchlist",
    this.myBid = "My Bid",
    this.myHold = "My Hold",
    this.myOrder = "My Ordered List",
    this.confirmStone = "Confirm Stone",
    this.myOffice = "My Office View",
    this.myOffer = "My Offer List",
    this.myPurchased = "My Purchased History",
    this.mySavedSearch = "My Saved Search",
    this.savedSearch = "Saved Search",
    this.myDemand = "My Demand",
    this.aboutUs = "About Us",
    this.contactUs = "Contact Us",
    this.changePassword = "Change Password",
    this.logout = "Logout",

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

//    Support
    this.accountAndPayment = "Account and Payment",

    //More Menu
    this.enquiry = "Enquiry",
    this.download = "Download",
    this.addToCart = "Add to Cart",
    this.addToWatchList = "Add to Watchlist",
    this.finalCalculation = "Final Calculation",
    this.bookOffice = "Book Office",
    this.clearSelection = "Clear Selection",
    this.comment = "Comments",
    this.hold = "Hold",
    this.offer = "Offer",
    this.officeView = "Office View",
    this.placeOrder = "Place Order",
    this.buyNow = "Buy Now",
    this.cancelStone = "Cancel Stone",
    this.share = "Share",
    this.searchResult = "Search Result",

    //home
    this.watchlist = "Watchlist",
    this.exclusive = "Exclusive",
    this.featuredStones = "Featured Stones",
    this.stoneOfDay = "Stones of Day",
    this.recentSearch = "Recent Search",
    this.viewAll = "View All",
    this.salesPersonDetail = "Sales Person Detail",
    //
    this.searchTitle = "Search Title",
    this.enterSearchTitle = "Enter Search Title",
    this.timeSlots = "Time Slots",
    this.selectCustomDate = "Select Custom date",
    this.availableSlot = "Available Slots",
    this.reqOfficeView = "Request Office View",
    this.myComments = "My Comment",
    this.myReminder = "My Reminder",
    this.reminder = "Reminder",
    this.manageAddress = "Manage Addresses",
    this.myAccount = "My Account",
    this.declaimer = "Disclaimer",
    this.shareStone = "Share Stone",
    this.addRemider = "Add reminder",
  });
}
