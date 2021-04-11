import 'package:flutter/material.dart';
import 'package:marketer_jr/models/company.dart';
import 'package:marketer_jr/models/investment.dart';
import 'package:marketer_jr/widgets/BottomModalSheetWidgets/viewInvestment.dart';

class InvestmentTile extends StatelessWidget {
  final Function _stateUpdate;
  final BuildContext rootContext;
  final Investment investment;
  final List<Company> companies;
  final List<Investment> investments;

  InvestmentTile(this.investment, this.companies,
    this.rootContext, this.investments,
    this._stateUpdate);

  @override
  Widget build(BuildContext context) {
    Company currentCompany = companies.firstWhere((element) {
      return element.getId() == investment.getCompanyId() ? true : false;
    });
    return ListTile(
      title: Text(currentCompany.getName(), style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
      subtitle: Text("Purchased shares: ${investment.getShareCount()}"),
      trailing: Column(children: [
        Text("B: \$${investment.getTotalAmount().toStringAsFixed(2)}"),
        Text("S: \$${(currentCompany.getMarketPrice() * investment.getShareCount()).toStringAsFixed(2)}", style: TextStyle(fontSize: 18,
        color: investment.getTotalAmount() < currentCompany.getMarketPrice() * investment.getShareCount() ? Colors.green.shade700 : Colors.red.shade700),),
      ],
      mainAxisAlignment: MainAxisAlignment.spaceAround,),
      onTap: () {
        showModalBottomSheet(context: rootContext, builder: (BuildContext context2) {
          return GestureDetector(
            onTap: () {},
            child: ViewInvestment(investment, currentCompany, investments, _stateUpdate),
            behavior: HitTestBehavior.opaque,
          );
        });
      },
    );
  }
}
