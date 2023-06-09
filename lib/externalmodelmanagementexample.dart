import 'package:ar_flutter_plugin/ar_flutter_plugin.dart';
import 'package:ar_flutter_plugin/datatypes/config_planedetection.dart';
import 'package:ar_flutter_plugin/datatypes/hittest_result_types.dart';
import 'package:ar_flutter_plugin/datatypes/node_types.dart';
import 'package:ar_flutter_plugin/managers/ar_anchor_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_location_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_session_manager.dart';
import 'package:ar_flutter_plugin/models/ar_anchor.dart';
import 'package:ar_flutter_plugin/models/ar_hittest_result.dart';
import 'package:ar_flutter_plugin/models/ar_node.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collegearproject/dashboard.dart';
import 'package:collegearproject/providers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:vector_math/vector_math_64.dart' as VectorMath;

class ExternalModelManagementWidget extends ConsumerStatefulWidget {
  const ExternalModelManagementWidget({
    super.key,
    required this.arModel,
  });

  final ARModel arModel;
  @override
  ConsumerState<ExternalModelManagementWidget> createState() => _ExternalModelManagementWidgetState();
}

class _ExternalModelManagementWidgetState extends ConsumerState<ExternalModelManagementWidget> {
  // Firebase stuff
  bool _initialized = false;
  bool _error = false;
  FirebaseManager firebaseManager = FirebaseManager();
  Map<String, Map> anchorsInDownloadProgress = <String, Map>{};

  late ARSessionManager arSessionManager;
  late ARObjectManager arObjectManager;
  late ARAnchorManager arAnchorManager;
  late ARLocationManager arLocationManager;

  List<ARNode> nodes = [];
  List<ARAnchor> anchors = [];
  String lastUploadedAnchor = "";
  late AvailableModel selectedModel;

  bool readyToUpload = false;
  bool readyToDownload = true;
  bool modelChoiceActive = false;

  final AudioPlayer audioPlayer = AudioPlayer();
  late bool isCompleted;
  bool isFavourite = false;
  @override
  void initState() {
    super.initState();
    isCompleted = widget.arModel.isCompleted;
    isFavourite = widget.arModel.isFavourite;
    selectedModel = AvailableModel(
        widget.arModel.name,
        widget.arModel.assetPath,
        // "https://github.com/rutvik110/ar_project/raw/main/Models/a/a_alphabet.glb",
        "");
    firebaseManager.initializeFlutterFire().then((value) => setState(() {
          _initialized = value;
          _error = !value;
        }));
  }

  Future<void> playTrack() async {
    await audioPlayer.play(
      AssetSource(widget.arModel.audioPath),
      volume: 1,
    );
  }

