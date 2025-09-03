import 'package:pintarr/model/checklistItem.dart';
import 'package:pintarr/model/type.dart';

class ChecklistV2 {
  static List<ChecklistItem> ahu = [
    ChecklistItem(
      des: 'Abnormal Noise',
      pass: true,
    ),
    ChecklistItem(
      des: 'Check unit condition during functioning and record all system data',
      pass: true,
    ),
    ChecklistItem(
      des: 'Check insulation / condensation',
      pass: true,
    ),
    ChecklistItem(
      des: 'Check and clean the filter and blower',
      pass: true,
      service: true,
    ),
    ChecklistItem(
      des: 'Check the filter and blower',
      pass: true,
      service: false,
    ),
    ChecklistItem(
      des: 'Check water leakage at valve and flange',
      pass: true,
    ),
    ChecklistItem(
      des: 'Clean drainage / drain pan',
      pass: true,
      service: true,
    ),
    ChecklistItem(
      des: 'Check all seals and gasket',
      pass: true,
    ),
    ChecklistItem(
      des: 'Check AHU panels, plates and latches',
      pass: true,
    ),
    ChecklistItem(
      des: 'Cleanliness and drainage at all plant room',
      pass: true,
    ),
    ChecklistItem(
      des: 'Motor bearing condition',
      pass: true,
    ),
    ChecklistItem(
      des: 'Clean cooling coil with city water',
      pass: true,
      service: true,
    ),
    ChecklistItem(
      des: 'Visual check and clean dust inside switch board',
      pass: true,
      service: true,
    ),
    ChecklistItem(
      des: 'Visual check switch board',
      pass: true,
      service: false,
    ),
    ChecklistItem(
      des: 'Check variable speed control',
      pass: true,
    ),
    ChecklistItem(
      des: 'Check operation of motorized valve controllers',
      pass: true,
    ),
    ChecklistItem(
      des: 'Check standby or duty motor',
      pass: true,
    ),
    ChecklistItem(
      des: 'Check for corrosion at unit',
      pass: true,
      half: true,
    ),
    ChecklistItem(
      des: 'Check damper mechanism',
      half: true,
      pass: true,
    ),
    ChecklistItem(
      des: 'Check bearing collar tightness',
      pass: true,
      half: true,
    ),
    ChecklistItem(
      des: 'Belt alignment / Tension ',
      pass: true,
      half: true,
    ),
    ChecklistItem(
      des: 'Clean blower fan',
      pass: true,
      service: true,
      half: true,
    ),
    ChecklistItem(
      des: 'AHU switch board - Tighten and Termination',
      pass: true,
      half: true,
    ),
    ChecklistItem(
      des: 'Clean water strainer',
      pass: true,
      service: true,
      year: true,
    ),
    ChecklistItem(
      des: 'Chemical clean cooling coil',
      pass: true,
      service: true,
      year: true,
    ),
    ChecklistItem(
      des: 'Running Amp R/Y/B',
      pass: false,
      value: ['A', 'A', 'A'],
    ),
    ChecklistItem(
      des: 'Megger motor',
      pass: false,
      value: ['Ω'],
      year: true,
    ),
  ];

