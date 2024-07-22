import 'package:favourite_places/providers/places_provider.dart';
import 'package:favourite_places/screens/new_place_screen.dart';
import 'package:favourite_places/screens/place_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlacesList extends ConsumerStatefulWidget {
  const PlacesList({super.key});
  @override
  ConsumerState<PlacesList> createState() {
    return _PlaceListState();
  }
}

class _PlaceListState extends ConsumerState<PlacesList> {
  late Future<void> _places;
  @override
  void initState() {
    _places = ref.read(placesProvider.notifier).getPlaces();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final favouritePlaces = ref.watch(placesProvider);
    Widget content = Center(
      child: Text(
        "No Places Added Yet!",
        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
      ),
    );
    if (favouritePlaces.isNotEmpty) {
      content = ListView.builder(
          itemCount: favouritePlaces.length,
          itemBuilder: (ctx, idx) => ListTile(
                leading: CircleAvatar(
                  backgroundImage: FileImage(favouritePlaces[idx].image),
                  radius: 16,
                ),
                title: Text(
                  favouritePlaces[idx].title,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                ),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (ctx) =>
                          PlaceScreen(id: favouritePlaces[idx].id)));
                },
              ));
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Places"),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (ctx) => const NewPlace()));
              },
              icon: const Icon(Icons.add))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder(
            future: _places,
            builder: (context, snapshot) =>
                snapshot.connectionState == ConnectionState.waiting
                    ? const Center(child: CircularProgressIndicator())
                    : content),
      ),
    );
  }
}
