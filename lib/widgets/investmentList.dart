import 'package:flutter/material.dart';
import 'package:marketer_jr/models/investment.dart';
import 'package:marketer_jr/widgets/investmentTile.dart';

import '../models/company.dart';

class InvestmentList extends StatelessWidget {
  final Function _stateUpdate;
  final BuildContext rootContext;
  final List<Investment> investments;
  final List<Company> companies;

  InvestmentList(
      this.investments, this.companies, this.rootContext, this._stateUpdate);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        width: double.infinity,
        child: investments.length > 0
            ? ListView.builder(
                itemBuilder: (context, index) {
                  Investment item = investments[index];
                  return Card(
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: InvestmentTile(item, companies, rootContext,
                          investments, _stateUpdate),
                    ),
                  );
                },
                itemCount: investments.length,
              )
            : Text(
                "No investments",
                style: TextStyle(fontSize: 28, color: Colors.grey.shade400),
              ),
        alignment: Alignment.center,
      ),
    );
  }
}
