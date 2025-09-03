import 'package:flutter/material.dart';

class TextBox extends StatelessWidget {
  const TextBox({Key? key, 
    this.text,
    this.init,
    this.enable,
    this.validator,
    this.onSaved,
    this.minLines,
    this.maxLines,
    this.keybordType,
    this.obscure,
    this.prefix,
    this.suffix,
    this.complete,
    this.border,
    this.onChg,
    this.read,
    this.controller,
  }) : super(key: key);
  final String? text;
  final String? init;
  final bool? enable;
  final bool? obscure;
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;
  final void Function(String?)? onChg;
  final TextInputType? keybordType;
  final int? minLines;
  final int? maxLines;
  final String? prefix;
  final String? suffix;
  final bool? read;
  final InputBorder? border;
  final TextEditingController? controller;
  final Function()? complete;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      child: TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        readOnly: read??false,
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          labelText: text??'',
          enabled: enable??true,
          suffixText: suffix,
          prefixStyle: const TextStyle(color: Colors.black, fontSize: 18),
          suffixStyle: const TextStyle(color: Colors.black, fontSize: 18),
          prefixText: prefix,
          border: border,
          

          // icon: Icon(Icons.people),
        ),
        style: const TextStyle(
          fontSize: 18,
        ),
        controller: controller,
        validator: validator,
        autocorrect: false,
        onSaved: onSaved,
        keyboardType: keybordType?? TextInputType.text,
        initialValue: init??'',
        obscureText: obscure??false,
        minLines: minLines??1,
        maxLines: maxLines??1,
        onEditingComplete: complete,
        onChanged: onChg,
      ),
    );
  }
}

class PasswordTextBox extends StatefulWidget {
   const PasswordTextBox({Key? key, 
    this.text,
    this.enable= true,
    this.validateText,
    this.onSaved,
    this.complete,
    this.border,
    this.init,
  }) : super(key: key);
  final String? text;
  final String? init;
  final String? validateText;
  final bool enable;
  final InputBorder? border;
  final void Function(String?)? onSaved;
  final void Function()? complete;

  @override
  _PasswordTextBoxState createState() => _PasswordTextBoxState();
}

class _PasswordTextBoxState extends State<PasswordTextBox> {
  bool obscure = true;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      child: TextFormField(
        initialValue: widget.init??'',
        decoration: InputDecoration(
          border: widget.border,
          labelText: widget.text??'',
          enabled: widget.enable,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          suffix: GestureDetector(
            onTap: () {
              setState(() {
                obscure ? obscure = false : obscure = true;
              });
            },
            child: Icon(
              Icons.remove_red_eye,
              color: obscure ? Colors.black87 : Colors.grey,
              size: 22,
            ),
          ),
        ),
        onEditingComplete: widget.complete,
        validator: (String? value) {
          if (value!.isEmpty) {
            return widget.validateText;
          }
          return null;
        },
        style: const TextStyle(
          fontSize: 18,
        ),
        autocorrect: false,
        onSaved: widget.onSaved,
        keyboardType: TextInputType.text,
        obscureText: obscure,
      ),
    );
  }
}

class NameTextBox extends TextBox {
  NameTextBox({Key? key, 
    text,
    enable= true,
    onSaved,
    String? validateText,
    validator,
    complete,
    init= '',
    read= false,
    border,
  }) : super(key: key, 
          text: text,
          enable: enable,
          onSaved: onSaved,
          validator: validator ??
              (String? value) {
                if (value!.isEmpty) {
                  return validateText;
                }
                return null;
              },
          obscure: false,
          init: init??'',
          read: read,
          complete: complete,
          border: border,
        );
}

class SearchTextBox extends TextBox {
   const SearchTextBox({Key? key, 
    border,
    onChg,
    init = '',
    // controller,
  }) : super(key: key, 
          text: 'Search',
          onChg: onChg,
          border: border,
          obscure: false,
          init: init,
          // controller:controller,

        );
}

class EmailTextBox extends TextBox {
  EmailTextBox({Key? key, 
    text,
    enable= true,
    onSaved,
    String? validateText,
    init= '',
    border,
    complete,
  }) : super(key: key, 
          keybordType: TextInputType.emailAddress,
          text: text,
          enable: enable,
          onSaved: onSaved,
          complete: complete,
          validator: (String? value) {
            if (value!.isEmpty) {
              return validateText;
            }
            if (!value.contains('@')) {
              return 'Please enter a valid email address';
            }
            return null;
          },
          obscure: false,
          border: border,
          init: init,

        );
}

class NumTextBox extends TextBox {
  NumTextBox({Key? key, 
    text,
    enable= true,
    onSaved,
    validator,
    String? validateText,
    init= '',
    String? prefix,
    String? suffix,
    read= false,
    border,
    complete,
  }) : super(key: key, 
          keybordType: TextInputType.numberWithOptions(decimal: true),
          text: text,
          enable: enable,
          complete: complete,
          onSaved: onSaved,
          validator: validator ??
              (String? value) {
                if (value!.isEmpty) {
                  return validateText;
                }
                if (num.tryParse(value) == null) {
                  return 'Please enter numeric value only';
                }
                return null;
              },
          obscure: false,
          init: init,
          prefix: prefix,
          border: border,
          suffix: suffix,
          read: read,
        );
}

class MultilineTextBox extends TextBox {
  MultilineTextBox({Key? key, 
    text,
    enable= true,
    onSaved,
    String? validateText,
    init,
    complete,
    border,
    read= false,
  }) : super(key: key, 
          text: text,
          complete: complete,
          enable: enable,
          onSaved: onSaved,
          validator: (String? value) {
            if (value!.isEmpty) {
              return validateText;
            }
            return null;
          },
          
          minLines: 4,
          maxLines: 8,
          init: init??'',
          border: border,
          read: read,
          keybordType: TextInputType.multiline,
        );
}

// class PhoneTextBox extends StatelessWidget {
//   final Function onSaved;
//   final String init;
//   final bool enable;
//   final String countryCode;
//   final String validateText;
//   PhoneTextBox({
//     this.onSaved,
//     this.init,
//     this.enable,
//     this.validateText,
//     this.countryCode: 'MY',
//   });
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           FormHead('Phone Number'),
//           IntlPhoneField(
//             initialValue: init,
//             enabled: enable,
//             autoValidate: false,
//             validator: (String value) {
//               if (value.isEmpty) {
//                 return validateText;
//               }
//               if (num.tryParse(value) == null) {
//                 return 'Please enter valid phone number.';
//               }
//               return null;
//             },
//             decoration: InputDecoration(
//               // labelText: ,
//               contentPadding: EdgeInsets.only(bottom: 15, left: 10),
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(20.0),
//                 borderSide: BorderSide(),
//               ),
//             ),
//             initialCountryCode: countryCode,
//             onSaved: onSaved,
//           ),
//         ],
//       ),
//     );
//   }
// }
