import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class StoryViewer extends HookWidget {
  final List<String> storyPaths; // image paths (file or asset)
  const StoryViewer({super.key, required this.storyPaths});

  @override
  Widget build(BuildContext context) {
    final pageController = usePageController();
    final currentIndex = useState(0);
    final timer = useRef<Timer?>(null);

    // start timer when widget is mounted
    useEffect(() {
      timer.value?.cancel();
      timer.value = Timer.periodic(const Duration(seconds: 5), (_) {
        if (currentIndex.value < storyPaths.length - 1) {
          currentIndex.value++;
          pageController.animateToPage(
            currentIndex.value,
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
          );
        } else {
          timer.value?.cancel();
          Navigator.of(context).pop();
        }
      });

      // cleanup
      return () {
        timer.value?.cancel();
      };
    }, [storyPaths]); // restart timer if stories change

    void goToNextStory() {
      if (currentIndex.value < storyPaths.length - 1) {
        currentIndex.value++;
        pageController.animateToPage(
          currentIndex.value,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      } else {
        Navigator.of(context).pop();
      }
    }

    void goToPreviousStory() {
      if (currentIndex.value > 0) {
        currentIndex.value--;
        pageController.animateToPage(
          currentIndex.value,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      }
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapUp: (details) {
          final width = MediaQuery.of(context).size.width;
          if (details.localPosition.dx < width / 2) {
            goToPreviousStory();
          } else {
            goToNextStory();
          }
        },
        child: Stack(
          children: [
            PageView.builder(
              controller: pageController,
              physics: const NeverScrollableScrollPhysics(), // auto only
              itemCount: storyPaths.length,
              itemBuilder: (context, index) {
                final story = storyPaths[index];
                return Center(
                  child:
                      story.startsWith("assets/")
                          ? Image.asset(story, fit: BoxFit.cover)
                          : Image.file(File(story), fit: BoxFit.cover),
                );
              },
            ),
            // Progress indicators at top
            Positioned(
              top: 40,
              left: 16,
              right: 16,
              child: Row(
                children:
                    storyPaths
                        .asMap()
                        .entries
                        .map(
                          (entry) => Expanded(
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 2),
                              height: 4,
                              decoration: BoxDecoration(
                                color:
                                    entry.key <= currentIndex.value
                                        ? Colors.white
                                        : Colors.white24,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ),
                        )
                        .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
