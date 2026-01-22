import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

class Followunfollow extends StatefulWidget {
  const Followunfollow({super.key});

  @override
  State<Followunfollow> createState() => _FollowunfollowState();
}

class _FollowunfollowState extends State<Followunfollow> {

  bool isFollowing = false;
  bool isAccountLock = false;

  // handle following
  void _handleFollow() {
    if ( isAccountLock ) {
      // show modalsheet
      _showLockAccountModal();
    } else {
      // follow direct user
      setState(() {
        isFollowing = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('You are following this account'))
      );
    }
  }

  // handle unfollowing
  void _handleUnFollow() {
    // show the modal for unfollowing
    _showUnFollowModal();
  }

  // implementation for show modal for lock accounts
  void _showLockAccountModal() {
    showModalBottomSheet(
      context: context, 
      builder: (context) {
        return Container(
          width: double.infinity,
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Text('This Account is Locked'), 
              const SizedBox(height: 16,), 
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  // Handle send message logic
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Message Sent to this Account'))
                  );
                }, 
                child: Text('Send Message'), 
              ),
              const SizedBox(height: 10,), 
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  // Handle request follow logic
                }, 
                child: Text('Request to Follow'),
              ),
            ],
          ),
        );
      }
    );
  }

  // implementation for unfollow account modal
  void _showUnFollowModal() {
    showModalBottomSheet(
      context: context, 
      builder: (context) {
        return Container(
          width: double.infinity,
          padding: EdgeInsets.only(bottom: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 16,), 
              ListTile(
                onTap: () {
                  Navigator.pop(context);
                  // handle the unfollow action
                  setState(() {
                    isFollowing = false;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('You Unfollow this Account'), 
                      action: SnackBarAction(
                        label: 'Undo', 
                        onPressed: () {
                          // handle the unfollow action
                          setState(() {
                            isFollowing = true;
                          });
                        }
                      ),
                    ),
                  );
                },
                leading: Icon(FontAwesome.person_circle_minus_solid),
                title: Text('Unfollow'),
              ),
              const SizedBox(height: 10,),
              ListTile(
                onTap: () {
                  Navigator.pop(context);
                  // handle the unfollow action
                  setState(() {
                    isFollowing = false;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Your are reporting this Account'), 
                      action: SnackBarAction(
                        label: 'Undo', 
                        onPressed: () {
                          
                        }
                      ),
                    ),
                  );
                },
                leading: Icon(Icons.report_gmailerrorred_rounded),
                title: Text('Report Users'),
              ), 
              const SizedBox(height: 10,), 
              ListTile(
                onTap: () {
                  Navigator.pop(context);
                  // handle the unfollow action
                  setState(() {
                    isFollowing = false;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Your are Block this user'), 
                      action: SnackBarAction(
                        label: 'Undo', 
                        onPressed: () {
                          
                        }
                      ),
                    ),
                  );
                },
                leading: Icon(Icons.block),
                title: Text('Block User'),
              ), 
            ],
          ),
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: isFollowing ? _handleUnFollow : _handleFollow,
      child: Text(isFollowing ? 'Following' : 'Follow'),
    );
  }
}