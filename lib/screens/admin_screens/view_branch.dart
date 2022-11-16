import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/branch_provider.dart';
import 'package:shop_app/providers/subject_provider.dart';
import 'package:shop_app/widgets/view_branch_card.dart';
import 'package:shop_app/widgets/view_subject_card.dart';

import '../../models/branch.dart';
import '../../models/subject.dart';

class ViewBranch extends StatefulWidget {
  static const routeName = '/view-branches';

  @override
  State<ViewBranch> createState() => _ViewBranchState();
}

class _ViewBranchState extends State<ViewBranch> {
  var _isLoading = true;
  var _isInit = false;
  var message = "No branch added at the moment";

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    if (!_isInit) {
      Provider.of<Branches>(context).fetchBranch().catchError((error) {
        message = error.toString();
      }).then((_) {
        setState(() {
          _isLoading = false;
        });
      });
      _isInit = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Branch> branches = Provider.of<Branches>(context).branches;
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Branch'),
      ),
      body: (_isLoading)
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : buildListView(branches),
    );
  }

  Widget buildListView(data) {
    return (data.length > 0)
        ? ListView.builder(
            itemBuilder: (ctx, index) => BranchCard(data[index]),
            itemCount: data.length,
          )
        : Center(
            child: Text(message),
          );
  }
}
