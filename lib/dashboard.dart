import 'package:collegearproject/aritemsdisplaygrid.dart';
import 'package:collegearproject/externalmodelmanagementexample.dart';
import 'package:collegearproject/profile.dart';
import 'package:collegearproject/providers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Dashboard extends ConsumerStatefulWidget {
  const Dashboard({super.key});

  @override
  ConsumerState<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends ConsumerState<Dashboard> {
  @override
  Widget build(
    BuildContext context,
  ) {
    final user = FirebaseAuth.instance.currentUser;
    final alphabets = ref.read(sharedPreferancesProvider).getStringList("${user!.uid}_alphabetsProgress") ?? [];
    final numbers = ref.read(sharedPreferancesProvider).getStringList("${user.uid}_numbersProgress") ?? [];
    final favourites = ref.read(sharedPreferancesProvider).getStringList("${user.uid}_favourites") ?? [];

    return Scaffold(
        drawer: Drawer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DrawerHeader(
                  padding: EdgeInsets.zero,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(user.photoURL!),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                          user.displayName!,
                          style: const TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        Text(user.email!),
                      ],
                    ),
                  )),
              ListTile(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                    return const UserProfile();
                  }));
                },
                leading: const Icon(
                  Icons.person_2_rounded,
                  color: Colors.blue,
                ),
                title: const Text("Profile"),
              ),
              const Spacer(),
              const Divider(),
              ListTile(
                onTap: () async {
                  await GoogleSignIn().signOut();
                  FirebaseAuth.instance.signOut();
                },
                leading: const Icon(Icons.logout_rounded),
                title: const Text("Logout"),
              ),
              const SizedBox(
                height: 48,
              ),
            ],
          ),
        ),
        appBar: AppBar(
          title: Row(
            children: const [
              Text("LearnAR"),
            ],
          ),
        ),
        body: DefaultTabController(
            length: 3,
            child: Column(
              children: [
                const TabBar(
                  tabs: [
                    Tab(
                      child: Text(
                        "Alphabets",
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Tab(
                      child: Text(
                        "Numbers",
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Tab(
                      child: Text(
                        "Favourites",
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
                        completedModels: alphabets,
                        arModels: alphabetModels,
                        favourites: favourites,
                        onTap: (model) async {
                          await Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                            return ExternalModelManagementWidget(
                              arModel: model,
                            );
                          }));
                          setState(() {});
                        },
                      ),
                      ARModelsDisplayGrid(
                        completedModels: numbers,
                        arModels: numberModels,
                        favourites: favourites,
                        onTap: (model) async {
                          await Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                            return ExternalModelManagementWidget(
                              arModel: model,
                            );
                          }));
                          setState(() {});
                        },
                      ),
                      ARModelsDisplayGrid(
                        completedModels: [...alphabets, ...numbers],
                        arModels: [...alphabetModels, ...numberModels]
                            .where((element) => favourites.contains(element.name))
                            .toList(),
                        favourites: favourites,
                        onTap: (model) async {
                          await Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                            return ExternalModelManagementWidget(
                              arModel: model,
                            );
                          }));
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                ),
              ],
            )));
  }
}

enum ModelType {
  alphabet,
  number;
}

class ARModel {
  final String name;
  final String assetPath;
  final String audioPath;
  final bool isCompleted;
  final ModelType modelType;
  final bool isFavourite;
  const ARModel({
    required this.name,
    required this.assetPath,
    required this.audioPath,
    required this.modelType,
    this.isCompleted = false,
    this.isFavourite = false,
  });
}

