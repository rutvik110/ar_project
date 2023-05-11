import 'package:collegearproject/aritemsdisplaygrid.dart';
import 'package:collegearproject/externalmodelmanagementexample.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("AlphabetAR"),
        ),
        body: DefaultTabController(
            length: 2,
            child: Column(
              children: [
                const TabBar(
                  tabs: [
                    Tab(
                      child: Text(
                        "Abcd",
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Tab(
                      child: Text(
                        "0123",
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      ARModelsDisplayGrid(
                        arModels: alphabetModels,
                        onTap: (model) {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return ExternalModelManagementWidget(
                              arModel: model,
                            );
                          }));
                        },
                      ),
                      ARModelsDisplayGrid(
                        arModels: numberModels,
                        onTap: (model) {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return ExternalModelManagementWidget(
                              arModel: model,
                            );
                          }));
                        },
                      ),
                    ],
                  ),
                ),
              ],
            )));
  }
}

class ARModel {
  final String name;
  final String assetPath;
  final String audioPath;
  const ARModel({
    required this.name,
    required this.assetPath,
    required this.audioPath,
  });
}

const List<ARModel> alphabetModels = [
  ARModel(
      name: "A",
      assetPath:
          "https://github.com/rutvik110/ar_project/raw/main/Models/alphabets/a.glb",
      audioPath: "pronounciations/A.wav"),
  ARModel(
      name: "B",
      assetPath:
          "https://github.com/rutvik110/ar_project/raw/main/Models/alphabets/b.glb",
      audioPath: "pronounciations/B.wav"),
  ARModel(
      name: "C",
      assetPath:
          "https://github.com/rutvik110/ar_project/raw/main/Models/alphabets/c.glb",
      audioPath: "pronounciations/C.wav"),
  ARModel(
      name: "D",
      assetPath:
          "https://github.com/rutvik110/ar_project/raw/main/Models/alphabets/d.glb",
      audioPath: "pronounciations/D.wav"),
  ARModel(
      name: "E",
      assetPath:
          "https://github.com/rutvik110/ar_project/raw/main/Models/alphabets/e.glb",
      audioPath: "pronounciations/E.wav"),
  ARModel(
      name: "F",
      assetPath:
          "https://github.com/rutvik110/ar_project/raw/main/Models/alphabets/f.glb",
      audioPath: "pronounciations/F.wav"),
  ARModel(
      name: "G",
      assetPath:
          "https://github.com/rutvik110/ar_project/raw/main/Models/alphabets/g.glb",
      audioPath: "pronounciations/G.wav"),
  ARModel(
      name: "H",
      assetPath:
          "https://github.com/rutvik110/ar_project/raw/main/Models/alphabets/h.glb",
      audioPath: "pronounciations/H.wav"),
  ARModel(
      name: "I",
      assetPath:
          "https://github.com/rutvik110/ar_project/raw/main/Models/alphabets/i.glb",
      audioPath: "pronounciations/I.wav"),
  ARModel(
      name: "J",
      assetPath:
          "https://github.com/rutvik110/ar_project/raw/main/Models/alphabets/j.glb",
      audioPath: "pronounciations/J.wav"),
  ARModel(
      name: "K",
      assetPath:
          "https://github.com/rutvik110/ar_project/raw/main/Models/alphabets/k.glb",
      audioPath: "pronounciations/K.wav"),
  ARModel(
      name: "L",
      assetPath:
          "https://github.com/rutvik110/ar_project/raw/main/Models/alphabets/l.glb",
      audioPath: "pronounciations/L.wav"),
  ARModel(
      name: "M",
      assetPath:
          "https://github.com/rutvik110/ar_project/raw/main/Models/alphabets/m.glb",
      audioPath: "pronounciations/M.wav"),
  ARModel(
      name: "N",
      assetPath:
          "https://github.com/rutvik110/ar_project/raw/main/Models/alphabets/n.glb",
      audioPath: "pronounciations/N.wav"),
  ARModel(
      name: "O",
      assetPath:
          "https://github.com/rutvik110/ar_project/raw/main/Models/alphabets/o.glb",
      audioPath: "pronounciations/O.wav"),
  ARModel(
      name: "P",
      assetPath:
          "https://github.com/rutvik110/ar_project/raw/main/Models/alphabets/p.glb",
      audioPath: "pronounciations/P.wav"),
  ARModel(
      name: "Q",
      assetPath:
          "https://github.com/rutvik110/ar_project/raw/main/Models/alphabets/q.glb",
      audioPath: "pronounciations/Q.wav"),
  ARModel(
      name: "R",
      assetPath:
          "https://github.com/rutvik110/ar_project/raw/main/Models/alphabets/r.glb",
      audioPath: "pronounciations/R.wav"),
  ARModel(
      name: "S",
      assetPath:
          "https://github.com/rutvik110/ar_project/raw/main/Models/alphabets/s.glb",
      audioPath: "pronounciations/S.wav"),
  ARModel(
      name: "T",
      assetPath:
          "https://github.com/rutvik110/ar_project/raw/main/Models/alphabets/t.glb",
      audioPath: "pronounciations/T.wav"),
  ARModel(
      name: "U",
      assetPath:
          "https://github.com/rutvik110/ar_project/raw/main/Models/alphabets/u.glb",
      audioPath: "pronounciations/U.wav"),
  ARModel(
      name: "V",
      assetPath:
          "https://github.com/rutvik110/ar_project/raw/main/Models/alphabets/v.glb",
      audioPath: "pronounciations/V.wav"),
  ARModel(
      name: "W",
      assetPath:
          "https://github.com/rutvik110/ar_project/raw/main/Models/alphabets/w.glb",
      audioPath: "pronounciations/W.wav"),
  ARModel(
      name: "X",
      assetPath:
          "https://github.com/rutvik110/ar_project/raw/main/Models/alphabets/x.glb",
      audioPath: "pronounciations/X.wav"),
  ARModel(
      name: "Y",
      assetPath:
          "https://github.com/rutvik110/ar_project/raw/main/Models/alphabets/y.glb",
      audioPath: "pronounciations/Y.wav"),
  ARModel(
      name: "Z",
      assetPath:
          "https://github.com/rutvik110/ar_project/raw/main/Models/alphabets/z.glb",
      audioPath: "pronounciations/Z.wav"),
];

