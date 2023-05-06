import 'package:cloud_firestore/cloud_firestore.dart';

class DataSeederServiceOld {
  static CollectionReference listLipstik =
      FirebaseFirestore.instance.collection('list_lipstik');

  static createListLipstik() {
    listLipstik.doc("1").set({
      'kategori': "warm nude",
      'nama_lipstik': "Clay Crush",
      'kode_warna': "C77362",
    });
    listLipstik.doc("2").set({
      'kategori': "deep plum",
      'nama_lipstik': "MPK 23",
      'kode_warna': "7E2343",
    });
    listLipstik.doc("3").set({
      'kategori': "mauve",
      'nama_lipstik': "Blushing Pout",
      'kode_warna': "C87192",
    });
    listLipstik.doc("4").set({
      'kategori': "wine red",
      'nama_lipstik': "Burgundy Blush",
      'kode_warna': "7D4448",
    });
    listLipstik.doc("5").set({
      'kategori': "terracotta",
      'nama_lipstik': "Chili Nude",
      'kode_warna': "C34C36",
    });
    listLipstik.doc("6").set({
      'kategori': "orange",
      'nama_lipstik': "Craving Coral",
      'kode_warna': "F85025",
    });
    listLipstik.doc("7").set({
      'kategori': "peachy pink",
      'nama_lipstik': "Daringly Nude",
      'kode_warna': "D68572",
    });
    listLipstik.doc("8").set({
      'kategori': "wine red",
      'nama_lipstik': "Divine Wine",
      'kode_warna': "863741",
    });
    listLipstik.doc("9").set({
      'kategori': "dark mauve",
      'nama_lipstik': "Lust for Blush",
      'kode_warna': "B76384",
    });
    listLipstik.doc("10").set({
      'kategori': "pink",
      'nama_lipstik': "Mesmerizing Magenta",
      'kode_warna': "E0478D",
    });
    listLipstik.doc("11").set({
      'kategori': "peachy nude",
      'nama_lipstik': "Nude Embrace",
      'kode_warna': "C78265",
    });
    listLipstik.doc("12").set({
      'kategori': "nude brown",
      'nama_lipstik': "Nude Nuance",
      'kode_warna': "B76557",
    });
    listLipstik.doc("13").set({
      'kategori': "blue-red",
      'nama_lipstik': "Rich Ruby",
      'kode_warna': "BE2734",
    });
    listLipstik.doc("14").set({
      'kategori': "orange-red",
      'nama_lipstik': "Siren Scarlet",
      'kode_warna': "E00809",
    });
    listLipstik.doc("15").set({
      'kategori': "nude brown",
      'nama_lipstik': "Touch of Spice",
      'kode_warna': "B46366",
    });
    listLipstik.doc("16").set({
      'kategori': "purple",
      'nama_lipstik': "Vibrant Violet",
      'kode_warna': "842C8D",
    });
    listLipstik.doc("17").set({
      'kategori': "wine red",
      'nama_lipstik': "Code Red",
      'kode_warna': "741321",
    });
    listLipstik.doc("18").set({
      'kategori': "peachy pink",
      'nama_lipstik': "Just A Teaser",
      'kode_warna': "DA806A",
    });
    listLipstik.doc("19").set({
      'kategori': "deep plum",
      'nama_lipstik': "Pretty Please",
      'kode_warna': "712632",
    });
    listLipstik.doc("20").set({
      'kategori': "nude brown",
      'nama_lipstik': "Smitten",
      'kode_warna': "B06370",
    });
    listLipstik.doc("21").set({
      'kategori': "warm pink",
      'nama_lipstik': "MPK09",
      'kode_warna': "c15459",
    });
    listLipstik.doc("22").set({
      'kategori': "terracotta",
      'nama_lipstik': "MOR05",
      'kode_warna': "d04145",
    });
    listLipstik.doc("23").set({
      'kategori': "pink",
      'nama_lipstik': "MPK10",
      'kode_warna': "d7566c",
    });
    listLipstik.doc("24").set({
      'kategori': "terracotta",
      'nama_lipstik': "MRD05",
      'kode_warna': "b23e3f",
    });
    listLipstik.doc("25").set({
      'kategori': "pink",
      'nama_lipstik': "MPK12",
      'kode_warna': "da5e82",
    });
    listLipstik.doc("26").set({
      'kategori': "plum",
      'nama_lipstik': "MPK11",
      'kode_warna': "93234b",
    });
    listLipstik.doc("27").set({
      'kategori': "blue-red",
      'nama_lipstik': "MRD04",
      'kode_warna': "C91B23",
    });
    listLipstik.doc("28").set({
      'kategori': "fuschia",
      'nama_lipstik': "MPK06",
      'kode_warna': "B21066",
    });
    listLipstik.doc("29").set({
      'kategori': "blue-red",
      'nama_lipstik': "MOR03",
      'kode_warna': "CC2B23",
    });
    listLipstik.doc("30").set({
      'kategori': "beige",
      'nama_lipstik': "MNU02",
      'kode_warna': "EAA794",
    });
    listLipstik.doc("31").set({
      'kategori': "light coral",
      'nama_lipstik': "MNU03",
      'kode_warna': "FF9A7A",
    });
    listLipstik.doc("32").set({
      'kategori': "rosy pink",
      'nama_lipstik': "MPK04",
      'kode_warna': "C66583",
    });
    listLipstik.doc("33").set({
      'kategori': "pale pink",
      'nama_lipstik': "MNU04",
      'kode_warna': "DE8797",
    });
  }

