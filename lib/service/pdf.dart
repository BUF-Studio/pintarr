import 'dart:io';
import 'package:collection/collection.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pintarr/model/check.dart';
import 'package:pintarr/model/checklist.dart';
import 'package:pintarr/model/checklistItem.dart';
import 'package:pintarr/model/checklistV2.dart';
import 'package:pintarr/model/report.dart';
import 'package:pintarr/model/reportType.dart';
import 'package:pintarr/model/type.dart';
import 'package:pintarr/model/unit.dart';
import 'package:pintarr/service/controller/checklistController.dart';
import 'package:pintarr/service/fire/database.dart';
import 'package:pintarr/service/format.dart';

class Pdf {
  Pdf(this.controller);
  ChecklistsController controller;
  List<Unit> unit = [];
  Future qrCode(List<Unit?> units, int count, String name) async {
    final pdf = Document();

    var logo = await rootBundle.loadString('assets/logo.svg');
    var bold = await rootBundle.load('assets/OpenSans-Bold.ttf');
    var base = await rootBundle.load('assets/OpenSans-Regular.ttf');
    // for (var i = 0; i < 100; i++) {
    //   units.add(Unit(
    //       id: 'qweqweqweqweqw$i',
    //       unitname: 'qweqweqweqw$i',
    //       serialNo: 'asdasdasds$i'));
    // }

    List<String> qr = [];
    List<String> unit = [];
    List<String> serial = [];
    for (var e in units) {
      qr.add(e!.id!);
      unit.add(e.unitname);
      serial.add(e.serialNo);
    }

    // count = 12;

    // print(qr.length);

    switch (count) {
      case 1:
        for (var i = 0; i < qr.length; i++) {
          _addQrPage(count, pdf, base, bold, logo, qr[i], unit[i], serial[i]);
        }
        break;
      default:
        List<String> qrs = [];
        List<String> units = [];
        List<String> serials = [];
        for (var i = 0; i < qr.length; i++) {
          qrs.add(qr[i]);
          units.add(unit[i]);
          serials.add(serial[i]);
          if (qrs.length == count || i == qr.length - 1) {
            while (qrs.length != count) {
              qrs.add('');
              units.add('');
              serials.add('');
            }
            _addQrPage(count, pdf, base, bold, logo, qrs, units, serials);
            qrs = [];
            units = [];
            serials = [];
          }
        }
        break;
    }
    return await save(pdf, name);
  }

  save(pdf, name) async {
    try {
      Directory? dic;
      String? path;
      // File file;
      if (Platform.isMacOS || Platform.isWindows) {
        dic = await getDownloadsDirectory();
      } else {
        print('permission');
        print(await Permission.storage.request().isGranted);
        // print(await Permission.);

        if (await Permission.storage.request().isGranted) {
          if (Platform.isIOS) {
            dic = await getApplicationDocumentsDirectory();
          } else {
            dic = await getExternalStorageDirectory();
            // dic = await ();
            // dic = await DownloadsPathProvider.downloadsDirectory;
          }
        }
      }
      path = dic!.path;
      File file;

      print(path);
      // if (Platform.isIOS) {
      //   file = File('$path$name.pdf');
      // } else {
      file = File('$path/$name.pdf');
      // }

      // final file = File('$name.pdf');
      await file.writeAsBytes(await pdf.save());
      // return '$path/$name.pdf';
    } catch (e) {
      print(e);
      throw e;
    }
  }

