class IntroStrings {
  final String intro1Title;
  final String intro2Title;
  final String intro3Title;

  final String intro1subtitle;
  final String intro2subtitle;
  final String intro3subtitle;

  final String intro1Desc;
  final String intro2Desc;
  final String intro3Desc;

  final String getStarted;

  const IntroStrings({
    this.intro1Title = "Manage Attendance",
    this.intro2Title = "Manage Ride",
    this.intro3Title = "View Timesheet & Ride History",
    this.intro1subtitle = "is dummy text",
    this.intro2subtitle = "is dummy text",
    this.intro3subtitle = "is dummy text",
    this.intro1Desc =
        "Start and end timer when you start or end duty.",
    this.intro2Desc =
        "Start and end ride when you board and drop passengers.",
    this.intro3Desc =
        "Take a look at attended duty time and finished rides.",
    this.getStarted = "Get Started",
  });
}
