// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import '../../../utils/DonationUtils.dart';
import 'BitcoinDonationSheet.dart';
import 'EthereumDonationSheet.dart';

class DonationCard extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _DonationCardState();
  }
}

class _DonationCardState extends State<DonationCard> {
  Future<List<int>> _dataInit;

  @override
  void initState() {
    _dataInit = DonationUtils.getDonations();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _dataInit,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done)
          return Card(
            child: InkWell(
              borderRadius: BorderRadius.circular(8.0),
              onTap: () {
                showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return SingleChildScrollView(
                        child: Column(
                          children: [
                            ListTile(
                              title: Text("Patreon"),
                              onTap: () {
                                DonationUtils.donatePatreon();
                              },
                            ),
                            ListTile(
                              title: Text("Bitcoin"),
                              onTap: () {
                                showModalBottomSheet<dynamic>(
                                  context: context,
                                  isScrollControlled: true,
                                  builder: (context) => BitcoinDonationSheet(),
                                );
                              },
                            ),
                            ListTile(
                              title: Text("Ethereum"),
                              onTap: () {
                                showModalBottomSheet<dynamic>(
                                  context: context,
                                  isScrollControlled: true,
                                  builder: (context) => EthereumDonationSheet(),
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    });
              },
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  horizontal: 15.0,
                  vertical: 15.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        bottom: 10.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Donations",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: 20.0,
                              color: Theme.of(context).accentColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            snapshot.data[0].toString() +
                                " / " +
                                snapshot.data[1].toString(),
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        bottom: 10.0,
                      ),
                      child: LinearProgressIndicator(
                        value: snapshot.data[0] / snapshot.data[1],
                        backgroundColor:
                            Theme.of(context).accentColor.withOpacity(
                                  0.5,
                                ),
                      ),
                    ),
                    Text(
                      "Tap to contribute!",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 12.5,
                        color: Theme.of(context)
                            .textTheme
                            .headline6
                            .color
                            .withOpacity(
                              0.7,
                            ),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        return Card(
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(
                15.0,
              ),
              child: Transform.scale(
                scale: 0.5,
                child: CircularProgressIndicator(),
              ),
            ),
          ),
        );
      },
    );
  }
}