const List<ARModel> alphabetModels = [
  ARModel(
      name: "A",
      modelType: ModelType.alphabet,
      assetPath: "https://github.com/rutvik110/ar_project/raw/main/Models/alphabets/a.glb",
      audioPath: "pronounciations/A.wav"),
  ARModel(
      name: "B",
      modelType: ModelType.alphabet,
      assetPath: "https://github.com/rutvik110/ar_project/raw/main/Models/alphabets/b.glb",
      audioPath: "pronounciations/B.wav"),
  ARModel(
      name: "C",
      modelType: ModelType.alphabet,
      assetPath: "https://github.com/rutvik110/ar_project/raw/main/Models/alphabets/c.glb",
      audioPath: "pronounciations/C.wav"),
  ARModel(
      name: "D",
      modelType: ModelType.alphabet,
      assetPath: "https://github.com/rutvik110/ar_project/raw/main/Models/alphabets/d.glb",
      audioPath: "pronounciations/D.wav"),
  ARModel(
      name: "E",
      modelType: ModelType.alphabet,
      assetPath: "https://github.com/rutvik110/ar_project/raw/main/Models/alphabets/e.glb",
      audioPath: "pronounciations/E.wav"),
  ARModel(
      name: "F",
      modelType: ModelType.alphabet,
      assetPath: "https://github.com/rutvik110/ar_project/raw/main/Models/alphabets/f.glb",
      audioPath: "pronounciations/F.wav"),
  ARModel(
      name: "G",
      modelType: ModelType.alphabet,
      assetPath: "https://github.com/rutvik110/ar_project/raw/main/Models/alphabets/g.glb",
      audioPath: "pronounciations/G.wav"),
  ARModel(
      name: "H",
      modelType: ModelType.alphabet,
      assetPath: "https://github.com/rutvik110/ar_project/raw/main/Models/alphabets/h.glb",
      audioPath: "pronounciations/H.wav"),
  ARModel(
      name: "I",
      modelType: ModelType.alphabet,
      assetPath: "https://github.com/rutvik110/ar_project/raw/main/Models/alphabets/i.glb",
      audioPath: "pronounciations/I.wav"),
  ARModel(
      name: "J",
      modelType: ModelType.alphabet,
      assetPath: "https://github.com/rutvik110/ar_project/raw/main/Models/alphabets/j.glb",
      audioPath: "pronounciations/J.wav"),
  ARModel(
      name: "K",
      modelType: ModelType.alphabet,
      assetPath: "https://github.com/rutvik110/ar_project/raw/main/Models/alphabets/k.glb",
      audioPath: "pronounciations/K.wav"),
  ARModel(
      name: "L",
      modelType: ModelType.alphabet,
      assetPath: "https://github.com/rutvik110/ar_project/raw/main/Models/alphabets/l.glb",
      audioPath: "pronounciations/L.wav"),
  ARModel(
      name: "M",
      modelType: ModelType.alphabet,
      assetPath: "https://github.com/rutvik110/ar_project/raw/main/Models/alphabets/m.glb",
      audioPath: "pronounciations/M.wav"),
  ARModel(
      name: "N",
      modelType: ModelType.alphabet,
      assetPath: "https://github.com/rutvik110/ar_project/raw/main/Models/alphabets/n.glb",
      audioPath: "pronounciations/N.wav"),
  ARModel(
      name: "O",
      modelType: ModelType.alphabet,
      assetPath: "https://github.com/rutvik110/ar_project/raw/main/Models/alphabets/o.glb",
      audioPath: "pronounciations/O.wav"),
  ARModel(
      name: "P",
      modelType: ModelType.alphabet,
      assetPath: "https://github.com/rutvik110/ar_project/raw/main/Models/alphabets/p.glb",
      audioPath: "pronounciations/P.wav"),
  ARModel(
      name: "Q",
      modelType: ModelType.alphabet,
      assetPath: "https://github.com/rutvik110/ar_project/raw/main/Models/alphabets/q.glb",
      audioPath: "pronounciations/Q.wav"),
  ARModel(
      name: "R",
      modelType: ModelType.alphabet,
      assetPath: "https://github.com/rutvik110/ar_project/raw/main/Models/alphabets/r.glb",
      audioPath: "pronounciations/R.wav"),
  ARModel(
      name: "S",
      modelType: ModelType.alphabet,
      assetPath: "https://github.com/rutvik110/ar_project/raw/main/Models/alphabets/s.glb",
      audioPath: "pronounciations/S.wav"),
  ARModel(
      name: "T",
      modelType: ModelType.alphabet,
      assetPath: "https://github.com/rutvik110/ar_project/raw/main/Models/alphabets/t.glb",
      audioPath: "pronounciations/T.wav"),
  ARModel(
      name: "U",
      modelType: ModelType.alphabet,
      assetPath: "https://github.com/rutvik110/ar_project/raw/main/Models/alphabets/u.glb",
      audioPath: "pronounciations/U.wav"),
  ARModel(
      name: "V",
      modelType: ModelType.alphabet,
      assetPath: "https://github.com/rutvik110/ar_project/raw/main/Models/alphabets/v.glb",
      audioPath: "pronounciations/V.wav"),
  ARModel(
      name: "W",
      modelType: ModelType.alphabet,
      assetPath: "https://github.com/rutvik110/ar_project/raw/main/Models/alphabets/w.glb",
      audioPath: "pronounciations/W.wav"),
  ARModel(
      name: "X",
      modelType: ModelType.alphabet,
      assetPath: "https://github.com/rutvik110/ar_project/raw/main/Models/alphabets/x.glb",
      audioPath: "pronounciations/X.wav"),
  ARModel(
      name: "Y",
      modelType: ModelType.alphabet,
      assetPath: "https://github.com/rutvik110/ar_project/raw/main/Models/alphabets/y.glb",
      audioPath: "pronounciations/Y.wav"),
  ARModel(
      name: "Z",
      modelType: ModelType.alphabet,
      assetPath: "https://github.com/rutvik110/ar_project/raw/main/Models/alphabets/z.glb",
      audioPath: "pronounciations/Z.wav"),
];

