import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:holdwise/common/widgets/error_dialog.dart';
import 'package:holdwise/common/widgets/role_based_appbar.dart';
import 'package:holdwise/features/explore_screen/data/models/advice.dart';
import 'package:holdwise/features/explore_screen/data/models/article.dart';
import 'package:holdwise/features/explore_screen/data/explore_cubit/explore_cubit.dart';
import 'package:holdwise/features/explore_screen/presentation/widgets/advice_card.dart';
import 'package:holdwise/features/explore_screen/presentation/widgets/article_card.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({Key? key}) : super(key: key);

  @override
  _ExplorePageState createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  bool _isDialogShowing = false;

  void _showErrorDialog(BuildContext context, String message) {
    if (_isDialogShowing) return;

    _isDialogShowing = true;
    final cubit = context.read<ExploreCubit>();

    showDialog(
      context: context,
      builder: (context) => ErrorDialog(
        title: "Error! Could not load data",
        message: message,
        onRetry: () {
          Navigator.of(context).pop();
          _isDialogShowing = false;
          cubit.fetchArticles();
          cubit.fetchAdvices();
        },
      ),
    ).then((_) {
      _isDialogShowing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ExploreCubit()
        ..fetchArticles()
        ..fetchAdvices(),
      child: BlocListener<ExploreCubit, ExploreState>(
        listener: (context, state) {
          if (state is ExploreError) {
            _showErrorDialog(context, state.message);
          }
        },
        child: DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: RoleBasedAppBar(
              displayActions: false,
              title: 'Explore',
              bottom: const TabBar(
                indicatorColor: Colors.yellow,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white70,
                labelStyle:
                    TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                tabs: [
                  Tab(text: "Articles"),
                  Tab(text: "Specialist Advice"),
                ],
              ),
            ),
            body: BlocBuilder<ExploreCubit, ExploreState>(
              builder: (context, state) {
                if (state is ExploreLoaded) {
                  return TabBarView(
                    children: [
                      RefreshIndicator(
                        onRefresh: () async {
                          await context.read<ExploreCubit>().fetchArticles();
                        },
                        child: state.isArticlesLoading
                            ? const Center(child: CircularProgressIndicator())
                            : CustomScrollView(
                                physics: const AlwaysScrollableScrollPhysics(),
                                slivers: [
                                  SliverList(
                                    delegate: SliverChildBuilderDelegate(
                                      (context, index) {
                                        final article = state.articles[index];
                                        return ArticleCard(article: article);
                                      },
                                      childCount: state.articles.length,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                      RefreshIndicator(
                        onRefresh: () async {
                          await context.read<ExploreCubit>().fetchAdvices();
                        },
                        child: state.isAdvicesLoading
                            ? const Center(child: CircularProgressIndicator())
                            : CustomScrollView(
                                physics: const AlwaysScrollableScrollPhysics(),
                                slivers: [
                                  SliverList(
                                    delegate: SliverChildBuilderDelegate(
                                      (context, index) {
                                        final advice = state.advices[index];
                                        return AdviceCard(advice: advice);
                                      },
                                      childCount: state.advices.length,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ],
                  );
                } else if (state is ExploreError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          width: double.infinity,
                          child: Text(
                            'Could not fetch the data.\nPlease refresh the page.',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                            softWrap: true,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: () =>
                              context.read<ExploreCubit>().refreshData(),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            textStyle: const TextStyle(fontSize: 16),
                          ),
                          child: const Text('Refresh'),
                        ),
                      ],
                    ),
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
