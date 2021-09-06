import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String msg;
  final String username;
  final String userImage;
  final bool isMe;
  final Key key;

  MessageBubble({
    this.msg,
    this.isMe,
    this.username,
    this.userImage,
    this.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Row(
          mainAxisAlignment:
              isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: isMe ? Theme.of(context).accentColor : Colors.grey[300],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                  bottomLeft: !isMe ? Radius.circular(0) : Radius.circular(12),
                  bottomRight: !isMe ? Radius.circular(12) : Radius.circular(0),
                ),
              ),
              width: 140,
              padding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10,
              ),
              margin: EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 16,
              ),
              child: Column(
                crossAxisAlignment:
                    isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Text(
                    username,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isMe
                          ? Theme.of(context).accentTextTheme.headline6.color
                          : Colors.black,
                    ),
                  ),
                  Text(
                    msg,
                    style: TextStyle(
                      color: isMe
                          ? Theme.of(context).accentTextTheme.headline6.color
                          : Colors.black,
                    ),
                    textAlign: isMe ? TextAlign.end : TextAlign.start,
                  ),
                ],
              ),
            ),
          ],
        ),
        Positioned(
          child: CircleAvatar(
            backgroundImage: NetworkImage(userImage),
          ),
          left: isMe ? null : 120,
          right: isMe ? 120 : null,
        ),
      ],
      overflow: Overflow.visible,
    );
  }
}
