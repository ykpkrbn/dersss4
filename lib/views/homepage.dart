import 'package:dersss4/controllers/football_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    FootballController _footballCtrl = Get.put(FootballController());
    return Scaffold(
      appBar: AppBar(title: Text('Ana Sayfa')),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 70),
            // Arama kutusuna yer bırak
            child: Center(
              child: Obx(
                () =>
                    _footballCtrl.matchDataList.isEmpty
                        ? Center(child: CircularProgressIndicator())
                        : ListView.builder(
                          itemCount: _footballCtrl.matchDataList.length,
                          itemBuilder: (context, index) {
                            final gelenVeri =
                                _footballCtrl.matchDataList[index];
                            Color backgroundColor;
                            switch (gelenVeri.resultType) {
                              case 'win':
                                backgroundColor = Colors.green;
                                break;
                              case 'draw':
                                backgroundColor = Colors.yellow;
                                break;
                              case 'lost':
                                backgroundColor = Colors.red;
                                break;
                              default:
                                backgroundColor = Colors.grey;
                            }
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                height: 60,
                                width: Get.size.width,
                                decoration: BoxDecoration(
                                  color: backgroundColor,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      /// Tarih Kısmı
                                      Text(
                                        gelenVeri.tarih,
                                        style: TextStyle(
                                          color:
                                              backgroundColor == Colors.red
                                                  ? Colors.white
                                                  : Colors.black,
                                        ),
                                      ),
                                      SizedBox(width: 3),

                                      /// Ev Sahibi Logosu
                                      gelenVeri.evSahibiLogo != null
                                          ? CircleAvatar(
                                            radius: 26,
                                            child: Image.network(
                                              gelenVeri.evSahibiLogo ??
                                                  'https://www.sporx.com/_img/lost_v2.png',
                                            ),
                                          )
                                          : Container(),

                                      Expanded(
                                        child: Row(
                                          children: [
                                            /// Ev Sahibi
                                            Expanded(
                                              child: Text(
                                                gelenVeri.evSahibi,
                                                style: TextStyle(
                                                  color:
                                                      backgroundColor ==
                                                              Colors.red
                                                          ? Colors.white
                                                          : Colors.black,
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Column(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      gelenVeri.macSonucuSkor,
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 20,
                                                        color:
                                                            backgroundColor ==
                                                                    Colors.red
                                                                ? Colors.white
                                                                : Colors.black,
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      gelenVeri.ilkYariSkoru,
                                                      style: TextStyle(
                                                        color:
                                                            backgroundColor ==
                                                                    Colors.red
                                                                ? Colors.white
                                                                : Colors.black,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),

                                            Expanded(
                                              child: Text(
                                                gelenVeri.deplasman,
                                                style: TextStyle(
                                                  color:
                                                      backgroundColor ==
                                                              Colors.red
                                                          ? Colors.white
                                                          : Colors.black,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      gelenVeri.deplasmanLogo != null
                                          ? CircleAvatar(
                                            radius: 26,
                                            child: Image.network(
                                              gelenVeri.deplasmanLogo ??
                                                  'https://www.sporx.com/_img/lost_v2.png',
                                            ),
                                          )
                                          : Container(),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
              ),
            ),
          ),
          Positioned(
            bottom: 120,
            left: 16,
            right: 16,
            child: TextFormField(
              controller: _footballCtrl.aramaCtrl,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  onPressed: () {
                    // Boşluk ile metni kelimelere ayır
                    List<String> words = _footballCtrl.aramaCtrl.text.trim().split(
                      ' ',
                    );

                    // Kelimeleri aralarına "-" ekleyerek birleştir
                    String word =
                        '${words.sublist(0, words.length - 1).join('-')}${words.last}';

                    String textt =
                        word
                            .replaceAll('ş', 's')
                            .replaceAll('ı', 'i')
                            .replaceAll('ç', 'c')
                            .replaceAll('ö', 'o')
                            .replaceAll('ğ', 'g')
                            .replaceAll('ü', 'u')
                            .toLowerCase()
                            .trim();
                    _footballCtrl.verileriGetir(textt);
                    _footballCtrl.aramaCtrl.clear();
                  },
                  icon: Icon(Icons.search),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                hintText: 'Takım Adı Ara',
                fillColor: Colors.white,
                filled: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