  static List<ChecklistItem> fcu = [
    ChecklistItem(
      des: 'Abnormal noise and vibration',
      pass: true,
    ),
    ChecklistItem(
      des: 'Check unit condition during functioning and record all system data',
      pass: true,
    ),
    ChecklistItem(
      des: 'Check insulation / condensation',
      pass: true,
    ),
    ChecklistItem(
      des: 'Check and clean the filter and blower',
      pass: true,
      service: true,
    ),
    ChecklistItem(
      des: 'Check the filter and blower',
      pass: true,
      service: false,
    ),
    ChecklistItem(
      des: 'Check water leakage at valve and flange',
      pass: true,
    ),
    ChecklistItem(
      des: 'Clean drainage / drain pan',
      pass: true,
      service: true,
    ),
    ChecklistItem(
      des: 'Check all seals and gasket',
      pass: true,
    ),
    ChecklistItem(
      des: 'Check FCU panels, plates and latches',
      pass: true,
    ),
    ChecklistItem(
      des: 'Cleanliness and drainage at all plant room',
      pass: true,
    ),
    ChecklistItem(
      des: 'Motor bearing condition',
      pass: true,
    ),
    ChecklistItem(
      des: 'Clean cooling coil with city water',
      pass: true,
      service: true,
    ),
    ChecklistItem(
      des: 'Visual check and clean dust inside switch board',
      pass: true,
      service: true,
    ),
    ChecklistItem(
      des: 'Visual check inside switch board',
      pass: true,
      service: false,
    ),
    ChecklistItem(
      des: 'Check variable speed control',
      pass: true,
    ),
    ChecklistItem(
      des: 'Check operation of motorized valve controllers',
      pass: true,
    ),
    ChecklistItem(
      des: 'Check standby or duty motor',
      pass: true,
    ),
    ChecklistItem(
      des: 'Check for corrosion at unit',
      pass: true,
      half: true,
    ),
    ChecklistItem(
      des: 'Check damper mechanism',
      half: true,
      pass: true,
    ),
    ChecklistItem(
      des: 'Check bearing collar tightness',
      pass: true,
      half: true,
    ),
    ChecklistItem(
      des: 'Belt alignment / Tension ',
      pass: true,
      half: true,
      belt: true,
    ),
    ChecklistItem(
      des: 'Clean blower fan',
      pass: true,
      service: true,
      half: true,
    ),
    ChecklistItem(
      des: 'FCU switch board - Tighten and Termination',
      pass: true,
      half: true,
    ),
    ChecklistItem(
      des: 'Clean water strainer',
      pass: true,
      service: true,
      year: true,
    ),
    ChecklistItem(
      des: 'Chemical clean cooling coil',
      pass: true,
      service: true,
      year: true,
    ),
    ChecklistItem(
      des: 'Running Amp R/Y/B',
      pass: false,
      value: ['A', 'A', 'A'],
    ),
    ChecklistItem(
      des: 'Megger motor',
      pass: false,
      value: ['Ω'],
      year: true,
    ),
  ];

  static List<ChecklistItem> fan = [
    ChecklistItem(
      des: 'Abnormal noise',
      pass: true,
    ),
    ChecklistItem(
      des: 'Check fan and wheel and operation wheel',
      pass: true,
    ),
    ChecklistItem(
      des: 'Motor bearing condition',
      pass: true,
    ),
    ChecklistItem(
      des: 'Lubricate bearing',
      pass: true,
      service: true,
    ),
    ChecklistItem(
      des: 'Visual check and clean dust inside switch board',
      pass: true,
      service: true,
    ),
    ChecklistItem(
      des: 'Visual check switch board',
      pass: true,
      service: false,
    ),
    ChecklistItem(
      des: 'Check variable speed control',
      pass: true,
    ),
    ChecklistItem(
      des: 'Check duty motor',
      pass: true,
    ),
    ChecklistItem(
      des: 'Check panels, plate and latches',
      pass: true,
    ),
    ChecklistItem(
      des: 'Check for corrosion at unit',
      pass: true,
      half: true,
    ),
    ChecklistItem(
      des: 'Check damper mechanism',
      half: true,
      pass: true,
    ),
    ChecklistItem(
      des: 'Check bearing collar tightness',
      pass: true,
      half: true,
    ),
    ChecklistItem(
      des: 'Belt alignment / Tension ',
      pass: true,
      half: true,
    ),
    ChecklistItem(
      des: 'Clean blower fan',
      pass: true,
      service: true,
      half: true,
    ),
    ChecklistItem(
      des: 'Running Amp R/Y/B',
      pass: false,
      value: ['A', 'A', 'A'],
    ),
    ChecklistItem(
      des: 'Megger motor',
      pass: false,
      value: ['Ω'],
      year: true,
    ),
  ];

