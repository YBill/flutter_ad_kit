/// 自动补充广告策略
///
/// * [none] 不自动补充
/// * [onAdShowed] 广告展示后自动补充
/// * [onAdCompleted] 广告展示失败或被关闭后自动补充
enum RefillTiming {
  none,
  onAdShowed,
  onAdCompleted,
}

class AutoRefillAdPolicy {
  final RefillTiming timing;
  final bool forceRefill;

  AutoRefillAdPolicy({required this.timing, this.forceRefill = false});

  factory AutoRefillAdPolicy.none() => AutoRefillAdPolicy(timing: RefillTiming.none);

  factory AutoRefillAdPolicy.onAdShowed({bool forceRefill = false}) => AutoRefillAdPolicy(timing: RefillTiming.onAdShowed, forceRefill: forceRefill);

  factory AutoRefillAdPolicy.onAdCompleted({bool forceRefill = false}) =>
      AutoRefillAdPolicy(timing: RefillTiming.onAdCompleted, forceRefill: forceRefill);

  static final AutoRefillAdPolicy defaultPolicy = AutoRefillAdPolicy.onAdCompleted();
}
