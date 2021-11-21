import 'package:fci_project/data/localization/localization_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class TextFieldTemplate {
  Function onchange;
  TextEditingController controller;
  BuildContext context;
  Widget suffix;
  Widget textField;

  TextFieldTemplate(
      this.onchange, this.controller, this.context, name,
      {bool canArabic = false, this.suffix,double height=50}) {
    textField =
        Container(
            height: 50,
            width: Get.width,
            child: Center(
              child: Container(
                  height: 50,
                  padding: EdgeInsets.only(left: 20, right: 10),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 2),
                      color: Colors.grey[100],
                      borderRadius:
                      BorderRadius.all(Radius.circular(20))),
                  child: Directionality(
                    textDirection: Localizations.localeOf(context).countryCode == 'ar'
                        ? TextDirection.ltr
                        : TextDirection.rtl,
                    child: TextFormField(
                      controller: controller,
                      style: TextStyle(fontSize: 15),
                      inputFormatters: <TextInputFormatter>[
                        canArabic
                            ? FilteringTextInputFormatter.deny(RegExp('[]'))
                            : FilteringTextInputFormatter.allow(RegExp('[a-zA-Z0-9-() ]')),
                      ],
                      validator: (value) {
                        return null;
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      enableSuggestions: true,
                      onChanged: onchange??(value) {},
                      decoration: InputDecoration(
                        hintText: name,
                        icon: suffix??Icon(Icons.account_balance_sharp,size: 20,color: Colors.grey,),
                        // labelText: name,
                        suffixIcon: Icon(
                          Icons.mic_none_outlined,
                          size: 20,
                          color: Colors.grey,
                        ),

                        hintStyle: TextStyle(
                          color: Color.fromRGBO(70, 70, 70, 1),
                        ),
                        border: InputBorder.none,
                      ),
                      textDirection: LocalizationService.selectedLang !=
                          LocalizationService.langs.first.obs?TextDirection.ltr:TextDirection.rtl,

                    ),
                  )),
            ));

  }
}
