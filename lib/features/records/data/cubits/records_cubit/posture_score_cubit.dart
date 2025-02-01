import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

part 'posture_score_state.dart';

class PostureScoreCubit extends Cubit<PostureScoreState> {
  final FirebaseFirestore _firestore;
  PostureScoreCubit({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance,
        super(PostureScoreInitial());

  void fetchPostureScore(String userId) {
    emit(PostureScoreLoading());

    _firestore.collection('postureRecords').doc(userId).snapshots().listen(
      (snapshot) {
        if (snapshot.exists) {
          final int postureScore = snapshot.data()?['score'] ?? 0;
          emit(PostureScoreLoaded(postureScore));
        } else {
          emit(PostureScoreError("No posture record found."));
        }
      },
      onError: (error) {
        print(error);
        emit(PostureScoreError(error.toString()));
      },
    );
  }
}
