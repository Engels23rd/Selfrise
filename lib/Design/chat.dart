import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../services/AuthService.dart';
import '../entity/Chat.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_proyecto_final/components/app_bart.dart';

class PantallaChat extends StatefulWidget {
  PantallaChat({Key? key}) : super(key: key);

  @override
  _PantallaChatState createState() => _PantallaChatState();
}

class _PantallaChatState extends State<PantallaChat> {
  final String? currentUser = AuthService.getUserId();
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  void scrollToBottom() {
    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
  }

  Future<void> sendMessage(String message) async {
    final chat = Chat(
      senderId: currentUser ?? 'Cargando nombre...',
      content: message,
      timestamp: DateTime.now(),
    );

    await FirebaseFirestore.instance.collection('chat').add(chat.toMap());

    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0),
        child: Container(
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          decoration: BoxDecoration(
            color: Color(0xFF2773B9),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20.0),
              bottomRight: Radius.circular(20.0),
            ),
          ),
          child: Center(
            child: CustomAppBar(titleText: "Chat"),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('chat')
                  .orderBy('timestamp', descending: false)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: SpinKitFadingCircle(
                      color: Colors.blueGrey,
                      size: 50.0,
                    ),
                  );
                }

                final chats = snapshot.data?.docs
                        .map((doc) => Chat.fromMap(
                            doc.data() as Map<String, dynamic>,
                            doc.id)) // Pasar el ID del documento
                        .toList() ??
                    [];

                WidgetsBinding.instance.addPostFrameCallback((_) {
                  scrollToBottom();
                });

                return ListView.builder(
                  controller: _scrollController,
                  itemCount: chats.length,
                  itemBuilder: (BuildContext context, int index) {
                    final chat = chats[index];
                    final isMe = chat.senderId == currentUser;
                    return FutureBuilder<Map<String, dynamic>?>(
                      future: AuthService.getUserData(chat.senderId),
                      builder: (context,
                          AsyncSnapshot<Map<String, dynamic>?>
                              userDataSnapshot) {
                        final senderName = isMe
                            ? 'Yo'
                            : userDataSnapshot.data?['name'] ??
                                'Cargando usuario...';

                        return _buildMessage(
                          context: context,
                          isMe: isMe,
                          message: chat.content,
                          senderName: senderName,
                          userPhotoUrl: userDataSnapshot.data?['imageLink'],
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
          KeyboardVisibilityBuilder(
            builder: (context, isKeyboardVisible) {
              return _buildInputField(isKeyboardVisible);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMessage({
    required BuildContext context,
    required bool isMe,
    required String message,
    required String senderName,
    required String? userPhotoUrl,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isMe)
            CircleAvatar(
              backgroundImage: userPhotoUrl != null
                  ? CachedNetworkImageProvider(userPhotoUrl)
                  : AssetImage('assets/imagenes/default_image.png')
                      as ImageProvider<Object>,
              radius: 20.0,
            ),
          SizedBox(width: isMe ? 8.0 : 0),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    senderName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 4.0),
                Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.7,
                  ),
                  padding: EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: isMe ? Color(0xFF2773B9) : Colors.grey[300],
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Text(
                    message,
                    style: TextStyle(
                      color: isMe ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (isMe)
            CircleAvatar(
              backgroundImage: userPhotoUrl != null
                  ? CachedNetworkImageProvider(userPhotoUrl)
                  : AssetImage('assets/imagenes/default_image.png')
                      as ImageProvider<Object>,
              radius: 20.0,
            ),
          SizedBox(width: !isMe ? 8.0 : 0),
        ],
      ),
    );
  }

  Widget _buildInputField(bool isKeyboardVisible) {
    TextEditingController messageController = TextEditingController();

    return Container(
      margin: EdgeInsets.only(bottom: 70, left: 10, right: 10, top: 10),
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
            50), // Ajusta el radio para hacerlo más redondeado
        color:
            Colors.grey[200], // Cambia el color de fondo del campo de entrada
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: messageController,
              decoration: InputDecoration(
                hintText: 'Escribe tu mensaje...',
                border: InputBorder.none, // Quita el borde del TextField
                contentPadding: EdgeInsets.symmetric(horizontal: 20),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                  50), // Ajusta el radio para hacerlo más redondeado
              color: Color(0xFF2773B9), // Cambia el color de fondo del botón
            ),
            child: IconButton(
              icon: Icon(Icons.send),
              onPressed: () {
                String message = messageController.text;
                if (message.isNotEmpty) {
                  sendMessage(message);
                  messageController.clear();
                }
              },
              color: Colors.white, // Cambia el color del icono del botón
            ),
          ),
        ],
      ),
    );
  }
}
