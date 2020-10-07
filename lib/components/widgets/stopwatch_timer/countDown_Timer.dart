import 'dart:async';
import 'package:rxdart/rxdart.dart';

class StopWatchRecord {
  StopWatchRecord({
	this.rawValue,
	this.minute,
	this.second,
	this.displayTime,
	this.hour
  });
  int hour;
  int rawValue;
  int minute;
  int second;
  String displayTime;
}

enum CountDownExecute {
  start, stop, reset,
}

class CountDownTimer {
  CountDownTimer({
	this.onChange,
	this.onChangeSecond,
	this.onChangeMinute,
	this.onChangeHour
  }) {
	_configure();
  }

  final Function(int) onChange;
  final Function(int) onChangeSecond;
  final Function(int) onChangeMinute;
  final Function(int) onChangeHour;


  final PublishSubject<int> elapsedTime = PublishSubject<int>();

  final BehaviorSubject<int> _rawTimeController = BehaviorSubject<int>(seedValue: 0);
  Observable<int> get rawTime => _rawTimeController.stream;

  final BehaviorSubject<DiffDate> _diffDateTimeController = BehaviorSubject<DiffDate>(seedValue: DiffDate(days: 0,hours: 0,min: 0,sec: 0));
  Observable<DiffDate> get diffDateValue => _diffDateTimeController.stream;

  final BehaviorSubject<int> _secondTimeController = BehaviorSubject<int>(seedValue: 0);
  Observable<int> get secondTime => _secondTimeController.stream;

  final BehaviorSubject<int> _minuteTimeController = BehaviorSubject<int>(seedValue: 0);
  Observable<int> get minuteTime => _minuteTimeController.stream;

  final BehaviorSubject<int> _hourTimeController = BehaviorSubject<int>(seedValue: 0);
  Observable<int> get hourTime => _hourTimeController.stream;

  final BehaviorSubject<List<StopWatchRecord>> _recordsController = BehaviorSubject<List<StopWatchRecord>>(seedValue: []);
  Observable<List<StopWatchRecord>> get records => _recordsController.stream;

  final PublishSubject<CountDownExecute> _executeController = PublishSubject<CountDownExecute>();
  Stream<CountDownExecute> get execute => _executeController;
  Sink<CountDownExecute> get onExecute => _executeController.sink;

  Timer _timer;
  int startTime = 0;
  int endTime=0;
  int _stopTime = 0;
  int _second;
  int _minute;
  int _hour;
  int elapsedEpoch = 0;
  DiffDate diffDate;
  List<StopWatchRecord> _records = [];

  static String getDisplayTime(int value, {
	bool minute = true,
	bool hour = true,
	bool second = true,
	bool milliSecond = true,
	String hourRightBreak = ':',
	String minuteRightBreak = ':',
	String secondRightBreak = '.',
  }) {
	final hStr = getDisplayTimeHour(value);
	final mStr = getDisplayTimeMinute(value);
	final sStr = getDisplayTimeSecond(value);
	final msStr = getDisplayTimeMilliSecond(value);
	var result = '';
	if (hour) {

	  result += '$hStr';
	}
	if (minute) {
	  if (hour) {
		result += hourRightBreak;
	  }
	  result += '$mStr';
	}
	if (second) {
	  if (minute) {
		result += minuteRightBreak;
	  }
	  result += '$sStr';
	}
	if (milliSecond) {
	  if (second) {
		result += secondRightBreak;
	  }
	  result += '$msStr';
	}
	return result;
  }

  static String getDateDisplayTime(DiffDate value) {
	return value.days.toString() +':'+
		value.hours.toString() +':'+
		value.min.toString() +':'+
		value.sec.toString() ;
  }

  static int getDateDisplayMinTime(DiffDate value) {
	return	value.min ;
  }
  static int getDateDisplaySecTime(DiffDate value) {
	return	value.sec ;
  }

  static String getDisplayTimeMinute(int value) {
	final m = (value / 60000).floor();
	return m.toString().padLeft(2, '0');
  }
  static String getDisplayTimeHour(int value) {
	final h = (value / 3600000).floor();
	return h.toString().padLeft(2, '0');
  }
  static String getDisplayTimeSecond(int value) {
	final s = (value % 60000 / 1000).floor();
	return s.toString().padLeft(2, '0');
  }

  static String getDisplayTimeMilliSecond(int value) {
	final ms = (value % 1000 / 10).floor();
	return ms.toString().padLeft(2, '0');
  }

  Future dispose() async {
	await elapsedTime.close();
	await _rawTimeController.close();
	await _diffDateTimeController.close();
	await _secondTimeController.close();
	await _minuteTimeController.close();
	await _hourTimeController.close();
	await _recordsController.close();
	await _executeController.close();
	disposeDiffTimer();
  }

  bool isRunning() => _timer != null ? _timer.isActive : false;