const List<ARModel> numberModels = [
  ARModel(
      name: "0",
      assetPath:
          "https://github.com/rutvik110/ar_project/raw/main/Models/numbers/0.glb",
      audioPath: "pronounciations/0.wav"),
  ARModel(
      name: "1",
      assetPath:
          "https://github.com/rutvik110/ar_project/raw/main/Models/numbers/1.glb",
      audioPath: "pronounciations/1.wav"),
  ARModel(
      name: "2",
      assetPath:
          "https://github.com/rutvik110/ar_project/raw/main/Models/numbers/2.glb",
      audioPath: "pronounciations/2.wav"),
  ARModel(
      name: "3",
      assetPath:
          "https://github.com/rutvik110/ar_project/raw/main/Models/numbers/3.glb",
      audioPath: "pronounciations/3.wav"),
  ARModel(
      name: "4",
      assetPath:
          "https://github.com/rutvik110/ar_project/raw/main/Models/numbers/4.glb",
      audioPath: "pronounciations/4.wav"),
  ARModel(
      name: "5",
      assetPath:
          "https://github.com/rutvik110/ar_project/raw/main/Models/numbers/5.glb",
      audioPath: "pronounciations/5.wav"),
  ARModel(
      name: "6",
      assetPath:
          "https://github.com/rutvik110/ar_project/raw/main/Models/numbers/6.glb",
      audioPath: "pronounciations/6.wav"),
  ARModel(
      name: "7",
      assetPath:
          "https://github.com/rutvik110/ar_project/raw/main/Models/numbers/7.glb",
      audioPath: "pronounciations/7.wav"),
  ARModel(
      name: "8",
      assetPath:
          "https://github.com/rutvik110/ar_project/raw/main/Models/numbers/8.glb",
      audioPath: "pronounciations/8.wav"),
  ARModel(
      name: "9",
      assetPath:
          "https://github.com/rutvik110/ar_project/raw/main/Models/numbers/9.glb",
      audioPath: "pronounciations/9.wav"),
];
