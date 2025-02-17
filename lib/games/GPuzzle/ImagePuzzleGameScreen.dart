import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

/// Kartın durumunu tutan model.
class CardModel {
  final String imagePath;
  bool isRevealed;
  bool isMatched;

  CardModel({
    required this.imagePath,
    this.isRevealed = false,
    this.isMatched = false,
  });
}

/// Oyun mantığını yöneten sınıf.
/// Kartlar çiftler halinde oluşturulur ve karıştırılır.
class ImagePuzzleLogic {
  List<CardModel> cards = [];
  CardModel? firstSelected;
  bool processing = false;

  ImagePuzzleLogic() {
    _initializeCards();
  }

  void _initializeCards() {
    List<String> images = [
      'lib/assets/img/pexels-charlesdeluvio-1851164.jpg',
      'lib/assets/img/pexels-laurathexplaura-3608263.jpg',
      'lib/assets/img/pexels-melisa-valentin-177621-704454.jpg',
      'lib/assets/img/pexels-pixabay-45201.jpg',
      'lib/assets/img/pexels-pixabay-47547.jpg',
      'lib/assets/img/pexels-pixabay-62289.jpg',
      'lib/assets/img/pexels-pixabay-53581.jpg',
      'lib/assets/img/pexels-pixabay-302304.jpg',
    ];
    // Her resim çift olarak eklensin.
    List<String> pairImages = [];
    for (var img in images) {
      pairImages.add(img);
      pairImages.add(img);
    }
    pairImages.shuffle(Random());

    cards = pairImages.map((img) => CardModel(imagePath: img)).toList();
  }

  /// Kart seçildiğinde kontrol eder. İlk seçilen kartı saklar,
  /// ikinci kart ile karşılaştırır. Eşleşme varsa kartlar kalır, eşleşmezse kapatılır.
  void selectCard(
    int index,
    VoidCallback onMatch,
    VoidCallback onMismatch,
    VoidCallback onGameCompleted,
  ) {
    if (processing || cards[index].isRevealed || cards[index].isMatched) return;

    cards[index].isRevealed = true;
    if (firstSelected == null) {
      firstSelected = cards[index];
    } else {
      processing = true;
      if (firstSelected!.imagePath == cards[index].imagePath) {
        // Eşleşme bulundu
        firstSelected!.isMatched = true;
        cards[index].isMatched = true;
        firstSelected = null;
        processing = false;
        onMatch();
        if (cards.every((card) => card.isMatched)) {
          onGameCompleted();
        }
      } else {
        // Eşleşme yok, kartlar kapatılacak.
        Timer(const Duration(seconds: 1), () {
          firstSelected!.isRevealed = false;
          cards[index].isRevealed = false;
          firstSelected = null;
          processing = false;
          onMismatch();
        });
      }
    }
  }

  /// Hint: Eşleşmemiş kartların tamamını 2 saniyeliğine açar.
  void showHint(VoidCallback onHintCompleted) {
    for (var card in cards) {
      if (!card.isMatched) {
        card.isRevealed = true;
      }
    }
    Timer(const Duration(seconds: 2), () {
      for (var card in cards) {
        if (!card.isMatched) {
          card.isRevealed = false;
        }
      }
      onHintCompleted();
    });
  }
}

class ImagePuzzleGameScreen extends StatefulWidget {
  const ImagePuzzleGameScreen({Key? key}) : super(key: key);

  @override
  State<ImagePuzzleGameScreen> createState() => _ImagePuzzleGameScreenState();
}

class _ImagePuzzleGameScreenState extends State<ImagePuzzleGameScreen> {
  late ImagePuzzleLogic gameLogic;
  int hintCount = 3; // Her levelde 3 hint hakkı
  String? centerMessage;

  @override
  void initState() {
    super.initState();
    gameLogic = ImagePuzzleLogic();
    // Başlangıçta tüm kartları açıyoruz:
    for (var card in gameLogic.cards) {
      card.isRevealed = true;
    }
    // 2 saniye sonra tüm kartları kapatıyoruz.
    Timer(const Duration(seconds: 2), () {
      setState(() {
        for (var card in gameLogic.cards) {
          // Eğer kart eşleşmediyse kapatılıyor.
          if (!card.isMatched) card.isRevealed = false;
        }
      });
    });
  }

  void showCenterMessage(String message) {
    setState(() {
      centerMessage = message;
    });
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        centerMessage = null;
      });
    });
  }

  void onCardTap(int index) {
    setState(() {
      gameLogic.selectCard(
        index,
        () {
          // Eşleşme bulundu, ekranı yenile
          setState(() {});
        },
        () {
          setState(() {});
        },
        () {
          // Oyun tamamlandığında
          showCenterMessage("Tebrikler, tüm resimler eşleşti!");
        },
      );
    });
  }

  void onHintPressed() {
    if (hintCount <= 0) {
      showCenterMessage("Hint kullandınız!");
      return;
    }
    setState(() {
      hintCount--;
    });
    gameLogic.showHint(() {
      setState(() {});
    });
  }

  /// Skor panelinde eşleşen çift sayısını gösteriyoruz.
  Widget _buildScorePanel() {
    // Her eşleşme iki kart olduğundan, matched kart sayısını 2'ye bölüyoruz.
    int matchedPairs = (gameLogic.cards.where((c) => c.isMatched).length ~/ 2);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.green[300],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        "Eşleşme: $matchedPairs",
        style: const TextStyle(
          fontSize: 20,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double boardSize = MediaQuery.of(context).size.width - 20;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Resim Puzzle"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              const SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildScorePanel(),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.lightbulb,
                            color: hintCount > 0 ? Colors.amber : Colors.grey,
                            size: 32,
                          ),
                          onPressed: onHintPressed,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "$hintCount",
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Oyun tahtası
              Center(
                child: Container(
                  width: boardSize,
                  height: boardSize,
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          crossAxisSpacing: 4,
                          mainAxisSpacing: 4,
                        ),
                    itemCount: gameLogic.cards.length,
                    itemBuilder: (context, index) {
                      final card = gameLogic.cards[index];
                      return GestureDetector(
                        onTap: () => onCardTap(index),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          decoration: BoxDecoration(
                            color:
                                card.isRevealed || card.isMatched
                                    ? Colors.white
                                    : Colors.blueGrey,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.black26),
                          ),
                          child: Center(
                            child:
                                card.isRevealed || card.isMatched
                                    ? Image.asset(
                                      card.imagePath,
                                      fit: BoxFit.contain,
                                    )
                                    : const SizedBox.shrink(),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              // Alt kısım: Sol tarafta skor paneli, sağ tarafta Hint butonu.
            ],
          ),
          if (centerMessage != null)
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  centerMessage!,
                  style: const TextStyle(fontSize: 24, color: Colors.white),
                ),
              ),
            ),
        ],
      ),
    );
  }
}