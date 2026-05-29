import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

//listitem is stateless - only displays what data is passed into it
class ListItem extends StatelessWidget {
  //inputs the widget needs to render
  final IconData iconData;
  final String itemName;
  final String itemPrice;
  final int counter;
  final VoidCallback onInc; //same as void function() - store function as var,
  //takes no argument and returns nothing

  const ListItem({
    super.key,
    required this.iconData,
    required this.itemName,
    required this.itemPrice,
    required this.counter,
    required this.onInc,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      //standard row layout - needs leading , title/sub, trailing fields
      leading: Icon(iconData),
      title: Text(itemName),
      subtitle: Text("\$$itemPrice"),
      //far right widget, pass counter and callback down to action item to perform increments
      trailing: ActionItem(counter: counter, onInc: onInc),
    );
  }
}

//display count and add button
class ActionItem extends StatelessWidget {
  final int counter;
  final VoidCallback onInc; // what to do when add button pressed

  const ActionItem({super.key, required this.counter, required this.onInc});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min, //only take space needed
      children: [
        Text("$counter"),
        //call the callback when add button pressed
        IconButton(onPressed: onInc, icon: Icon(Icons.add)),
      ],
    );
  }
}

class TipSelect extends StatefulWidget {
  final void Function(bool addTip, int selectedTip) onTipChanged;
  const TipSelect({super.key, required this.onTipChanged});

  @override
  State<TipSelect> createState() => _TipSelectState();
}

class _TipSelectState extends State<TipSelect> {
  bool addTip = false;
  int selectedTip = 10;
  List<int> tipOptions = [10, 15, 20, 25];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SwitchListTile(
          // same as listitle but with toggle switch
          title: Text("Add a tip?"),
          value:
              addTip, //on/off state of switch/toggle, auto false, true if toggled
          onChanged: (value) {
            //value(true/false) gets passed
            setState(() {
              //setstate to update ui / change variable
              addTip = value; //store new true/false state
            });
            //call function, give two values addtip(true/false) and selectdTip(tip amount)
            widget.onTipChanged(addTip, selectedTip);
          },
        ),
        if (addTip) //if addtip is true
          Wrap(
            spacing: 10,
            //.map turns each int into a list of 4 widgets
            children: tipOptions.map((tip) {
              return ChoiceChip(
                label: Text("$tip% "),
                selected:
                    selectedTip ==
                    tip, //bool expression highlights the selected tip
                onSelected: (selected) {
                  //pass bool
                  setState(() {
                    selectedTip = tip; //update to new value
                  });
                  widget.onTipChanged(addTip, selectedTip);
                },
              );
            }).toList(), //wrap requires list
          ),
      ],
    );
  }
}

//statless bc it just does math and display
class OrderTotal extends StatelessWidget {
  final double total;
  final int tip;
  final bool tipEnabled;

  const OrderTotal({
    super.key,
    required this.total,
    required this.tip,
    required this.tipEnabled,
  });

  @override
  Widget build(BuildContext context) {
    double tipAmount = tipEnabled
        ? total * tip / 100
        : 0; //if tipenabled is true, total * tip / 100 operates , tipam = 0 if false
    double finalTotal = tipAmount + total;

    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Subtotal: \$${total.toStringAsFixed(2)}"),
          if (tipEnabled) Text("Tip: \$${tipAmount.toStringAsFixed(2)}"),
          Text("Total: \$${finalTotal.toStringAsFixed(2)}"),
        ],
      ),
    );
  }
}

//statless bc tapping button only shows dialog
class ConfirmSection extends StatelessWidget {
  const ConfirmSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        showDialog(
          //shows a pop up needs context and builder / pushes diaglog on stack
          context: context,
          builder: (context) {
            return AlertDialog(
              //needs title, content and actions
              title: Text("Order Confirmed"),
              content: Text("Your order has been placed"),
              actions: [
                TextButton(
                  onPressed: () {
                    //pops dialog off stack/dismiss pop up
                    Navigator.pop(context);
                  },
                  child: Text("Dismiss"),
                ),
              ],
            );
          },
        );
      },
      child: Text("Confirm Order"),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Checkout App - Assignment 2',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 139, 188, 149),
        ),
      ),
      home: const MyHomePage(title: 'Flower Shop Checkout'),
      
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int sunflowerCount = 0;
  int marigoldCount = 0;
  int firCount = 0;
  int weedKillerCount = 0;

  bool addTip = false;
  int selectedTip = 10;

  double get subTotal =>
      (sunflowerCount * 3.99) +
      (marigoldCount * 3.99) +
      (firCount * 5.99) +
      (weedKillerCount * 12.99);

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
        leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Image.asset('assets/images/flowerlogo.png',),
  )
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: ListView(
          //use for scrollable
          children: [
            Card(
              child: Column(
                children: [
                  ListItem(
                    iconData: Icons.local_florist,
                    itemName: "Sunflower Seeds",
                    itemPrice: "3.99",
                    counter: sunflowerCount,
                    onInc: () => setState(() => sunflowerCount++),
                  ),
                  Divider(),
                  ListItem(
                    iconData: Icons.local_florist,
                    itemName: "Marigold Seeds",
                    itemPrice: "3.99",
                    counter: marigoldCount,
                    onInc: () => setState(() => marigoldCount++),
                  ),
                  Divider(),
                  ListItem(
                    iconData: Icons.park,
                    itemName: "Fir Sapling",
                    itemPrice: "5.99",
                    counter: firCount,
                    onInc: () => setState(() => firCount++),
                  ),
                  Divider(),
                  ListItem(
                    iconData: Icons.grass,
                    itemName: "Weed Killer",
                    itemPrice: "12.99",
                    counter: weedKillerCount,
                    onInc: () => setState(() => weedKillerCount++),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 16.0,
                  horizontal: 12.0,
                ),
                child: TipSelect(
                  onTipChanged: (tipOn, tipVal) {
                    setState(() {
                      addTip = tipOn;
                      selectedTip = tipVal;
                    });
                  },
                ),
              ),
            ),
            SizedBox(height: 10),

            Card(
              child: OrderTotal(
                total: subTotal,
                tip: selectedTip,
                tipEnabled: addTip,
              ),
            ),
            SizedBox(height: 10),
            ConfirmSection(),
            
          ],
        ),
      ),
    );
  }
}
