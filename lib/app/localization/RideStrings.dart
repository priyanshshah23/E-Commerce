class RideStrings {
  final String totalFare;
  final String riderIsNotHere;
  final String cancelTrip;
  final String cancelDelivery;

  // Home screen
  final String chat;
  final String support;
  final String pickUpNotAvailable;
  final String dropOffNotAvailable;
  final String call;
  final String waitingForRider;
  final String waitingForDeliveryPickup;
  final String eta;

  // Home screen Popup Button
  final String arrivedCap;
  final String arrived;
  final String startCap;
  final String start;
  final String complete;
  final String delivered;
  final String startRideCap;
  final String startDeliveryCap;
  final String endDeliveryCap;
  final String verifySignature;
  final String verifyByDelivery;
  final String completeCap;
  final String acceptCap;
  final String rateRiderCap;
  final String ride;

  // Ride Cancellation Popup
  final String noThanks;

  // Ride delete CustomDialog
  final String deleteRide;
  final String setDefultVehicle;

  // Ride Rating
  final String howWasYourRider;
  final String reason;
  final String selectReason;
  final String addAComment;

  //RideHIstory Screen
  final String rideTime;
  final String deliveryTime;
  final String deliveryCharges;
  final String rideType;
  final String typeOfService;
  final String pickUpLocationText;
  final String dropOffLocationText;
  final String deliveryLocationText;
  final String personText;
  final String online;
  final String cash;
  final String pickupTime;
  final String deliveredTime;
  final String verificationMethod;
  final String contactPerson;
  final String pickupDetail;
  final String deliverDetail;
  final String signature;
  final String deliveryCode;
  final String notDelivered;
  final String reasonForNotDelivered;
  final String deliveryCharge;

  //Ride summary Screen
  final String submitted;
  final String pending;
  final String resolved;
  final String totalRide;
  final String cashCollection;
  final String onlineCollection;
  final String totalCollection;
  final String incentive;
  final String disputeMessage;
  final String disputSuccess;
  final String disputSuccessMsg;
  final String disputId;
  final String yourdisputId;
  final String pickingUp;
  final String delivery;
  final String deliveryCap;
  final String cancelRidewith;
  final String cancelDeliverywith;
  final String pickupNotAvailableFor;
  final String deliveryNotDone;
  final String reasonForCancellation;
  final String areYouSureCancelRide;
  final String areYouSureCancelDelivery;
  final String ratingErroMsg;
  final String rides;
  final String deliveries;

  //Ride Detail Screen
  final String raiseDispute;
  final String paymentMadeSucessfullyByCash;
  final String time;
  final String distance;
  final String dateAndTime;
  final String vehicleUsed;
  final String tripType;
  final String youRated;
  final String remark;
  final String yourComment;
  final String arrivedAtLoc;
  final String arrivedAtDeliveryLoc;
  final String howWasYourRide;
  final String howWasYourCustomer;
  final String howWasYourMerchant;
  final String rateRider;
  final String rateCustomer;
  final String rateMerchant;
  final String droppingOff;
  final String delivering;
  final String arrivedAtDropOff;
  final String areyouSureCompleteRide;
  final String areyouSureCompleteDelivery;
  final String isPayingOnline;
  final String hasPayedOnline;
  final String hasPayedCash;
  final String collectCashpayment;
  final String privateRide;
  final String normalDelivery;
  final String sharingRide;
  final String cancleCharge;

  const RideStrings({
    this.ratingErroMsg = 'Please add comment or rating',
    this.privateRide = 'Normal',
    this.delivery = 'delivery',
    this.deliveryCap = 'Delivery',
    this.verifySignature = 'Verify by signature',
    this.verifyByDelivery = 'Verify by delivery code',
    this.delivering = 'Delivering',
    this.delivered = 'Delivered',
    this.normalDelivery = 'Normal Delivery',
    this.pickUpNotAvailable = 'Pickup Not Available',
    this.dropOffNotAvailable = 'Delivery not done',
    this.sharingRide = 'Sharing',
    this.collectCashpayment = 'Collect Cash Payment from',
    this.hasPayedOnline = 'has paid online',
    this.hasPayedCash = 'has paid cash',
    this.isPayingOnline = 'is paying online',
    this.droppingOff = 'Dropping off',
    this.arrivedAtDropOff = 'Arrived at drop off location of',
    this.areyouSureCompleteRide =
        'Are you sure you want to complete the ride with',
    this.areyouSureCompleteDelivery =
        'Are you sure you want to complete the delivery of',
    this.arrivedAtLoc = "Arrived at pickup location of",
    this.arrivedAtDeliveryLoc = "Arrived at delivery pickup location of",
    this.start = 'Start',
    this.reasonForCancellation = 'Reason for cancellation',
    this.areYouSureCancelRide = 'Are you sure you want to cancel the ride with',
    this.areYouSureCancelDelivery =
        'Are you sure you want to cancel the delivery with',
    this.totalFare = "Total Fare",
    this.resolved = "Resolved",
    this.disputSuccess = "Your dispute has been",
    this.disputSuccessMsg = "successfully submitted",
    this.disputId = "Dispute ID ",
    this.yourdisputId = "Your dispute id is ",
    this.riderIsNotHere = "Rider isn't here",
    this.cancelTrip = "Cancel Ride",
    this.cancelDelivery = "Cancel Delivery",

    // Home screen
    this.chat = "Chat",
    this.support = 'Support',
    this.pickingUp = "Picking up",
    this.call = "Call",
    this.waitingForRider = "Waiting for rider",
    this.waitingForDeliveryPickup = "Waiting for delivery pickup",
    this.eta = "ETA",
    this.cancelRidewith = "Cancel ride with",
    this.cancelDeliverywith = "Cancel delivery with",
    this.pickupNotAvailableFor = "Pickup not available for",
    this.deliveryNotDone = "Delivery not done for",
    // Home screen Popup Button
    this.arrivedCap = "ARRIVED",
    this.arrived = "Arrived",
    this.startCap = "START",
    this.startRideCap = "Start Ride",
    this.startDeliveryCap= "Start Delivery",
    this.endDeliveryCap= "Verify",
    this.completeCap = "COMPLETE",
    this.complete = "Complete",
    this.acceptCap = "ACCEPT",
    this.rateRiderCap = "RATE RIDER",
    this.ride = "Ride",

    // Ride Cancellation Popup
    this.noThanks = "No Thanks!",

    // Ride delete CustomDialog
    this.deleteRide = "Are you sure you want to delete this vehicle?",
    this.setDefultVehicle =
        "Are you sure you want to set this vehicle as default vehicle?",

    // Ride Rating
    this.howWasYourRider = "How was your rider?",
    this.reason = "Reason",
    this.selectReason = "Select Reason",
    this.addAComment = "Add a comment",

    //ridehistory Screen
    this.rideTime = 'Ride Time',
    this.deliveryTime = 'Delivery Time',
    this.deliveryCharges = 'Delivery Charge',
    this.rideType = 'Ride Type',
    this.typeOfService = "Type of Service",
    this.dropOffLocationText = "Drop off location",
    this.deliveryLocationText = "Delivery location",
    this.pickUpLocationText = "Pickup location",
    this.personText = "person",
    this.online = "Online",
    this.cash = "Cash",
    this.pickupTime = "Picked up Time",
    this.deliveredTime = "Delivered Time",
    this.verificationMethod = "Verification Method",
    this.pickupDetail = "Pickup details",
    this.deliverDetail = "Delivery details",
    this.contactPerson = "Contact person",
    this.signature = "Signature",
    this.deliveryCode = "Delivery Code",
    this.notDelivered = "Not Delivered",
    this.reasonForNotDelivered = "Reason for not pickup",
    this.deliveryCharge = "Delivery Charge",

    //Ride summary screen
    this.submitted = "Submitted",
    this.pending = "Pending",
    this.totalRide = "Total\nRide/Delivery",
    this.cashCollection = "Cash\nCollection",
    this.onlineCollection = "Online\nCollection",
    this.totalCollection = "Total\nCollection",
    this.incentive = "Incentive",
    this.rides = "Rides",
    this.deliveries = "Deliveries",

    //Ride Detail screen
    this.raiseDispute = "Raise Dispute",
    this.paymentMadeSucessfullyByCash = "Payment made sucessfully by ",
    this.time = "Time",
    this.distance = "Distance",
    this.dateAndTime = "Date & Time",
    this.vehicleUsed = "Vehicle Used",
    this.tripType = "Trip Type",
    this.youRated = "You rated",
    this.remark = "Remark",
    this.yourComment = "Your Comment",
    this.disputeMessage = "Initiate dispute on recent 4 hours rides",
    this.howWasYourRide = "How was your rider?",
    this.howWasYourCustomer = "How was your customer?",
    this.howWasYourMerchant = "How was your merchant?",
    this.rateRider = "Rate Rider",
    this.rateCustomer = "Rate Customer",
    this.rateMerchant = "Rate Merchant",
    this.cancleCharge = "Cancellation Charge",
  });
}
