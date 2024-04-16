import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BoardInfoWidget extends ConsumerStatefulWidget {
  const BoardInfoWidget({super.key, required this.label});

  final String label;

  @override
  ConsumerState<BoardInfoWidget> createState() => _BoardInfoWidgetState();
}

class _BoardInfoWidgetState extends ConsumerState<BoardInfoWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: Theme.of(context).colorScheme.surface,
        ),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.label,
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: Theme.of(context).textTheme.displayLarge?.fontSize,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '게시글',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontSize:
                            Theme.of(context).textTheme.bodyLarge?.fontSize,
                      ),
                    ),
                    Text('10',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize:
                              Theme.of(context).textTheme.titleMedium?.fontSize,
                          fontWeight: FontWeight.w600,
                        )),
                  ],
                ),
                const SizedBox(
                  width: 20,
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: Colors.grey,
                ),
                const SizedBox(
                  width: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '댓글',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontSize:
                            Theme.of(context).textTheme.bodyLarge?.fontSize,
                      ),
                    ),
                    Text('1000',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize:
                              Theme.of(context).textTheme.titleMedium?.fontSize,
                          fontWeight: FontWeight.w600,
                        )),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
