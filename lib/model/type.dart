// import 'package:cloud_firestore/cloud_firestore.dart';

class AcType {
  static const String ahu = 'Air Handling Unit';
  static const String fcu = 'Fan Coil Unit';
  static const String pre = 'Precision Air Cond';
  static const String cas = 'Chilled Water Cassette';
  static const String fan = 'Mechanical Ventilation Fan';
  static const String ct = 'Cooling Tower';
  static const String chill = 'Chilled Water Pump';
  static const String con = 'Condenser Water Pump';
  static const String chi = 'Chiller';
  static const String split = 'Split Unit';
  static const String deh = 'Dehumidifier';
  static const String chik = 'Chiller Kitchen';
  static const String frek = 'Freezer Kitchen';
  static const String waste = 'Chiller Clinical Waste';
  static const String mri = 'MRI Mini Chiller';
  static const String vrvo = 'VRV Outdoor Unit';
  static const String vrvi = 'VRV Indoor Unit';
  static const String air = 'Air Cooled Package';
  static const String all = 'All Type';

  static List<String> acType(bool a) => [
        if (a) all,
        ahu,
        fcu,
        pre,
        cas,
        fan,
        ct,
        chill,
        con,
        chi,
        split,
        deh,
        chik,
        frek,
        waste,
        mri,
        vrvo,
        vrvi,
        air
      ];

 
}



// class AcType {
//   AcType({
//     this.id,
//     required this.name,
//     this.added,
//     this.delete,
//   });
//   String? id;
//   String name;
//   Timestamp? added;
//   Timestamp? delete;


//   static AcType fromMap(Map<String, dynamic> data, id, {json = false}) {
//     // final String id = data['id'];
//     // final String address = data['address'];
//     final String name = data['name'];
//     final Timestamp? added = json
//         ? (data['added'] == null
//             ? null
//             : Timestamp.fromMillisecondsSinceEpoch(data['added']))
//         : data['added'];
//     final Timestamp? delete = json
//         ? (data['delete'] == null
//             ? null
//             : Timestamp.fromMillisecondsSinceEpoch(data['delete']))
//         : data['delete'];

//     return AcType(
//       id: id,
//       name: name,
//       added: added,
//       delete: delete,
//     );
//   }

//   copy() => AcType(
//         id: id,
//         name: name,
//         added: added,
//       delete: delete,
//       );

//   Map<String, dynamic> toMap({
//     bool json = false,
//     bool add = false,
//     bool del = false,
//   }) {
//     return {
//       'name': name,
//       'added': add
//           ?(win ?? FieldValue.serverTimestamp())
//           : (json ? (added?.millisecondsSinceEpoch) : added),
//       'delete': del
//           ?(win ?? FieldValue.serverTimestamp())
//           : (json ? (delete?.millisecondsSinceEpoch) : delete),
//     };
//   }
// }

