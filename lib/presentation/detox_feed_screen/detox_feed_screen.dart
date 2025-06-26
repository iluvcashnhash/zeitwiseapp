import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/detox_card_widget.dart';
import './widgets/detox_slide_view_widget.dart';

class DetoxFeedScreen extends StatefulWidget {
  const DetoxFeedScreen({super.key});

  @override
  State<DetoxFeedScreen> createState() => _DetoxFeedScreenState();
}

class _DetoxFeedScreenState extends State<DetoxFeedScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  bool _isRefreshing = false;
  List<Map<String, dynamic>> _articles = [];

  @override
  void initState() {
    super.initState();
    _loadInitialArticles();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _loadInitialArticles() {
    setState(() {
      _articles = _getMockArticles();
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMoreArticles();
    }
  }

  Future<void> _loadMoreArticles() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _articles.addAll(_getMockArticles());
      _isLoading = false;
    });
  }

  Future<void> _onRefresh() async {
    setState(() {
      _isRefreshing = true;
    });

    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _articles = _getMockArticles();
      _isRefreshing = false;
    });
  }

  void _openArticleSlides(Map<String, dynamic> article) {
    HapticFeedback.lightImpact();
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            DetoxSlideViewWidget(article: article),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 1.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;

          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);

          return SlideTransition(position: offsetAnimation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }

  List<Map<String, dynamic>> _getMockArticles() {
    return [
      {
        "id": 1,
        "headline": "Global Markets Plunge Amid Economic Uncertainty",
        "source": "Financial Times",
        "timestamp": DateTime.now().subtract(const Duration(hours: 2)),
        "category": "Economics",
        "slides": [
          {
            "type": "headline",
            "content": "Global Markets Plunge Amid Economic Uncertainty",
            "backgroundColor": AppTheme.primaryNavy,
          },
          {
            "type": "rawdetails",
            "details": [
              "Stock markets have lost over 15% of their value in the past week alone",
              "Major banks are reporting significant losses across all sectors",
              "Unemployment claims have spiked to their highest levels since 2008"
            ],
            "backgroundColor": Color(0xFF7F1D1D),
          },
          {
            "type": "historical",
            "content":
                "Similar market volatility occurred during the 1929 Stock Market Crash, yet economies recovered and grew stronger through innovation and adaptation.",
            "year": "1929",
            "backgroundColor": AppTheme.historicalSepia,
          },
          {
            "type": "analysis",
            "content":
                "Markets are cyclical by nature. What appears as chaos today often becomes the foundation for tomorrow's growth. Economic uncertainty, while uncomfortable, drives innovation and resilience.",
            "sage": "Marcus Aurelius",
            "backgroundColor": AppTheme.lightIndigo,
          },
          {
            "type": "meme",
            "imageUrl":
                "https://images.unsplash.com/photo-1611974789855-9c2a0a7236a3?w=500&h=400&fit=crop",
            "caption": "STONKS ONLY GO DOWN\\nUNTIL THEY GO UP AGAIN",
            "backgroundColor": AppTheme.warmGold,
          }
        ]
      },
      {
        "id": 2,
        "headline": "Climate Change Accelerates Faster Than Expected",
        "source": "Nature Climate",
        "timestamp": DateTime.now().subtract(const Duration(hours: 4)),
        "category": "Environment",
        "slides": [
          {
            "type": "headline",
            "content": "Climate Change Accelerates Faster Than Expected",
            "backgroundColor": AppTheme.primaryNavy,
          },
          {
            "type": "rawdetails",
            "details": [
              "Global temperatures have risen 1.2°C faster than predicted models",
              "Arctic ice is melting at three times the previously estimated rate",
              "Extreme weather events have increased by 400% in the last decade"
            ],
            "backgroundColor": Color(0xFF7F1D1D),
          },
          {
            "type": "historical",
            "content":
                "The Little Ice Age (1300-1850) showed humanity's remarkable ability to adapt to dramatic climate shifts through innovation and community cooperation.",
            "year": "1300-1850",
            "backgroundColor": AppTheme.historicalSepia,
          },
          {
            "type": "analysis",
            "content":
                "Every crisis contains within it the seeds of opportunity. Climate challenges are accelerating human innovation at unprecedented rates, from renewable energy to sustainable agriculture.",
            "sage": "Lao Tzu",
            "backgroundColor": AppTheme.lightIndigo,
          },
          {
            "type": "meme",
            "imageUrl":
                "https://images.unsplash.com/photo-1569163139394-de4e4f43e4e3?w=500&h=400&fit=crop",
            "caption": "EARTH: GETS WARMER\\nHUMANS: TIME TO INNOVATE",
            "backgroundColor": AppTheme.warmGold,
          }
        ]
      },
      {
        "id": 3,
        "headline": "Political Tensions Rise Across Nations",
        "source": "Reuters",
        "timestamp": DateTime.now().subtract(const Duration(hours: 6)),
        "category": "Politics",
        "slides": [
          {
            "type": "headline",
            "content": "Political Tensions Rise Across Nations",
            "backgroundColor": AppTheme.primaryNavy,
          },
          {
            "type": "rawdetails",
            "details": [
              "Trade wars have escalated with tariffs reaching historic highs",
              "Diplomatic relations between major powers are at their lowest since the Cold War",
              "Border conflicts have increased by 60% globally this year"
            ],
            "backgroundColor": Color(0xFF7F1D1D),
          },
          {
            "type": "historical",
            "content":
                "The Congress of Vienna (1815) showed how nations can resolve conflicts through dialogue and diplomacy, establishing peace that lasted for decades.",
            "year": "1815",
            "backgroundColor": AppTheme.historicalSepia,
          },
          {
            "type": "analysis",
            "content":
                "Conflict often precedes understanding. Political tensions, while challenging, force societies to examine their values and find common ground through discourse.",
            "sage": "Confucius",
            "backgroundColor": AppTheme.lightIndigo,
          },
          {
            "type": "meme",
            "imageUrl":
                "https://images.unsplash.com/photo-1529107386315-e1a2ed48a620?w=500&h=400&fit=crop",
            "caption": "POLITICIANS ARGUING\\nCITIZENS: FIRST TIME?",
            "backgroundColor": AppTheme.warmGold,
          }
        ]
      },
      {
        "id": 4,
        "headline": "Technology Job Market Faces Major Disruption",
        "source": "TechCrunch",
        "timestamp": DateTime.now().subtract(const Duration(hours: 8)),
        "category": "Technology",
        "slides": [
          {
            "type": "headline",
            "content": "Technology Job Market Faces Major Disruption",
            "backgroundColor": AppTheme.primaryNavy,
          },
          {
            "type": "rawdetails",
            "details": [
              "AI automation threatens to eliminate 40% of current tech jobs",
              "Major tech companies have announced layoffs exceeding 200,000 positions",
              "Junior developer positions have decreased by 70% compared to last year"
            ],
            "backgroundColor": Color(0xFF7F1D1D),
          },
          {
            "type": "historical",
            "content":
                "The Industrial Revolution (1760-1840) displaced many traditional jobs but created entirely new industries and opportunities for human advancement.",
            "year": "1760-1840",
            "backgroundColor": AppTheme.historicalSepia,
          },
          {
            "type": "analysis",
            "content":
                "Disruption is the universe's way of making space for growth. Every technological shift creates new possibilities for human creativity and contribution.",
            "sage": "Heraclitus",
            "backgroundColor": AppTheme.lightIndigo,
          },
          {
            "type": "meme",
            "imageUrl":
                "https://images.unsplash.com/photo-1486312338219-ce68e2c6b7d3?w=500&h=400&fit=crop",
            "caption": "AI TAKING JOBS\\nHUMANS: GUESS I'LL EVOLVE",
            "backgroundColor": AppTheme.warmGold,
          }
        ]
      },
      {
        "id": 5,
        "headline": "Healthcare System Struggles with Rising Costs",
        "source": "Medical Journal",
        "timestamp": DateTime.now().subtract(const Duration(hours: 12)),
        "category": "Health",
        "slides": [
          {
            "type": "headline",
            "content": "Healthcare System Struggles with Rising Costs",
            "backgroundColor": AppTheme.primaryNavy,
          },
          {
            "type": "rawdetails",
            "details": [
              "Healthcare costs have increased by 300% over the past decade",
              "Medical bankruptcy affects 1 in 4 families annually",
              "Essential medications are now priced 10x higher than manufacturing costs"
            ],
            "backgroundColor": Color(0xFF7F1D1D),
          },
          {
            "type": "historical",
            "content":
                "The discovery of penicillin (1928) revolutionized medicine from a simple mold, proving that breakthrough solutions often come from unexpected places.",
            "year": "1928",
            "backgroundColor": AppTheme.historicalSepia,
          },
          {
            "type": "analysis",
            "content":
                "Challenges in healthcare drive innovation. Today's problems become tomorrow's breakthroughs, as human ingenuity finds ways to heal more effectively and affordably.",
            "sage": "Hippocrates",
            "backgroundColor": AppTheme.lightIndigo,
          },
          {
            "type": "meme",
            "imageUrl":
                "https://images.unsplash.com/photo-1559757148-5c350d0d3c56?w=500&h=400&fit=crop",
            "caption": "HEALTHCARE EXPENSIVE\\nAPPLE A DAY: AM I A JOKE?",
            "backgroundColor": AppTheme.warmGold,
          }
        ]
      }
    ];
  }

  Widget _buildSkeletonCard() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 70.w,
            height: 2.h,
            decoration: BoxDecoration(
              color: AppTheme.softGray.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          SizedBox(height: 2.h),
          Container(
            width: 90.w,
            height: 1.5.h,
            decoration: BoxDecoration(
              color: AppTheme.softGray.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          SizedBox(height: 1.h),
          Container(
            width: 60.w,
            height: 1.5.h,
            decoration: BoxDecoration(
              color: AppTheme.softGray.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Detox Feed',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            onPressed: () {
              HapticFeedback.lightImpact();
              // Filter functionality
            },
            icon: CustomIconWidget(
              iconName: 'filter_list',
              color: Theme.of(context).colorScheme.onSurface,
              size: 24,
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        color: AppTheme.activeCyan,
        backgroundColor: Theme.of(context).cardColor,
        child: CustomScrollView(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: EdgeInsets.only(top: 1.h),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    if (index < _articles.length) {
                      return DetoxCardWidget(
                        article: _articles[index],
                        onTap: () => _openArticleSlides(_articles[index]),
                      );
                    } else if (_isLoading) {
                      return _buildSkeletonCard();
                    }
                    return null;
                  },
                  childCount: _articles.length + (_isLoading ? 3 : 0),
                ),
              ),
            ),
            if (_isLoading)
              SliverToBoxAdapter(
                child: Container(
                  padding: EdgeInsets.all(4.w),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: AppTheme.activeCyan,
                      strokeWidth: 2,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
