import 'package:flutter/material.dart';
import 'package:offer_show/asset/data.dart';
import 'package:offer_show/page/detail_component/salaryComment.dart';
import 'package:offer_show/util/provider.dart';
import 'package:provider/provider.dart';

class CommentsInfo extends StatefulWidget {
  List<CommentData> commentData = [];
  CommentsInfo({Key key, this.commentData}) : super(key: key);
  @override
  _CommentsInfoState createState() => _CommentsInfoState();
}

class _CommentsInfoState extends State<CommentsInfo> {
  List<CommentData> commentData;

  @override
  void initState() {
    super.initState();
    commentData = widget.commentData;
  }

  List<Widget> _getBuild() {
    if (commentData == null) return [Container()];
    List<Widget> tmp = [];
    for (var i = 0; i < commentData.length; i++) {
      var tmpCommentData = commentData[i];
      tmp.add(SalaryComment(
        commentId: tmpCommentData.commentId,
        content: tmpCommentData.content,
        index: i + 1,
        isMine: tmpCommentData.isMine,
        isOwner: tmpCommentData.isOwner,
        time: tmpCommentData.time,
      ));
    }
    return tmp;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: _getBuild(),
      ),
    );
  }
}
