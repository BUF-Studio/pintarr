import 'package:flutter/material.dart';
import 'package:pintarr/content/report/reportDetailMobile.dart';
import 'package:pintarr/content/report/reportPage.dart';
import 'package:pintarr/model/client.dart';
import 'package:pintarr/model/report.dart';
import 'package:pintarr/model/reportType.dart';
import 'package:pintarr/model/type.dart';
import 'package:pintarr/service/format.dart';
import 'package:pintarr/service/pdf.dart';
import 'package:pintarr/widget/alert.dart';
import 'package:pintarr/widget/dropDown.dart';
import 'package:pintarr/widget/empty.dart';
import 'package:pintarr/widget/responsive.dart';
import 'package:pintarr/widget/searchBar.dart';
import 'package:pintarr/widget/textDetail.dart';
import 'package:pintarr/widget/tile.dart';
import 'package:pintarr/widget/title.dart';
import 'package:provider/provider.dart';

class SearchMonthReport extends StatefulWidget {
  final List<Report> reports;
  const SearchMonthReport(this.reports, {Key? key}) : super(key: key);
  @override
  _SearchMonthReportState createState() => _SearchMonthReportState();
}

class _SearchMonthReportState extends State<SearchMonthReport> {
  String? _search;
  String? _type;
  String? _location;
  String? _current;
  bool? comment;
  bool? filter;
  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final ReportNavi page = Provider.of<ReportNavi>(context);
    final Client client = Provider.of<Client>(context);
    final Pdf pdf = Provider.of<Pdf>(context);

    List<Report> report = [];
// comment ??= page.comment;
// filter ??= page.filter;

    dld() {
      return Alert.box(
          context,
          'Downloaded',
          const Text(
              'Reports successfully downloaded. Please check your download folder.'),
          <Widget>[
            Alert.ok(context, () {
              Navigator.pop(context);
            }, 'Ok')
          ]);
    }

    fail() {
      return Alert.box(
          context,
          'Failed',
          const Text('Cant find download directory. Failed to download.'),
          <Widget>[
            Alert.ok(context, () {
              Navigator.pop(context);
            }, 'Ok')
          ]);
    }

    _search ??= page.search;
    _type ??= page.type;
    _location ??= page.location;
    _current ??= page.current;
    report.addAll(widget.reports);
    if (_search != null && _search != '')
      report.removeWhere(
          (e) => !e.unitname.toLowerCase().contains(_search!.toLowerCase()));
    if (_type != null && _type != '' && _type != 'All Type')
      report.removeWhere((e) => e.type != _type);
    if (_location != null && _location != '' && _location != 'All Location')
      report.removeWhere((e) => e.location != _location);
    if (_current != null && _current != '' && _current != 'All Condition')
      report.removeWhere((e) => e.current != _current);
    if (comment != null && comment!) report.removeWhere((e) => e.comment == '');

    if (report.isNotEmpty && _search != '') print(report.length);
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: SearchBarr(
                init: _search ??= page.search,
                chg: (v) {
                  setState(() {
                    _search = v;
                    // print('hehe');
                  });
                },
              ),
            ),
            if (!Responsive.isMobile(context))
              IconButton(
                onPressed: () {
                  setState(() {
                    filter = !(filter ?? page.filter);
                  });
                },
                icon: Icon((filter ?? page.filter)
                    ? Icons.filter_alt_off
                    : Icons.filter_alt),
              ),
            if (!Responsive.isMobile(context))
              SizedBox(
                width: 20,
              )
          ],
        ),
        if ((filter ?? page.filter) && !Responsive.isMobile(context))
          Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: DropDown(
                      item: (e) {
                        return DropItem.item(
                          name: e,
                          value: e,
                        );
                      },
                      list: AcType.acType(true),
                      onChanged: (n) {
                        setState(() {
                          _type = n;
                        });
                      },
                      text: 'Type',
                      value: _type ?? page.type,
                    ),
                  ),
                  Expanded(
                    child: DropDown(
                      item: (e) {
                        return DropItem.item(
                          name: e,
                          value: e,
                        );
                      },
                      list: ['All Location', ...client.location],
                      onChanged: (n) {
                        setState(() {
                          _location = n;
                        });
                      },
                      text: 'Location',
                      value: _location ?? page.location,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  TextCheck(
                    'With Comment',
                    comment ?? page.comment,
                    (v) {
                      setState(() {
                        comment = v;
                      });
                    },
                  ),
                  Expanded(
                    child: DropDown(
                      item: (e) {
                        return DropItem.item(
                          name: e,
                          value: e,
                        );
                      },
                      list: ['All Condition', 'Good', 'Problem', 'Down'],
                      onChanged: (n) {
                        setState(() {
                          _current = n;
                        });
                      },
                      text: 'Condition',
                      value: _current ?? page.current,
                    ),
                  ),
                  Expanded(
                    child: PageButt(
                      'Download Filtered Report',
                      onTap: () {
                        Alert.box(
                            context,
                            'Download',
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Tile(
                                //   title: Text('Compact Report'),
                                //   tap: () async {
                                //     try {
                                //       await Pdf().serviceReports(reports, false,
                                //           '${client.name}_${page.report.mon}_CompactReport');
                                //       Navigator.pop(context);
                                //       dld();
                                //     } catch (e) {
                                //       fail();
                                //     }
                                //   },
                                // ),
                                Tile(
                                  title: const Text('Normal Report'),
                                  tap: () async {
                                    try {
                                      await pdf.serviceReports(report,
                                          '${client.name}_${page.report!.mon}_Filtered_${DateTime.now().millisecondsSinceEpoch}_NormalReport');
                                      // print('hhe');
                                      // await Pdf().serviceReports(reports, true,'');
                                      Navigator.pop(context);

                                      dld();
                                    } catch (e) {
                                      fail();
                                    }
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            ),
                            <Widget>[
                              Alert.cancel(context),
                            ]);
                      },
                    ),
                  )
                ],
              )
            ],
          ),
        if (report.isEmpty) Empty('No Report Found'),
        if (report.isNotEmpty)
          ListView.builder(
            shrinkWrap: true,
            physics: const ScrollPhysics(),
            itemCount: report.length,
            itemBuilder: (context, index) {
              color() {
                if (!report[index].checked) return Colors.grey;
                if (report[index].current == 'Good') return Colors.green;
                if (report[index].current == 'Problem') return Colors.orange;
                if (report[index].current == 'Down') return Colors.red;
                return Colors.grey;
              }

              return Tile(
                title: Text(
                    '${report[index].unitname} / ${reportTypeToString(report[index].reportType)!}'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(Format.epochToString(report[index].date)),
                    Text('Unit condition : ${report[index].current}'),
                  ],
                ),
                tap: () {
                  if (!Responsive.isMobile(context)) {
                    page.updateReport(
                      ReportPages.detail,
                      rpt: report[index],
                      back: page.report,
                      src: _search,
                      com: comment,
                      loc: _location,
                      typ: _type,
                      fil: filter,
                      cur: _current,
                    );
                  }
                  if (Responsive.isMobile(context)) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ReportDetailMobile(report[index]),
                        ));
                  }
                },
                trail: const Icon(Icons.arrow_forward_ios),
                lead: Icon(
                  Icons.verified,
                  color: color(),
                ),
              );
            },
          ),
      ],
    );
  }
}
