import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/BackEnd/PostLikes.dart';
import 'package:instagram_clone/providers/userProvider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CommentsCard extends StatelessWidget {
  String? comment;
  String? commenterName;
  List? likes;
  String? commenTime;
  String? commenterProfile;
  String? postId;
  String? commentId;

  CommentsCard(
      {this.commenTime,
      this.postId,
      this.commentId,
      this.comment,
      this.likes,
      this.commenterName,
      this.commenterProfile});
  time() {
    var NowDateTime = DateTime.now();
    var postingTime = commenTime;
    final Duration duration =
        NowDateTime.difference(DateTime.parse(postingTime!));
    if (duration.inMinutes == 0 && duration.inHours == 0) {
      return "now";
    } else if (duration.inHours == 0 && duration.inMinutes <= 59) {
      return "${duration.inMinutes}m ago";
    } else if (duration.inMinutes > 59 && duration.inHours <= 24) {
      return "${duration.inHours}h ago";
    } else if (duration.inHours > 24 && duration.inDays <= 30) {
      return "${duration.inDays}d ago";
    } else if (duration.inDays > 30) {
      return DateFormat.yMMMMd().format(DateTime.parse(commenTime!));
    } else {
      return commenTime;
    }
  }
//new branch updated
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<userProvider>(context).getUser;
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: ListTile(
          leading: ClipOval(
            child: CachedNetworkImage(
              height: 45,
              width: 45,
              fit: BoxFit.cover,
              imageUrl: commenterProfile.toString(),
              placeholder: (context, url) => new CircularProgressIndicator(),
              errorWidget: (context, url, error) => new Icon(Icons.error),
            ),
          ),
          title: Text(
            commenterName.toString(),
            style: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.w500, fontSize: 14),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                comment.toString(),
                style: const TextStyle(fontSize: 12, color: Colors.black),
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    time().toString(),
                    style: const TextStyle(fontSize: 13),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Text(
                    likes!.isEmpty ? '' : "${likes!.length} likes",
                    style: const TextStyle(fontSize: 13),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  const Text(
                    "Reply",
                    style: TextStyle(fontSize: 13),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  const Text(
                    "Send",
                    style: TextStyle(fontSize: 13),
                  )
                ],
              )
            ],
          ),
          trailing: IconButton(
              onPressed: () {
                Likes().likeComment(postId!, user.id!, commentId!, likes!);
              },
              icon: Icon(
                likes!.contains(user.id)
                    ? Icons.favorite
                    : Icons.favorite_border_outlined,
                size: 15,
                color: likes!.contains(user.id) ? Colors.red : Colors.black,
              ))),
    );
  }
}
