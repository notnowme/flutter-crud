import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserInfoWidget extends ConsumerStatefulWidget {
  const UserInfoWidget({super.key});

  @override
  ConsumerState<UserInfoWidget> createState() => _UserInfoWidgetState();
}

class _UserInfoWidgetState extends ConsumerState<UserInfoWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 100,
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: Theme.of(context).colorScheme.surface,
        ),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SizedBox(
                  width: 56,
                  height: 56,
                  child: Container(
                    width: 56,
                    height: 56,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'aaaa',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize:
                              Theme.of(context).textTheme.bodyLarge?.fontSize),
                    ),
                    Text(
                      'bbbb',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontSize:
                            Theme.of(context).textTheme.bodyMedium?.fontSize,
                      ),
                    ),
                  ],
                )
              ],
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.create),
              color: Theme.of(context).colorScheme.onPrimary,
            )
          ],
        ),
      ),
    );
  }
}
