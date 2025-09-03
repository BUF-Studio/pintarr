import 'package:flutter/material.dart';
import 'package:pintarr/model/check.dart';
import 'package:pintarr/model/checklistV2.dart';
import 'package:pintarr/service/controller/checklistController.dart';
import 'package:provider/provider.dart';

class ReportData extends StatelessWidget {
  final List<dynamic> data;
  final String type;
  final int? version;
  const ReportData(this.data, this.type, this.version, {Key? key})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final ChecklistsController checklistsController =
        Provider.of<ChecklistsController>(context);
    final cls = checklistsController.getChecklist(type, version: version ?? 2);
    final cl = cls.item;
    print(cls.version);

    return ListView.builder(
        shrinkWrap: true,
        physics: const ScrollPhysics(),
        itemCount: data.length,
        itemBuilder: (context, index) {
          print(cl[index].des);
          if (data[index] == null) {
            return Container();
          }

          return Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey[300]!),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),

            child: cl[index].pass
                ? _pass(data[index], cl[index].des)
                : _ans(
                    data[index],
                    cl[index].value![0] == ''
                        ? cl[index].des
                        : cl[index].des + ' (' + cl[index].value![0]! + ')'),
            // child: Row(
            //   crossAxisAlignment: CrossAxisAlignment.start,
            //   children: <Widget>[
            //     Text(
            //       data[index]['ques'],
            //       style: TextStyle(
            //         fontSize: 20,
            //       ),
            //     ),
            //     if (data[index].runtimeType == bool)
            //       _pass(data[index]),
            //     if (data[index].runtimeType == List)
            //       _ans(data[index]),
            //   ],
            // ),
          );
        });
  }

  _pass(String data, ques) {
    return Row(
      children: [
        Expanded(
          child: Container(
            child: Text(
              ques,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ),
        const SizedBox(
          width: 20,
        ),
        Container(
          // width: 50,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Text(
              //   data,
              //   style: TextStyle(
              //     fontSize: 16,
              //     color: data == 'Pass' ? Colors.green : Colors.red,
              //   ),
              // ),
              const SizedBox(
                width: 10,
              ),
              if (data == 'Pass')
                const Icon(
                  Icons.check_circle_outline,
                  color: Colors.green,
                  size: 20,
                ),
              if (data != 'Pass')
                const Icon(
                  Icons.highlight_off,
                  size: 20,
                  color: Colors.red,
                ),
            ],
          ),
        ),
      ],
    );
  }

//   Text slash() => Text(
//         ' / ',
//         style: TextStyle(fontSize: 16),
//       );

  _ans(data, ques) {
    return Row(
      children: [
        Expanded(
          child: Container(
            child: Text(
              ques,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ),
        Container(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                data,
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
