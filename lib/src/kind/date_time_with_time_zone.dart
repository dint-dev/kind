// Copyright 2021 Gohilla Ltd.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'package:kind/kind.dart';
import 'package:meta/meta.dart';

/// Like [DateTime], but supports any time zone.
///
/// Year must be between 0000 and 9999.
@sealed
class DateTimeWithTimeZone implements Comparable<DateTimeWithTimeZone> {
  static final DateTimeWithTimeZone epoch =
      DateTimeWithTimeZone.fromDateTime(DateTimeKind.epoch);

  /// Microseconds since [epoch].
  final int microsecondsSinceEpochInUtc;

  /// Time zone.
  final Timezone timezone;

  /// Constructs dateTimeWithTimeZone from [DateTime].
  ///
  /// The API is identical to [DateTime()] constructor.
  factory DateTimeWithTimeZone.utc(
    int year, [
    int month = 1,
    int day = 1,
    int hour = 0,
    int minute = 0,
    int second = 0,
    int millisecond = 0,
    int microsecond = 0,
  ]) {
    final dateTime = DateTime.utc(
      year,
      month,
      day,
      hour,
      minute,
      second,
      millisecond,
      microsecond,
    );
    return DateTimeWithTimeZone.fromDateTime(dateTime);
  }

  /// Constructs dateTimeWithTimeZone from [DateTime].
  factory DateTimeWithTimeZone.fromDateTime(DateTime dateTime) {
    final timezone = dateTime.isUtc ? Timezone.utc : Timezone.local;
    return DateTimeWithTimeZone.fromMicrosecondsSinceEpoch(
      dateTime.toUtc().microsecondsSinceEpoch,
      timezone,
    );
  }

  /// Constructs dateTimeWithTimeZone from microseconds since [epoch].
  DateTimeWithTimeZone.fromMicrosecondsSinceEpoch(
    this.microsecondsSinceEpochInUtc, [
    this.timezone = Timezone.utc,
  ]);

  /// Day of the month (1 ... 31).
  int get day => toDateTime().add(timezone.differenceToUtc).day;

  @override
  int get hashCode => microsecondsSinceEpochInUtc.hashCode ^ timezone.hashCode;

  /// Month of the year (1 ... 12).
  int get month => toDateTime().add(timezone.differenceToUtc).month;

  /// Year (0 ... 9999).
  int get year => toDateTime().add(timezone.differenceToUtc).year;

  @override
  bool operator ==(other) =>
      other is DateTimeWithTimeZone &&
      microsecondsSinceEpochInUtc == other.microsecondsSinceEpochInUtc &&
      timezone == other.timezone;

  /// The API is identical to [DateTime.add].
  DateTimeWithTimeZone add(Duration duration) {
    return DateTimeWithTimeZone.fromMicrosecondsSinceEpoch(
      microsecondsSinceEpochInUtc + duration.inMicroseconds,
      timezone,
    );
  }

  @override
  int compareTo(DateTimeWithTimeZone other) {
    final r = microsecondsSinceEpochInUtc
        .compareTo(other.microsecondsSinceEpochInUtc);
    if (r != 0) {
      return r;
    }
    return timezone.compareTo(other.timezone);
  }

  /// The API is identical to [DateTime.difference].
  Duration difference(DateTimeWithTimeZone other) {
    return toDateTime().difference(other.toDateTime());
  }

  /// The API is identical to [DateTime.isAfter].
  bool isAfter(DateTimeWithTimeZone dateTimeWithTimeZone) =>
      microsecondsSinceEpochInUtc
          .compareTo(dateTimeWithTimeZone.microsecondsSinceEpochInUtc) >
      0;

  /// The API is identical to [DateTime.isBefore].
  bool isBefore(DateTimeWithTimeZone dateTimeWithTimeZone) =>
      microsecondsSinceEpochInUtc
          .compareTo(dateTimeWithTimeZone.microsecondsSinceEpochInUtc) <
      0;

  /// The API is identical to [DateTime.subtract].
  DateTimeWithTimeZone subtract(Duration duration) {
    return DateTimeWithTimeZone.fromMicrosecondsSinceEpoch(
      microsecondsSinceEpochInUtc - duration.inMicroseconds,
      timezone,
    );
  }

  /// Constructs [DateTime] from this instance.
  DateTime toDateTime({bool utc = false}) {
    final dateTime = DateTime.fromMicrosecondsSinceEpoch(
      microsecondsSinceEpochInUtc,
      isUtc: true,
    );
    if (utc) {
      return dateTime;
    }
    return dateTime.toLocal();
  }

