import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String postId;
  final String ownerEmail;
  final String gamer_tag;
  final String description;
  final String mediaUrl;
  List rip,f,gg;
  String profilePic;
  int fCount,ripCount,ggCount;
  DateTime timestamp;
  String slug;
  Post(
      {this.postId,
      this.ownerEmail,
      this.gamer_tag,
      this.description,
      this.mediaUrl,
      this.f,
      this.gg,
      this.rip,
      this.fCount,
      this.ripCount,
      this.profilePic,
      this.ggCount,
      this.timestamp,
      this.slug
      });

  factory Post.fromDocument(DocumentSnapshot doc) {
    return Post(
      postId: doc['postId'],
      ownerEmail: doc['ownerEmail'],
      gamer_tag: doc['gamer_Tag'],
      description: doc['description'],
      mediaUrl: doc['mediaUrl'],
      f: doc['f'],
      rip: doc['rip'],
      gg: doc['gg'],
      profilePic:doc['owner_pic'],
      timestamp:doc['timestamp'].toDate(),
      slug:doc['slug']
    );
  }

  int getFCount(f) {
    if (f ==[]) {
      return 0;
    }

    int count = 0;
    f.forEach((val) {
        count += 1;
      
    });
    return count;
  }
  int geripCount(rip) {
    if (rip == []) {
      return 0;
    }

    int count = 0;
    rip.forEach((val) {
        count += 1;
    });
    return count;
  }
  int getGGCount(gg) {
    if (gg == []) {
      return 0;
    }

    int count = 0;
    gg.forEach((val) {
        count += 1;
    });
    return count;
  }
}