  static List<ChecklistItem> deh = [
    ChecklistItem(
      des: 'Abnormal noise',
      pass: true,
    ),
    ChecklistItem(
      des: 'Rotor inspection',
      pass: true,
    ),
    ChecklistItem(
      des: 'Motor bearing condition',
      pass: true,
    ),
    ChecklistItem(
      des: 'Lubricate bearing',
      pass: true,
      service: true,
    ),
    ChecklistItem(
      des: 'Belt alignment / tension',
      pass: true,
    ),
    ChecklistItem(
      des: 'Check condition filter',
      pass: true,
      half: true,
    ),
    ChecklistItem(
      des: 'Visual check and clean dust inside switch board',
      pass: true,
      service: true,
    ),
    ChecklistItem(
      des: 'Visual check inside switch board',
      pass: true,
      service: false,
    ),
    ChecklistItem(
      des: 'Check electrical termination',
      pass: true,
      half: true,
    ),
    ChecklistItem(
      des: 'Check control device and sensors',
      pass: true,
      half: true,
    ),
    ChecklistItem(
      des: 'Check variable speed control',
      pass: true,
    ),
    ChecklistItem(
      des: 'Tighten and termination',
      pass: true,
      service: true,
      half: true,
    ),
    ChecklistItem(
        des: 'Record motor FLA from name plate', pass: false, value: ['A']),
    ChecklistItem(
      des: 'Running Amp R/Y/B',
      pass: false,
      value: ['A', 'A', 'A'],
    ),
    ChecklistItem(
      des: 'Megger motor',
      pass: false,
      value: ['Ω'],
      year: true,
    ),
  ];

