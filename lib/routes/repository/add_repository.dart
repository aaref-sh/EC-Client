import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:tt/components/modal_dialog.dart';
import 'package:tt/helpers/functions.dart';
import 'package:tt/helpers/resources.dart';
import 'package:tt/helpers/settings.dart';
import 'package:tt/models/repository.dart';
// import 'package:fluttertoast/fluttertoast.dart';

class AddRepository extends StatefulWidget {
  const AddRepository({super.key});

  @override
  State<AddRepository> createState() => _AddRepositoryState();
}

class _AddRepositoryState extends State<AddRepository> {
  var nameController = TextEditingController();
  var noteController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Column(
        children: [
          TextFormField(
            decoration: InputDecoration(labelText: resName),
            controller: nameController,
          ),
          TextFormField(
            decoration: InputDecoration(labelText: resNotes),
            controller: noteController,
          ),
          const SizedBox(height: 5),
          ElevatedButton(
              onPressed: () async {
                if (nameController.text.isEmpty) return;
                showLoadingPanel(context);
                var dio = Dio();
                dio.options.headers['Authorization'] = 'Bearer ';
                dio.options.headers['Content-Type'] = 'application/json';
                var repo = Repository(
                    name: nameController.text, notes: noteController.text);
                try {
                  var response =
                      await dio.post("${host}Repository/Create", data: repo);
                  if (response.statusCode == 200) {
                    nameController.text = '';
                    noteController.text = '';
                    hideLoadingPanel(context);
                    showErrorMessage(context, resDone);
                  }
                } catch (e) {
                  // show toast error message
                  hideLoadingPanel(context);
                  showErrorMessage(context, resError);

                  print(e);
                }
              },
              child: Text(resAdd))
        ],
      ),
    );
  }
}
