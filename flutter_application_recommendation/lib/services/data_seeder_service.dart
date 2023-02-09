import 'package:cloud_firestore/cloud_firestore.dart';

class DataSeederService {
  static CollectionReference kategoriWarnaCollection =
      FirebaseFirestore.instance.collection('kategori_warna');

  static createKategoriWarna() {
    kategoriWarnaCollection.doc("1").set({'nama_kategori': "mauve"});
    kategoriWarnaCollection.doc("2").set({'nama_kategori': "dark mauve"});
    kategoriWarnaCollection.doc("3").set({'nama_kategori': "pink"});
    kategoriWarnaCollection.doc("4").set({'nama_kategori': "pale pink"});
    kategoriWarnaCollection.doc("5").set({'nama_kategori': "peachy pink"});
    kategoriWarnaCollection.doc("6").set({'nama_kategori': "rosy pink"});
    kategoriWarnaCollection.doc("7").set({'nama_kategori': "warm pink"});
    kategoriWarnaCollection.doc("8").set({'nama_kategori': "beige"});
    kategoriWarnaCollection.doc("9").set({'nama_kategori': "rosy beige"});
    kategoriWarnaCollection.doc("10").set({'nama_kategori': "nude beige"});
    kategoriWarnaCollection.doc("11").set({'nama_kategori': "light coral"});
    kategoriWarnaCollection.doc("12").set({'nama_kategori': "peachy nude"});
    kategoriWarnaCollection.doc("13").set({'nama_kategori': "blue red"});
    kategoriWarnaCollection.doc("14").set({'nama_kategori': "orange red"});
    kategoriWarnaCollection.doc("15").set({'nama_kategori': "orange"});
    kategoriWarnaCollection.doc("16").set({'nama_kategori': "wine red"});
    kategoriWarnaCollection.doc("17").set({'nama_kategori': "plum"});
    kategoriWarnaCollection.doc("18").set({'nama_kategori': "deep plum"});
    kategoriWarnaCollection.doc("19").set({'nama_kategori': "terracotta"});
    kategoriWarnaCollection.doc("20").set({'nama_kategori': "brown"});
    kategoriWarnaCollection.doc("21").set({'nama_kategori': "nude brown"});
    kategoriWarnaCollection.doc("22").set({'nama_kategori': "dark chocolate"});
    kategoriWarnaCollection.doc("23").set({'nama_kategori': "fuschia"});
    kategoriWarnaCollection.doc("24").set({'nama_kategori': "purple"});
    kategoriWarnaCollection.doc("25").set({'nama_kategori': "warm nude"});
  }

  static CollectionReference listLipstik =
      FirebaseFirestore.instance.collection('list_lipstik');

