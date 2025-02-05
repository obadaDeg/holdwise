import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:holdwise/features/explore_screen/data/models/advice.dart';
import 'package:holdwise/features/explore_screen/data/models/article.dart';

part 'explore_state.dart';

class ExploreCubit extends Cubit<ExploreState> {
  ExploreCubit() : super(const ExploreLoaded([], [], false, false));

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> fetchArticles() async {
    // Ensure we're in a valid state before modifying the articles loading flag
    if (state is! ExploreLoaded) {
      emit(const ExploreLoaded([], [], false, false));
    }

    emit((state as ExploreLoaded).copyWith(isArticlesLoading: true));

    try {
      QuerySnapshot articlesSnapshot =
          await firestore.collection('articles').get();
      List<ArticleModel> articles = articlesSnapshot.docs.map((doc) {
        return ArticleModel.fromFirestore(doc);
      }).toList();

      emit((state as ExploreLoaded)
          .copyWith(articles: articles, isArticlesLoading: false));
    } catch (e) {
      emit(ExploreError("Failed to load articles: $e"));
    }
  }

  Future<void> fetchAdvices() async {
    // Ensure we're in a valid state before modifying the advices loading flag
    if (state is! ExploreLoaded) {
      emit(const ExploreLoaded([], [], false, false));
    }

    emit((state as ExploreLoaded).copyWith(isAdvicesLoading: true));

    try {
      QuerySnapshot advicesSnapshot =
          await firestore.collection('advices').get();
      List<AdviceModel> advices = advicesSnapshot.docs.map((doc) {
        return AdviceModel.fromFirestore(doc);
      }).toList();

      emit((state as ExploreLoaded)
          .copyWith(advices: advices, isAdvicesLoading: false));
    } catch (e) {
      emit(ExploreError("Failed to load advices: $e"));
    }
  }

  // A method to refresh both articles and advices together
  Future<void> refreshData() async {
    emit(const ExploreLoaded([], [], true, true)); // Reset state and show loaders
    await fetchArticles();
    await fetchAdvices();
  }
}