  /// Returns a string with format "yyyy-MM-ddTHH:mm:ss.mmmuuuZ"
  String toIso8601String() {
    if (timezone == Timezone.utc) {
      return toDateTime(utc: true).toIso8601String();
    }
    final dateTime = toDateTime(utc: true).add(timezone.differenceToUtc);
    final string = dateTime.toIso8601String();
    final stringWithoutZ = string.substring(0, string.length - 1);
    return '$stringWithoutZ${timezone.toIso8601String()}';
  }

  @override
  String toString() {
    return 'DateTimeWithTimeZone.parse("${toIso8601String()}")';
  }

  /// Returns the most precise available dateTimeWithTimeZone.
  ///
  /// Implementation details (that may change in future):
  ///   * In VM, microsecond precision is used.
  ///   * In browsers, millisecond precision is used.
  static DateTimeWithTimeZone now() {
    return DateTimeWithTimeZone.fromDateTime(DateTime.now());
  }

  /// Parses a dateTimeWithTimeZone with format "yyyy-MM-ddTHH:mm:ss.mmmuuuZ".
  ///
  /// If parsing fails, throws [FormatException].
  ///
  /// ## Example
  /// ```
  /// import 'package:kind/kind.dart';
  ///
  /// final dateTimeWithTimeZone = DateTimeWithTimeZone.parse('1970-01-01T02:00:00.009+05:30');
  /// ```
  static DateTimeWithTimeZone parse(String s) {
    var timezone = Timezone.utc;
    if (!(s.endsWith('z') || s.endsWith('Z'))) {
      var i = s.lastIndexOf('+');
      if (i < 0) {
        i = s.lastIndexOf('-');
      }
      if (i == s.length - 3 || i == s.length - 6) {
        timezone = Timezone.parse(s.substring(i));
        s = '${s.substring(0, i)}Z';
      } else {
        s = '${s}Z';
      }
    }
    final dateTime = DateTime.parse(s).subtract(timezone.differenceToUtc);
    return DateTimeWithTimeZone.fromMicrosecondsSinceEpoch(
      dateTime.microsecondsSinceEpoch,
      timezone,
    );
  }

  /// Parses a dateTimeWithTimeZone with format "yyyy-MM-ddTHH:mm:ss.mmmuuuZ".
  ///
  /// If parsing fails, returns null.
  ///
  /// ## Example
  /// ```
  /// import 'package:kind/kind.dart';
  ///
  /// final dateTimeWithTimeZone = DateTimeWithTimeZone.tryParse('1970-01-01T02:00:00.009+05:30');
  /// ```
  static DateTimeWithTimeZone? tryParse(String source) {
    try {
      return parse(source);
    } on FormatException {
      return null;
    }
  }
}

/// Timezone for [DateTimeWithTimeZone];
@sealed
class Timezone implements Comparable<Timezone> {
  static const Timezone utc = Timezone.fromDifferenceToUtc(Duration());

  static DateTime? _localCachedAt;

  static Timezone? _cachedLocal;

  static const _constantTimeZones = <String, Timezone>{
    '-11': Timezone.fromDifferenceToUtc(Duration(hours: -11)),
    '-10': Timezone.fromDifferenceToUtc(Duration(hours: -10)),
    '-09': Timezone.fromDifferenceToUtc(Duration(hours: -9)),
    '-08': Timezone.fromDifferenceToUtc(Duration(hours: -8)),
    '-07': Timezone.fromDifferenceToUtc(Duration(hours: -7)),
    '-06': Timezone.fromDifferenceToUtc(Duration(hours: -6)),
    '-04': Timezone.fromDifferenceToUtc(Duration(hours: -4)),
    '-05': Timezone.fromDifferenceToUtc(Duration(hours: -5)),
    '-03': Timezone.fromDifferenceToUtc(Duration(hours: -3)),
    '-02': Timezone.fromDifferenceToUtc(Duration(hours: -2)),
    '+00': Timezone.fromDifferenceToUtc(Duration(hours: 0)),
    '+01': Timezone.fromDifferenceToUtc(Duration(hours: 1)),
    '+02': Timezone.fromDifferenceToUtc(Duration(hours: 2)),
    '+03': Timezone.fromDifferenceToUtc(Duration(hours: 3)),
    '+04': Timezone.fromDifferenceToUtc(Duration(hours: 4)),
    '+05': Timezone.fromDifferenceToUtc(Duration(hours: 5)),
    '+05:30': Timezone.fromDifferenceToUtc(Duration(hours: 5, minutes: 30)),
    '+06': Timezone.fromDifferenceToUtc(Duration(hours: 6)),
    '+06:30': Timezone.fromDifferenceToUtc(Duration(hours: 6, minutes: 30)),
    '+07': Timezone.fromDifferenceToUtc(Duration(hours: 7)),
    '+08': Timezone.fromDifferenceToUtc(Duration(hours: 8)),
    '+09': Timezone.fromDifferenceToUtc(Duration(hours: 9)),
    '+09:30': Timezone.fromDifferenceToUtc(Duration(hours: 9, minutes: 30)),
    '+10:30': Timezone.fromDifferenceToUtc(Duration(hours: 10, minutes: 30)),
    '+11': Timezone.fromDifferenceToUtc(Duration(hours: 11)),
    '+12': Timezone.fromDifferenceToUtc(Duration(hours: 12)),
  };

