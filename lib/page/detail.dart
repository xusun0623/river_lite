import 'package:flutter/material.dart';
import 'package:offer_show/asset/data.dart';
import 'package:offer_show/util/interface.dart';

class SalaryDetail extends StatefulWidget {
  @override
  _SalaryDetailState createState() => _SalaryDetailState();
}

class _SalaryDetailState extends State<SalaryDetail> {
  @override
  Widget build(BuildContext context) {
    final salaryId = ModalRoute.of(context).settings.arguments;
    SalaryData salaryData;

    void _getData() async {
      final res = await Api().webapi_v2_offer_detail();
      print("$res");
    }

    @override
    void initState() {
      super.initState();
      _getData();
      print(salaryId);
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
        title: Text(
          "SalaryDetail",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Container(
        child: Center(
          child: Text(
            "widget.data",
          ),
        ),
      ),
    );
  }
}
