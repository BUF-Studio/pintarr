enum ReportType { minor, major, three, month, half, year, repair, breakdown }

String? reportTypeToString(ReportType? type) {
  if (type == ReportType.minor) return 'Minor Service';
  if (type == ReportType.major) return 'Major Service';
  if (type == ReportType.month) return 'Monthly Service';
  if (type == ReportType.three) return '3-Monthly Service';
  if (type == ReportType.half) return 'Half-yearly Service';
  if (type == ReportType.year) return 'Yearly Service';
  if (type == ReportType.repair) return 'Repair';
  if (type == ReportType.breakdown) return 'Breakdown';
  return null;
}

ReportType reportTypeFromString(String type) {
 
  if (type == 'Minor Service') return ReportType.minor;
  if (type == 'Major Service') return ReportType.major;
  if (type == 'Monthly Service') return ReportType.month;
  if (type == '3-Monthly Service') return ReportType.three;
  if (type == 'Half-yearly Service') return ReportType.half;
  if (type == 'Yearly Service') return ReportType.year;
  if (type == 'Repair') return ReportType.repair;
  if (type == 'Breakdown') return ReportType.breakdown;
  return ReportType.minor;
  
}
