import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart'; // استيراد مكتبة الفيديو

void main() {
  runApp(const JordanTourismApp());
}

class JordanTourismApp extends StatelessWidget {
  const JordanTourismApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'سياحة الأردن',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        useMaterial3: true,
        fontFamily: 'Arial',
      ),
      home: const MainNavigationScreen(),
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomeScreen(),
    const QuizScreen(),
    const RatingScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: _pages[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.deepOrange,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'الرئيسية'),
          BottomNavigationBarItem(icon: Icon(Icons.quiz), label: 'الاختبار'),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: 'التقييم'),
        ],
      ),
    );
  }
}

// 1. الشاشة الرئيسية: تم تحويلها إلى StatefulWidget لدعم الفيديو
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    // تأكد من وضع ملف فيديو في هذا المسار أو تغيير المسار لاسم ملفك
    _controller = VideoPlayerController.asset('assets/video/jordan.mp4')
      ..initialize().then((_) {
        setState(() {}); // تحديث الواجهة عند جاهزية الفيديو
      });
  }

  @override
  void dispose() {
    _controller.dispose(); // إغلاق وحدة التحكم عند الخروج لتوفير الذاكرة
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 250.0,
          floating: false,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            title: const Text(
              'اكتشف الأردن',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                shadows: [Shadow(blurRadius: 10, color: Colors.black)],
              ),
            ),
            background: Stack(
              fit: StackFit.expand,
              children: [
                // عرض الفيديو إذا كان جاهزاً، وإلا عرض لون مؤقت
                _controller.value.isInitialized
                    ? AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: VideoPlayer(_controller),
                      )
                    : Container(
                        color: Colors.black,
                        child: const Center(child: CircularProgressIndicator()),
                      ),
                IconButton(
                  onPressed: () async {
                    _controller.value.isPlaying
                        ? await _controller.play()
                        : await _controller.pause();
                    setState(() {});
                  },
                  icon: Icon(
                    _controller.value.isPlaying
                        ? Icons.pause_circle
                        : Icons.play_circle,
                  ),
                ),
                // طبقة تعتيم خفيفة ليظهر النص بوضوح
                Container(color: Colors.black.withOpacity(0.2)),
              ],
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildListDelegate([
            _buildSectionTitle('أشهر المواقع السياحية'),
            _buildLocationItem(
              'مدينة البتراء',
              'إحدى عجائب الدنيا السبع الجديدة وردية الصخر.',
              'assets/images/petra.jpg',
            ),
            _buildLocationItem(
              'وادي رم',
              'صحراء مذهلة وتجربة تخييم تحت النجوم.',
              'assets/images/wadi-rum.webp',
            ),
            _buildLocationItem(
              'البحر الميت',
              'أخفض نقطة على سطح الأرض ومياه علاجية.',
              'assets/images/dead-sea.jpg',
            ),
            _buildLocationItem(
              'قلعة عجلون',
              'معلم تاريخي إسلامي بناه عز الدين أسامة.',
              'assets/images/ajloun.webp',
            ),
            const SizedBox(height: 20),
          ]),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildLocationItem(String name, String description, String imagePath) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 5,
      child: Column(
        children: [
          Image.asset(
            imagePath,
            height: 180,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              height: 180,
              color: Colors.grey[300],
              child: const Icon(Icons.image_not_supported, size: 50),
            ),
          ),
          ListTile(
            title: Text(
              name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(description),
            trailing: const Icon(Icons.location_on, color: Colors.deepOrange),
          ),
        ],
      ),
    );
  }
}

// 2. شاشة الاختبار (تبقى كما هي)
class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _currentQuestionIndex = 0;
  int _totalScore = 0;

  final List<Map<String, Object>> _questions = [
    {
      'question': 'أين تقع البتراء؟',
      'answers': [
        {'text': 'معان', 'score': 1},
        {'text': 'عمان', 'score': 0},
      ],
    },
    {
      'question': 'ما هو اللقب الذي يطلق على وادي رم؟',
      'answers': [
        {'text': 'وادي القمر', 'score': 1},
        {'text': 'الوادي الأخضر', 'score': 0},
      ],
    },
    {
      'question': 'أين يقع البحر الميت؟',
      'answers': [
        {'text': 'غور الأردن', 'score': 1},
        {'text': 'إربد', 'score': 0},
      ],
    },
    {
      'question': 'من بنى قلعة عجلون؟',
      'answers': [
        {'text': 'عز الدين أسامة', 'score': 1},
        {'text': 'الأنباط', 'score': 0},
      ],
    },
    {
      'question': 'ما هي عاصمة الأردن؟',
      'answers': [
        {'text': 'عمان', 'score': 1},
        {'text': 'العقبة', 'score': 0},
      ],
    },
  ];

  void _answerQuestion(int score) {
    setState(() {
      _totalScore += score;
      _currentQuestionIndex++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('اختبر معلوماتك')),
      body: Center(
        child: _currentQuestionIndex < _questions.length
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'السؤال ${_currentQuestionIndex + 1} من ${_questions.length}',
                    style: const TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      _questions[_currentQuestionIndex]['question'] as String,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 30),
                  ...(_questions[_currentQuestionIndex]['answers']
                          as List<Map<String, Object>>)
                      .map((answer) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 40,
                          ),
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.deepOrange,
                                foregroundColor: Colors.white,
                              ),
                              onPressed: () =>
                                  _answerQuestion(answer['score'] as int),
                              child: Text(answer['text'] as String),
                            ),
                          ),
                        );
                      }),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.emoji_events,
                    size: 100,
                    color: Colors.amber,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'النتيجة النهائية: $_totalScore / ${_questions.length}',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () => setState(() {
                      _currentQuestionIndex = 0;
                      _totalScore = 0;
                    }),
                    icon: const Icon(Icons.refresh),
                    label: const Text('إعادة الاختبار'),
                  ),
                ],
              ),
      ),
    );
  }
}

// 3. شاشة التقييم (تبقى كما هي)
class RatingScreen extends StatefulWidget {
  const RatingScreen({super.key});

  @override
  State<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  int _userRating = 0;

  void _handleRating(int rating) {
    setState(() => _userRating = rating);
    String message = rating >= 4
        ? 'شكراً لتقييمك الرائع! 👏'
        : 'شكراً لتقييمك، نسعى للأفضل دائماً.';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.deepOrange,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.rate_review, size: 80, color: Colors.deepOrange),
          const SizedBox(height: 20),
          const Text(
            'قيم تجربتك مع التطبيق',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              return IconButton(
                icon: Icon(
                  index < _userRating ? Icons.star : Icons.star_border,
                  color: Colors.amber,
                  size: 45,
                ),
                onPressed: () => _handleRating(index + 1),
              );
            }),
          ),
          if (_userRating > 0)
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Text(
                'تقييمك الحالي: $_userRating من 5',
                style: const TextStyle(color: Colors.grey),
              ),
            ),
        ],
      ),
    );
  }
}
