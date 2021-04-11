import 'package:flutter/material.dart';
import 'package:marketer_jr/models/investment.dart';

import '../models/company.dart';
import 'companyTile.dart';

class CompanyList extends StatelessWidget {
  final BuildContext rootContext;
  final List<Company> companies;
  final List<Investment> _investments;
  final Function _stateUpdate;

  CompanyList(this.companies, this.rootContext, this._investments, this._stateUpdate);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
          width: double.infinity,
          child: ListView.builder(
            itemBuilder: (context, index) {
              Company item = companies[index];
              return Card(
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: CompanyTile(item, rootContext, _investments, _stateUpdate),
                ),
              );
            },
            itemCount: companies.length,
          )),
    );
  }
}