const List<ARModel> numberModels = [
  ARModel(
      name: "0",
      modelType: ModelType.number,
      assetPath: "https://github.com/rutvik110/ar_project/raw/main/Models/numbers/0.glb",
      audioPath: "pronounciations/0.wav"),
  ARModel(
      name: "1",
      modelType: ModelType.number,
      assetPath: "https://github.com/rutvik110/ar_project/raw/main/Models/numbers/1.glb",
      audioPath: "pronounciations/1.wav"),
  ARModel(
      name: "2",
      modelType: ModelType.number,
      assetPath: "https://github.com/rutvik110/ar_project/raw/main/Models/numbers/2.glb",
      audioPath: "pronounciations/2.wav"),
  ARModel(
      name: "3",
      modelType: ModelType.number,
      assetPath: "https://github.com/rutvik110/ar_project/raw/main/Models/numbers/3.glb",
      audioPath: "pronounciations/3.wav"),
  ARModel(
      name: "4",
      modelType: ModelType.number,
      assetPath: "https://github.com/rutvik110/ar_project/raw/main/Models/numbers/4.glb",
      audioPath: "pronounciations/4.wav"),
  ARModel(
      name: "5",
      modelType: ModelType.number,
      assetPath: "https://github.com/rutvik110/ar_project/raw/main/Models/numbers/5.glb",
      audioPath: "pronounciations/5.wav"),
  ARModel(
      name: "6",
      modelType: ModelType.number,
      assetPath: "https://github.com/rutvik110/ar_project/raw/main/Models/numbers/6.glb",
      audioPath: "pronounciations/6.wav"),
  ARModel(
      name: "7",
      modelType: ModelType.number,
      assetPath: "https://github.com/rutvik110/ar_project/raw/main/Models/numbers/7.glb",
      audioPath: "pronounciations/7.wav"),
  ARModel(
      name: "8",
      modelType: ModelType.number,
      assetPath: "https://github.com/rutvik110/ar_project/raw/main/Models/numbers/8.glb",
      audioPath: "pronounciations/8.wav"),
  ARModel(
      name: "9",
      modelType: ModelType.number,
      assetPath: "https://github.com/rutvik110/ar_project/raw/main/Models/numbers/9.glb",
      audioPath: "pronounciations/9.wav"),
];
