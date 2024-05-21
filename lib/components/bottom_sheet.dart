import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:tt/components/modal_dialog.dart';
import 'package:tt/helpers/functions.dart';
import 'package:tt/helpers/resources.dart';
import 'package:tt/helpers/settings.dart';

void showBottomDrawer(BuildContext context, int id, String controller,
    {bool withDelete = true}) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      var dio = Dio();
      // Here you can return any widget that you want to show in the bottom drawer.
      return Container(
        height: 200,
        child: Column(
          children: [
            const Text("", style: TextStyle(fontSize: 20)),
            !withDelete
                ? Container()
                : ListTile(
                    iconColor: Colors.red[900],
                    leading: Icon(Icons.delete),
                    title: Text(
                      resDelete,
                      style: TextStyle(fontSize: 20, color: Colors.red[900]),
                    ),
                    onTap: () async {
                      try {
                        // delete confirmation dialog
                        var result = await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text(resDelete),
                                content: Text(resDeleteConfirm),
                                actions: [
                                  TextButton(
                                    child: Text(resYes),
                                    onPressed: () {
                                      Navigator.of(context).pop(true);
                                    },
                                  ),
                                  TextButton(
                                    child: Text(resNo),
                                    onPressed: () {
                                      Navigator.of(context).pop(false);
                                    },
                                  ),
                                ],
                              );
                            });
                        if (result) {
                          showLoadingPanel(context);
                          try {
                            // delete the item
                            var response = await dio
                                .delete('${host}${controller}/delete/${id}');
                            if (response.statusCode == 200) {
                              hideLoadingPanel(context);
                              showErrorMessage(context, resDone);
                            }
                          } catch (e) {
                            hideLoadingPanel(context);
                            showErrorMessage(context, resError);
                          }
                        }
                      } catch (e) {}
                    },
                  ),
            ListTile(
              leading: Icon(Icons.edit),
              title: Text(
                resEdit,
                style: TextStyle(fontSize: 20),
              ),
              onTap: () {
                showEditDialog(id, controller);
              },
            ),
          ],
        ),
      );
    },
  );
}

void showEditDialog(int id, String controller) {
  // get data from server
  var dio = Dio();
  dio.options.headers['content-type'] = 'application/json; charset=UTF-8';
  var response = dio.get("${host}${controller}/");
}
