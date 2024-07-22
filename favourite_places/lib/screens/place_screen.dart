import 'package:favourite_places/providers/places_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlaceScreen extends ConsumerWidget {
  const PlaceScreen({super.key, required this.id});
  final String id;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final place = ref.watch(placesProvider).firstWhere((p) => p.id == id);
    return Scaffold(
        appBar: AppBar(
          title: Text(place.title),
        ),
        body: Center(child: Text(place.title, style: Theme.of(context).textTheme.bodyLarge!.copyWith(
          color: Theme.of(context).colorScheme.onSurface,
        ),),),
        );
  }
}
