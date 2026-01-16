enum EmojiCategoryType {
  smileysAndPeople,
  nature,
  foodAndDrink,
  activities,
  travelAndPlaces,
  objects,
  symbols,
  flags,
}

class EmojiCategory {
  const EmojiCategory({
    required this.type,
    required this.title,
    required this.icon,
    required this.emojis,
  });

  final EmojiCategoryType type;
  final String title;
  final String icon;
  final List<String> emojis;
}
