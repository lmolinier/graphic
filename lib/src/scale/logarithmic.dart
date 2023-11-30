import 'dart:math' as dart_math;

import 'package:graphic/src/dataflow/tuple.dart';
import 'package:graphic/src/scale/util/nice_numbers.dart';
import 'package:graphic/src/scale/util/nice_range.dart';

import 'continuous.dart';

/// The specification of a logarithmic scale.
///
/// It converts [num] to [double]s normalized to `[0, 1]` logarithmically.
class LogarithmicScale extends ContinuousScale<num> {
  /// Creates a logarithmic scale.
  LogarithmicScale({
    num? min,
    num? max,
    double? marginMin,
    double? marginMax,
    String? title,
    String? Function(num)? formatter,
    List<num>? ticks,
    int? tickCount,
    bool? niceRange,
  }) : super(
          min: min,
          max: max,
          marginMin: marginMin,
          marginMax: marginMax,
          title: title,
          formatter: formatter,
          ticks: ticks,
          tickCount: tickCount,
          niceRange: niceRange,
        );

  @override
  bool operator ==(Object other) => other is LogarithmicScale && super == other;
}

/// The logarithmic scale converter.
class LogarithmicScaleConv extends ContinuousScaleConv<num> {
  LogarithmicScaleConv(
    LogarithmicScale spec,
    List<Tuple> tuples,
    String variable,
  ) {
    if (spec.min != null && spec.max != null) {
      min = spec.min!;
      max = spec.max!;
    } else {
      // Don't use the first one in case it is NaN.
      num minTmp = double.infinity;
      num maxTmp = double.negativeInfinity;
      for (var tuple in tuples) {
        final value = tuple[variable] as num;
        if (!value.isNaN) {
          minTmp = dart_math.min(minTmp, value);
          maxTmp = dart_math.max(maxTmp, value);
        }
      }

      // If all data are the same, the range is 10, to get a nice margin 1 and avoid
      // 0 problem.
      final range = maxTmp == minTmp ? 10 : maxTmp - minTmp;
      final marginMin = range * (spec.marginMin ?? 0.1);
      final marginMax = range * (spec.marginMax ?? 0.1);
      min = spec.min ?? minTmp - marginMin;
      max = spec.max ?? maxTmp + marginMax;
    }

    final tickCount = spec.tickCount ?? 5;

    if (spec.niceRange == true) {
      final niceRange = logarithmicNiceRange(min!, max!, tickCount);
      min = niceRange.first;
      max = niceRange.last;
    }

    if (spec.ticks != null) {
      ticks = spec.ticks!;
    } else {
      ticks = logarithmicNiceNumbers(min!, max!, tickCount);
    }

    title = spec.title ?? variable;
    formatter = spec.formatter ?? defaultFormatter;
  }

  @override
  double convert(num input) => (input==0?1e-20:dart_math.log(input) - dart_math.log(min!)) / (dart_math.log(max!) - dart_math.log(min!));

  @override
  num invert(double output) => dart_math.pow(min! + output * (max! - min!), 10);

  @override
  num get zero => double.negativeInfinity;

  @override
  String defaultFormatter(num value) => value.toString();

  @override
  bool operator ==(Object other) => other is LogarithmicScaleConv && super == other;
}
