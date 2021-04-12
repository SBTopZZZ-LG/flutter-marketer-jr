import 'package:flutter/material.dart';
import 'package:marketer_jr/currentUser.dart';
import 'package:marketer_jr/models/actionHistory.dart';
import 'package:marketer_jr/models/company.dart';
import 'package:marketer_jr/models/investment.dart';
import 'package:marketer_jr/models/investor.dart';

class NewInvestment extends StatefulWidget {
  final Company _targetCompany;
  final List<Investment> _investments;
  final Function _stateUpdate;

  NewInvestment(this._targetCompany, this._investments, this._stateUpdate);

  @override
  _NewInvestmentState createState() => _NewInvestmentState(_targetCompany, _investments, _stateUpdate);
}

class _NewInvestmentState extends State<NewInvestment> {
  final Company _targetCompany;
  final List<Investment> _investments;
  final Function _stateUpdate;

  _NewInvestmentState(this._targetCompany, this._investments, this._stateUpdate);

  TextEditingController nShares = TextEditingController();

  String _validateField() {
    String errorMsg = "Enter a valid positive number";
    try {
      return int.parse(nShares.text) > 0 && int.parse(nShares.text) <= (CurrentUser.getAvailableBalance() / _targetCompany.getMarketPrice()).toInt()
          ? null : errorMsg;
    } catch(e) {
      print(e);
      return errorMsg;
    }
  }

  void createInvestment() {
    if (_validateField() != null)
        return;

    int shareCount = int.parse(nShares.text);

    num totalAmount = shareCount * _targetCompany.getMarketPrice();

    Investor user = _targetCompany.getInvestorByUserId(CurrentUser.getUserId());

    if (user == null) {
      _targetCompany.addInvestor(Investor(CurrentUser.getUserId(), shareCount));
      _investments.add(Investment(CurrentUser.getUserId(), _targetCompany.getId(), totalAmount, shareCount));
    } else {
      user.deltaShares(shareCount);
      Investment previousInv = _investments.firstWhere((Investment element) {
        return element.getUserId() == CurrentUser.getUserId() && element.getCompanyId() == _targetCompany.getId() ? true : false;
      });
      previousInv.deltaTotalAmount(totalAmount);
      previousInv.deltaShareCount(shareCount);
    }
    _targetCompany.deltaShares(-1 * shareCount);

    _stateUpdate(() {
      CurrentUser.subtractBalance(totalAmount);

      ActionHistory.addNewRawAction(1, "Purchased ${shareCount} shares from ${_targetCompany.getName()} for \$${totalAmount.toStringAsFixed(2)}");
    });

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(child: Padding(
        child: Column(
        children: [
          Row(children: [
            Text(_targetCompany.getName(), style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
            Column(children: [
              Text("Market value: \$${_targetCompany.getMarketPrice().toStringAsFixed(2)}", style: TextStyle(fontSize: 18),),
              Text("Was: \$${_targetCompany.getLastMarketPrice().toStringAsFixed(2)}", style: TextStyle(fontSize: 15),),
            ],),
          ],
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          ),
        Container(width: double.infinity, child: Text("Available Shares: ${_targetCompany.getShareCount()}",)),
          Column(children: [
            SizedBox(height: 20,),
            TextField(
              keyboardType: const TextInputType.numberWithOptions(signed: false),
              controller: nShares,
              decoration: InputDecoration(labelText: "Number of shares to buy", errorText: _validateField(),),),
            Container(width: double.infinity, child: Text("Max. shares purchasable: ${(CurrentUser.getAvailableBalance() / _targetCompany.getMarketPrice()).toInt() > _targetCompany.getShareCount() ? _targetCompany.getShareCount() : (CurrentUser.getAvailableBalance() / _targetCompany.getMarketPrice()).toInt()}",)),
            SizedBox(height: 50,),
            SizedBox(height: 1, width: double.infinity, child: DecoratedBox(decoration: BoxDecoration(color: Colors.black),),),
            SizedBox(height: 5,),
            Container(width: double.infinity, child: Text("Total Amount: \$${(_targetCompany.getMarketPrice() * int.parse(nShares.text.length == 0 ? "0" : nShares.text)).toStringAsFixed(2)}",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),)),
            Container(width: double.infinity, child: Text("New Balance: \$${(CurrentUser.getAvailableBalance() - (_targetCompany.getMarketPrice() * int.parse(nShares.text.length == 0 ? "0" : nShares.text))).toStringAsFixed(2)}",
              style: TextStyle(fontSize: 15),)),
            Container(width: double.infinity, child: ElevatedButton(child: Text("Purchase"), onPressed: _validateField() == null ? createInvestment : null,), alignment: Alignment.centerRight,),
          ],)
      ],), padding: EdgeInsets.all(10),),),
    );
  }
}
