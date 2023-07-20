import 'package:flutter/material.dart';
import 'package:hapis/constants.dart';

class RequestComponent extends StatelessWidget {
  final bool isSent;
  final bool isMatching;
  final bool isDonation;
  const RequestComponent({
    super.key,
    required this.isSent,
    required this.isMatching,
    required this.isDonation,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.3,
      height: MediaQuery.of(context).size.height * 0.2,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        //  color: HapisColors.primary,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const CircleAvatar(
                backgroundImage: AssetImage('assets/images/donorpin.png'),
                radius: 30,
              ),
              SizedBox(width: MediaQuery.of(context).size.width * 0.05),
              Expanded(
                child: isSent
                    ? RichText(
                        text: const TextSpan(
                          style: TextStyle(fontSize: 18, color: Colors.black),
                          children: [
                            TextSpan(
                              text: 'Request sent to ',
                            ),
                            TextSpan(
                              text: 'Person Name',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      )
                    : isMatching
                        ? RichText(
                            text: const TextSpan(
                              style:
                                  TextStyle(fontSize: 18, color: Colors.black),
                              children: [
                                TextSpan(
                                  text: 'Person Name',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                TextSpan(
                                    text:
                                        ' is a good match for your needs. Want to Contact him? '),
                              ],
                            ),
                          )
                        : isDonation
                            ? RichText(
                                text: const TextSpan(
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.black),
                                  children: [
                                    TextSpan(text: 'You and  '),
                                    TextSpan(
                                      text: 'Person Name ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    TextSpan(
                                      text: 'are now in contact',
                                    ),
                                  ],
                                ),
                              )
                            : RichText(
                                text: const TextSpan(
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.black),
                                  children: [
                                    TextSpan(
                                      text: 'Person Name',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    TextSpan(
                                        text:
                                            ' requested to contact you about your offered/need for '),
                                    TextSpan(
                                      text: 'item',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
              ),
            ],
          ),
          isSent
              ? Align(
                  alignment: Alignment.bottomRight,
                  child: ElevatedButton(
                    onPressed: () {
                      // Handle button click here
                    },
                    child: Text('PENDING'),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          HapisColors.lgColor1), // Button background color
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                          EdgeInsets.all(15)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(5), // Button border radius
                          // You can also set other properties like borderColor, borderWidth, etc. here
                        ),
                      ),
                    ),
                  ),
                )
              : isMatching
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            // Handle button click here
                          },
                          child: Text('REQUEST'),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                HapisColors
                                    .lgColor4), // Button background color
                            padding:
                                MaterialStateProperty.all<EdgeInsetsGeometry>(
                                    EdgeInsets.all(15)),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    5), // Button border radius
                                // You can also set other properties like borderColor, borderWidth, etc. here
                              ),
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            // Handle button click here
                          },
                          child: Text('IGNORE'),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                HapisColors
                                    .lgColor2), // Button background color
                            padding:
                                MaterialStateProperty.all<EdgeInsetsGeometry>(
                                    EdgeInsets.all(15)),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    5), // Button border radius
                                // You can also set other properties like borderColor, borderWidth, etc. here
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : isDonation
                      ? Align(
                          alignment: Alignment.center,
                          child: ElevatedButton(
                            onPressed: () {
                              // Handle button click here
                            },
                            child: Text('FINISH PROCESS'),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  HapisColors
                                      .lgColor4), // Button background color
                              padding:
                                  MaterialStateProperty.all<EdgeInsetsGeometry>(
                                      EdgeInsets.all(15)),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      5), // Button border radius
                                  // You can also set other properties like borderColor, borderWidth, etc. here
                                ),
                              ),
                            ),
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                // Handle button click here
                              },
                              child: Text('ACCEPT'),
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(HapisColors
                                        .lgColor4), // Button background color
                                padding: MaterialStateProperty.all<
                                    EdgeInsetsGeometry>(EdgeInsets.all(15)),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        5), // Button border radius
                                    // You can also set other properties like borderColor, borderWidth, etc. here
                                  ),
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                // Handle button click here
                              },
                              child: Text('DECLINE'),
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(HapisColors
                                        .lgColor2), // Button background color
                                padding: MaterialStateProperty.all<
                                    EdgeInsetsGeometry>(EdgeInsets.all(15)),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        5), // Button border radius
                                    // You can also set other properties like borderColor, borderWidth, etc. here
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
        ],
      ),

      //Text('Item $index'),
    );
  }
}
