import 'package:cloud_firestore/cloud_firestore.dart';

class DataSeederService {
  static CollectionReference listLipstik =
      FirebaseFirestore.instance.collection('list_lipstik');

  static createListLipstik() {
    listLipstik.doc("1").set({
      'kategori': "dark mauve",
      'nama_lipstik': "Witty",
      'kode_lipstik': "40",
      'kode_warna': "90484c",
    });
    listLipstik.doc("2").set({
      'kategori': "pink",
      'nama_lipstik': "Coy",
      'kode_lipstik': "20",
      'kode_warna': "c74a68",
    });
    listLipstik.doc("3").set({
      'kategori': "blue-red",
      'nama_lipstik': "Wicked",
      'kode_lipstik': "50",
      'kode_warna': "b80023",
    });
    listLipstik.doc("4").set({
      'kategori': "wine red",
      'nama_lipstik': "Unrivaled",
      'kode_lipstik': "30",
      'kode_warna': "880a2b",
    });
    listLipstik.doc("5").set({
      'kategori': "light coral",
      'nama_lipstik': "Mischievous",
      'kode_lipstik': "60",
      'kode_warna': "c94d46",
    });
    listLipstik.doc("6").set({
      'kategori': "peachy pink",
      'nama_lipstik': "Peachy",
      'kode_lipstik': "15",
      'kode_warna': "c75457",
    });
    listLipstik.doc("7").set({
      'kategori': "peachy warm",
      'nama_lipstik': "Saucy",
      'kode_lipstik': "65",
      'kode_warna': "b74948",
    });
    listLipstik.doc("8").set({
      'kategori': "plum",
      'nama_lipstik': "Lippy",
      'kode_lipstik': "10",
      'kode_warna': "95101f",
    });
    listLipstik.doc("9").set({
      'kategori': "rosy beige",
      'nama_lipstik': "Cheeky",
      'kode_lipstik': "35",
      'kode_warna': "af5b59",
    });
    listLipstik.doc("10").set({
      'kategori': "pale pink",
      'nama_lipstik': "Charmed",
      'kode_lipstik': "100",
      'kode_warna': "c96d6c",
    });
    listLipstik.doc("11").set({
      'kategori': "terracotta",
      'nama_lipstik': "Extra",
      'kode_lipstik': "130",
      'kode_warna': "973a2c",
    });
    listLipstik.doc("12").set({
      'kategori': "peachy nude",
      'nama_lipstik': "Intriguing",
      'kode_lipstik': "63",
      'kode_warna': "cc725f",
    });
    listLipstik.doc("13").set({
      'kategori': "nude pink",
      'nama_lipstik': "Irresistable",
      'kode_lipstik': "62",
      'kode_warna': "ae544c",
    });
    listLipstik.doc("14").set({
      'kategori': "warm nude",
      'nama_lipstik': "Keen",
      'kode_lipstik': "125",
      'kode_warna': "ba453c",
    });
    listLipstik.doc("15").set({
      'kategori': "warm pink",
      'nama_lipstik': "Peppy",
      'kode_lipstik': "115",
      'kode_warna': "aa464e",
    });
    listLipstik.doc("16").set({
      'kategori': "nude brown",
      'nama_lipstik': "Punchy",
      'kode_lipstik': "120",
      'kode_warna': "95594f",
    });
    listLipstik.doc("17").set({
      'kategori': "orange-red",
      'nama_lipstik': "Red Hot",
      'kode_lipstik': "25",
      'kode_warna': "e1100f",
    });
    listLipstik.doc("18").set({
      'kategori': "terracotta",
      'nama_lipstik': "Risky",
      'kode_lipstik': "61",
      'kode_warna': "ab362d",
    });
  }

  static CollectionReference dataMapping =
      FirebaseFirestore.instance.collection('data_mapping');

