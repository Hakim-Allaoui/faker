import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faker/models/post_model.dart';
import 'package:faker/models/profile_model.dart';
import 'package:faker/utils/auth.dart';
import 'package:faker/utils/tools.dart';

class Posts {
  static Map<String, PostModel> posts = new Map<String, PostModel>();

  static bool isAdmin = false;

  static Future<bool> getUserPosts() async {
    posts.clear();

    isAdmin = /*MyAuth.auth.currentUser?.uid == 'JFcLHGqFmqSt54xu4lm4lQqgBHE3' || */MyAuth.auth.currentUser?.email == 'hakim.allaoui97@gmail.com' || MyAuth.auth.currentUser?.email == 'amegos11@gmail.com';

    Tools.logger.w("isAdmin: $isAdmin");

    try{
      if (isAdmin) {
        DateTime last12h = DateTime.now().subtract(Duration(hours: 6));
        FirebaseFirestore.instance
            .collection('posts')
            .where("createdAt",
            isGreaterThan: last12h)
            .orderBy("createdAt", descending: true)
            .get()
            .then((snapshot) {
          Tools.logger.i("${snapshot.docs.length} Posts Retrieved");

          snapshot.docs.forEach((element) {
            posts.addAll({
              element.id: PostModel.fromJson(element.data()["post"]),
            });
          });
        });
        return true;
      } else {
        FirebaseFirestore.instance
            .collection('posts')
            .where("user",
            isEqualTo: MyAuth.auth.currentUser?.uid ?? 'don\'t retrieve anything')
            .orderBy("createdAt", descending: true)
            .get()
            .then((snapshot) {
          Tools.logger.i("${snapshot.docs.length} Posts Retrieved");

          snapshot.docs.forEach((element) {
            posts.addAll({
              element.id: PostModel.fromJson(element.data()["post"]),
            });
          });
        });
      }
      return true;
    } catch (e){
      Tools.logger.e(e);
      return false;
    }
  }

  static Future<void> addPost(PostModel post) async {
    final newPost = FirebaseFirestore.instance.collection('posts').doc();

    await newPost.set({
      "user": MyAuth.auth.currentUser.uid,
      "createdAt": Timestamp.now(),
      "post": post.toJson()
    });

    posts[newPost.id] = post;

    Tools.logger.i("Post added successfully");
  }

  static Future<void> editPost(String id, PostModel post) async {
    final updatingPost = FirebaseFirestore.instance.collection('posts').doc(id);

    await updatingPost.update({
      "user": MyAuth.auth.currentUser.uid,
      "createdAt": Timestamp.now(),
      "post": post.toJson()
    });

    posts[updatingPost.id] = post;

    Tools.logger.i("Post updated successfully");
  }

  static Future<void> deletePost(String id) async {
    await FirebaseFirestore.instance.collection('posts').doc(id).delete();

    posts.removeWhere((key, value) => key == id);

    Tools.logger.w("Post deleted: where id = $id");
  }

  static Future<void> deleteProfile(String id) async {
    await FirebaseFirestore.instance.collection('profiles').doc(id).delete();

    posts.removeWhere((key, value) => key == id);

    Tools.logger.w("profile deleted: where id = $id");
  }

}

class Profiles{
  static Map<String, ProfileModel> profiles = new Map<String, ProfileModel>();

  static bool isAdmin = false;

  static Future<bool> getUserProfiles() async {
    profiles.clear();

    isAdmin = /*MyAuth.auth.currentUser?.uid == 'JFcLHGqFmqSt54xu4lm4lQqgBHE3' || */MyAuth.auth.currentUser?.email == 'hakim.allaoui97@gmail.com' || MyAuth.auth.currentUser?.email == 'amegos11@gmail.com';

    try{
      if (isAdmin) {
        DateTime last12h = DateTime.now().subtract(Duration(hours: 6));
        FirebaseFirestore.instance
            .collection('profiles')
            .where("createdAt",
            isGreaterThan: last12h)
            .orderBy("createdAt", descending: true)
            .get()
            .then((snapshot) {
          Tools.logger.i("${snapshot.docs.length} profiles Retrieved");

          snapshot.docs.forEach((element) {
            profiles.addAll({
              element.id: ProfileModel.fromJson(element.data()["profile"]),
            });
          });
        });
        return true;
      } else {
        FirebaseFirestore.instance
            .collection('profiles')
            .where("user",
            isEqualTo: MyAuth.auth.currentUser?.uid ?? 'don\'t retrieve anything')
            .orderBy("createdAt", descending: true)
            .get()
            .then((snapshot) {
          Tools.logger.i("${snapshot.docs.length} profiles Retrieved");

          snapshot.docs.forEach((element) {
            profiles.addAll({
              element.id: ProfileModel.fromJson(element.data()["profile"]),
            });
          });
        });
      }
      return true;
    } catch (e){
      Tools.logger.e(e);
      return false;
    }
  }

  static Future<String> addProfile(ProfileModel profile) async {
    final newProfile = FirebaseFirestore.instance.collection('profiles').doc();

    await newProfile.set({
      "user": MyAuth.auth.currentUser.uid,
      "createdAt": Timestamp.now(),
      "profile": profile.toJson()
    });

    profiles[newProfile.id] = profile;

    Tools.logger.i("profile added successfully");
    return newProfile.id;
  }

  static Future<void> editProfile(String id, ProfileModel profile) async {
    final updatingProfile = FirebaseFirestore.instance.collection('profiles').doc(id);

    await updatingProfile.update({
      "user": MyAuth.auth.currentUser.uid,
      "createdAt": Timestamp.now(),
      "profile": profile.toJson()
    });

    profiles[updatingProfile.id] = profile;

    Tools.logger.i("profile updated successfully");
  }
  static Future<void> deleteProfile(String id) async {
    await FirebaseFirestore.instance.collection('profiles').doc(id).delete();

    profiles.removeWhere((key, value) => key == id);

    Tools.logger.w("profile deleted: where id = $id");
  }

}