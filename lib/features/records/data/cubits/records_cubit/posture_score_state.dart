part of 'posture_score_cubit.dart';

abstract class PostureScoreState extends Equatable {
  const PostureScoreState();

  @override
  List<Object> get props => [];
}

class PostureScoreInitial extends PostureScoreState {}

class PostureScoreLoading extends PostureScoreState {}

class PostureScoreLoaded extends PostureScoreState {
  final int score;
  const PostureScoreLoaded(this.score);

  @override
  List<Object> get props => [score];
}

class PostureScoreError extends PostureScoreState {
  final String message;
  const PostureScoreError(this.message);

  @override
  List<Object> get props => [message];
}
