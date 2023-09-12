import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hovering/hovering.dart';

class PilihanKelasButton extends StatelessWidget {
  String kelas;
  String asrama;
  List pilihanKelas;
  String nama;
  double spaceForButtons = 16;
  Function buatKelas;

  PilihanKelasButton(
      this.kelas, this.pilihanKelas, this.buatKelas, this.asrama, this.nama);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ElevatedButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Dialog(
                      child: Container(
                        height: 250,
                        width: 400,
                        padding: EdgeInsets.all(16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              height: 50,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Center(
                                    child: Text(
                                      '$kelas',
                                      style: GoogleFonts.poppins(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: 125,
                              decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(12)),
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: pilihanKelas.length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () {
                                        //generate random 6 digit number
                                        var rng = new Random();
                                        var code = rng.nextInt(900000) + 100000;
                                        print(
                                            'pressed ${pilihanKelas[index] + ' ' + kelas + ' ' + code.toString()}');
                                        buatKelas('$kelas', code.toString(),
                                            '${pilihanKelas[index]}', asrama);
                                      },
                                      child: HoverAnimatedContainer(
                                          cursor: SystemMouseCursors.click,
                                          margin: EdgeInsets.all(8),
                                          // color: Colors.white,
                                          // hoverColor: Colors.grey[200],
                                          decoration: BoxDecoration(
                                              color: Colors.pink[100],
                                              borderRadius:
                                                  BorderRadius.circular(12)),
                                          hoverDecoration: BoxDecoration(
                                              //drop shadow
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey,
                                                  offset: Offset(1.0, 1.0),
                                                  blurRadius: 6.0,
                                                ),
                                              ],
                                              color: Colors.pink[50],
                                              borderRadius:
                                                  BorderRadius.circular(12)),
                                          //add curve corners

                                          width: 100,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Image(
                                                image: AssetImage(
                                                    'assets/ic_${pilihanKelas[index].toString().toLowerCase()}.png'),
                                                width: 50,
                                                height: 50,
                                              ),
                                              SizedBox(
                                                height: 8,
                                              ),
                                              Text(
                                                pilihanKelas[index].toString(),
                                                style: GoogleFonts.poppins(
                                                    color: Colors.black54,
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          )),
                                    );
                                  }),
                            )
                          ],
                        ),
                      ),
                    );
                  });
            },
            child: Text(kelas)),
        SizedBox(
          width: spaceForButtons,
        ),
      ],
    );
  }
}