  /// Time zone of the current process.
  static Timezone get local {
    final cachedLocal = _cachedLocal;
    final now = DateTime.now();
    if (cachedLocal != null) {
      final cachedAt = _localCachedAt!;
      if (now.difference(cachedAt).inSeconds < 2 &&
          cachedAt.year == now.year &&
          cachedAt.month == now.month &&
          cachedAt.day == now.day) {
        return cachedLocal;
      }
    }
    final result = Timezone.fromDifferenceToUtc(now.timeZoneOffset);
    _localCachedAt = now;
    _cachedLocal = result;
    return result;
  }

  /// Difference to the UTC time zone.
  final Duration differenceToUtc;

  /// Constructs a time zone based on difference to the UTC time zone.
  const Timezone.fromDifferenceToUtc(this.differenceToUtc);

  @override
  int get hashCode => differenceToUtc.hashCode;

  @override
  bool operator ==(other) =>
      other is Timezone && differenceToUtc == other.differenceToUtc;

  @override
  int compareTo(Timezone other) =>
      differenceToUtc.compareTo(other.differenceToUtc);

  /// Builds ISO 8601 string such as "2020-12-31T23:59:59.000000-0500".
  String toIso8601String() {
    final differenceToUtc = this.differenceToUtc;
    if (differenceToUtc == const Duration()) {
      return 'Z';
    }
    final hours = differenceToUtc.inHours;
    final minutes = differenceToUtc.inMinutes % 60;
    final plus = differenceToUtc.inMinutes < 0 ? '' : '+';
    var s = '$plus${hours.toString().padLeft(2, '0')}';
    if (minutes == 0) {
      return s;
    }
    return '$s:${minutes.toString().padLeft(2, '0')}';
  }

  @override
  String toString() {
    if (differenceToUtc == const Duration()) {
      return 'TimeZone.utc';
    }
    return 'TimeZone.fromDifferenceToUtc($differenceToUtc)';
  }

  /// Parses timezone such as "+08:00" (UTC + 8 hours) or "Z" (UTC).
  ///
  /// If parsing fails, throws [FormatException]. Ifprefer no exception to be
  /// thrown, use [tryParse].
  static Timezone parse(String s) {
    if (s == 'Z' || s == 'z') {
      return utc;
    }
    final originalSource = s;
    if (s.endsWith(':00')) {
      s = s.substring(0, s.length - 3);
    }
    final constant = _constantTimeZones[s];
    if (constant != null) {
      return constant;
    }

    // Minutes other than :00?
    var minutes = 0;
    if (s.endsWith(':30')) {
      s = s.substring(0, s.length - 3);
      minutes = 30;
    } else if (s.endsWith(':45')) {
      s = s.substring(0, s.length - 3);
      minutes = 45;
    }

    final hours = int.tryParse(s);

    // Facts from Internet:
    // * Lowest timezone is UTC-12
    // * Highest timezone is UTC+13
    if (hours == null || hours < -12 || hours > 13) {
      throw FormatException('Invalid hours', originalSource);
    }
    return Timezone.fromDifferenceToUtc(Duration(
      hours: hours,
      minutes: hours.sign * minutes,
    ));
  }

  /// Parses timezone such as "+0800" (UTC + 8 hours) or "Z" (UTC).
  ///
  /// If parsing fails, returns null. If you prefer an exception to be thrown,
  /// use [parse].
  static Timezone? tryParse(String s) {
    try {
      return parse(s);
    } on FormatException {
      return null;
    }
  }
}