  static List<ChecklistItem> split = [
    ChecklistItem(
      des: 'Check unit condition during functioning and record all system data',
      pass: true,
    ),
    ChecklistItem(
      des: 'Check and clean the filter and blower',
      pass: true,
      service: true,
    ),
    ChecklistItem(
      des: 'Check the filter and blower',
      pass: true,
      service: false,
    ),

    ChecklistItem(
      des: 'Check the cleanliness / clogging of condensate tray',
      pass: true,
    ),
    ChecklistItem(
      des: 'Inspect scale copper tube',
      pass: true,
      half: true,
    ),
    // ChecklistItem(
    //   des:
    //       'Record the data and evaluate the condition of the heat transfer before and after cleaning',
    //   half: true,
    //   pass: true,
    // ),
    ChecklistItem(
      des: 'Check all the control devices',
      pass: true,
    ),
    ChecklistItem(
      des: 'Check connection, fittings and pipe line',
      half: true,
      pass: true,
    ),
    ChecklistItem(
      des: 'Check and clean dust',
      pass: true,
      service: true,
    ),
    ChecklistItem(
      des: 'Check all the safety device',
      pass: true,
    ),
    ChecklistItem(
      des: 'Check casing for sign of corrosion',
      pass: true,
    ),
    ChecklistItem(
      des: 'Check and clean cooling fins with chemicals',
      pass: true,
      service: true,
      half: true,
    ),
    // ChecklistItem(
    //   des: 'Check refrigerant pressure (top-up if less)',
    //   pass: true,
    // ),
    ChecklistItem(
      des: 'Pressure',
      pass: false,
      // half: true,
      value: ['psi'],
    ),
    ChecklistItem(
      des: 'Temperature',
      pass: false,
      half: true,
      value: ['˚C'],
    ),
    ChecklistItem(
      des: 'Running Amp',
      pass: false,
      // half: true,
      value: ['A'],
    ),
  ];

//   static const List<Map<String, dynamic>> ahu = [
//     {
//       'des': 'Check and clean washable filters.',
//       'pass': true,
//       'service': true,
//     },
//     {
//       'des': 'Chemical clean cooling coil.',
//       'pass': true,
//       'major': true,
//       'service': true,
//     },
//     {
//       'des': 'Clean cooling coil and tray.',
//       'pass': true,
//       'major': false,
//       'service': true,
//     },
//     {
//       'des': 'Check fan blower bearing.',
//       'pass': true,
//     },
//     {
//       'des': 'Check motor bearing.',
//       'pass': true,
//     },
//     {
//       'des': 'Check alignment and belt.',
//       'pass': true,
//     },
//     {
//       'des': 'Check abnormal noise.',
//       'pass': true,
//     },
//     {
//       'des': 'Check damage of casing and clean body panel.',
//       'pass': true,
//     },
//     {
//       'des': 'Check leakage of valve.',
//       'pass': true,
//     },
//     {
//       'des': 'Check damage of insulation.',
//       'pass': true,
//     },
//     {
//       'des': 'Check cleanliness of room.',
//       'pass': true,
//     },
//     {
//       'des': 'Check control panel.',
//       'pass': true,
//     },
//     {
//       'des': 'CHW in/out temperature.',
//       'pass': false,
//       'value': ['°C', '°C'],
//     },
//     {
//       'des': 'CHW in/out pressure.',
//       'pass': false,
//       'value': ['Pa', 'Pa'],
//     },
//     {
//       'des': 'Motor running amp R/Y/B.',
//       'pass': false,
//       'value': ['A', 'A', 'A'],
//     },
//   ];

//   static const List<Map<String, dynamic>> fcu = [
//     {
//       'des': 'Check and clean washable filters.',
//       'pass': true,
//       'service': true,
//     },
//     {
//       'des': 'Chemical clean cooling coil.',
//       'pass': true,
//       'major': true,
//       'service': true,
//     },
//     {
//       'des': 'Clean cooling coil and tray.',
//       'pass': true,
//       'major': false,
//       'service': true,
//     },
//     {
//       'des': 'Check fan blower bearing.',
//       'pass': true,
//     },
//     {
//       'des': 'Check motor bearing.',
//       'pass': true,
//     },
//     {
//       'des': 'Check alignment and belt.',
//       'pass': true,
//       'belt': true,
//     },
//     {
//       'des': 'Check leakage of valve.',
//       'pass': true,
//     },
//     {
//       'des': 'Check damage of insulation.',
//       'pass': true,
//     },
//     {
//       'des': 'Room temperature.',
//       'pass': false,
//       'value': ['°C'],
//     },
//     {
//       'des': 'Motor running amp R/Y/B.',
//       'pass': false,
//       'value': ['A', 'A', 'A'],
//     },
//   ];

//   static const List<Map<String, dynamic>> fan = [
//     {
//       'des': 'Check abnormal noise.',
//       'pass': true,
//     },
//     {
//       'des': 'Check alignment of belt drives.',
//       'pass': true,
//       'belt': true,
//     },
//     {
//       'des': 'Check and lubricate bearing.',
//       'pass': true,
//     },
//     {
//       'des': 'Clean fan case and blower.',
//       'pass': true,
//       'service': true,
//     },
//     {
//       'des': 'Check control panel.',
//       'pass': true,
//     },
//     {
//       'des': 'Motor running amp R/Y/B.',
//       'pass': false,
//       'value': ['A', 'A', 'A'],
//     },
//   ];

