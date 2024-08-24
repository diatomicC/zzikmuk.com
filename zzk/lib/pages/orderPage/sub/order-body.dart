import 'package:flutter/material.dart';
import '../../../classes/FoodSectionClass.dart';
import '../itemPage/item.dart';

class SectionWidget extends StatelessWidget {
  final FoodSection section;
  final String languageCode;
  final String restaurantId;

  final bool isGridMode = true;

  SectionWidget({required this.section, required this.languageCode, required this.restaurantId});

  @override
  Widget build(BuildContext context) {
    List<FoodItem> filteredItems = section.items.where((item) => item.language == languageCode).toList();

    //  if the filteredItems list is empty, return an empty container
    if (filteredItems.isEmpty) {
      return Container(); // Don't show empty sections
    }

    // sort the items by their id
    filteredItems.sort((a, b) => a.id.compareTo(b.id));

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            section.name,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        isGridMode
            ? GridView.builder(
                padding: EdgeInsets.all(8),
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 0.7,
                ),
                itemCount: filteredItems.length,
                itemBuilder: (BuildContext context, int index) {
                  return ItemGridWidget(
                    restaurantId: restaurantId,
                    item: filteredItems[index],
                    languageCode: languageCode,
                  );
                },
              )
            : ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: filteredItems.length,
                itemBuilder: (BuildContext context, int index) {
                  return ItemListWidget(
                    item: filteredItems[index],
                    languageCode: languageCode,
                    restaurantId: restaurantId,
                  );
                },
              ),
      ],
    );
  }
}

class ItemGridWidget extends StatelessWidget {
  final FoodItem item;
  final String restaurantId;
  final String languageCode;

  ItemGridWidget({required this.item, required this.languageCode, required this.restaurantId});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ItemPage(
                      foodItem: item,
                      languageCode: languageCode,
                      restaurantId: restaurantId,
                    )));
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 170,
              decoration: BoxDecoration(
                image: DecorationImage(
                  // find corresponding image file in local file
                  image: Image.asset('assets/images/$restaurantId/${item.imageFileName}').image,
                  onError: (exception, stackTrace) {
                    print('Error loading image: $exception');
                  },
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Hero(
                      tag: 'foodItem-${item.name}',
                      // transitionOnUserGestures: true,
                      child: Text(
                        item.name,
                        style: Theme.of(context).textTheme.titleLarge,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(height: 4),
                    Expanded(
                      child: Text(
                        item.description,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  '${item.price.toStringAsFixed(0)}원',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    // text spacing
                    letterSpacing: -0.5,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ItemListWidget extends StatelessWidget {
  final FoodItem item;
  final String languageCode;
  final String restaurantId;

  ItemListWidget({required this.item, required this.languageCode, required this.restaurantId});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Card(
        // no border radius
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        child: ListTile(
          // make the leading fit full size
          dense: true,
          contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
          leading: Hero(
            tag: 'foodItem-${item.name}',
            child: Container(
              height: 170,
              decoration: BoxDecoration(
                image: DecorationImage(
                  // find corresponding image file in local file
                  image: Image.asset('assets/images/$restaurantId/${item.imageFileName}').image,
                  onError: (exception, stackTrace) {
                    print('Error loading image: $exception');
                  },
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          title: Padding(
            padding: const EdgeInsets.all(0.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  item.description,
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
                Text(
                  'Price: ${item.price.toStringAsFixed(2)} 원',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
