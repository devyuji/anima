import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

import 'package:anima/constraint.dart';
import 'package:anima/model/profile.dart';
import 'package:anima/provider/profile.dart';
import 'package:anima/provider/view_screen.dart';
import 'package:anima/widgets/back.dart';
import 'package:anima/widgets/gap.dart';

class StartUpScreen extends ConsumerStatefulWidget {
  const StartUpScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _StartUpScreenState();
}

class _StartUpScreenState extends ConsumerState<StartUpScreen> {
  late final GlobalKey<FormState> _formKey;
  String _name = "";

  @override
  void initState() {
    super.initState();

    _formKey = GlobalKey<FormState>();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _next() async {
    if (!_formKey.currentState!.validate()) return;

    _formKey.currentState!.save();

    ref
        .read(fetchProfileProvider.notifier)
        .add(Profile(name: _name, image: ""));

    ref.read(viewScreenProvider.notifier).change(false);

    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            leading: backButton(context),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(kDefaultPadding),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "To Get Started please enter your name",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Gap(),
                  Form(
                    key: _formKey,
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: "Name",
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                          color: kActionColor,
                        )),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: kActionColor,
                          ),
                        ),
                      ),
                      onSaved: ((newValue) => _name = newValue ?? ""),
                    ),
                  ),
                  const Gap(),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      onPressed: _next,
                      icon: const Icon(Icons.east_outlined),
                      label: const Text("Next"),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
