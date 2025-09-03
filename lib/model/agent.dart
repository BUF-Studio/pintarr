class Agent {
  Agent({
    required this.username,
    required this.admin,
    required this.pintar,
    required this.access,
    required this.id,
    required this.join,
    this.cid,
  });

  String username;
  int join;
  // final String password;
  // final String pic;
  bool admin;
  bool pintar;
  bool access;
  String? cid;
  String id;

  static Agent fromMap(Map<String, dynamic> data, id) {
    // if (data == null) {
    //   return null;
    // }
    print(data);

    final String username = data['username'];
    final int join = data['join'];
    // final String password = data['password'];
    // final String pic = data['pic'];
    final bool admin = data['admin'];
    final bool pintar = data['pintar'];
    final bool access = data['access'];
    final String? cid = data['cid'];

    return Agent(
      username: username,
      access: access,
      join: join,
      // password: password,
      admin: admin,
      pintar: pintar,
      cid: cid,
      id: id,
      // pic: pic,
    );
  }

  copy() => Agent(
        username: username,
        access: access,
        // password: password,
        join: join,
        admin: admin,
        pintar: pintar,
        cid: cid,
        id: id,
        // pic: pic,
      );

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'access': access,
      'admin': admin,
      'join': join,
      'pintar': pintar,
      'cid': cid,
    };
  }
}
