import 'package:flutter/material.dart';
import 'gflow_levels.dart';
import 'gflow_progress.dart';
import 'gflow_game.dart';

/// Seviye Seçim Ekranı:
/// - Kilitli veya açık seviyeleri gösterir
/// - Açık olan seviyeye tıklayınca GFlowGameScreen'e gider
class GFlowLevelSelectionScreen extends StatefulWidget {
  const GFlowLevelSelectionScreen({Key? key}) : super(key: key);

  @override
  State<GFlowLevelSelectionScreen> createState() => _GFlowLevelSelectionScreenState();
}

class _GFlowLevelSelectionScreenState extends State<GFlowLevelSelectionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("GFlow - Seviye Seçimi"),
        centerTitle: true,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, // 3 sütun
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.2,
        ),
        itemCount: gflowLevels.length,
        itemBuilder: (context, index) {
          bool locked = GFlowProgressManager.instance.isLocked(index);

          return InkWell(
            onTap: locked
                ? null
                : () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => GFlowGameScreen(levelIndex: index),
                      ),
                    ).then((_) {
                      // Oyundan geri dönüldüğünde sayfayı yenile (kilit durumu güncellenebilir)
                      setState(() {});
                    });
                  },
            child: Container(
              decoration: BoxDecoration(
                color: locked ? Colors.grey.shade400 : Colors.deepPurple.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: locked
                    ? const Icon(Icons.lock, size: 36, color: Colors.black54)
                    : Text(
                        "Seviye ${index + 1}",
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
              ),
            ),
          );
        },
      ),
    );
  }
}