  @override
  void dispose() {
    super.dispose();
    arSessionManager.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    // Show error message if initialization failed
    if (_error) {
      return Scaffold(
          appBar: AppBar(
            title: const Text('External Model Management'),
          ),
          body: Center(
            child: Column(
              children: [
                const Text("Firebase initialization failed"),
                ElevatedButton(child: const Text("Retry"), onPressed: () => {initState()})
              ],
            ),
          ));
    }

    // Show a loader until FlutterFire is initialized
    if (!_initialized) {
      return Scaffold(
          appBar: AppBar(
            title: const Text('External Model Management'),
          ),
          body: Container(
              child:
                  Center(child: Column(children: const [CircularProgressIndicator(), Text("Initializing Firebase")]))));
    }

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            if (isCompleted)
              const Icon(
                Icons.check_circle_rounded,
                color: Colors.greenAccent,
              ),
            const SizedBox(
              width: 8,
            ),
            Text('${widget.arModel.name} Model Display'),
          ],
        ),
        // actions: <Widget>[
        //   // IconButton(
        //   //   icon: Icon(Icons.pets),
        //   //   onPressed: () {
        //   //     setState(() {
        //   //       modelChoiceActive = !modelChoiceActive;
        //   //     });
        //   //   },
        //   // ),
        // ],
      ),
      body: Stack(
        children: [
          ARView(
            onARViewCreated: onARViewCreated,
            planeDetectionConfig: PlaneDetectionConfig.horizontalAndVertical,
          ),
          // Align(
          //   alignment: FractionalOffset.bottomCenter,
          //   child: Row(
          //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //       children: [
          //         ElevatedButton(
          //             onPressed: onRemoveEverything,
          //             child: Text("Remove Everything")),
          //       ]),
          // ),
          // Align(
          //   alignment: FractionalOffset.topCenter,
          //   child: Row(
          //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //       children: [
          //         Visibility(
          //             visible: readyToUpload,
          //             child: ElevatedButton(
          //                 onPressed: onUploadButtonPressed,
          //                 child: Text("Upload"))),
          //         Visibility(
          //             visible: readyToDownload,
          //             child: ElevatedButton(
          //                 onPressed: onDownloadButtonPressed,
          //                 child: Text("Download"))),
          //       ]),
          // ),
          Align(
              alignment: FractionalOffset.centerLeft,
              child: Visibility(
                  visible: modelChoiceActive,
                  child: ModelSelectionWidget(onTap: onModelSelected, firebaseManager: firebaseManager))),
          Align(
            alignment: Alignment.bottomRight,
            child: Row(
              children: [
                const SizedBox(
                  width: 8,
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    playTrack();
                  },
                  icon: const Icon(
                    Icons.voice_chat_rounded,
                  ),
                  label: const Text(
                    "Pronounce",
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    final alphabets =
                        ref.read(sharedPreferancesProvider).getStringList("${user!.uid}_favourites") ?? [];

                    final updatedList = List<String>.from(alphabets);
                    updatedList.add(widget.arModel.name);
                    await ref.read(sharedPreferancesProvider).setStringList("${user.uid}_favourites", updatedList);
                    setState(() {
                      isFavourite = true;
                    });
                  },
                  icon: Icon(
                    isFavourite ? Icons.favorite : Icons.favorite_border,
                    color: isFavourite ? Colors.red : Colors.white,
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                ElevatedButton.icon(
                  onPressed: () async {
                    final alphabets = ref.read(sharedPreferancesProvider).getStringList(
                            widget.arModel.modelType == ModelType.alphabet
                                ? "${user!.uid}_alphabetsProgress"
                                : "${user!.uid}_numbersProgress") ??
                        [];

                    final updatedList = List<String>.from(alphabets);
                    updatedList.add(widget.arModel.name);
                    await ref.read(sharedPreferancesProvider).setStringList(
                        widget.arModel.modelType == ModelType.alphabet
                            ? "${user.uid}_alphabetsProgress"
                            : "${user.uid}_numbersProgress",
                        updatedList);
                    setState(() {
                      isCompleted = true;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                            "🥳 Hooray! You learned a new ${widget.arModel.modelType == ModelType.alphabet ? "word" : "number"}👏")));
                  },
                  icon: Icon(
                    Icons.check_circle_rounded,
                    color: isCompleted ? Colors.greenAccent : null,
                  ),
                  label: Text(
                    isCompleted
                        ? "${widget.arModel.modelType == ModelType.alphabet ? "Alphabet" : "Number"} Leanred"
                        : "Mark As Complete",
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void onARViewCreated(
    ARSessionManager narSessionManager,
    ARObjectManager narObjectManager,
    ARAnchorManager narAnchorManager,
    ARLocationManager narLocationManager,
  ) {
    arSessionManager = narSessionManager;
    arObjectManager = narObjectManager;
    arAnchorManager = narAnchorManager;
    arLocationManager = narLocationManager;

    arSessionManager.onInitialize(
      showFeaturePoints: false,
      showPlanes: true,
      customPlaneTexturePath: "Images/triangle.png",
      showWorldOrigin: true,
    );
    arObjectManager.onInitialize();
    arAnchorManager.initGoogleCloudAnchorMode();

    arSessionManager.onPlaneOrPointTap = onPlaneOrPointTapped;
    arObjectManager.onNodeTap = onNodeTapped;
    arAnchorManager.onAnchorUploaded = onAnchorUploaded;
    arAnchorManager.onAnchorDownloaded = onAnchorDownloaded;

    arLocationManager.startLocationUpdates().then((value) => null).onError((error, stackTrace) {
      switch (error.toString()) {
        case 'Location services disabled':
          {
            showAlertDialog(
                context,
                "Action Required",
                "To use cloud anchor functionality, please enable your location services",
                "Settings",
                arLocationManager.openLocationServicesSettings,
                "Cancel");
            break;
          }

        case 'Location permissions denied':
          {
            showAlertDialog(
                context,
                "Action Required",
                "To use cloud anchor functionality, please allow the app to access your device's location",
                "Retry",
                arLocationManager.startLocationUpdates,
                "Cancel");
            break;
          }

        case 'Location permissions permanently denied':
          {
            showAlertDialog(
                context,
                "Action Required",
                "To use cloud anchor functionality, please allow the app to access your device's location",
                "Settings",
                arLocationManager.openAppPermissionSettings,
                "Cancel");
            break;
          }

        default:
          {
            arSessionManager.onError(error.toString());
            break;
          }
      }
      arSessionManager.onError(error.toString());
    });
  }

  void onModelSelected(AvailableModel model) {
    selectedModel = model;
    arSessionManager.onError("${model.name} selected");
    setState(() {
      modelChoiceActive = false;
    });
  }

  Future<void> onRemoveEverything() async {
    for (var anchor in anchors) {
      arAnchorManager.removeAnchor(anchor);
    }
    anchors = [];
    if (lastUploadedAnchor != "") {
      setState(() {
        readyToDownload = true;
        readyToUpload = false;
      });
    } else {
      setState(() {
        readyToDownload = true;
        readyToUpload = false;
      });
    }
  }

  Future<void> onNodeTapped(List<String> nodeNames) async {
    var foregroundNode = nodes.firstWhere((element) => element.name == nodeNames.first);
    arSessionManager.onError(foregroundNode.data?["onTapText"]);
  }

  Future<void> onPlaneOrPointTapped(List<ARHitTestResult> hitTestResults) async {
    var singleHitTestResult =
        hitTestResults.firstWhere((hitTestResult) => hitTestResult.type == ARHitTestResultType.plane);
    var newAnchor = ARPlaneAnchor(transformation: singleHitTestResult.worldTransform, ttl: 2);
    bool? didAddAnchor = await arAnchorManager.addAnchor(newAnchor);
    if (didAddAnchor != null && didAddAnchor) {
      anchors.add(newAnchor);
      // Add note to anchor
      var newNode = ARNode(
          type: NodeType.webGLB,
          uri: selectedModel.uri,
          scale: VectorMath.Vector3(0.2, 0.2, 0.2),
          position: VectorMath.Vector3(0.0, 0.0, 0.0),
          rotation: VectorMath.Vector4(1.0, 0.0, 0.0, 0.0),
          data: {"onTapText": "I am a ${selectedModel.name}"});
      bool? didAddNodeToAnchor = await arObjectManager.addNode(newNode, planeAnchor: newAnchor);
      if (didAddNodeToAnchor != null && didAddNodeToAnchor) {
        nodes.add(newNode);
        setState(() {
          readyToUpload = true;
        });
      } else {
        arSessionManager.onError("Adding Node to Anchor failed");
      }
    } else {
      arSessionManager.onError("Adding Anchor failed");
    }
  }

  Future<void> onUploadButtonPressed() async {
    arAnchorManager.uploadAnchor(anchors.last);
    setState(() {
      readyToUpload = false;
    });
  }

  onAnchorUploaded(ARAnchor anchor) {
    // Upload anchor information to firebase
    firebaseManager.uploadAnchor(anchor, arLocationManager.currentLocation);
    // Upload child nodes to firebase
    if (anchor is ARPlaneAnchor) {
      for (var nodeName in anchor.childNodes) {
        firebaseManager.uploadObject(nodes.firstWhere((element) => element.name == nodeName));
      }
    }
    setState(() {
      readyToDownload = true;
      readyToUpload = false;
    });
    arSessionManager.onError("Upload successful");
  }

  ARAnchor onAnchorDownloaded(Map<String, dynamic> serializedAnchor) {
    final data = anchorsInDownloadProgress[serializedAnchor["cloudanchorid"]]!;

    final anchor = ARPlaneAnchor.fromJson(Map.castFrom<dynamic, dynamic, String, dynamic>(data));
    anchorsInDownloadProgress.remove(anchor.cloudanchorid);
    anchors.add(anchor);

    // Download nodes attached to this anchor
    firebaseManager.getObjectsFromAnchor(anchor, (snapshot) {
      for (var objectDoc in snapshot.docs) {
        final data = objectDoc.data()!;
        data as Map<String, dynamic>;
        final object = ARNode.fromMap(data);
        arObjectManager.addNode(object, planeAnchor: anchor);
        nodes.add(object);
      }
    });

    return anchor;
  }

  Future<void> onDownloadButtonPressed() async {
    //this.arAnchorManager.downloadAnchor(lastUploadedAnchor);
    //firebaseManager.downloadLatestAnchor((snapshot) {
    //  final cloudAnchorId = snapshot.docs.first.get("cloudanchorid");
    //  anchorsInDownloadProgress[cloudAnchorId] = snapshot.docs.first.data();
    //  arAnchorManager.downloadAnchor(cloudAnchorId);
    //});

    // Get anchors within a radius of 100m of the current device's location
    if (arLocationManager.currentLocation != null) {
      firebaseManager.downloadAnchorsByLocation((snapshot) {
        final cloudAnchorId = snapshot.get("cloudanchorid");
        anchorsInDownloadProgress[cloudAnchorId] = snapshot.data()! as Map<String, dynamic>;
        arAnchorManager.downloadAnchor(cloudAnchorId);
      }, arLocationManager.currentLocation, 0.1);
      setState(() {
        readyToDownload = false;
      });
    } else {
      arSessionManager.onError("Location updates not running, can't download anchors");
    }
  }

  void showAlertDialog(BuildContext context, String title, String content, String buttonText, Function buttonFunction,
      String cancelButtonText) {
    // set up the buttons
    Widget cancelButton = ElevatedButton(
      child: Text(cancelButtonText),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget actionButton = ElevatedButton(
      child: Text(buttonText),
      onPressed: () {
        buttonFunction();
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        cancelButton,
        actionButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}

// Class for managing interaction with Firebase (in your own app, this can be put in a separate file to keep everything clean and tidy)
typedef FirebaseListener = void Function(QuerySnapshot snapshot);
typedef FirebaseDocumentStreamListener = void Function(DocumentSnapshot snapshot);

class FirebaseManager {
  late FirebaseFirestore firestore;
  late Geoflutterfire geo;
  late CollectionReference<Map<String, dynamic>> anchorCollection;
  late CollectionReference objectCollection;
  late CollectionReference modelCollection;

  // Firebase initialization function
  Future<bool> initializeFlutterFire() async {
    try {
      // Wait for Firebase to initialize
      await Firebase.initializeApp();
      geo = Geoflutterfire();
      firestore = FirebaseFirestore.instance;
      anchorCollection = FirebaseFirestore.instance.collection('anchors');
      objectCollection = FirebaseFirestore.instance.collection('objects');
      modelCollection = FirebaseFirestore.instance.collection('models');
      return true;
    } catch (e) {
      return false;
    }
  }

  void uploadAnchor(ARAnchor anchor, Position currentLocation) {
    if (firestore == null) return;

    var serializedAnchor = anchor.toJson();
    var expirationTime = DateTime.now().millisecondsSinceEpoch / 1000 + serializedAnchor["ttl"] * 24 * 60 * 60;
    serializedAnchor["expirationTime"] = expirationTime;
    // Add location
    GeoFirePoint myLocation = geo.point(latitude: currentLocation.latitude, longitude: currentLocation.longitude);
    serializedAnchor["position"] = myLocation.data;

    anchorCollection
        .add(serializedAnchor)
        .then((value) => print("Successfully added anchor: " + serializedAnchor["name"]))
        .catchError((error) => print("Failed to add anchor: $error"));
  }

  void uploadObject(ARNode node) {
    if (firestore == null) return;

    var serializedNode = node.toMap();

    objectCollection
        .add(serializedNode)
        .then((value) => print("Successfully added object: " + serializedNode["name"]))
        .catchError((error) => print("Failed to add object: $error"));
  }

  void downloadLatestAnchor(FirebaseListener listener) {
    anchorCollection
        .orderBy("expirationTime", descending: false)
        .limitToLast(1)
        .get()
        .then((value) => listener(value))
        .catchError((error) => (error) => print("Failed to download anchor: $error"));
  }

  void downloadAnchorsByLocation(FirebaseDocumentStreamListener listener, Position location, double radius) {
    GeoFirePoint center = geo.point(latitude: location.latitude, longitude: location.longitude);

    Stream<List<DocumentSnapshot>> stream =
        geo.collection(collectionRef: anchorCollection).within(center: center, radius: radius, field: 'position');

    stream.listen((List<DocumentSnapshot> documentList) {
      for (var element in documentList) {
        listener(element);
      }
    });
  }

  void downloadAnchorsByChannel() {}

  void getObjectsFromAnchor(ARPlaneAnchor anchor, FirebaseListener listener) {
    objectCollection
        .where("name", whereIn: anchor.childNodes)
        .get()
        .then((value) => listener(value))
        .catchError((error) => print("Failed to download objects: $error"));
  }

  void deleteExpiredDatabaseEntries() {
    WriteBatch batch = FirebaseFirestore.instance.batch();
    anchorCollection
        .where("expirationTime", isLessThan: DateTime.now().millisecondsSinceEpoch / 1000)
        .get()
        .then((anchorSnapshot) => anchorSnapshot.docs.forEach((anchorDoc) {
              // Delete all objects attached to the expired anchor
              objectCollection.where("name", arrayContainsAny: anchorDoc.get("childNodes")).get().then(
                  (objectSnapshot) => objectSnapshot.docs.forEach((objectDoc) => batch.delete(objectDoc.reference)));
              // Delete the expired anchor
              batch.delete(anchorDoc.reference);
            }));
    batch.commit();
  }

  void downloadAvailableModels(FirebaseListener listener) {
    modelCollection
        .get()
        .then((value) => listener(value))
        .catchError((error) => print("Failed to download objects: $error"));
  }
}

class AvailableModel {
  String name;
  String uri;
  String image;
  AvailableModel(this.name, this.uri, this.image);
}

class ModelSelectionWidget extends StatefulWidget {
  final Function onTap;
  final FirebaseManager firebaseManager;

  const ModelSelectionWidget({super.key, required this.onTap, required this.firebaseManager});

  @override
  _ModelSelectionWidgetState createState() => _ModelSelectionWidgetState();
}

class _ModelSelectionWidgetState extends State<ModelSelectionWidget> {
  List<AvailableModel> models = [];

  @override
  void initState() {
    super.initState();
    widget.firebaseManager.downloadAvailableModels((snapshot) {
      for (var element in snapshot.docs) {
        setState(() {
          models
              .add(AvailableModel(element.get("name"), element.get("uri"), element.get("image").first["downloadURL"]));
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: Colors.white,
                style: BorderStyle.solid,
                width: 4.0,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(5)),
              shape: BoxShape.rectangle,
              boxShadow: const <BoxShadow>[
                BoxShadow(
                  color: Color(0x66000000),
                  blurRadius: 10.0,
                  spreadRadius: 4.0,
                )
              ],
            ),
            child: Text('Choose a Model', style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 2.0)),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.width * 0.65,
            child: ListView.builder(
              itemCount: models.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    widget.onTap(models[index]);
                  },
                  child: Card(
                    elevation: 4.0,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(5),
                      ),
                    ),
                    child: Column(
                      children: [
                        Padding(padding: const EdgeInsets.all(20), child: Image.network(models[index].image)),
                        Text(
                          models[index].name,
                          style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 2.0),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          )
        ]);
  }
}