  static CollectionReference dataMapping =
      FirebaseFirestore.instance.collection('data_mapping');

  static createDataMapping() {
    dataMapping.doc("fair_cool").set({
      "skintone": "fair",
      "undetone": "cool",
      "warna": FieldValue.arrayUnion(
          ['mauve', 'pale pink', 'beige', 'pink', 'fuschia', 'purple'])
    });
    dataMapping.doc("fair_warm").set({
      "skintone": "fair",
      "undetone": "warm",
      "warna": FieldValue.arrayUnion(
          ["light coral", "peachy nude", "peachy pink", "warm nude"])
    });
    dataMapping.doc("fair_neutral").set({
      "skintone": "fair",
      "undetone": "neutral",
      "warna": FieldValue.arrayUnion([
        "mauve",
        "pale pink",
        "beige",
        "pink",
        "light coral",
        "peachy nude",
        "peachy pink"
      ])
    });

    dataMapping.doc("light_cool").set({
      "skintone": "light",
      "undetone": "cool",
      "warna":
          FieldValue.arrayUnion(["mauve", "rosy pink", "fuschia", "purple"])
    });
    dataMapping.doc("light_warm").set({
      "skintone": "light",
      "undetone": "warm",
      "warna": FieldValue.arrayUnion(["warm pink", "rosy beige", "warm nude"])
    });
    dataMapping.doc("light_neutral").set({
      "skintone": "light",
      "undetone": "neutral",
      "warna": FieldValue.arrayUnion(
          ["mauve", "rosy pink", "warm pink", "rosy beige"])
    });

    dataMapping.doc("medium_cool").set({
      "skintone": "medium",
      "undetone": "cool",
      "warna":
          FieldValue.arrayUnion(["dark mauve", "blue-red", "fuschia", "purple"])
    });
    dataMapping.doc("medium_warm").set({
      "skintone": "medium",
      "undetone": "warm",
      "warna": FieldValue.arrayUnion(["orange-red", "nude beige", "warm nude"])
    });
    dataMapping.doc("medium_neutral").set({
      "skintone": "medium",
      "undetone": "neutral",
      "warna": FieldValue.arrayUnion(
          ["dark mauve", "blue-red", "orange-red", "nude beige"])
    });

    dataMapping.doc("tan_cool").set({
      "skintone": "tan",
      "undetone": "cool",
      "warna":
          FieldValue.arrayUnion(["plum", "dark mauve", "fuschia", "purple"])
    });
    dataMapping.doc("tan_warm").set({
      "skintone": "tan",
      "undetone": "warm",
      "warna": FieldValue.arrayUnion(["terracotta", "nude brown"])
    });
    dataMapping.doc("tan_neutral").set({
      "skintone": "tan",
      "undetone": "neutral",
      "warna": FieldValue.arrayUnion(
          ["plum", "dark mauve", "terracotta", "nude brown"])
    });

    dataMapping.doc("deep_cool").set({
      "skintone": "deep",
      "undetone": "cool",
      "warna": FieldValue.arrayUnion(
          ["deep plum", "wine red", "dark chocolate", "fuschia", "purple"])
    });
    dataMapping.doc("deep_warm").set({
      "skintone": "deep",
      "undetone": "warm",
      "warna": FieldValue.arrayUnion(["orange", "orange-red", "brown"])
    });
    dataMapping.doc("deep_neutral").set({
      "skintone": "deep",
      "undetone": "neutral",
      "warna": FieldValue.arrayUnion([
        "deep plum",
        "wine red",
        "dark chocolate",
        "orange",
        "orange-red",
        "brown"
      ])
    });
  }
}
