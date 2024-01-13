import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:install_plugin/install_plugin.dart';
import 'package:path_provider/path_provider.dart';

import 'package:anima/widgets/loading.dart';
import 'package:anima/constraint.dart';
import 'package:anima/provider/check_for_update.dart';
import 'package:anima/widgets/back.dart';
import 'package:anima/widgets/gap.dart';

class CheckForUpdateScreen extends ConsumerStatefulWidget {
  const CheckForUpdateScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CheckForUpdateScreenState();
}

class _CheckForUpdateScreenState extends ConsumerState<CheckForUpdateScreen> {
  final CancelToken _cancelToken = CancelToken();
  String _downloadProgress = "Update";

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _cancelToken.cancel();

    super.dispose();
  }

  Future<void> _downloadAPK(String url) async {
    try {
      final tempDir = await getTemporaryDirectory();
      final downloadPath = "${tempDir.path}/anima.apk";

      await Dio().downloadUri(
        Uri.parse(url),
        downloadPath,
        cancelToken: _cancelToken,
        onReceiveProgress: (received, total) {
          if (total <= 0) {
            return;
          }
          setState(() {
            _downloadProgress =
                "${(received / total * 100).toStringAsFixed(0)}%";
          });
        },
      );

      await InstallPlugin.install(downloadPath);
    } catch (err) {
      debugPrint("$err");
    }
  }

  @override
  Widget build(BuildContext context) {
    final response = ref.watch(checkForUpdateProvider);

    return SafeArea(
      child: Scaffold(
        body: RefreshIndicator(
          backgroundColor: kPrimaryColor,
          color: kActionColor,
          onRefresh: () => ref.refresh(checkForUpdateProvider.future),
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                leading: backButton(context),
                title: const Text("Check For Update"),
              ),
              SliverPadding(
                padding: const EdgeInsets.all(kDefaultPadding),
                sliver: SliverToBoxAdapter(
                  child: response.when(
                    data: (data) {
                      return Column(
                        children: [
                          const Icon(Icons.auto_awesome_outlined),
                          const Gap(),
                          Text(
                            data.version,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const Gap(),
                          Text(data.body),
                          if (data.updateAvailable)
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () => _downloadAPK(data.downloadUrl),
                                child: Text(
                                  _downloadProgress,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                    error: (err, _) => Center(
                      child: Text(
                        "ERROR!! unable to check for new update.",
                        style:
                            TextStyle(fontSize: 20, color: Colors.red.shade300),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    loading: () => const Center(
                      child: RepaintBoundary(
                        child: Loading(),
                      ),
                    ),
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
