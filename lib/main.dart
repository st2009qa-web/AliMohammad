import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(const JordanTourismApp());
}

// -------------------------------------------------------------------------
// القالب الرئيسي
// -------------------------------------------------------------------------
class JordanTourismApp extends StatelessWidget {
  const JordanTourismApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'اكتشف الأردن',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFE65100)),
        useMaterial3: true,
        fontFamily: 'Cairo', // يفضل إضافة خط كاهيرو
      ),
      home: const Directionality(
        textDirection: TextDirection.rtl,
        child: MainNavigationScreen(),
      ),
    );
  }
}

// -------------------------------------------------------------------------
// شريط التنقل السفلي
// -------------------------------------------------------------------------
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
      body: IndexedStack(
        // IndexedStack بحافظ على حالة الشاشات عشان ما يرجع الفيديو يعيد من الأول
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFFE65100),
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: 'الرئيسية',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.quiz), label: 'الاختبار'),
          BottomNavigationBarItem(
            icon: Icon(Icons.star_rate_rounded),
            label: 'التقييم',
          ),
        ],
      ),
    );
  }
}

// -------------------------------------------------------------------------
// 1. الشاشة الرئيسية (شغالة 100% مع الفيديو)
// -------------------------------------------------------------------------
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
    _controller = VideoPlayerController.asset('assets/video/jordan.mp4')
      ..initialize().then((_) {
        setState(() {}); // تحديث الواجهة بعد تحميل الفيديو
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 280.0,
          pinned: true,
          backgroundColor: Colors.white,
          flexibleSpace: FlexibleSpaceBar(
            titlePadding: const EdgeInsets.only(right: 16, bottom: 16),
            title: const Text(
              'اكتشف الأردن',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            background: Stack(
              fit: StackFit.expand,
              children: [
                _controller.value.isInitialized
                    ? VideoPlayer(_controller)
                    : Container(color: Colors.black),
                Container(color: Colors.black.withOpacity(0.3)), // تظليل خفيف
                Center(
                  child: IconButton(
                    icon: Icon(
                      _controller.value.isPlaying
                          ? Icons.pause_circle
                          : Icons.play_circle,
                      size: 65,
                      color: Colors.white,
                    ),
                    onPressed: () => setState(
                      () => _controller.value.isPlaying
                          ? _controller.pause()
                          : _controller.play(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: const Text(
              'أشهر المواقع السياحية',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildListDelegate([
            const LocationCard(
              name: 'مدينة البتراء',
              desc: 'إحدى عجائب الدنيا السبع الجديدة وردية الصخر.',
              img: 'assets/images/petra.jpg',
            ),
            const LocationCard(
              name: 'وادي رم',
              desc: 'صحراء مذهلة وتجربة تخييم تحت النجوم.',
              img: 'assets/images/wadi-rum.webp',
            ),
            const LocationCard(
              name: 'البحر الميت',
              desc: 'أخفض نقطة على سطح الأرض ومياه علاجية.',
              img: 'assets/images/dead-sea.jpg',
            ),
            const LocationCard(
              name: 'قلعة عجلون',
              desc:
                  'قلعة عجلون، أو ما تعرف بقلعة الربض، بنيت في عهد الدولة الأيوبية على يد عز الدين أسامة',
              img: 'assets/images/ajloun.webp',
            ),
            const LocationCard(
              name: 'أم قيس',
              desc:
                  'عُرفت أم قيس قديمًا باسم جدارا، وهي إحدى المدن اليونانية- الرومانية العشر (حلف المدن العشرة). وفي الأزمنة القديمة، كانت جدارا تقع في موقع استراتيجي ويمر بها عدد من الطرق التجارية التي كانت تربط سوريا وفلسطين.',
              img: 'assets/images/umqais.webp',
            ),
            const SizedBox(height: 20),
          ]),
        ),
      ],
    );
  }
}

class LocationCard extends StatelessWidget {
  final String name, desc, img;
  const LocationCard({
    super.key,
    required this.name,
    required this.desc,
    required this.img,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      clipBehavior: Clip.antiAlias,
      elevation: 5,
      child: Column(
        children: [
          Image.asset(
            img,
            height: 200,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              height: 200,
              color: Colors.grey,
              child: const Icon(Icons.image, size: 50),
            ),
          ),
          ListTile(
            title: Text(
              name,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            subtitle: Text(desc, style: const TextStyle(fontSize: 14)),
            trailing: const Icon(Icons.location_on, color: Color(0xFFE65100)),
          ),
        ],
      ),
    );
  }
}

// -------------------------------------------------------------------------
// 2. شاشة الاختبار (شغالة مع الخلفية وصوت التصفيق)
// -------------------------------------------------------------------------
class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  int _currentIdx = 0;
  int _score = 0;
  bool _isFinished = false;

  final List<Map<String, dynamic>> _questions = [
    {
      'q': 'أين تقع البتراء؟',
      'answers': [
        {'text': 'معان', 'isCorrect': true},
        {'text': 'عمان', 'isCorrect': false},
      ],
    },
    {
      'q': 'ما هو لقب وادي رم؟',
      'answers': [
        {'text': 'وادي القمر', 'isCorrect': true},
        {'text': 'الوادي الملون', 'isCorrect': false},
      ],
    },
    {
      'q': 'أين يقع البحر الميت؟',
      'answers': [
        {'text': 'غور الأردن', 'isCorrect': true},
        {'text': 'العقبة', 'isCorrect': false},
      ],
    },
    {
      'q': 'من بنى قلعة عجلون؟',
      'answers': [
        {'text': 'عز الدين أسامة', 'isCorrect': true},
        {'text': 'صلاح الدين', 'isCorrect': false},
      ],
    },
    {
      'q': 'ما هي عاصمة الأردن؟',
      'answers': [
        {'text': 'عمان', 'isCorrect': true},
        {'text': 'الزرقاء', 'isCorrect': false},
      ],
    },
  ];

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void _answerQuestion(bool isCorrect) async {
    if (isCorrect) {
      _score++;
      await _audioPlayer.play(
        AssetSource('sound/clapp.mp3'),
      ); // تشغيل صوت التصفيق
    }

    setState(() {
      if (_currentIdx < _questions.length - 1) {
        _currentIdx++;
      } else {
        _isFinished = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isFinished) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.emoji_events, size: 100, color: Colors.amber),
              const SizedBox(height: 20),
              Text(
                'نتيجتك: $_score من ${_questions.length}',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE65100),
                  foregroundColor: Colors.white,
                ),
                onPressed: () => setState(() {
                  _currentIdx = 0;
                  _score = 0;
                  _isFinished = false;
                }),
                child: const Text(
                  'إعادة الاختبار',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      );
    }

    double progress = (_currentIdx + 1) / _questions.length;
    final currentQuestion = _questions[_currentIdx];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'اختبر معلوماتك',
          style: TextStyle(
            color: Color(0xFF8D4B38),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          // الخلفية الشفافة
          Positioned.fill(
            child: Opacity(
              opacity: 0.08, // شفافية ممتازة عشان ما تخرب عالنص
              child: Image.asset(
                'assets/images/bg_outline.png',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const SizedBox(), // عشان لو ما حطيت الصورة ما يضرب التطبيق
              ),
            ),
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 8,
                    backgroundColor: Colors.orange.shade100,
                    color: const Color(0xFFE65100),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'السؤال ${_currentIdx + 1} من ${_questions.length}',
                style: const TextStyle(color: Colors.grey, fontSize: 18),
              ),
              const SizedBox(height: 60),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  currentQuestion['q'],
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D2D2D),
                  ),
                ),
              ),
              const Spacer(),
              ...(currentQuestion['answers'] as List).map(
                (ans) => _buildModernButton(ans['text'], ans['isCorrect']),
              ),
              const SizedBox(height: 60),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildModernButton(String text, bool isCorrect) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 35, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFE65100),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () => _answerQuestion(isCorrect),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Center(
              child: Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// -------------------------------------------------------------------------
// 3. شاشة التقييم (شغالة مع صوت التشجيع)
// -------------------------------------------------------------------------
class RatingScreen extends StatefulWidget {
  const RatingScreen({super.key});

  @override
  State<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  int _rating = 0;
  final TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    _audioPlayer.dispose();
    _commentController.dispose();
    super.dispose();
  }

  void _submitRating() async {
    if (_rating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('الرجاء اختيار التقييم أولاً!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_rating >= 4) {
      // تشغيل صوت التشجيع إذا كان التقييم 4 أو 5 نجوم
      await _audioPlayer.play(AssetSource('sound/cheer.mp3'));
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('شكراً لتقييمك الرائع!'),
        backgroundColor: Colors.green,
      ),
    );

    // تصفير الخانات بعد الإرسال
    setState(() {
      _rating = 0;
      _commentController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        // عشان الكيبورد ما يغطي الشاشة لما تكتب
        child: Padding(
          padding: const EdgeInsets.only(top: 100, left: 20, right: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.rate_review_rounded,
                size: 100,
                color: Color(0xFFE65100),
              ),
              const SizedBox(height: 30),
              const Text(
                'قيم تجربتك مع التطبيق',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  5,
                  (index) => IconButton(
                    icon: Icon(
                      index < _rating ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                      size: 50,
                    ),
                    onPressed: () => setState(() => _rating = index + 1),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              TextField(
                controller: _commentController,
                decoration: InputDecoration(
                  hintText: 'أضف تعليقك هنا...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                ),
                maxLines: 4,
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE65100),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onPressed: _submitRating,
                  child: const Text(
                    'إرسال التقييم',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
