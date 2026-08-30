import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/database/hive_service.dart';
import '../../../../core/database/hive_keys.dart';
import '../../data/models/org_models.dart';

// === Events ===
abstract class OrgEvent extends Equatable {
  const OrgEvent();
  @override
  List<Object?> get props => [];
}

class LoadOrgDataEvent extends OrgEvent {}

class UpdateOrgSetupEvent extends OrgEvent {
  final OrgModel org;
  const UpdateOrgSetupEvent(this.org);
  @override
  List<Object?> get props => [org];
}

class SearchStudentsEvent extends OrgEvent {
  final String query;
  const SearchStudentsEvent(this.query);
  @override
  List<Object?> get props => [query];
}

class AddStudentEvent extends OrgEvent {
  final OrgStudentModel student;
  const AddStudentEvent(this.student);
  @override
  List<Object?> get props => [student];
}

// === State ===
class OrgState extends Equatable {
  final OrgModel org;
  final List<OrgStudentModel> allStudents;
  final List<OrgStudentModel> filteredStudents;
  final List<OrgClassModel> classes;
  final String searchQuery;
  final bool isLoading;

  const OrgState({
    required this.org,
    required this.allStudents,
    required this.filteredStudents,
    required this.classes,
    this.searchQuery = '',
    this.isLoading = false,
  });

  OrgState copyWith({
    OrgModel? org,
    List<OrgStudentModel>? allStudents,
    List<OrgStudentModel>? filteredStudents,
    List<OrgClassModel>? classes,
    String? searchQuery,
    bool? isLoading,
  }) {
    return OrgState(
      org: org ?? this.org,
      allStudents: allStudents ?? this.allStudents,
      filteredStudents: filteredStudents ?? this.filteredStudents,
      classes: classes ?? this.classes,
      searchQuery: searchQuery ?? this.searchQuery,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [org, allStudents, filteredStudents, classes, searchQuery, isLoading];
}

// === BLoC ===
class OrgBloc extends Bloc<OrgEvent, OrgState> {
  OrgBloc()
      : super(OrgState(
          org: _loadSavedOrg(),
          allStudents: _loadSavedStudents(),
          filteredStudents: _loadSavedStudents(),
          classes: OrgRepositoryData.getSampleClasses(),
        )) {
    on<LoadOrgDataEvent>((event, emit) {
      final savedOrg = _loadSavedOrg();
      final savedStudents = _loadSavedStudents();
      emit(state.copyWith(
        org: savedOrg,
        allStudents: savedStudents,
        filteredStudents: savedStudents,
      ));
    });

    on<UpdateOrgSetupEvent>((event, emit) async {
      await HiveService.saveOrgData(HiveKeys.orgDataKey, event.org.toMap());
      emit(state.copyWith(org: event.org));
    });

    on<SearchStudentsEvent>((event, emit) {
      final query = event.query.trim().toLowerCase();
      if (query.isEmpty) {
        emit(state.copyWith(searchQuery: '', filteredStudents: state.allStudents));
      } else {
        final filtered = state.allStudents.where((s) {
          return s.name.toLowerCase().contains(query) || s.className.toLowerCase().contains(query);
        }).toList();
        emit(state.copyWith(searchQuery: query, filteredStudents: filtered));
      }
    });

    on<AddStudentEvent>((event, emit) async {
      final updatedStudents = List<OrgStudentModel>.from(state.allStudents)..insert(0, event.student);
      final rawList = updatedStudents.map((s) => s.toMap()).toList();
      await HiveService.saveOrgData(HiveKeys.orgStudentsKey, rawList);

      emit(state.copyWith(
        allStudents: updatedStudents,
        filteredStudents: updatedStudents,
      ));
    });
  }

  static OrgModel _loadSavedOrg() {
    final raw = HiveService.getOrgData<Map>(HiveKeys.orgDataKey);
    if (raw != null) {
      return OrgModel.fromMap(raw);
    }
    return OrgModel.defaultSample();
  }

  static List<OrgStudentModel> _loadSavedStudents() {
    final raw = HiveService.getOrgData<List>(HiveKeys.orgStudentsKey);
    if (raw != null && raw.isNotEmpty) {
      return raw.map((item) => OrgStudentModel.fromMap(item as Map)).toList();
    }
    return OrgRepositoryData.getSampleStudents();
  }
}
