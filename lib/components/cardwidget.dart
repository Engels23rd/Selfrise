import 'package:flutter/material.dart';
import 'package:flutter_proyecto_final/Colors/colors.dart';
import 'package:flutter_proyecto_final/Design/podcast/podcastcontroller.dart';
import 'package:url_launcher/url_launcher.dart';

class CardWidget extends StatefulWidget {
  final cardsdata podcast;

  const CardWidget({Key? key, required this.podcast}) : super(key: key);

  @override
  CardWidgetState createState() => CardWidgetState();
}

class CardWidgetState extends State<CardWidget> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    Future<void>? _launched;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.drawer,
        border: Border.all(color: AppColors.drawer),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              padding: EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
              child: Text(
                widget.podcast.name,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.white),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            margin: EdgeInsets.only(top: 10, left: 15, right: 15),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: FadeInImage(
                placeholder: AssetImage("assets/podcast/loading.gif"),
                image: AssetImage(widget.podcast.image),
                fit: BoxFit.fill,
              ),
            ),
          ),
          Center(
            child: Container(
              margin: EdgeInsets.only(top: 15),
              child: Text(
                widget.podcast.autor,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                    fontSize: 20),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            padding: EdgeInsets.only(left: 15, right: 15),
            child: _isExpanded
                ? Text(
                    widget.podcast.description,
                    style: TextStyle(color: AppColors.white, fontSize: 15),
                  )
                : Text(
                    widget.podcast.description.substring(0, 100) + '...',
                    style: TextStyle(color: AppColors.white, fontSize: 15),
                  ),
          ),
          if (widget.podcast.description.length > 100)
            Center(
              child: Container(
                margin: EdgeInsets.only(top: 5),
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      _isExpanded = !_isExpanded;
                    });
                  },
                  child: Text(
                    _isExpanded ? 'Ver menos' : 'Ver más',
                    style: TextStyle(
                        color: AppColors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 17),
                  ),
                ),
              ),
            ),
          Container(
            margin: EdgeInsets.only(top: 10, left: 225),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.textColor,
                  shadowColor: AppColors.darkGray),
              onPressed: () {
                _launched = _launchInBrowser(widget.podcast.link);
              },
              child: Text(
                'Ver aquí',
                style: TextStyle(
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 17),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _launchInBrowser(String url) async {
    Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $uri');
    }
  }
}