  static List<ChecklistItem> ct = [
    ChecklistItem(
      des: 'Clean infill, cold water basin, hot water basin and sump.',
      pass: true,
      service: true,
    ),
    ChecklistItem(
      des: 'Clean sump strainer.',
      pass: true,
      service: true,
    ),
    ChecklistItem(
      des: 'Check the operation of spray nozzles and water distribution.',
      pass: true,
    ),
    ChecklistItem(
      des:
          'Check the fan motor bearing condition and lubricate with grease if needed.',
      pass: true,
    ),
    ChecklistItem(
      des:
          'Check the alignment and tensions of the belt and adjust if necessary.',
      pass: true,
    ),
    ChecklistItem(
      des: 'Check and tighten bolts and nuts.',
      pass: true,
    ),
    ChecklistItem(
      des: 'Check body casing condition for leak and frame work for rust.',
      pass: true,
    ),
    ChecklistItem(
      des: 'Check the float valve operation level.',
      pass: true,
    ),
    ChecklistItem(
      des: 'Check the control panel.',
      pass: true,
    ),
    ChecklistItem(
      des: 'Fan motor running amp R/Y/B.',
      pass: false,
      value: ['A', 'A', 'A'],
    ),
  ];

  static List<ChecklistItem> chill = [
    ChecklistItem(
      des: 'Check for any abnormal noise and vibration.',
      pass: true,
    ),
    ChecklistItem(
      des:
          'Check the pump and motor bearing condition and lubricate with grease.',
      pass: true,
    ),
    ChecklistItem(
      des: 'Check the mechanical seal and glands pack for any water leakage.',
      pass: true,
    ),
    ChecklistItem(
      des: 'Check and tighten bolts and nuts.',
      pass: true,
    ),
    ChecklistItem(
      des: 'Check pump and motor spring isolator / rubber pad condition.',
      pass: true,
    ),
    ChecklistItem(
      des: 'Check the condition of the PU insulation and jacketing.',
      pass: true,
    ),
    ChecklistItem(
      des: 'Check the control panel.',
      pass: true,
    ),
    ChecklistItem(
        des: 'Check the water pressure in / out.',
        pass: false,
        value: ['Pa', 'Pa.']),
    ChecklistItem(
      des: 'Fan motor running amp R/Y/B.',
      pass: false,
      value: ['A', 'A', 'A'],
    ),
  ];

  static List<ChecklistItem> con = [
    ChecklistItem(
      des: 'Check for any abnormal noise and vibration.',
      pass: true,
    ),
    ChecklistItem(
      des:
          'Check the pump and motor bearing condition and lubricate with grease.',
      pass: true,
    ),
    ChecklistItem(
      des: 'Check the mechanical seal and glands pack for any water leakage.',
      pass: true,
    ),
    ChecklistItem(
      des: 'Check and tighten bolts and nuts.',
      pass: true,
    ),
    ChecklistItem(
      des: 'Check pump and motor spring isolator / rubber pad condition.',
      pass: true,
    ),
    ChecklistItem(
      des: 'Check the control panel.',
      pass: true,
    ),
    ChecklistItem(
        des: 'Check the water pressure in / out.',
        pass: false,
        value: ['Pa', 'Pa']),
    ChecklistItem(
      des: 'Fan motor running amp R/Y/B.',
      pass: false,
      value: ['A', 'A', 'A'],
    ),
  ];

