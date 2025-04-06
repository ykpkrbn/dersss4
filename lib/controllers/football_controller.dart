import 'package:charset_converter/charset_converter.dart';
import 'package:dersss4/models/football_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html;

class FootballController extends GetxController {

  RxList<FootballModel> matchDataList = <FootballModel>[].obs;

  TextEditingController aramaCtrl = TextEditingController();


  @override
  void onInit() {
    verileriGetir('fenerbahce');
    super.onInit();
  }

  Future<void> verileriGetir(String takim) async {
    matchDataList.clear();
    String url = 'https://www.sporx.com/$takim-fiksturu-ve-mac-sonuclari';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      // Karakter kodlamasını windows-1254 olarak dönüştürme
      var content = await CharsetConverter.decode(
        "windows-1254",
        response.bodyBytes,
      );

      final document = html.parse(content);



      final trrr = document.getElementsByTagName('tr');



      for (var td in trrr) {
        final cells = td.getElementsByTagName('td');

        if (cells.length >= 3) {
          /// Tarih kısmını alıyor.
          String tarih = cells[0].text.trim();

          /// Burada Hangi Lig Maçı yaptığını çekiyoruz
          String oynadigiLig = cells[1].text.trim();

          /// Burda  Seçtiğimiz takımın kazanması, beraberliği,
          /// mağlubiyeti veya maçın oynanmadığını çekiyoruz
          final _imageElement =
              cells[2].getElementsByTagName('img').isNotEmpty
                  ? cells[2].getElementsByTagName('img')[0]
                  : null;

          final winImage =
              _imageElement != null ? _imageElement.attributes['src'] : null;

          // Resim URL'sindeki belirteci ayıklayarak sonucu belirleme
          String resultType;

          if (winImage != null) {
            if (winImage.contains('win')) {
              resultType = 'win';
            } else if (winImage.contains('draw')) {
              resultType = 'draw';
            } else if (winImage.contains('lost')) {
              resultType = 'lost';
            } else {
              resultType = 'unknown';
            }
          } else {
            resultType = 'unknown';
          }


          /// Burda Ev Sahibi Takımın Logosunu çekiyoruz
          final _evSahibiLogoss =
              cells[3].getElementsByTagName('img').isNotEmpty
                  ? cells[3].getElementsByTagName('img')[0]
                  : null;

          final evSahibiLogo =
              _evSahibiLogoss != null
                  ? _evSahibiLogoss.attributes['src']
                  : null;

          /// Ev Sahibi takımın Adı
          final String evSahibi = cells[4].text.trim();

          /// Oynanan Maçın Skoru
          final String macSonucuSkor = cells[5].text.trim();

          /// Deplasman Takımının Adı
          final String deplasman = cells[6].text.trim();

          /// Deplasman Takımının Logosunu çekiyoruz
          final _deplasmanLogos =
              cells[7].getElementsByTagName('img').isNotEmpty
                  ? cells[7].getElementsByTagName('img')[0]
                  : null;

          final deplasmanLogo =
              _deplasmanLogos != null
                  ? _deplasmanLogos.attributes['src']
                  : null;

          /// İlk Yarı Skoru
          final String ilkYariSkoru = cells[8].text.trim();

          final modelim = FootballModel(
            tarih: tarih,
            oynananLig: oynadigiLig,
            resultType: resultType,
            evSahibiLogo: evSahibiLogo,
            evSahibi: evSahibi,
            macSonucuSkor: macSonucuSkor,
            deplasman: deplasman,
            deplasmanLogo: deplasmanLogo,
            ilkYariSkoru: ilkYariSkoru,
          );
          matchDataList.add(modelim);
          print('Gelen Link ${modelim.deplasman}');
        }
      }
    } else {
      throw Exception('Veri çekme işlemi başarısız oldu');
    }
  }
}
