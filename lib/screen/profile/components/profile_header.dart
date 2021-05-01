import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hotelapp/common/styles/styles.dart';
import 'package:flutter_hotelapp/common/utils/image_utils.dart';

class ProfileHeader extends StatelessWidget {
  final String name, email;
  final ImageProvider image;
  final Function press;
  final bool logged;

  const ProfileHeader({
    Key key,
    @required this.logged,
    @required this.name,
    @required this.email,
    @required this.image,
    this.press,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 310,
      child: Stack(
        children: [
          ClipPath(
            clipper: HeaderClipper(),
            child: Container(
              height: 220,
              color: Colors.blueGrey,
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: press ?? () {},
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 15.0),
                    height: 128.0,
                    width: 128.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 4.0, // border thickness
                      ),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: image ??
                            ImageUtils.getAssetImage('no_picture_avatar'),
                      ),
                    ),
                  ),
                ),
                Text(name ?? AppLocalizations.of(context).pressAvatarToLogin,
                    style: kBodyTextStyle),
                SizedBox(height: 10),
                Text(
                  email,
                  style: kSecondaryBodyTextStyle,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// custom header shape
/// ClipPath 能夠使用 clipper 切割 child
class HeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();

    double height = size.height;
    double width = size.width;

    path.lineTo(0, size.height - 20);

    var firstControlPoint = Offset(width / 4, height);
    var firstEndPoint = Offset(width / 2.25, height - 30);

    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    var secondControlPoint = Offset(width / 4 * 3, height - 80);
    var secondEndPoint = Offset(width, height - 40);

    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(size.width, size.height - 40);
    path.lineTo(size.width, 0);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
