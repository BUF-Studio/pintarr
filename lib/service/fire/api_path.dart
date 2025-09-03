class APIPath {
  static String agents() => 'agent';
  static String agent(uid) => 'agent/$uid';
  static String acTypes() => 'actype';
  static String acType(tid) => 'actype/$tid';
  static String checklists() => 'checklist';
  static String checklist(cid) => 'checklist/$cid';
  // static String checklists() => 'checklist';
  // static String checklist(cid) => 'checklist/$cid';
  // static String actypes() => 'type';
  // static String actype(tid) => 'type/$tid';
  static String clients() => 'client';
  static String client(cid) => 'client/$cid';
  static String units(cid) => 'client/$cid/unit';
  static String unit(cid, uid) => 'client/$cid/unit/$uid';
  // static String report(rid) => 'report/$rid';
  static String reports(cid) => 'client/$cid/report';
  static String report(cid,rid) => 'client/$cid/report/$rid';
  static String test(id) => 'test/$id';
  // static String prices(cid) => 'client/$cid/price';
  // static String price(cid, pid) => 'client/$cid/price/$pid';
  // static String staffs() => 'staff';

}
