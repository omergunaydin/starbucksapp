import '../../data/products_api_client.dart';

class Constants {
  static int splashScreenTime = 2000;

  static String testUserImage =
      'https://scontent.ftzx1-1.fna.fbcdn.net/v/t31.18172-8/14468230_10154553478743559_4780208916183168431_o.jpg?_nc_cat=103&ccb=1-7&_nc_sid=09cbfe&_nc_ohc=Nx8pZaAEpKQAX_TuBs1&_nc_ht=scontent.ftzx1-1.fna&oh=00_AfAQiufWDDG7eUQee07vRwN3CV2skXYpYVvXOiijGxlcAQ&oe=643ED8D4';

  /// Images ///
  static String logoImagePath = 'assets/images/logo.png';
  static String splashBgPath = 'assets/images/welcome_back.png';
  static String shortSelectedPath = 'assets/images/short_selected.png';
  static String shortUnSelectedPath = 'assets/images/short_unselected.png';
  static String tallSelectedPath = 'assets/images/tall_selected.png';
  static String tallUnSelectedPath = 'assets/images/tall_unselected.png';
  static String grandeSelectedPath = 'assets/images/grande_selected.png';
  static String grandeUnSelectedPath = 'assets/images/grande_unselected.png';
  static String ventiSelectedPath = 'assets/images/venti_selected.png';
  static String ventiUnSelectedPath = 'assets/images/venti_unselected.png';

  static String welcomePageImagePath1 = 'assets/images/wellpage1.png';
  static String welcomePageTitle1 = 'Coffee makes your day Productive';
  static String welcomePageSubTitle1 = 'They say coffee keeps you from getting bored. But really it’s just to make the day longer.';

  static String welcomePageImagePath2 = 'assets/images/wellpage2.png';
  static String welcomePageTitle2 = 'Brewed for a great tasting cup';
  static String welcomePageSubTitle2 = 'A coffee-break with coworkers is a great way to recharge and connect';

  static String welcomePageImagePath3 = 'assets/images/wellpage3.png';
  static String welcomePageTitle3 = 'A cup of coffee can complete your day';
  static String welcomePageSubTitle3 = 'Hear a song, see a flower, notice sunshine, smell coffee and think of you!';

  static String explanation = 'Nutrition information is calculated based on our standart recipes, only changing drink size will update this information';

  final mainTabsDrinks = ['Hot Coffees', 'Hot Teas', 'Hot Drinks', 'Frappuccino® Blended Beverages', 'Cold Coffees', 'Iced Teas'];
  final mainTabsFoods = ['Hot Breakfast', 'Bakery', 'Lunch', 'Oatmeal & Yogurt'];
  final mainTabsGoods = ['Merchandise', 'Whole Bean', 'VIA® Instant', 'Gift Cards'];

  List<List<String>> listOfTabListDrinks = [
    [
      'Americanos',
      'Brewed Coffees',
      'Cappuccinos',
      'Espresso Shots',
      'Flat Whites',
      'Lattes',
      'Macchiatos',
      'Mochas',
    ],
    [
      'Chai Teas',
      'Black Teas',
      'Green Teas',
      'Herbal Teas',
    ],
    [
      'Hot Chocolates',
      'Juice',
      'Steamers',
    ],
    [
      'Coffee Frappuccino®',
      'Creme Frappuccino®',
    ],
    [
      'Cold Brews',
      'Nitro Cold Brews',
      'Iced Americano',
      'Iced Coffees',
      'Iced Shaken Espresso',
      'Iced Flat Whites',
      'Iced Lattes',
      'Iced Macchiatos',
      'Iced Mochas',
    ],
    ['Iced Black Teas', 'Iced Chai Teas', 'Iced Green Teas', 'Iced Herbal Teas'],
  ];

  List<List<String>> listOfTabListFoods = [
    [
      'Breakfast Sandwiches & Wraps',
      'Sous Vide Egg Bites',
    ],
    [
      'Bagels',
      'Cookies, Brownies & Bars',
      'Croissants',
      'Loaves, Cakes & Buns',
      'Danishes & Doughnuts',
      'Muffins & Scones',
    ],
    [
      'Warm Sandwiches',
      'Protein Boxes',
    ],
    [
      'Oatmeal & Yogurt',
    ]
  ];

  List<List<String>> listOfTabListGoods = [
    ['Cold Cups', 'Tumblers', 'Mugs', 'Water Bottles', 'Other'],
    [
      'Starbucks Reserve®',
      'Blonde Roast',
      'Medium Roast',
      'Dark Roast',
    ],
    ['Flavored', 'Blonde Roast', 'Medium Roast', 'Dark Roast'],
    ['Happy Birthday', 'Thank You', 'Traditional']
  ];

  getFutureList(List<String> mainTabs, List<List<String>> listOfTabList) {
    List<List<Future>> futureList = [];
    for (int i = 0; i < mainTabs.length; i++) {
      List<Future> list = List.generate(listOfTabList[i].length, (j) => ProductsApiClient().fetchProductsData(mainTabs[i], listOfTabList[i][j]));
      futureList.add(list);
    }
    return futureList;
  }
}
