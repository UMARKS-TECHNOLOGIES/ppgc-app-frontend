import 'package:hooks_riverpod/legacy.dart';

class Package {
  final String title;
  final int percentage;
  final int amount;
  final String date;
  final String name;

  const Package({
    required this.title,
    required this.percentage,
    required this.amount,
    required this.date,
    required this.name,
  });

  factory Package.fromJson(Map<String, dynamic> json) {
    return Package(
      title: json['title'] as String,
      percentage: json['percentage'] as int,
      amount: json['amount'] as int,
      date: json['date'] as String,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'percentage': percentage,
      'amount': amount,
      'date': date,
      'name': name,
    };
  }

  Package copyWith({
    String? title,
    int? percentage,
    int? amount,
    String? date,
    String? name,
  }) {
    return Package(
      title: title ?? this.title,
      percentage: percentage ?? this.percentage,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      name: name ?? this.name,
    );
  }
}

enum Status { loading, loaded, error, idle, creating }

class PackageDraft {
  final String? title;
  final int? percentage;
  final int? amount;
  final String? date;
  final String? name;

  const PackageDraft({
    this.title,
    this.percentage,
    this.amount,
    this.date,
    this.name,
  });

  PackageDraft copyWith({
    String? title,
    int? percentage,
    int? amount,
    String? date,
    String? name,
  }) {
    return PackageDraft(
      title: title ?? this.title,
      percentage: percentage ?? this.percentage,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      name: name ?? this.name,
    );
  }

  bool get isComplete =>
      title != null &&
      percentage != null &&
      amount != null &&
      date != null &&
      name != null;

  Package toPackage() {
    if (!isComplete) {
      throw StateError('PackageDraft is incomplete');
    }

    return Package(
      title: title!,
      percentage: percentage!,
      amount: amount!,
      date: date!,
      name: name!,
    );
  }
}

class InvestmentState {
  final Package newPackage;
  final PackageDraft draft;
  final Status status;
  final String? errorMessage;
  final List<Package> packages;
  final int page;
  final bool isPaginating;
  final bool hasMore;

  const InvestmentState({
    this.draft = const PackageDraft(),

    this.newPackage = const Package(
      amount: 0,
      date: "",
      name: "",
      percentage: 0,
      title: "",
    ),
    this.packages = const [],
    this.status = Status.idle,
    this.errorMessage,
    this.page = 0,
    this.isPaginating = false,
    this.hasMore = true,
  });

  InvestmentState copyWith({
    PackageDraft? draft,

    Package? newPackage,
    Status? status,
    String? errorMessage,
    List<Package>? packages,
    int? page,
    bool? isPaginating,
    bool? hasMore,
  }) {
    return InvestmentState(
      draft: draft ?? this.draft,

      newPackage: newPackage ?? this.newPackage,
      status: status ?? this.status,
      errorMessage: errorMessage,
      packages: packages ?? this.packages,
      page: page ?? this.page,
      isPaginating: isPaginating ?? this.isPaginating,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}

class InvestmentController extends StateNotifier<InvestmentState> {
  InvestmentController() : super(const InvestmentState());

  Future<void> fetchPackages({bool refresh = false}) async {
    if (state.status == Status.loading) return;

    state = state.copyWith(
      status: Status.loading,
      packages: refresh ? [] : state.packages,
      page: refresh ? 0 : state.page,
      hasMore: true,
    );

    try {
      final nextPage = refresh ? 1 : state.page + 1;

      final fetchedPackages = <Package>[];

      state = state.copyWith(
        packages: [...state.packages, ...fetchedPackages],
        status: Status.loaded,
        page: nextPage,
        hasMore: fetchedPackages.isNotEmpty,
      );
    } catch (e) {
      state = state.copyWith(status: Status.error, errorMessage: e.toString());
    }
  }

  Future<void> fetchMore() async {
    if (state.isPaginating || !state.hasMore) return;

    state = state.copyWith(isPaginating: true);

    try {
      final nextPage = state.page + 1;

      final fetchedPackages = <Package>[];

      state = state.copyWith(
        packages: [...state.packages, ...fetchedPackages],
        status: Status.loaded,
        page: nextPage,
        isPaginating: false,
        hasMore: fetchedPackages.isNotEmpty,
      );
    } catch (e) {
      state = state.copyWith(
        status: Status.error,
        errorMessage: e.toString(),
        isPaginating: false,
      );
    }
  }

  Future<void> createPackage() async {
    state = state.copyWith(status: Status.creating);

    try {
      final createdPackage = state.newPackage;

      state = state.copyWith(
        packages: [createdPackage, ...state.packages],
        status: Status.loaded,
      );
    } catch (e) {
      state = state.copyWith(status: Status.error, errorMessage: e.toString());
    }
  }

  void clearError() {
    state = state.copyWith(status: Status.idle, errorMessage: null);
  }

  void resetAll() {
    state = const InvestmentState();
  }

  //   DRAFT

  /// Save partial input from any screen
  void updateDraft({
    String? title,
    int? percentage,
    int? amount,
    String? date,
    String? name,
  }) {
    state = state.copyWith(
      draft: state.draft.copyWith(
        title: title,
        percentage: percentage,
        amount: amount,
        date: date,
        name: name,
      ),
    );
  }

  /// Validate draft before final submit
  bool get canSubmit => state.draft.isComplete;

  /// Commit draft into final Package
  Future<void> submitDraft() async {
    if (!state.draft.isComplete) {
      state = state.copyWith(
        status: Status.error,
        errorMessage: 'Please complete all fields',
      );
      return;
    }

    state = state.copyWith(status: Status.creating);

    try {
      final package = state.draft.toPackage();

      state = state.copyWith(
        packages: [package, ...state.packages],
        draft: const PackageDraft(), // reset draft
        status: Status.loaded,
      );
    } catch (e) {
      state = state.copyWith(status: Status.error, errorMessage: e.toString());
    }
  }

  /// Clear draft manually
  void resetDraft() {
    state = state.copyWith(draft: const PackageDraft());
  }
}

final investmentProvider =
    StateNotifierProvider<InvestmentController, InvestmentState>(
      (ref) => InvestmentController(),
    );
