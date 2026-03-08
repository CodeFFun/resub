import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resub/app/theme/theme_data.dart';
import 'package:resub/core/utils/responsive_utils.dart';
import 'package:resub/features/graph/domain/entities/shop_dashboard_overview_entity.dart';
import 'package:resub/features/graph/presentation/state/graph_state.dart';
import 'package:resub/features/graph/presentation/view_models/graph_view_model.dart';
import 'package:resub/features/graph/presentation/widgets/dashboard_section_card.dart';
import 'package:resub/features/graph/presentation/widgets/overview_stat_card.dart';
import 'package:resub/features/graph/presentation/widgets/payment_split_chart.dart';
import 'package:resub/features/graph/presentation/widgets/revenue_trend_chart.dart';
import 'package:resub/features/graph/presentation/widgets/top_products_revenue_chart.dart';

class ShopOverviewScreen extends ConsumerStatefulWidget {
  const ShopOverviewScreen({super.key});

  @override
  ConsumerState<ShopOverviewScreen> createState() => _ShopOverviewScreenState();
}

class _ShopOverviewScreenState extends ConsumerState<ShopOverviewScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(graphViewModelProvider.notifier).getShopOverview();
    });
  }

  String _currency(double value) => 'Rs. ${value.toStringAsFixed(2)}';

  String _rate(double value) {
    final percent = value <= 1 ? value * 100 : value;
    return '${percent.toStringAsFixed(1)}%';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final appColors = theme.extension<AppThemeColors>();

    final state = ref.watch(graphViewModelProvider);

    ref.listen<GraphState>(graphViewModelProvider, (previous, next) {
      if (next.status == GraphStatus.error &&
          next.errorMessage != null &&
          next.errorMessage!.isNotEmpty) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(next.errorMessage!)));
      }
    });

    final overview = state.overview;
    final isLoading = state.status == GraphStatus.loading && overview == null;
    final showError = state.status == GraphStatus.error && overview == null;

    if (isLoading) {
      return Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (showError) {
      return Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                state.errorMessage ?? 'Failed to load shop overview',
                style: TextStyle(
                  fontSize: context.rFont(16),
                  color: colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: context.rHeight(14)),
              ElevatedButton(
                onPressed: () {
                  ref.read(graphViewModelProvider.notifier).getShopOverview();
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (overview == null) {
      return Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: Center(
          child: Text(
            'No overview data available',
            style: TextStyle(
              fontSize: context.rFont(16),
              color: appColors?.secondaryText ?? colorScheme.onSurface,
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 900;
          final cardCount = isMobile
              ? 1
              : constraints.maxWidth < 1280
              ? 2
              : 4;

          return RefreshIndicator(
            onRefresh: () async {
              await ref.read(graphViewModelProvider.notifier).getShopOverview();
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.only(
                top: context.rHeight(75),
                left: context.rSpacing(12),
                right: context.rSpacing(12),
                bottom: context.rSpacing(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildCardsGrid(context, overview, cardCount),
                  SizedBox(height: context.rHeight(16)),
                  if (isMobile)
                    Column(
                      children: [
                        DashboardSectionCard(
                          title: 'Revenue Trend',
                          minHeight: context.rHeight(250),
                          child: RevenueTrendChart(
                            points: overview.revenueTrend,
                          ),
                        ),
                        SizedBox(height: context.rHeight(16)),
                        DashboardSectionCard(
                          title: 'Payment Methods',
                          minHeight: context.rHeight(250),
                          child: PaymentSplitChart(
                            splits: overview.paymentSplit,
                          ),
                        ),
                      ],
                    )
                  else
                    SizedBox(
                      height: context.rHeight(360),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: DashboardSectionCard(
                              title: 'Revenue Trend',
                              child: RevenueTrendChart(
                                points: overview.revenueTrend,
                              ),
                            ),
                          ),
                          SizedBox(width: context.rWidth(16)),
                          Expanded(
                            child: DashboardSectionCard(
                              title: 'Payment Methods',
                              child: PaymentSplitChart(
                                splits: overview.paymentSplit,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  SizedBox(height: context.rHeight(16)),
                  SizedBox(
                    height: isMobile ? null : context.rHeight(300),
                    child: DashboardSectionCard(
                      title: 'Top Products',
                      minHeight: context.rHeight(240),
                      child: TopProductsRevenueChart(
                        products: overview.topProductsByRevenue,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCardsGrid(
    BuildContext context,
    ShopDashboardOverviewEntity overview,
    int cardCount,
  ) {
    final cards = [
      OverviewStatCard(
        title: 'Total Revenue',
        value: _currency(overview.cards.revenue),
        icon: Icons.attach_money,
      ),
      OverviewStatCard(
        title: 'Total Orders',
        value: overview.cards.orders.toString(),
        icon: Icons.shopping_cart_outlined,
      ),
      OverviewStatCard(
        title: 'Average Order Value',
        value: _currency(overview.cards.aov),
        icon: Icons.currency_exchange,
      ),
      OverviewStatCard(
        title: 'Success Rate',
        value: _rate(overview.cards.successfulPaymentRate),
        icon: Icons.task_alt,
      ),
    ];

    if (cardCount == 1) {
      return Column(
        children: [
          for (int i = 0; i < cards.length; i++) ...[
            SizedBox(height: context.rHeight(110), child: cards[i]),
            if (i != cards.length - 1) SizedBox(height: context.rHeight(12)),
          ],
        ],
      );
    }

    return GridView.count(
      crossAxisCount: cardCount,
      crossAxisSpacing: context.rWidth(16),
      mainAxisSpacing: context.rHeight(16),
      shrinkWrap: true,
      childAspectRatio: 2.0,
      physics: const NeverScrollableScrollPhysics(),
      children: cards,
    );
  }
}