  static List<ChecklistItem> chi = [
    ChecklistItem(
      des: 'Check noise and vibration.',
      pass: true,
    ),
    ChecklistItem(
      des: 'Check for condensation.',
      pass: true,
    ),
    ChecklistItem(
      des: 'Check leakage at valves and flanges.',
      pass: true,
    ),
    ChecklistItem(
      des: 'Visually inspect chiller switchboard.',
      pass: true,
    ),
    ChecklistItem(
      des: 'Check refrigerant charge.',
      pass: true,
    ),
    ChecklistItem(
      des: 'Check oil level and colour.',
      pass: true,
    ),
    ChecklistItem(
      des: 'Check seals and gaskets.',
      pass: true,
    ),
    ChecklistItem(
      des: 'Check chiller cover, plate and latches.',
      pass: true,
    ),
    ChecklistItem(
      des: 'Check cleanliness and drainage.',
      pass: true,
    ),
    ChecklistItem(
      des: 'Check lighting and switches.',
      pass: true,
    ),
    ChecklistItem(
      des: 'Check lock and security devices.',
      pass: true,
    ),
    ChecklistItem(
      des: 'Check control and indicator light.',
      pass: true,
    ),
    ChecklistItem(
      des: 'Check sign of leakage.',
      pass: true,
    ),
    ChecklistItem(
      des: 'Check flow switch.',
      pass: true,
    ),
    ChecklistItem(
      des: 'Compressor oil level',
      pass: false,
      value: [''],
    ),
    ChecklistItem(
      des: 'Compressor oil temperature.',
      pass: false,
      value: ['˚F'],
    ),
    ChecklistItem(
      des: 'Compressor oil pressure.',
      pass: false,
      value: ['Psig'],
    ),
    ChecklistItem(
      des: 'Compressor filter differential pressure.',
      pass: false,
      value: ['Psid'],
    ),
    ChecklistItem(
      des: 'Compressor slide valve.',
      pass: false,
      value: ['%'],
    ),
    ChecklistItem(
      des: 'Motor volt.',
      pass: false,
      value: ['V'],
    ),
    ChecklistItem(
      des: 'Motor rated load Amp.',
      pass: false,
      value: ['A'],
    ),
    ChecklistItem(
      des: 'Motor FLA.',
      pass: false,
      value: ['%'],
    ),
    ChecklistItem(
      des: 'Motor running Amp.',
      pass: false,
      value: ['A'],
    ),
    ChecklistItem(
      des: 'Cooler evaporator pressure.',
      pass: false,
      value: ['Psig'],
    ),
    ChecklistItem(
      des: 'Cooler evaporator temperature.',
      pass: false,
      value: ['˚F'],
    ),
    ChecklistItem(
      des: 'Cooler evaporator superheat.',
      pass: false,
      value: ['˚F'],
    ),
    ChecklistItem(
      des: 'Cooler entering water temperature.',
      pass: false,
      value: ['˚F'],
    ),
    ChecklistItem(
      des: 'Cooler leaving water temperature.',
      pass: false,
      value: ['˚F'],
    ),
    ChecklistItem(
      des: 'Cooler inlet water pressure.',
      pass: false,
      value: ['Psig'],
    ),
    ChecklistItem(
      des: 'Cooler outlet water pressure.',
      pass: false,
      value: ['Psig'],
    ),
    ChecklistItem(
      des: 'Condenser pressure.',
      pass: false,
      value: ['Psig'],
    ),
    ChecklistItem(
      des: 'Condenser temperature.',
      pass: false,
      value: ['˚F'],
    ),
    ChecklistItem(
      des: 'Condenser sub cooling.',
      pass: false,
      value: ['˚F'],
    ),
    ChecklistItem(
      des: 'Condenser entering water temperature.',
      pass: false,
      value: ['˚F'],
    ),
    ChecklistItem(
      des: 'Condenser leaving water temperature.',
      pass: false,
      value: ['˚F'],
    ),
    ChecklistItem(
      des: 'Condenser inlet water pressure.',
      pass: false,
      value: ['Psig'],
    ),
    ChecklistItem(
      des: 'Condenser outlet water pressure.',
      pass: false,
      value: ['Psig'],
    ),
  ];

  static List<ChecklistItem>? check(String data) {
    switch (data) {
      case AcType.ahu:
        return ahu;
      case AcType.fcu:
        return fcu;
      case AcType.cas:
        return fcu;
      case AcType.pre:
        return fcu;
      case AcType.fan:
        return fan;
      case AcType.ct:
        return ct;
      case AcType.chill:
        return chill;
      case AcType.con:
        return con;
      case AcType.chi:
        return chi;
      case AcType.split:
        return split;
      case AcType.deh:
        return deh;
      case AcType.chik:
        return split;
      case AcType.frek:
        return split;
      case AcType.waste:
        return split;
      default:
        return null;
    }
  }
}
