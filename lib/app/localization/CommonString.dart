class CommonString {
  // button caption
  final String btnSkip;
  final String btnContinue;
  final String btnContinueCap;
  final String btnEdit;
  final String btnSubmit;
  final String btnNextCap;
  final String btnSaveCap;
  final String btnWithdrawCap;
  final String btnSaveAndContinueCap;
  final String btnUnregister;
  final String btnClose;
  final String remove;
  final String refresh;
  final String done;
  final String doneCap;
  final String cancel;
  final String allow;
  final String apply;
  final String cancelCap;
  final String uploadCap;
  final String yesCancelCap;
  final String ok;
  final String fetchLocationMessage;
  final String yes;
  final String no;
  final String btnAddNewAddress;
  final String btnCancel;
  final String btnBookTicket;
  final String btnTakeSelfie;
  final String successfully;
  final String lblAppExit;
  final String lblExit;
  final String openAppSetting;

  //App Update Dialog
  final String notYetAvailable;
  final String updateAvailable;
  final String downloadAppFrom;
  final String playStore;
  final String skipUpdate;

  //Greetings
  final String goodMorning;
  final String goodAfternoon;
  final String goodEvening;

  // Other
  final String reallyExit;
  final String alert;
  final String loading;
  final String error;
  final String jumpToTop;

  // My Vehicle List
  final String selected;

  final String selectCountry;
  final String clickHere;

  final String lblThanx;
  final String lbllogout;
  final String fromDate;
  final String toDate;

  //ADD ADDRESS SCREEN
  final String lblSelectCity;
  final String lblSelectState;
  final String lblSelectCountry;

  //Text field label
  final String lblName;
  final String lblCity;
  final String lblState;
  final String lblMobileNumber;
  final String lblCountry;
  final String lblPinCode;

  //Offers String
  final String lblCode;

  //Order String
  final String lblOrderNo;
  final String lblOrderItem;
  final String lblDelivered;

  //BookingRideSummary
  final String lblTicketReady;
  final String lblPersonTicket;
  final String lblShuttleBus;
  final String lblPickup;
  final String lblDropoff;
  final String lblPassenger;
  final String lblDeliveryNo;
  final String lblPrice;
  final String lblValid;
  final String lblRenew;
  final String lblDeparture;
  final String lblArrived;
  final String lblSendtoFriend;
  final String popupRenewTitle;
  final String popupRenewDesc;
  final String popuplblPassenger;
  final String popuplblCancel;
  final String popupbtnRenew;
  final String ridelblAwesome;
  final String ridelblArrived;
  final String lblRideQues;
  final String lblRideDesc;
  final String ridebtnDone;

  // Payment screen
  final String paymentScreenTitle;
  final String pickuplbl;
  final String droplbl;
  final String makePaymentButtonlbl;
  final String pessangerslbl;
  final String priceBreakuplbl;
  final String tripPricelbl;
  final String taxeslbl;
  final String totallbl;

  // Text filed hint Text
  final String passengerName;
  final String cardNumberhint;
  final String cvvhint;
  final String datehint;

  //  View Ride
  final String pickUpText;
  final String startAtText;
  final String endAtText;
  final String dropOffText;
  final String personText;

  final String btnTryAgain;

  //Dialog Text
  final String enterFareDetails;
  final String enterFareDetailDesc;
  final String btnUnderstand;

//Version Update
  final String btnUpdate;
  final String applicationUpdate;
  final String newVersionMessage;
  final String readMore;

  //Ride bottomsheet
  final String paymentCollected;

  final String addComment;
  final String verify;
  final String save;

  //RS Symbol String
  final String rs;


  const CommonString({
    // button caption
    this.save = 'Save',
    this.verify ='Verify',
    this.readMore = 'Read More',
    this.goodMorning = 'Good Morning',
    this.goodAfternoon = 'Good Afternoon',
    this.goodEvening = 'Good Evening',
    this.btnSkip = "Skip",
    this.btnUpdate = "Update",
    this.btnContinue = "Continue",
    this.btnContinueCap = "CONTINUE",
    this.btnEdit = "Edit",
    this.btnSubmit = "Submit",
    this.btnNextCap = "Next",
    this.btnSaveCap = "Update Password",
    this.btnWithdrawCap = "WITHDRAW",
    this.btnSaveAndContinueCap = "SAVE & CONTINUE",
    this.btnUnregister = "Unregistered Mobile",
    this.btnClose = "Close",
    this.remove = "Remove",
    this.refresh = "Refresh",
    this.fetchLocationMessage = "Please wait we are fetching your location",
    this.done = "Done",
    this.doneCap = "DONE",
    this.cancel = "Cancel",
    this.allow = 'Allow',
    this.apply = 'Apply',
    this.cancelCap = "CANCEL",
    this.uploadCap = "UPLOAD",
    this.yesCancelCap = "YES, CANCEL",
    this.ok = "Ok",
    this.yes = "Yes",
    this.no = "No",
    this.selectCountry = "Select Size",
    this.clickHere = "Click Here",
    this.btnAddNewAddress = "ADD NEW ADDRESS",
    this.btnCancel = "CANCEL",
    this.btnTakeSelfie = "Take Selfie",
    this.successfully = "Successfully",
    this.lblAppExit = "Are you sure you want to exit?",
    this.lblExit = "Exit",
    this.openAppSetting = "Open Settings",

    //App Update Dialog
    this.notYetAvailable = "Not yet available",
    this.updateAvailable = "Update Available!",
    this.downloadAppFrom = "Download application update from",
    this.playStore = "Play Store",
    this.skipUpdate = "Skip Update",

    // Other
    this.reallyExit = "Really exit?",
    this.alert = "Alert!",
    this.loading = "Loading",
    this.error = "Error",
    this.jumpToTop = "Jump to top",

    // My Vehicle List
    this.selected = "Selected",
    this.lbllogout = "Log Out",
    this.lblThanx = "Thank you",

    //ADD ADDRESS SCREEN
    this.lblSelectCity = "Select City",
    this.lblSelectState = "Select State",
    this.lblSelectCountry = "Select Country",

    //Text Field label
    this.lblCity = "City",
    this.lblCountry = "Country",
    this.lblName = "Name",
    this.lblPinCode = "PIN Code",
    this.lblMobileNumber = "Mobile Number",
    this.lblState = "State",

    //Offers String
    this.lblCode = "Code: ",

    //Order String
    this.lblOrderNo = "Order No: ",
    this.lblOrderItem = "Order Item: ",
    this.lblDelivered = "Delivered ",

    //Booking Ride Summary Strings
    this.lblTicketReady = "Your ticket is ready",
    this.lblPersonTicket = "Ticket of 2 person",
    this.lblShuttleBus = "Shuttle Bus",
    this.lblPickup = "Pickup",
    this.lblDropoff = "Dropoff",
    this.lblPassenger = "Passenger",
    this.lblDeliveryNo = "Delivery No.",
    this.lblPrice = "Price",
    this.lblValid = "Valid For",
    this.lblRenew = "Renew",
    this.lblDeparture = "Departure",
    this.lblArrived = "Arrived",
    this.lblSendtoFriend = "Send to friend",
    this.popupRenewTitle = "Renew ticket",
    this.popupRenewDesc =
        "Lorem ipsum dolor sit amet, consectetur elit. Nunc maximus, nulla ut commodo sagittis",
    this.popuplblPassenger = "Passenger",
    this.popuplblCancel = "Cancel",
    this.popupbtnRenew = "Renew",
    this.ridelblAwesome = "Awesome",
    this.ridelblArrived = "You have arrived!",
    this.lblRideQues = "How was your Ride!",
    this.lblRideDesc =
        "Lorem ipsum dolor sit amet, consetetur sadipscing elitr,",
    this.ridebtnDone = "Done",

    // View Ride
    this.dropOffText = "Dropoff",
    this.pickUpText = "Pickup",
    this.startAtText = 'Start at',
    this.endAtText = 'End at',
    this.personText = "person",
    // Payment screen
    this.paymentScreenTitle = "Payment",
    this.pickuplbl = "Pickup",
    this.droplbl = "Dropoff",
    this.makePaymentButtonlbl = "Make payment",
    this.pessangerslbl = "Passengers",
    this.priceBreakuplbl = "Price Breakup",
    this.tripPricelbl = "Trip Price",
    this.taxeslbl = "Taxes",
    this.totallbl = "Total",

    // hint Text
    this.cardNumberhint = "Card Number",
    this.cvvhint = "CVV",
    this.datehint = "MM/YY",
    this.btnBookTicket = "Book ticket",
    this.passengerName = "Passenger name",
    this.btnTryAgain = "Try Again",

    //Dialog text
    this.enterFareDetails = 'Enter Sales Details',
    this.enterFareDetailDesc =
        'You can not move back or change screen without adding sales details.',
    this.fromDate = "From Date",
    this.toDate = "To Date",
    this.btnUnderstand = "I Understand",

//Version Update
    this.applicationUpdate = "Application Update",
    this.newVersionMessage = "A new version of application is available, please update the application to continue.",

    //Ride bottomsheeet
    this.paymentCollected = "Payment Collected",

    this.addComment = "Add a comment",

    //RS Symbol String
    this.rs = "\u20B9",

  });
}
