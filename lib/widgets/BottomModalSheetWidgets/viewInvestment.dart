import 'package:flutter/material.dart';
import 'package:marketer_jr/models/actionHistory.dart';
import 'package:marketer_jr/models/company.dart';
import 'package:marketer_jr/models/investment.dart';
import 'package:marketer_jr/models/investor.dart';

import '../../currentUser.dart';

class ViewInvestment extends StatefulWidget {
  final Function _stateUpdate;
  final List<Investment> _investments;
  final Investment _investment;
  final Company _targetCompany;

  ViewInvestment(this._investment, this._targetCompany, this._investments, this._stateUpdate);

  @override
  _ViewInvestmentState createState() => _ViewInvestmentState(_investment, _targetCompany, _investments, _stateUpdate);
}

class _ViewInvestmentState extends State<ViewInvestment> {
  final Function _stateUpdate;
  final List<Investment> _investments;
  final Investment _investment;
  final Company _targetCompany;

  _ViewInvestmentState(this._investment, this._targetCompany, this._investments, this._stateUpdate);

  TextEditingController nShares = TextEditingController();

  String _validateField() {
    String errorMsg = "Enter a valid positive number";
    try {
      return int.parse(nShares.text) > 0 && int.parse(nShares.text) <= _investment.getShareCount()
          ? null : errorMsg;
    } catch(e) {
      print(e);
      return errorMsg;
    }
  }

  void deleteInvestment() {
    if (_validateField() != null)
      return;

    int shareCount = int.parse(nShares.text);

    num totalAmount = shareCount * _targetCompany.getMarketPrice();

    if (shareCount == _investment.getShareCount()) {
      _targetCompany.removeInvestorByObject(_targetCompany.getInvestorsList().firstWhere((element) {
        return element.getUserId() == CurrentUser.getUserId() ? true : false;
      }));

      _investments.remove(_investment);
    } else {
      Investor user = _targetCompany.getInvestorByUserId(CurrentUser.getUserId());

      user.deltaShares(-1 * shareCount);
      Investment previousInv = _investments.firstWhere((Investment element) {
        return element.getUserId() == CurrentUser.getUserId() && element.getCompanyId() == _targetCompany.getId() ? true : false;
      });

      previousInv.deltaTotalAmount(-1 * totalAmount);
      previousInv.deltaShareCount(-1 * shareCount);
    }

    _targetCompany.deltaShares(shareCount);

    _stateUpdate(() {
      CurrentUser.addBalance(totalAmount);

      ActionHistory.addNewRawAction(0, "Sold ${shareCount} shares from ${_targetCompany.getName()} for${_investment.getTotalAmount() < totalAmount ? " profit of " : _investment.getTotalAmount() == totalAmount ? "" : " loss of "}\$${(_investment.getTotalAmount() - totalAmount).abs().toStringAsFixed(2)}");
    });

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(child: Padding(padding: EdgeInsets.all(10), child: Column(
        children: [
          Row(children: [
            Text(_targetCompany.getName(), style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
            Column(children: [
              Text("Market price: \$${_targetCompany.getMarketPrice().toStringAsFixed(2)}", style: TextStyle(fontSize: 18),),
              Text("Bought for: \$${_investment.getTotalAmount().toStringAsFixed(2)}", style: TextStyle(fontSize: 15),),
            ],),
          ],
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
          ),
          Container(width: double.infinity, child: Text("Shares purchased: ${_investment.getShareCount()}",)),
          Column(children: [
            SizedBox(height: 20,),
            TextField(
              keyboardType: const TextInputType.numberWithOptions(signed: false),
              controller: nShares,
              decoration: InputDecoration(labelText: "Number of shares to sell", errorText: _validateField(),),),
            SizedBox(height: 50,),
            SizedBox(height: 1, width: double.infinity, child: DecoratedBox(decoration: BoxDecoration(color: Colors.black),),),
            SizedBox(height: 5,),
            Container(width: double.infinity, child: Text("Total Selling price: \$${((nShares.text.length > 0 ? int.parse(nShares.text) : 0) * _targetCompany.getMarketPrice()).toStringAsFixed(2)}",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),)),
            Container(width: double.infinity, child: Text("New Balance: \$${(CurrentUser.getAvailableBalance() + (_investment.getShareCount() * _targetCompany.getMarketPrice())).toStringAsFixed(2)}",
              style: TextStyle(fontSize: 15),)),
            Container(width: double.infinity, child: ElevatedButton(child: Text("Sell"), onPressed: _validateField() == null ? deleteInvestment : null,), alignment: Alignment.centerRight,),
          ],)
        ],),),),
    );
  }
}
