import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:my_bazar/constant.dart';

class Notifications extends StatefulWidget {
  const Notifications({Key? key}) : super(key: key);

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1.0,
        iconTheme: const IconThemeData(color: kTitleColor),
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'Notifications',
          style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
        ),
        actions: [
          PopupMenuButton(
            elevation: 1.0,
            splashRadius: 5.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6.0),
            ),
            padding: EdgeInsets.zero,
            itemBuilder: (BuildContext bc) => [
              PopupMenuItem(
                child: Text(
                  'Mute Notification',
                  style: kTextStyle.copyWith(color: kTitleColor),
                ),
              ),
              PopupMenuItem(
                child: Text(
                  'Clear All',
                  style: kTextStyle.copyWith(color: kTitleColor),
                ),
              ),
            ],
            onSelected: (value) {
              Navigator.pushNamed(context, '$value');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Today',
                style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold, fontSize: 18.0),
              ),
              const SizedBox(height: 10.0),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: 5,
                itemBuilder: (_, i) {
                  return ListTile(
                      visualDensity: const VisualDensity(vertical: -3),
                      contentPadding: EdgeInsets.zero,
                      horizontalTitleGap: 10,
                      leading: const CircleAvatar(
                        radius: 30.0,
                        backgroundImage: NetworkImage("https://assets.iqonic.design/old-themeforest-images/prokit/datingApp/Image.9.jpg"),
                      ),
                      title: Text(
                        'Cameron Williamson',
                        style: kTextStyle.copyWith(color: kTitleColor, fontSize: 18.0),
                        maxLines: 1,
                      ),
                      subtitle: Text(
                        '2 min ago “New Message”',
                        style: kTextStyle.copyWith(color: kGreyTextColor),
                      ),
                      trailing: const Icon(MdiIcons.circleMedium, color: kMainColor, size: 25.0));
                },
              ),
              const SizedBox(height: 20.0),
              Text(
                'Yesterday',
                style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold, fontSize: 18.0),
              ),
              const SizedBox(height: 10.0),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: 5,
                itemBuilder: (_, i) {
                  return ListTile(
                      visualDensity: const VisualDensity(vertical: -3),
                      contentPadding: EdgeInsets.zero,
                      horizontalTitleGap: 10,
                      leading: const CircleAvatar(
                        radius: 30.0,
                        backgroundImage: NetworkImage("https://assets.iqonic.design/old-themeforest-images/prokit/datingApp/Image.9.jpg"),
                      ),
                      title: Text(
                        'Cameron Williamson',
                        style: kTextStyle.copyWith(color: kTitleColor, fontSize: 18.0),
                        maxLines: 1,
                      ),
                      subtitle: Text(
                        '2 min ago “New Message”',
                        style: kTextStyle.copyWith(color: kGreyTextColor),
                      ),
                      trailing: const Icon(MdiIcons.circleMedium, color: kGreyTextColor, size: 25.0));
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
