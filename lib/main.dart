import 'dart:math';

import 'package:flutter/material.dart';
import 'package:marketer_jr/models/actionHistory.dart';

import 'currentUser.dart';
import 'models/investment.dart';
import 'widgets/investmentList.dart';
import 'models/company.dart';
import 'storage/sp.dart';
import 'widgets/companyList.dart';
import 'widgets/history.dart';

GlobalKey<NavigatorState> materialAppContext;

void main() {
  runApp(MaterialApp(
    navigatorKey: materialAppContext,
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AppPage();
  }
}

class AppPage extends State<MyApp> {
  List<Company> companies = [
    Company("1", "Apple", 35000, 5000, 4500, []),
    Company("2", "OnePlus", 44000, 4000, 4120, []),
    Company("3", "Microsoft", 55000, 4600, 5120, []),
    Company("4", "Adobe", 27500, 6750, 7000, []),
    Company("5", "Samsung", 37500, 5500, 6500, []),
  ];

  bool isAppStart = true;

  List<List<bool>> generatedValues = [];

  List<Investment> investments = [];

  BuildContext materialAppContext;

  int selectedPage = 0;

  void pageUpdate(Function prefunction) {
    setState(() {
      prefunction();
    });
  }

  void onPageSwitch(int newPageIndex) {
    setState(() {
      selectedPage = newPageIndex;
    });
  }

  Widget returnCurrentPage(BuildContext buildContext) {
    switch (selectedPage) {
      case 0:
        return Column(children: [
          History(),
        ]);
      case 1:
        return Column(
          children: [
            CompanyList(companies, buildContext, investments, pageUpdate),
          ],
        );
      case 2:
        return Column(
          children: [
            InvestmentList(investments, companies, buildContext, pageUpdate),
          ],
        );
      default:
        return null;
    }
  }

  Widget getPage() {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Text(
              "Marketer Jr",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              "Saumitra Topinkatti",
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            child: Center(
              child: Text(
                "Wallet: \$${CurrentUser.getAvailableBalance().toStringAsFixed(2)}",
                style: TextStyle(fontSize: 18),
              ),
            ),
            padding: EdgeInsets.all(10),
          ),
        ],
      ),
      body: returnCurrentPage(context),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: "Companies"),
          BottomNavigationBarItem(
              icon: Icon(Icons.request_page), label: "Purchased Shares"),
        ],
        currentIndex: selectedPage,
        onTap: (newIndex) => onPageSwitch(newIndex),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.refresh),
        tooltip: "Simulate day",
        onPressed: () {
          pageUpdate(() {
            for (int i = 0; i < companies.length; i++) {
              Company company = companies[i];
              List<bool> values = generatedValues[i];

              if (values.length > 20) values.removeAt(0);

              num delta = Random().nextInt(2) == 0
                  ? Random().nextDouble() * Random().nextInt(1000)
                  : Random().nextInt(Random().nextInt(1000));

              double positivity = 0;
              double bonusFactor = 0;
              for (bool value in values.reversed) {
                positivity += (value ? 1 : 0) / values.length;
                positivity += bonusFactor;
                bonusFactor += value ? 0.075 : -1 * bonusFactor;
              }

              int temp = Random().nextInt(values.length + 1);
              bool isAddition = temp >= values.length
                  ? (positivity > 0.5 ? false : true)
                  : values[temp];
              values.add(isAddition);

              company.deltaMarketPrice(delta * (isAddition ? 1 : -1));
              company.deltaShares(Random().nextInt(51) * (isAddition ? 1 : -1));

              print(company.getName());
            }
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    generatedValues = List<List<bool>>.generate(companies.length, (index) {
      return [
        companies[index].getMarketPrice() >
                companies[index].getLastMarketPrice()
            ? true
            : false
      ];
    });

    if (!isAppStart)
      saveData(investments, companies, ActionHistory.getActions());
    else
      setState(() {
        getData((List<Investment> _investments, List<Company> _companies,
            List<ActionItem> _history) {
          print(_investments);

          if (_investments != null) this.investments = _investments;
          if (_companies != null) this.companies = _companies;
          if (_history != null)
            for (ActionItem item in _history) ActionHistory.addNewAction(item);
        });
      });

    if (isAppStart) {
      isAppStart = false;
    }

    return getPage();
  }
}
