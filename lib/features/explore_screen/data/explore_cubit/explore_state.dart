part of 'explore_cubit.dart';

abstract class ExploreState extends Equatable {
  const ExploreState();

  @override
  List<Object> get props => [];
}

class ExploreLoaded extends ExploreState {
  final List<ArticleModel> articles;
  final List<AdviceModel> advices;
  final bool isArticlesLoading;
  final bool isAdvicesLoading;

  const ExploreLoaded(
      this.articles, this.advices, this.isArticlesLoading, this.isAdvicesLoading);

  @override
  List<Object> get props =>
      [articles, advices, isArticlesLoading, isAdvicesLoading];

  ExploreLoaded copyWith({
    List<ArticleModel>? articles,
    List<AdviceModel>? advices,
    bool? isArticlesLoading,
    bool? isAdvicesLoading,
  }) {
    return ExploreLoaded(
      articles ?? this.articles,
      advices ?? this.advices,
      isArticlesLoading ?? this.isArticlesLoading,
      isAdvicesLoading ?? this.isAdvicesLoading,
    );
  }
}

class ExploreError extends ExploreState {
  final String message;
  const ExploreError(this.message);

  @override
  List<Object> get props => [message];
}
