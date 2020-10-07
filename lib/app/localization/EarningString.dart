class EarningStrings {
  final String cash;
  final String online;
  final String totalEarning;

  final String availbleHrs;
  final String totalDistance;

  final String earnings;
  final String timeWiseEarnings;
  final String totalTrips;

  final String myAccountBalance;
  final String minimumACbalanceDesc;
  final String inYourAccount;
  final String outstandingBalance;
  final String outstandingBalanceDesc;

  const EarningStrings({
    this.cash = "Cash",
    this.online = "Online",
    this.totalEarning = "Total Earnings",
    this.availbleHrs = "Available hrs",
    this.totalDistance = "Total Distance",
    this.earnings = "Earnings",
    this.timeWiseEarnings = "Time Wise Earnings",
    this.totalTrips = "Total Trips",
    this.myAccountBalance = "Account Balance",
    this.minimumACbalanceDesc = 'You have to keep minimum balance of ',
    this.inYourAccount = ' in your account.',
    this.outstandingBalance = 'Outstanding balance of ',
    this.outstandingBalanceDesc =  ' will be adjusted in your account as and when your online bookings will increase.',
  });
}