  _qrContainer(logo, qr, unit, serial, height) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      child: qr == ''
          ? Container(
              height: double.infinity,
              width: double.infinity,
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: height / 4,
                      height: height / 4,
                      child: SvgImage(svg: logo),
                    ),
                    SizedBox(width: 20),
                    Text(
                      'PINTAR CARE',
                      style: TextStyle(
                        fontSize: height / 8,
                      ),
                    ),
                  ],
                ),
                BarcodeWidget(
                  data: qr,
                  barcode: Barcode.qrCode(),
                  height: height,
                  width: height,
                ),
                Column(
                  children: [
                    Text(
                      'Unitname : ' + unit,
                      style: TextStyle(
                          fontSize: (height / 16) > 8 ? (height / 16) : 8),
                    ),
                    Text(
                      'Serial No. : ' + serial,
                      style: TextStyle(
                          fontSize: (height / 16) > 8 ? (height / 16) : 8),
                    ),
                  ],
                ),
              ],
            ),
    );
  }

  _addQrPage(count, pdf, base, bold, logo, qr, unit, serial) {
    pdf.addPage(
      Page(
        pageFormat: PdfPageFormat.a4,
        orientation:
            count == 2 ? PageOrientation.landscape : PageOrientation.portrait,
        theme: ThemeData.withFont(
          base: Font.ttf(base),
          bold: Font.ttf(bold),
        ),
        build: (context) {
          switch (count) {
            case 1:
              return _qrContainer(logo, qr, unit, serial, 350.0);

            case 2:
              return Row(
                children: [
                  Expanded(
                    child: _qrContainer(logo, qr[0], unit[0], serial[0], 200.0),
                  ),
                  Expanded(
                    child: _qrContainer(logo, qr[1], unit[1], serial[1], 200.0),
                  ),
                ],
              );

            case 4:
              return Column(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                            child: _qrContainer(
                                logo, qr[0], unit[0], serial[0], 150.0)),
                        Expanded(
                            child: _qrContainer(
                                logo, qr[1], unit[1], serial[1], 150.0)),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                            child: _qrContainer(
                                logo, qr[2], unit[2], serial[2], 150.0)),
                        Expanded(
                            child: _qrContainer(
                                logo, qr[3], unit[3], serial[3], 150.0)),
                      ],
                    ),
                  ),
                ],
              );

            case 12:
              return Column(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                            child: _qrContainer(
                                logo, qr[0], unit[0], serial[0], 80.0)),
                        Expanded(
                            child: _qrContainer(
                                logo, qr[1], unit[1], serial[1], 80.0)),
                        Expanded(
                            child: _qrContainer(
                                logo, qr[2], unit[2], serial[2], 80.0)),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                            child: _qrContainer(
                                logo, qr[3], unit[3], serial[3], 80.0)),
                        Expanded(
                            child: _qrContainer(
                                logo, qr[4], unit[4], serial[4], 80.0)),
                        Expanded(
                            child: _qrContainer(
                                logo, qr[5], unit[5], serial[5], 80.0)),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                            child: _qrContainer(
                                logo, qr[6], unit[6], serial[6], 80.0)),
                        Expanded(
                            child: _qrContainer(
                                logo, qr[7], unit[7], serial[7], 80.0)),
                        Expanded(
                            child: _qrContainer(
                                logo, qr[8], unit[8], serial[8], 80.0)),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                            child: _qrContainer(
                                logo, qr[9], unit[9], serial[9], 80.0)),
                        Expanded(
                            child: _qrContainer(
                                logo, qr[10], unit[10], serial[10], 80.0)),
                        Expanded(
                            child: _qrContainer(
                                logo, qr[11], unit[11], serial[11], 80.0)),
                      ],
                    ),
                  ),
                ],
              );
            default:
              return Container();
          }
        },
      ),
    );
  }

  // _addChecklist(list, Checklist checklist, pdf, logo, base, bold,
  //     {chi = false}) {
  //   // List<Report> rep = [];

  //   for (var i = 0; i < list.length; i++) {
  //     // if (single) {

  //     if (chi) {
  //       _addChillerPage(pdf, logo, base, bold, list[i], checklist.item);
  //     } else {
  //       _addCheckListPage(pdf, logo, base, bold, list[i], checklist.item);
  //     }
  //     // } else {
  //     //   rep.add(list[i]);
  //     //   if (rep.length == 7 || i == list.length - 1) {
  //     //     _addCheckListPage(pdf, logo, base, bold, rep, checklist, false);
  //     //     rep = [];
  //     //   }
  //     // }
  //   }
  // }

  Future serviceReports(List<Report> reports, name) async {
    // print(reports);
    // print('service report');
    // unit = units;
    final pdf = Document();

    // pdf.theme =

    var logo = await rootBundle.loadString('assets/logo.svg');
    var bold = await rootBundle.load('assets/OpenSans-Bold.ttf');
    var base = await rootBundle.load('assets/OpenSans-Regular.ttf');

    // List<String> actype = AcType.acType(false);

    for (Report report in reports) {
      Checklist checklist = controller.getChecklist(
        report.type,
        version: report.version,
      );

      if (report.type == AcType.chi) {
        _addChillerPage(pdf, logo, base, bold, report, checklist.item);
      } else {
        // print(report.version);
        // print(checklist.version);
        // print(report.data.length);
        // print(checklist.item.length);

        // if(report.type == AcType.ahu && ){

        // }
        _addCheckListPage(pdf, logo, base, bold, report, checklist.item);
      }
      // _addChecklist(list, checklist, pdf, logo, base, bold);
    }

// get
    print('save');
    await save(pdf, name);

    // return file;
  }

  _addCheckListPage(
      pdf, logo, base, bold, Report report, List<ChecklistItem> checklist) {
    // var attach = [];
    // reports.forEach((e) {
    //   if (e.attachUrl != null) attach.add(e.attachUrl);
    // });

    var tag = ['Tag No', report.unitname];
    var type = ['Unit Type', report.type];
    var serial = ['Serial No', report.serial];
    var loc = ['Location', report.location];
    var model = ['Model', report.model];
    var con = ['Unit Condition', report.current];

    var belt;
    var beltSize;

    if (report.type == AcType.fcu || report.type == AcType.fan) {
      if (report.belt != null) {
        belt = ['With Belt', report.belt! ? 'Yes' : 'No'];
      } else {
        Unit? u = unit.firstWhereOrNull((e) => e.id == report.uid);

        if (u != null && u.belt != null) {
          belt = ['With Belt', u.belt! ? 'Yes' : 'No'];
        }
      }
    }
    if (report.type == AcType.ahu) {
      if (report.beltSize != null) {
        beltSize = ['Belt Size', report.beltSize];
      } else {
        Unit? u = unit.firstWhereOrNull((e) => e.id == report.uid);

        if (u != null && u.beltSize != null) {
          beltSize = ['Belt Size', u.beltSize];
        }
      }
    }

    var detail = [
      tag,
      type,
      serial,
      loc,
      model,
      con,
      if (belt != null) belt,
      if (beltSize != null) beltSize,
    ];

    var data = [
      ['No', 'Description', '']
    ];

    int j = 1;

    for (var i = 0; i < checklist.length; i++) {
      // print(report.unitname);
      if (report.data[i] != null) {
        List<String> lis = [];
        lis.add(j.toString());
        String ques = checklist[i].des;
        if (!checklist[i].pass && checklist[i].value![0] != '') {
          ques = '$ques (${checklist[i].value![0]!})';
        }
        j++;

        lis.add(ques);
        // lis.add(report.data[i]!);
        lis.add(report.data[i]=='Pass'?'/':(report.data[i]=='Fail'?'X':report.data[i])!);
        data.add(lis);
      }
    }

    List<String> comment = (report.comment).split('\n');
    int lines = comment.length;
    int lin = 0;

    for (var i = 0; i < lines; i++) {
      lin += 1;
      String com = comment[i];
      for (var j = 0; j < com.length; j += 83) {
        if (j > 85) lin += 1;
      }
    }

    // String coom = '';

    // for (var p = 0; p < 3; p++) {
    //   coom += (comment[p]+'\n');
    // }
    // report.comment = coom;

    bool withComment = lin <= 3;
    // bool withComment = true;

    pdf.addPage(
      Page(
        pageFormat: PdfPageFormat.a4,
        orientation: PageOrientation.portrait,
        theme: ThemeData.withFont(
          base: Font.ttf(base),
          bold: Font.ttf(bold),
        ),
        build: (context) {
          return Column(
            children: [
              _head(logo),

              _reportTable(report, checklist, detail, data, withComment),
              // if (!full && checklist != Checklist.chi)
              //   _serviceReportsTable(reports, checklist),
              Text(
                'This is a computer generated document. No signature is required.',
                style: const TextStyle(
                  fontSize: 6,
                ),
              ),
            ],
          );
        },
      ),
    );

    if (!withComment) {
      pdf.addPage(
        Page(
          pageFormat: PdfPageFormat.a4,
          orientation: PageOrientation.portrait,
          theme: ThemeData.withFont(
            base: Font.ttf(base),
            bold: Font.ttf(bold),
          ),
          build: (context) {
            return Column(
              children: [
                _head(logo),

                Text(
                  '${reportTypeToString(report.reportType)} Report',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                    // fontSize: 12,
                  ),
                ),
                SizedBox(height: 5),
                _detailTable(detail, {
                  0: const FlexColumnWidth(1),
                  1: const FlexColumnWidth(4),
                }),
                SizedBox(height: 5),

                _commentBox(report.comment, height: (lin + 1) * 16.0),
                SizedBox(height: 5),
                Text(
                  'Page 2 of 2',
                  style: const TextStyle(
                    fontSize: 6,
                  ),
                ),
                SizedBox(height: 5),

                // if (!full && checklist != Checklist.chi)
                //   _serviceReportsTable(reports, checklist),
                Text(
                  'This is a computer generated document. No signature is required.',
                  style: const TextStyle(
                    fontSize: 6,
                  ),
                ),
              ],
            );
          },
        ),
      );
    }
  }

  _addChillerPage(
      pdf, logo, base, bold, Report report, List<ChecklistItem> checklist) {
    // var attach = [];
    // reports.forEach((e) {
    //   if (e.attachUrl != null) attach.add(e.attachUrl);
    // });

    var tag = ['Tag No', report.unitname];
    var type = ['Unit Type', report.type];
    var serial = ['Serial No', report.serial];
    var loc = ['Location', report.location];
    var model = ['Model', report.model];
    var con = ['Unit Condition', report.current];
    var detail = [
      tag,
      type,
      serial,
      loc,
      model,
      con,
    ];

    var checkdata = [
      ['Description', '']
    ];
    var readdata = [
      ['Description', '']
    ];

    // int j = 1;

    for (var i = 0; i < checklist.length; i++) {
      if (report.data[i] != null) {
        List<String> lis = [];
        // lis.add(j.toString());
        String ques = checklist[i].des;
        if (!checklist[i].pass && checklist[i].value![0] != '') {
          ques = ques + ' (' + checklist[i].value![0]! + ')';
        }
        // j++;

        lis.add(ques);
        lis.add(report.data[i]!);
        if (checklist[i].value == null) {
          checkdata.add(lis);
        } else {
          readdata.add(lis);
        }
      }
    }

    List<String> comment = report.comment.split('\n');
    int lines = comment.length;
    int lin = 0;

    // String coom = '';

    // for (var p = 0; p < 13; p++) {
    //   coom += (comment[p]+'\n');
    // }
    // report.comment = coom;

    for (var i = 0; i < lines; i++) {
      lin += 1;
      String com = comment[i];
      for (var j = 0; j < com.length; j += 40) {
        if (j > 40) lin += 1;
      }
    }

    bool withComment = lin <= 13;
    // bool withComment = true;

    pdf.addPage(
      Page(
        pageFormat: PdfPageFormat.a4,
        orientation: PageOrientation.portrait,
        theme: ThemeData.withFont(
          base: Font.ttf(base),
          bold: Font.ttf(bold),
        ),
        build: (context) {
          return Column(
            children: [
              _head(logo),

              _chillerTable(
                  report, checklist, detail, readdata, checkdata, withComment),
              // if (!full && checklist != Checklist.chi)
              //   _serviceReportsTable(reports, checklist),
              if (!withComment)
                Text(
                  'Page 1 of 2',
                  style: const TextStyle(
                    fontSize: 6,
                  ),
                ),

              Text(
                'This is a computer generated document. No signature is required.',
                style: const TextStyle(
                  fontSize: 6,
                ),
              ),
            ],
          );
        },
      ),
    );

    if (!withComment) {
      pdf.addPage(
        Page(
          pageFormat: PdfPageFormat.a4,
          orientation: PageOrientation.portrait,
          theme: ThemeData.withFont(
            base: Font.ttf(base),
            bold: Font.ttf(bold),
          ),
          build: (context) {
            return Column(
              children: [
                _head(logo),

                Text(
                  '${reportTypeToString(report.reportType)} Report',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                    // fontSize: 12,
                  ),
                ),
                SizedBox(height: 5),
                _detailTable(detail, {
                  0: const FlexColumnWidth(1),
                  1: const FlexColumnWidth(4),
                }),
                SizedBox(height: 5),

                _commentBox(report.comment, height: (lin + 1) * 16.0),
                SizedBox(height: 5),
                Text(
                  'Page 2 of 2',
                  style: const TextStyle(
                    fontSize: 6,
                  ),
                ),
                SizedBox(height: 5),

                // if (!full && checklist != Checklist.chi)
                //   _serviceReportsTable(reports, checklist),
                Text(
                  'This is a computer generated document. No signature is required.',
                  style: const TextStyle(
                    fontSize: 6,
                  ),
                ),
              ],
            );
          },
        ),
      );
    }
  }

  _chillerTable(Report report, List<ChecklistItem> checklist, detail, readdata,
      checkdata, withComment) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 2),
          child: Text(
            '${reportTypeToString(report.reportType)} Report',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
              // fontSize: 12,
            ),
          ),
        ),
        SizedBox(height: 10),
        _detailTable(detail, {
          0: const FlexColumnWidth(1),
          1: const FlexColumnWidth(4),
        }),

        SizedBox(height: 10),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _detailTable(
                readdata,
                {
                  0: const FlexColumnWidth(7),
                  1: const FlexColumnWidth(2),
                },
              ),
            ),
            SizedBox(width: 5),
            Expanded(
              child: Column(
                children: [
                  _detailTable(
                    checkdata,
                    {
                      0: const FlexColumnWidth(7),
                      1: const FlexColumnWidth(2),
                    },
                  ),
                  SizedBox(height: 10),
                  _commentBox(
                      withComment ? report.comment : 'Comment at Page 2',
                      height: 200.0),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        _byTable(report),
        // SizedBox(height: 10),
      ],
    );
  }

  _reportTable(Report report, List<ChecklistItem> checklist, detail, data,
      bool comment) {
    return Column(
      children: [
        Text(
          '${reportTypeToString(report.reportType)} Report',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 10,
            // fontSize: 12,
          ),
        ),
        SizedBox(height: 5),
        _detailTable(detail, {
          0: const FlexColumnWidth(1),
          1: const FlexColumnWidth(4),
        }),
        SizedBox(height: 5),
        _detailTable(data, {
          0: const FlexColumnWidth(1),
          1: const FlexColumnWidth(7),
          2: const FlexColumnWidth(2),
        }),
        SizedBox(height: 5),
        _byTable(report),

        SizedBox(height: 5),
        // _fullTable(),
        if (comment) _commentBox(report.comment),
        if (!comment)
          Text(
            'Page 1 of 2',
            style: const TextStyle(
              fontSize: 6,
            ),
          ),
      ],
    );
  }

  _byTable(Report report) {
    return DefaultTextStyle(
      style: const TextStyle(fontSize: 10),
      child: Container(
        height: 50,
        width: double.infinity,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  border: Border.all(width: 0.3),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Reported By : '),
                    SizedBox(height: 3),
                    Text(report.by),
                    Text(
                      Format.epochToString(report.date),
                    ),
                    // SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  border: Border.all(width: 0.3),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Checked By : '),
                    SizedBox(height: 3),
                    Text(report.checkBy ?? ''),
                    Text(
                      Format.epochToString(report.checkdate),
                    ),
                    // SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _tableRow(data) {
    List<TableRow> children = [];
    for (final row in data) {
      final tableRow = <Widget>[];

      for (final dynamic cell in row) {
        tableRow.add(
          Container(
            padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 2),
            child: Text(
              cell.toString(),
              style: TextStyle(
                color:
                    cell.toString() == 'Fail' ? PdfColors.red : PdfColors.black,
              ),
            ),
          ),
        );
      }

      children.add(TableRow(
        children: tableRow,
        // repeat: rowNum < headerCount,
        // decoration: decoration,
      ));
      // rowNum++;
    }
    return children;
  }

  _detailTable(data, columnWidth) {
    return DefaultTextStyle(
      style: const TextStyle(
        fontSize: 10,
        lineSpacing: 0.3,
        // color: PdfColors.black
        // wordSpacing: ,
      ),

      child: Table(
        border: TableBorder.all(
          width: 0.3,
        ),
        columnWidths: columnWidth,
        children: _tableRow(data),
      ),

      // child: Table.fromTextArray(

      //     headerAlignment: Alignment.centerLeft,
      //     // cellAlignment: Alignment.centerLeft,
      //     data: data,
      //     // cellDecoration: BoxDecoration(),
      //     cellStyle: TextStyle(color: PdfColors.red),
      //     cellPadding: EdgeInsets.symmetric(vertical: 1, horizontal: 2),
      //     border: TableBorder.all(
      //       width: 0.3,
      //     ),
      //     columnWidths: columnWidth
      //     // ? {
      //     //     0: FlexColumnWidth(1),
      //     //     1: FlexColumnWidth(7),
      //     //     2: FlexColumnWidth(2),
      //     //   }
      //     // : {
      //     //     0: FlexColumnWidth(1),
      //     //     1: FlexColumnWidth(4),
      //     //     // if (no) 2: FlexColumnWidth(1),
      //     //   }
      //     ),
    );
  }

  _commentBox(comment, {height}) {
    return Container(
      height: height ?? 60,
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(width: 0.3),
        // color: PdfColor.fromInt(323232),
      ),
      child: DefaultTextStyle(
        style: const TextStyle(fontSize: 10),
        child: Padding(
          padding: const EdgeInsets.only(left: 2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Comment : '),
              Text(comment),
            ],
          ),
        ),
      ),
    );
  }

  // _serviceReportsTable(List<Report> reports, List<ChecklistItem> checklist) {
  //   while (reports.length != 7) {
  //     List<String> dat = [];
  //     for (var u = 0; u < checklist.length; u++) dat.add('');
  //     reports.add(Report(
  //       data: dat,
  //     ));
  //   }
  //   var tag = ['', 'Tag No'];
  //   var serial = ['', 'Serial No'];
  //   var loc = ['', 'Location'];
  //   var model = ['', 'Model'];
  //   var head = ['No', 'Description'];
  //   var des = [];
  //   // var body = [];
  //   var by = ['', 'Service By'];
  //   var date = ['', 'Date'];
  //   var cby = ['', 'Checked Date'];
  //   var cdate = ['', 'Checked By'];
  //   var current = ['', 'Unit Condition'];
  //   var comment = [];

  //   for (var e in reports) {
  //     tag.add(e.unitname ?? '');
  //     serial.add(e.serial ?? '');
  //     loc.add(e.location ?? '');
  //     model.add(e.model ?? '');
  //     head.add('');
  //     des.add(e.data);
  //     date.add(e.date == null ? '' : Format.epochToString(e.date));
  //     cdate.add(e.checkdate == null ? '' : Format.epochToString(e.checkdate));
  //     by.add(e.by ?? '');
  //     cby.add(e.checkBy ?? '');
  //     current.add(e.current ?? '');
  //     comment.add(e.comment ?? '');
  //   }

  //   var data = [
  //     tag,
  //     serial,
  //     loc,
  //     model,
  //     head,
  //   ];
  //   for (var i = 0; i < checklist.length; i++) {
  //     List<String> lis = [];
  //     lis.add((i + 1).toString());
  //     String ques = checklist[i].des;
  //     if (!checklist[i].pass && checklist[i].value[0] != '') {
  //       ques = ques + ' (' + checklist[i].value[0] + ')';
  //     }
  //     lis.add(ques);
  //     for (var e in des) {
  //       lis.add(e[i] ?? '');
  //     }
  //     data.add(lis);
  //   }

  //   var rep = [
  //     current,
  //     by,
  //     date,
  //     cby,
  //     cdate,
  //   ];

  //   List<String> comm = [];

  //   for (var t = 2; t < comment.length; t++) {
  //     if (comment[t].trim() != '') {
  //       comm.add(tag[t] + ' : ' + comment[t].trim());
  //     }
  //   }

  //   return Column(
  //     children: [
  //       Padding(
  //         padding: EdgeInsets.only(bottom: 2),
  //         child: Text(
  //           '${reports[0].type} Check Sheet',
  //           style: TextStyle(
  //             fontWeight: FontWeight.bold,
  //             fontSize: 8,
  //             // fontSize: 12,
  //           ),
  //         ),
  //       ),
  //       _table(data),
  //       _table(rep),
  //       _commentBox(comm, false),
  //     ],
  //   );
  // }

  // _table(data) {
  //   print('_table');
  //   return DefaultTextStyle(
  //     style: TextStyle(
  //       fontSize: 8,
  //       lineSpacing: 0.3,
  //       // wordSpacing: ,
  //     ),
  //     child: Table.fromTextArray(
  //         headerAlignment: Alignment.centerLeft,
  //         // cellAlignment: Alignment.centerLeft,
  //         data: data,
  //         cellStyle: TextStyle(
  //             color: data == 'Fail' ? PdfColors.red : PdfColors.black),
  //         cellPadding: EdgeInsets.symmetric(vertical: 1, horizontal: 2),
  //         border: TableBorder.all(
  //           width: 0.1,
  //         ),
  //         columnWidths: {
  //           0: FlexColumnWidth(0.3),
  //           1: FlexColumnWidth(3.7),
  //           2: FlexColumnWidth(1),
  //           3: FlexColumnWidth(1),
  //           4: FlexColumnWidth(1),
  //           5: FlexColumnWidth(1),
  //           6: FlexColumnWidth(1),
  //           7: FlexColumnWidth(1),
  //           8: FlexColumnWidth(1),
  //         }),
  //   );
  // }

  _head(logo) {
    return Container(
      // color: PdfColor.fromInt(323232),
      // height: 100,
      child: Row(
        children: [
          Container(
            width: 45,
            height: 45,
            child: SvgImage(svg: logo),
          ),
          SizedBox(width: 20),
          DefaultTextStyle(
            style: const TextStyle(fontSize: 6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'PINTAR ENGINEERING SDN BHD ( 1424036-K )',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                    'M9-3, Beverly Hills Phase 1, Jalan Bundusan Penampang, 88300 Kota Kinabalu Sabah'),
                Text('Email : keepintar@gmail.com'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
