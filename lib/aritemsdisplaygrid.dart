import 'package:collegearproject/dashboard.dart';
import 'package:flutter/material.dart';

class ARModelsDisplayGrid extends StatelessWidget {
  const ARModelsDisplayGrid({
    super.key,
    required this.arModels,
    required this.onTap,
  });
  final List<ARModel> arModels;

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
        return InkWell(
          onTap: () {
            onTap(arModel);
          },
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, 2),
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
        );
      },
    );
  }
}