  Future _configure() async {


	elapsedTime.listen((value) {

	  _rawTimeController.add(value);
	  if (onChange != null) {
		onChange(value);
	  }
	  final latestSecond = _getSecond(value);
	  if (_second != latestSecond) {
		_secondTimeController.add(latestSecond);
		_second = latestSecond;
		if (onChangeSecond != null) {
		  onChangeSecond(latestSecond);
		}
	  }
	  final latestMinute = _getMinute(value);
	  if (_minute != latestMinute) {
		_minuteTimeController.add(latestMinute);
		_minute = latestMinute;
		if (onChangeMinute != null) {
		  onChangeMinute(latestMinute);
		}
	  }
	  final latestHour = _getHour(value);
	  if (_hour != latestHour) {
		_hourTimeController.add(latestHour);
		_hour = latestHour;
		if (onChangeHour != null) {
		  onChangeHour(latestHour);
		}
	  }
	});

	_executeController
		.where((value) => value != null)
		.listen((value) {
	  switch (value) {
		case CountDownExecute.start:
		  _start();
		  break;
		case CountDownExecute.stop:
		  _stop();
		  break;
		case CountDownExecute.reset:
		  _reset();
		  break;

	  }
	});
  }

  int _getMinute(int value) => (value / 60000).floor();

  int _getHour(int value) {
	return (value / (3600000)).floor();
  }

  int _getSecond(int value) => (value / 1000).floor();

  void _handle(Timer timer) {

	/*if(elapsedEpoch!=0)
	{
	  elapsedTime.add(//DateTime.now().millisecondsSinceEpoch - startTime
		//+
		  _stopTime
			  +(DateTime.now().millisecondsSinceEpoch-elapsedEpoch));

	  //elapsedEpoch = 0;
	}
	else*/
	if(startTime!=0)
	  elapsedTime.add(startTime-DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day,
		  DateTime.now().hour,
		  DateTime.now().minute,
		  DateTime.now().second+30).millisecondsSinceEpoch );
  }

  void _start() {

	if (_timer == null || !_timer.isActive) {
	  startTime = DateTime.now().millisecondsSinceEpoch;
	  _timer = Timer.periodic(const Duration(milliseconds: 1), _handle);
	}
  }
  DiffDate getDateData() {
	if (endTime == null) return null;
	int diff = ((endTime - DateTime
		.now()
		.millisecondsSinceEpoch) / 1000).floor();
	if (diff < 0) {
	  return null;
	}
	int days,
		hours,
		min,
		sec = 0;
	if (diff >= 86400) {
	  days = (diff / 86400).floor();
	  diff -= days * 86400;
	} else {
	  // if days = -1 => Don't show;
	  days = 0;
	}
	if (diff >= 3600) {
	  hours = (diff / 3600).floor();
	  diff -= hours * 3600;
	} else {
//      hours = days == -1 ? -1 : 0;
	  hours = 0;
	}
	if (diff >= 60) {
	  min = (diff / 60).floor();
	  diff -= min * 60;
	} else {
//      min = hours == -1 ? -1 : 0;
	  min = 0;
	}
	sec = diff.toInt();
	return DiffDate(days: days, hours: hours, min: min, sec: sec);
  }


  void _stop() {
	if (_timer != null && _timer.isActive) {
	  _timer.cancel();
	  _timer = null;
	  _stopTime += DateTime.now().millisecondsSinceEpoch - startTime;
	}
  }

  void _reset() {
	if (_timer != null && _timer.isActive) {
	  _timer.cancel();
	  _timer = null;
	}
	startTime = 0;
	_stopTime = 0;
	_second = null;
	_hour = null;
	_minute = null;
	_records = [];
	_recordsController.add(_records);
	elapsedTime.add(0);
	elapsedEpoch = 0;
  }

  void _lap() {
	if (_timer != null && _timer.isActive) {
	  final rawValue = _rawTimeController.value;
	  _records.add(StopWatchRecord(
		rawValue: rawValue,
		hour: _getHour(rawValue),
		minute: _getMinute(rawValue),
		second: _getSecond(rawValue),
		displayTime: getDisplayTime(rawValue),
	  ));
	  _recordsController.add(_records);
	}
  }

  timerDiffDate() {
	DiffDate data = getDateData();
	if (data != null) {
		diffDate = data;
		_diffDateTimeController.add(diffDate);
	} else {
	  return null;
	}
	disposeDiffTimer();
	const period = const Duration(seconds: 1);
	_timer = Timer.periodic(period, (timer) {

	  DiffDate data = getDateData();
	  if (data != null) {

		  diffDate = data;
		  _diffDateTimeController.add(diffDate);


		  checkDateEnd(data);
	  } else {
		disposeDiffTimer();
	  }
	});
  }
  disposeDiffTimer() {
	_timer?.cancel();
	_timer = null;
  }
  void checkDateEnd(DiffDate data) {
	if(data.days == 0 && data.hours == 0 && data.min == 0 && data.sec == 0) {

	  disposeDiffTimer();
	}
  }
}
class DiffDate {
  final int days;
  final int hours;
  final int min;
  final int sec;

  DiffDate({this.days, this.hours, this.min, this.sec});
}