  static createDataMapping() {
    dataMapping.doc("fair_cool").set({
      "skintone": "fair",
      "undetone": "cool",
      "warna": FieldValue.arrayUnion([
        "mauve",
        "pale pink",
        "beige",
        "pink",
        "fuschia",
        "purple",
        "rosy beige",
      ])
    });
    dataMapping.doc("fair_warm").set({
      "skintone": "fair",
      "undetone": "warm",
      "warna": FieldValue.arrayUnion([
        "light coral",
        "peachy nude",
        "peachy pink",
        "warm nude",
        "nude pink",
        "peachy warm",
      ])
    });
    dataMapping.doc("fair_netral").set({
      "skintone": "fair",
      "undetone": "netral",
      "warna": FieldValue.arrayUnion([
        "mauve",
        "pale pink",
        "beige",
        "pink",
        "peachy nude",
        "rosy beige",
        "nude pink",
        "peachy warm",
      ])
    });

    dataMapping.doc("light_cool").set({
      "skintone": "light",
      "undetone": "cool",
      "warna": FieldValue.arrayUnion([
        "mauve",
        "rosy pink",
        "fuschia",
        "purple",
        "nude brown",
        "peachy nude",
        "pale pink",
      ])
    });
    dataMapping.doc("light_warm").set({
      "skintone": "light",
      "undetone": "warm",
      "warna": FieldValue.arrayUnion([
        "warm pink",
        "rosy beige",
        "warm nude",
        "pink",
        "peachy nude",
      ])
    });
    dataMapping.doc("light_netral").set({
      "skintone": "light",
      "undetone": "netral",
      "warna": FieldValue.arrayUnion([
        "mauve",
        "rosy pink",
        "warm pink",
        "rosy beige",
        "pink",
        "peachy nude",
        "pale pink",
        "peachy warm",
      ])
    });

    dataMapping.doc("medium_cool").set({
      "skintone": "medium",
      "undetone": "cool",
      "warna": FieldValue.arrayUnion([
        "dark mauve",
        "blue-red",
        "fuschia",
        "purple",
        "peachy nude",
      ])
    });
    dataMapping.doc("medium_warm").set({
      "skintone": "medium",
      "undetone": "warm",
      "warna": FieldValue.arrayUnion([
        "orange-red",
        "nude beige",
        "warm nude",
        "blue-red",
        "peachy nude",
        "terracotta",
      ])
    });
    dataMapping.doc("medium_netral").set({
      "skintone": "medium",
      "undetone": "netral",
      "warna": FieldValue.arrayUnion([
        "dark mauve",
        "blue-red",
        "orange-red",
        "nude beige",
        "peachy pink",
        "peachy nude",
        "warm nude",
        "terracotta",
      ])
    });

    dataMapping.doc("tan_cool").set({
      "skintone": "tan",
      "undetone": "cool",
      "warna": FieldValue.arrayUnion([
        "plum",
        "dark mauve",
        "fuschia",
        "purple",
      ])
    });
    dataMapping.doc("tan_warm").set({
      "skintone": "tan",
      "undetone": "warm",
      "warna": FieldValue.arrayUnion([
        "terracotta",
        "nude brown",
        "nude pink",
      ])
    });
    dataMapping.doc("tan_netral").set({
      "skintone": "tan",
      "undetone": "netral",
      "warna": FieldValue.arrayUnion([
        "plum",
        "dark mauve",
        "terracotta",
        "nude brown",
        "warm nude",
        "nude pink",
      ])
    });

    dataMapping.doc("deep_cool").set({
      "skintone": "deep",
      "undetone": "cool",
      "warna": FieldValue.arrayUnion([
        "deep plum",
        "wine red",
        "dark chocolate",
        "fuschia",
        "purple",
        "plum",
      ])
    });
    dataMapping.doc("deep_warm").set({
      "skintone": "deep",
      "undetone": "warm",
      "warna": FieldValue.arrayUnion([
        "orange",
        "orange-red",
        "brown",
        "nude brown",
        "terracotta",
      ])
    });
    dataMapping.doc("deep_netral").set({
      "skintone": "deep",
      "undetone": "netral",
      "warna": FieldValue.arrayUnion([
        "deep plum",
        "wine red",
        "dark chocolate",
        "brown",
        "nude brown",
        "blue-red",
        "plum",
        "terracotta",
      ])
    });
  }
}
