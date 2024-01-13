import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:anima/main.dart';
import 'package:anima/provider/profile.dart';
import 'package:anima/screen/setting/check_for_update.dart';
import 'package:anima/widgets/loading.dart';
import 'package:anima/widgets/scroll_indicator.dart';
import 'package:anima/utils/custom_route_animation.dart';
import 'package:anima/utils/custom_snackbar.dart';
import 'package:anima/constraint.dart';
import 'package:anima/screen/setting/backup_restore.dart';
import 'package:anima/widgets/custom_modal_bottom_sheet.dart';
import 'package:anima/widgets/gap.dart';

class SettingScreen extends ConsumerStatefulWidget {
  const SettingScreen({super.key});

  @override
  ConsumerState<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends ConsumerState<SettingScreen> {
  String _requestFeatureMessage = "";
  final _formKey = GlobalKey<FormState>();

  Future<void> _requestFeatureSend() async {
    _formKey.currentState!.save();

    String email = Uri.encodeComponent("raghavancool24@gmail.com");
    String subject = Uri.encodeComponent("Request a new Feature #anima");
    String body = Uri.encodeComponent(_requestFeatureMessage);

    Uri mail = Uri.parse("mailto:$email?subject=$subject&body=$body");
    if (!await launchUrl(mail)) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(customSnackBar(context, "Unable to open mail.", true));
    }
  }

  void _requestFeature() {
    customModalBottomSheet(
      context,
      (_) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.9,
        child: Padding(
          padding: const EdgeInsets.all(kDefaultPadding),
          child: Column(
            children: [
              const Align(
                alignment: Alignment.center,
                child: ScrollIndicator(),
              ),
              const Gap(),
              Expanded(
                child: ListView(
                  children: [
                    const Text(
                      "Request a feature",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                    const Gap(),
                    Text(
                      "Enter the feature you want to add and I will be sure to check and come up with it.",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade400,
                      ),
                    ),
                    const Gap(),
                    Form(
                      key: _formKey,
                      child: TextFormField(
                        onSaved: (text) {
                          _requestFeatureMessage = text ?? "";
                        },
                        style: Theme.of(context)
                            .inputDecorationTheme
                            .hintStyle!
                            .copyWith(
                              color: Colors.white,
                            ),
                        decoration: InputDecoration(
                          labelText: "Feature required",
                          hintText: "I would like to have...",
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: kActionColor,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: kActionColor,
                            ),
                          ),
                        ),
                        maxLines: null,
                      ),
                    ),
                    const Gap(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton.icon(
                          style: ButtonStyle(
                            shape: MaterialStatePropertyAll(
                              RoundedRectangleBorder(
                                side: const BorderSide(color: kActionColor),
                                borderRadius:
                                    BorderRadius.circular(kBorderRadius),
                              ),
                            ),
                          ),
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(
                            Icons.close,
                            color: Colors.white,
                          ),
                          label: const Text(
                            "Close",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const Gap(
                          axis: Axis.horizontal,
                        ),
                        TextButton.icon(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(kActionColor),
                          ),
                          onPressed: _requestFeatureSend,
                          icon: const Icon(
                            Icons.send,
                            color: Colors.white,
                          ),
                          label: const Text(
                            "Send",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(fetchProfileProvider);

    return CustomScrollView(
      slivers: [
        const SliverAppBar(
          floating: true,
          title: Text("Setting"),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(kDefaultPadding),
          sliver: SliverToBoxAdapter(
            child: Column(
              children: [
                profile.when(
                  data: (data) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          flex: 1,
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(kBorderRadius),
                              child: SizedBox(
                                height: double.infinity,
                                width: double.infinity,
                                child: Image.asset(
                                  "assets/images/profile_placeholder.png",
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const Gap(
                          axis: Axis.horizontal,
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            data.name.capitalize(),
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    );
                  },
                  error: (error, _) => const Text("error"),
                  loading: () => const RepaintBoundary(child: Loading()),
                ),
                const Gap(),
                listly(
                  const Icon(Icons.cloud_upload),
                  "Backup & Restore",
                  const Icon(Icons.navigate_next),
                  () => Navigator.push(
                    context,
                    customRouteAnimation(
                      const BackupScreen(),
                    ),
                  ),
                ),
                const Gap(),
                listly(
                  const Icon(Icons.star),
                  "Request a Feature",
                  const Icon(Icons.navigate_next),
                  _requestFeature,
                ),
                const Gap(),
                listly(
                  const Icon(Icons.bug_report),
                  "Report a Bug",
                  const Icon(Icons.navigate_next),
                  () async => await launchUrl(
                    Uri.parse("https://github.com/devyuji/anima-app/issues"),
                    mode: LaunchMode.externalApplication,
                  ),
                ),
                const Gap(),
                listly(
                  const Icon(Icons.update_outlined),
                  "Check for update",
                  const Icon(Icons.navigate_next),
                  () => Navigator.push(context,
                      customRouteAnimation(const CheckForUpdateScreen())),
                ),
                const Gap(),
                listly(
                  const Icon(Icons.code),
                  "Developer",
                  const Icon(Icons.navigate_next),
                  () async {
                    await launchUrl(
                      Uri.parse("https://devyuji.com"),
                      mode: LaunchMode.externalApplication,
                    );
                  },
                ),
                const Gap(),
                const Text(
                  "v1.0.0",
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  GestureDetector listly(
      [Widget? trailing,
      String? title,
      Widget? leading,
      void Function()? onTap]) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(kDefaultPadding),
        decoration: BoxDecoration(
          color: kPrimaryColor,
          borderRadius: BorderRadius.circular(kBorderRadius),
        ),
        child: Row(
          children: [
            trailing ?? const SizedBox(),
            const Gap(
              axis: Axis.horizontal,
            ),
            Text(title ?? ""),
            const Spacer(),
            leading ?? const SizedBox(),
          ],
        ),
      ),
    );
  }
}