  static createListLipstik() {
    DocumentReference ref1 =
        FirebaseFirestore.instance.collection('kategori_warna').doc('1');
    DocumentReference ref2 =
        FirebaseFirestore.instance.collection('kategori_warna').doc('2');
    DocumentReference ref3 =
        FirebaseFirestore.instance.collection('kategori_warna').doc('3');
    DocumentReference ref4 =
        FirebaseFirestore.instance.collection('kategori_warna').doc('4');
    DocumentReference ref5 =
        FirebaseFirestore.instance.collection('kategori_warna').doc('5');
    DocumentReference ref6 =
        FirebaseFirestore.instance.collection('kategori_warna').doc('6');
    DocumentReference ref7 =
        FirebaseFirestore.instance.collection('kategori_warna').doc('7');
    DocumentReference ref8 =
        FirebaseFirestore.instance.collection('kategori_warna').doc('8');
    DocumentReference ref9 =
        FirebaseFirestore.instance.collection('kategori_warna').doc('9');
    DocumentReference ref10 =
        FirebaseFirestore.instance.collection('kategori_warna').doc('10');
    DocumentReference ref11 =
        FirebaseFirestore.instance.collection('kategori_warna').doc('11');
    DocumentReference ref12 =
        FirebaseFirestore.instance.collection('kategori_warna').doc('12');
    DocumentReference ref13 =
        FirebaseFirestore.instance.collection('kategori_warna').doc('13');
    DocumentReference ref14 =
        FirebaseFirestore.instance.collection('kategori_warna').doc('14');
    DocumentReference ref15 =
        FirebaseFirestore.instance.collection('kategori_warna').doc('15');
    DocumentReference ref16 =
        FirebaseFirestore.instance.collection('kategori_warna').doc('16');
    DocumentReference ref17 =
        FirebaseFirestore.instance.collection('kategori_warna').doc('17');
    DocumentReference ref18 =
        FirebaseFirestore.instance.collection('kategori_warna').doc('18');
    DocumentReference ref19 =
        FirebaseFirestore.instance.collection('kategori_warna').doc('19');
    DocumentReference ref20 =
        FirebaseFirestore.instance.collection('kategori_warna').doc('20');
    DocumentReference ref21 =
        FirebaseFirestore.instance.collection('kategori_warna').doc('21');
    DocumentReference ref22 =
        FirebaseFirestore.instance.collection('kategori_warna').doc('22');
    DocumentReference ref23 =
        FirebaseFirestore.instance.collection('kategori_warna').doc('23');
    DocumentReference ref24 =
        FirebaseFirestore.instance.collection('kategori_warna').doc('24');
    DocumentReference ref25 =
        FirebaseFirestore.instance.collection('kategori_warna').doc('25');

    listLipstik.doc("1").set({
      'kategori': ref25,
      'nama_lipstik': "Clay Crush",
      'kode_warna': "C77362",
    });
    listLipstik.doc("2").set({
      'kategori': ref18,
      'nama_lipstik': "MPK 23",
      'kode_warna': "7E2343",
    });
    listLipstik.doc("3").set({
      'kategori': ref1,
      'nama_lipstik': "Blushing Pout",
      'kode_warna': "C87192",
    });
    listLipstik.doc("4").set({
      'kategori': ref16,
      'nama_lipstik': "Burgundy Blush",
      'kode_warna': "7D4448",
    });
    listLipstik.doc("5").set({
      'kategori': ref19,
      'nama_lipstik': "Chili Nude",
      'kode_warna': "C34C36",
    });
    listLipstik.doc("6").set({
      'kategori': ref15,
      'nama_lipstik': "Craving Coral",
      'kode_warna': "F85025",
    });
    listLipstik.doc("7").set({
      'kategori': ref5,
      'nama_lipstik': "Daringly Nude",
      'kode_warna': "D68572",
    });
    listLipstik.doc("8").set({
      'kategori': ref16,
      'nama_lipstik': "Divine Wine",
      'kode_warna': "863741",
    });
    listLipstik.doc("9").set({
      'kategori': ref2,
      'nama_lipstik': "Lust for Blush",
      'kode_warna': "B76384",
    });
    listLipstik.doc("10").set({
      'kategori': ref3,
      'nama_lipstik': "Mesmerizing Magenta",
      'kode_warna': "E0478D",
    });
    listLipstik.doc("11").set({
      'kategori': ref12,
      'nama_lipstik': "Nude Embrace",
      'kode_warna': "C78265",
    });
    listLipstik.doc("12").set({
      'kategori': ref21,
      'nama_lipstik': "Nude Nuance",
      'kode_warna': "B76557",
    });
    listLipstik.doc("13").set({
      'kategori': ref13,
      'nama_lipstik': "Rich Ruby",
      'kode_warna': "BE2734",
    });
    listLipstik.doc("14").set({
      'kategori': ref14,
      'nama_lipstik': "Siren Scarlet",
      'kode_warna': "E00809",
    });
    listLipstik.doc("15").set({
      'kategori': ref21,
      'nama_lipstik': "Touch of Spice",
      'kode_warna': "B46366",
    });
    listLipstik.doc("16").set({
      'kategori': ref24,
      'nama_lipstik': "Vibrant Violet",
      'kode_warna': "842C8D",
    });
    listLipstik.doc("17").set({
      'kategori': ref16,
      'nama_lipstik': "Code Red",
      'kode_warna': "741321",
    });
    listLipstik.doc("18").set({
      'kategori': ref5,
      'nama_lipstik': "Just A Teaser",
      'kode_warna': "DA806A",
    });
    listLipstik.doc("19").set({
      'kategori': ref18,
      'nama_lipstik': "Pretty Please",
      'kode_warna': "712632",
    });
    listLipstik.doc("20").set({
      'kategori': ref21,
      'nama_lipstik': "Smitten",
      'kode_warna': "B06370",
    });
    listLipstik.doc("21").set({
      'kategori': ref7,
      'nama_lipstik': "MPK09",
      'kode_warna': "c15459",
    });
    listLipstik.doc("22").set({
      'kategori': ref19,
      'nama_lipstik': "MOR05",
      'kode_warna': "d04145",
    });
    listLipstik.doc("23").set({
      'kategori': ref3,
      'nama_lipstik': "MPK10",
      'kode_warna': "d7566c",
    });
    listLipstik.doc("24").set({
      'kategori': ref19,
      'nama_lipstik': "MRD05",
      'kode_warna': "b23e3f",
    });
    listLipstik.doc("25").set({
      'kategori': ref3,
      'nama_lipstik': "MPK12",
      'kode_warna': "da5e82",
    });
    listLipstik.doc("26").set({
      'kategori': ref17,
      'nama_lipstik': "MPK11",
      'kode_warna': "93234b",
    });
    listLipstik.doc("27").set({
      'kategori': ref13,
      'nama_lipstik': "MRD04",
      'kode_warna': "C91B23",
    });
    listLipstik.doc("28").set({
      'kategori': ref23,
      'nama_lipstik': "MPK06",
      'kode_warna': "B21066",
    });
    listLipstik.doc("29").set({
      'kategori': ref13,
      'nama_lipstik': "MOR03",
      'kode_warna': "CC2B23",
    });
    listLipstik.doc("30").set({
      'kategori': ref8,
      'nama_lipstik': "MNU02",
      'kode_warna': "EAA794",
    });
    listLipstik.doc("31").set({
      'kategori': ref11,
      'nama_lipstik': "MNU03",
      'kode_warna': "FF9A7A",
    });
    listLipstik.doc("32").set({
      'kategori': ref6,
      'nama_lipstik': "MPK04",
      'kode_warna': "C66583",
    });
    listLipstik.doc("33").set({
      'kategori': ref4,
      'nama_lipstik': "MNU04",
      'kode_warna': "DE8797",
    });
  }
}
