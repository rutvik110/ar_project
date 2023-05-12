import 'package:collegearproject/dashboard.dart';
import 'package:flutter/material.dart';

class ARModelsDisplayGrid extends StatelessWidget {
  const ARModelsDisplayGrid({
    super.key,
    required this.arModels,
    required this.onTap,
    required this.completedModels,
  });
  final List<ARModel> arModels;
  final List<String> completedModels;

  final void Function(ARModel model) onTap;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: arModels.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemBuilder: (context, index) {
        final arModel = arModels[index];
        final isCompleted = completedModels.contains(arModel.name);
        return InkWell(
          onTap: () {
            final arModelfinal = ARModel(
              name: arModel.name,
              assetPath: arModel.assetPath,
              audioPath: arModel.audioPath,
              modelType: arModel.modelType,
              isCompleted: isCompleted,
            );
            onTap(arModelfinal);
          },
          child: Stack(
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  color: isCompleted ? Colors.green[50] : Colors.blue[50],
                  border: isCompleted
                      ? Border.all(color: Colors.green, width: 2)
                      : Border.all(color: Colors.blue, width: 1),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    isCompleted
                        ? BoxShadow(
                            color: Colors.green[200]!,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          )
                        : BoxShadow(
                            color: Colors.blue[200]!,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                  ],
                ),
                child: Center(
                  child: Text(
                    arModel.name,
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              if (isCompleted)
                const Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.check_circle_rounded,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
