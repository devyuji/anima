import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as Path;

import 'package:anima/database/anime_db.dart';
import 'package:anima/utils/custom_snackbar.dart';
import 'package:anima/constraint.dart';
import 'package:anima/widgets/gap.dart';
import 'package:anima/widgets/back.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BackupScreen extends StatefulWidget {
  const BackupScreen({Key? key}) : super(key: key);

  @override
  State<BackupScreen> createState() => _BackupScreenState();
}

class _BackupScreenState extends State<BackupScreen> {
  String _lastBackup = "Never";
  bool _restoring = false;
  bool _backing = false;
  String _backupDir = "";

  @override
  void initState() {
    super.initState();

    _init();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _init() async {
    final pref = await SharedPreferences.getInstance();

    final b = await _backupPath();

    setState(() {
      _lastBackup = pref.getString("lastBackup") ?? "Never";
      _backupDir = b;
    });
  }

  Future<String> _backupPath() async {
    final path = await getExternalStorageDirectory();
    final splitList = path!.path.split('Android');
    final splitTillAndroid = splitList[0];

    final backupPath = Path.join(
        splitTillAndroid, "Android", "media", "com.devyuji.anima", "backup");

    return backupPath;
  }

  Future<void> _backup() async {
    setState(() {
      _backing = true;
    });
    try {
      final pref = await SharedPreferences.getInstance();

      final backupPath = _backupDir;
      final dbPath = await AnimeDB.databasePath();

      final status = await Permission.manageExternalStorage.request();
      if (status.isDenied) {
        if (!mounted) return;

        customSnackBar(context, "Required storage permission", true);
      } else {
        final backupDir = Directory(backupPath);
        if (!await backupDir.exists()) {
          await backupDir.create(recursive: true);
        }

        final f = File(dbPath);
        await f.copy(Path.join(backupPath, 'anime_list.db'));

        DateTime now = DateTime.now();
        String formattedDate = DateFormat('dd-MM-yyyy HH:mm').format(now);

        pref.setString("lastBackup", formattedDate);

        setState(() {
          _lastBackup = formattedDate;
        });
      }
    } catch (err) {
      debugPrint("$err");
      if (!mounted) return;

      customSnackBar(context, "Unable to create a backup");
    }
    setState(() {
      _backing = false;
    });
  }

  Future<void> _restore([String? filePath]) async {
    setState(() {
      _restoring = true;
    });

    try {
      final dbPath = await AnimeDB.databasePath();
      final backupPath = await _backupPath();

      File backupDir = File(Path.join(backupPath, "anime_list.db"));

      if (!await backupDir.exists() && filePath == null) {
        if (!mounted) return;

        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: const Text(
              "No Backup file found",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  final result = await FilePicker.platform.pickFiles();

                  if (result == null) return;

                  _restore(result.files.single.path);

                  if (!mounted) return;
                  Navigator.pop(context);
                },
                child: const Text('Choose file'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Close"),
              ),
            ],
          ),
        );
      } else {
        if (filePath != null) {
          await File(filePath).copy(dbPath);
        } else {
          await backupDir.copy(dbPath);
        }

        if (!mounted) return;
      }
    } catch (err) {
      debugPrint("$err");
    }

    setState(() {
      _restoring = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            snap: true,
            leading: backButton(context),
            title: const Text("Backup and Restore"),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(kDefaultPadding),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.backup_outlined),
                      Gap(
                        axis: Axis.horizontal,
                      ),
                      Text(
                        "Backup",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const Gap(),
                  Text(
                    "Back up your anime list. You can restore them when you reinstall anima. Your anime list will also be backed up.",
                    style: TextStyle(
                      leadingDistribution: TextLeadingDistribution.even,
                      color: Colors.grey.shade400,
                    ),
                  ),
                  const Gap(),
                  Text(
                    "Last Backup : $_lastBackup",
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Gap(),
                  if (_backing)
                    const LinearProgressIndicator(
                      minHeight: 2,
                    ),
                  TextButton(
                    style: const ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(kActionColor),
                    ),
                    onPressed: _backup,
                    child: const Text(
                      "Back up",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const Gap(),
                  const Row(
                    children: [
                      Icon(Icons.restore),
                      Gap(
                        axis: Axis.horizontal,
                      ),
                      Text(
                        "Restore",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const Gap(),
                  Text(
                    "Restore your anime list.",
                    style: TextStyle(
                      color: Colors.grey.shade400,
                    ),
                  ),
                  const Gap(),
                  if (_restoring) const LinearProgressIndicator(minHeight: 2),
                  TextButton(
                    style: const ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(kActionColor),
                      padding: MaterialStatePropertyAll(EdgeInsets.all(10)),
                    ),
                    onPressed: _restore,
                    child: const Text(
                      "Restore",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const Gap(),
                  Row(
                    children: [
                      Icon(
                        Icons.info_outlined,
                        color: Colors.grey.shade500,
                        size: 20,
                      ),
                      const Gap(size: 10, axis: Axis.horizontal),
                      Text(
                        "Restoring will override the current anime list.",
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
