import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/desktop/common/button/d_custom_text_big_button.dart';
import 'package:sideswap/desktop/common/button/d_toolbar_button.dart';
import 'package:sideswap/providers/autosign_provider.dart';
import 'package:sideswap/providers/swaption_session_providers.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/providers/warmup_app_provider.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

class DSwaptionConnectionsButton extends HookConsumerWidget {
  const DSwaptionConnectionsButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final swaptionSessions = ref.watch(swaptionSessionProvider);

    final animationController = useAnimationController(
      duration: const Duration(milliseconds: 150),
      reverseDuration: const Duration(milliseconds: 75),
      initialValue: 0,
    );

    final Animation<double> heightFactor = useMemoized(() {
      return animationController.drive(CurveTween(curve: Curves.fastOutSlowIn));
    }, [animationController]);

    final expanded = useState(false);
    final entry = useState<OverlayEntry?>(null);
    final overlay = useMemoized(() => Overlay.of(context));
    final buttonKey = useMemoized(() => GlobalKey());
    final size = MediaQuery.of(context).size;

    final showOverlayCallback = useCallback((double left, double top) {
      final navigatorKey = ref.read(navigatorKeyProvider);
      final navigatorRenderBox =
          navigatorKey.currentContext!.findRenderObject() as RenderBox;
      final size = navigatorRenderBox.size;

      final buttonRenderBox =
          buttonKey.currentContext!.findRenderObject() as RenderBox;

      final offset = navigatorRenderBox.localToGlobal(
        Offset(size.width - left, buttonRenderBox.size.height + top),
      );

      entry.value = OverlayEntry(
        builder: (context) {
          return SwaptionConnectionsMenu(
            offset: offset,
            animationController: animationController,
            heightFactor: heightFactor,
            onTap: () {
              expanded.value = !expanded.value;
            },
          );
        },
      );
      overlay.insert(entry.value!);
    }, [context, overlay]);

    useEffect(() {
      // cleanup overlay ondispose widget
      return () {
        entry.value?.remove();
      };
    }, const []);

    useEffect(() {
      if (expanded.value && entry.value == null) {
        Future.microtask(() => showOverlayCallback.call(374, 4));
        return;
      }

      return;
    }, [expanded.value]);

    useEffect(() {
      if (expanded.value) {
        animationController.forward();
        return;
      }

      animationController.reverse();
      return;
    }, [expanded.value]);

    useEffect(() {
      animationController.addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.dismissed) {
          entry.value?.remove();
          entry.value = null;
          return;
        }
      });

      return;
    }, [animationController]);

    useEffect(() {
      if (entry.value != null) {
        entry.value?.remove();
        Future.microtask(() => showOverlayCallback.call(374, 4));
      }
      return;
    }, [size]);

    useEffect(() {
      if (swaptionSessions.isEmpty) {
        expanded.value = false;
        entry.value?.remove();
        entry.value = null;
        return;
      }

      return;
    }, [swaptionSessions]);

    return DTopToolbarButton(
      key: buttonKey,
      name: '',
      icon: SizedBox(
        width: 18,
        height: 18,
        child: Stack(
          children: [
            swaptionSessions.isNotEmpty
                ? Badge.count(
                    count: swaptionSessions.length,
                    maxCount: 99,
                    backgroundColor: SideSwapColors.bitterSweet,
                    child: SvgPicture.asset(
                      'assets/swaption_connections.svg',
                      width: 18,
                      height: 18,
                    ),
                  )
                : SvgPicture.asset(
                    'assets/swaption_connections.svg',
                    width: 18,
                    height: 18,
                    colorFilter: ColorFilter.mode(
                      SideSwapColors.pewterBlue,
                      BlendMode.srcIn,
                    ),
                  ),
          ],
        ),
      ),
      onPressed: swaptionSessions.isNotEmpty
          ? () {
              expanded.value = !expanded.value;
            }
          : null,
    );
  }
}

class SwaptionConnectionsMenu extends HookConsumerWidget {
  const SwaptionConnectionsMenu({
    super.key,
    this.offset = Offset.zero,
    this.onTap,
    required this.animationController,
    required this.heightFactor,
  });

  final Offset offset;
  final AnimationController animationController;
  final Animation<double> heightFactor;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final swaptionSessions = ref.watch(swaptionSessionProvider);
    // default size is the size of the empty notification menu
    final size = useState(Size(370, 300));

    return Stack(
      children: [
        Positioned(child: GestureDetector(onTap: onTap)),
        Positioned(
          top: offset.dy,
          left: offset.dx,
          child: SizedBox(
            width: size.value.width,
            height: size.value.height,
            child: AnimatedBuilder(
              animation: animationController.view,
              builder: (context, child) {
                return ClipRect(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    heightFactor: heightFactor.value,
                    child: Container(
                      decoration: BoxDecoration(
                        color: SideSwapColors.maastrichtBlue,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(8),
                          bottomRight: Radius.circular(8),
                          topLeft: Radius.circular(8),
                          topRight: Radius.circular(8),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: child,
                      ),
                    ),
                  ),
                );
              },
              child: Column(
                children: [
                  SizedBox(
                    height: 28,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Active sessions:'.tr(),
                          style: Theme.of(
                            context,
                          ).textTheme.bodySmall?.copyWith(fontSize: 14),
                        ),
                        swaptionSessions.isEmpty
                            ? const SizedBox()
                            : DCustomTextBigButton(
                                onPressed: () {
                                  for (final swaptionSession
                                      in swaptionSessions) {
                                    final msg = To();
                                    msg.stopSession = To_StopSession(
                                      sessionId: swaptionSession.sessionId,
                                    );
                                    ref.read(walletProvider).sendMsg(msg);
                                  }
                                },
                                child: SizedBox(
                                  height: 24,
                                  child: Center(
                                    child: Text(
                                      'Disconnect all'.tr(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            color:
                                                SideSwapColors.brightTurquoise,
                                          ),
                                    ),
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  swaptionSessions.isEmpty
                      ? Flexible(
                          child: Text(
                            'No active sessions'.tr(),
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: SideSwapColors.cornFlower),
                          ),
                        )
                      : Flexible(
                          child: CustomScrollView(
                            slivers: [
                              SliverList.builder(
                                itemBuilder: (context, index) {
                                  return SwaptionDomainItem(
                                    swaptionSession: swaptionSessions[index],
                                  );
                                },
                                itemCount: swaptionSessions.length,
                              ),
                            ],
                          ),
                        ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class SwaptionDomainItem extends ConsumerWidget {
  const SwaptionDomainItem({super.key, required this.swaptionSession});

  final SwaptionSession swaptionSession;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(color: SideSwapColors.pewterBlue, height: 3, thickness: 1),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                if (swaptionSession.isLocal)
                  Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: Icon(
                      Icons.computer,
                      size: 14,
                      color: SideSwapColors.brightTurquoise,
                    ),
                  ),
                Text(
                  swaptionSession.domain,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                if (swaptionSession.isLocal)
                  Padding(
                    padding: const EdgeInsets.only(left: 6),
                    child: Text(
                      '[local]',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: SideSwapColors.brightTurquoise,
                      ),
                    ),
                  ),
              ],
            ),
            IconButton(
              onPressed: () {
                final msg = To();
                msg.stopSession = To_StopSession(
                  sessionId: swaptionSession.sessionId,
                );
                ref.read(walletProvider).sendMsg(msg);
              },
              icon: Icon(Icons.link_off, size: 18),
            ),
          ],
        ),
        if (swaptionSession.isLocal)
          Row(
            children: [
              Checkbox(
                value: ref.watch(
                  autosignProvider.select(
                    (m) => m[swaptionSession.domain] == true,
                  ),
                ),
                onChanged: (v) async {
                  if (v == true) {
                    final ok =
                        await ref.read(walletProvider).isAuthenticated();
                    if (!ok) return;
                  }
                  ref.read(autosignProvider.notifier).setAutosign(
                        swaptionSession.domain,
                        v ?? false,
                      );
                },
              ),
              Text(
                'Autosign'.tr(),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
      ],
    );
  }
}
