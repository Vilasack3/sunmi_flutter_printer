// import 'package:flutter/material.dart';
// import 'package:sunmi/sunmi_screen.dart';
//
// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Sunmi Flutter Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: SunmiScreen(),
//     );
//   }
// }
import 'dart:typed_data';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sunmi_printer_plus/column_maker.dart';
import 'package:sunmi_printer_plus/enums.dart';
import 'dart:async';

import 'package:sunmi_printer_plus/sunmi_printer_plus.dart';
import 'package:sunmi_printer_plus/sunmi_style.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.landscapeRight, DeviceOrientation.landscapeRight]);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Sunmi Printer',
        theme: ThemeData(
          primaryColor: Colors.black,
        ),
        debugShowCheckedModeBanner: false,
        home: const Home());
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool printBinded = false;
  int paperSize = 0;
  String serialNumber = "";
  String printerVersion = "";
  @override
  void initState() {
    super.initState();

    _bindingPrinter().then((bool? isBind) async {
      SunmiPrinter.paperSize().then((int size) {
        setState(() {
          paperSize = size;
        });
      });

      SunmiPrinter.printerVersion().then((String version) {
        setState(() {
          printerVersion = version;
        });
      });

      SunmiPrinter.serialNumber().then((String serial) {
        setState(() {
          serialNumber = serial;
        });
      });

      setState(() {
        printBinded = isBind!;
      });
    });
  }

  /// must binding ur printer at first init in app
  Future<bool?> _bindingPrinter() async {
    final bool? result = await SunmiPrinter.bindingPrinter();
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sunmi printer Example'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                      onPressed: () async {
                        String url =
                            'https://scontent.fvte3-1.fna.fbcdn.net/v/t39.30808-6/309166580_201966465520966_1791098588484974235_n.png?_nc_cat=107&ccb=1-7&_nc_sid=09cbfe&_nc_eui2=AeE43ESHF0ZQ-nCSujFPgMgJyo6YRnhYeKjKjphGeFh4qKELs1YaUyB_PKV_vMIbA2QQsCzgHeAmwdopkVj74h0J&_nc_ohc=vmxHOc9LBukAX_Z-PmJ&_nc_ht=scontent.fvte3-1.fna&oh=00_AfCK5UkYgwxXZ2aGLEHe1PIG5ookbpcshi1EAO5IYvVAWQ&oe=647E740E';
                        // convert image to Uint8List format
                        Uint8List byte =
                            (await NetworkAssetBundle(Uri.parse(url)).load(url))
                                .buffer
                                .asUint8List();
                        await SunmiPrinter.initPrinter();
                        await SunmiPrinter.startTransactionPrint(true);
                        await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER);
                        // await SunmiPrinter.line();
                        await SunmiPrinter.printImage(byte);
                        await SunmiPrinter.lineWrap(1);
                        await SunmiPrinter.printText(
                          'ກະຊວງການເງິນ',
                          style: SunmiStyle(align: SunmiPrintAlign.CENTER),
                        );
                        await SunmiPrinter.printText(
                          'ບໍລິສັດລັດ ວິສະຫະກິດ ຫວຍພັດທະນາ',
                          style: SunmiStyle(align: SunmiPrintAlign.CENTER),
                        );
                        await SunmiPrinter.printText(
                          'ຕົວແທນຈຳໜ່າຍ ຫວຍ SMS',
                          style: SunmiStyle(align: SunmiPrintAlign.CENTER),
                        );
                        await SunmiPrinter.line();
                        await SunmiPrinter.printRow(
                          cols: [
                            ColumnMaker(
                              text: 'ເລກບິນ:',
                              width: 10,
                              align: SunmiPrintAlign.LEFT,
                            ),
                            ColumnMaker(
                              text: 'XXXXXXXXXXX555',
                              width: 16,
                              align: SunmiPrintAlign.LEFT,
                            ),
                          ],
                        );
                        await SunmiPrinter.printRow(
                          cols: [
                            ColumnMaker(
                                text: 'Name',
                                width: 12,
                                align: SunmiPrintAlign.LEFT),
                            ColumnMaker(
                                text: 'Qty',
                                width: 6,
                                align: SunmiPrintAlign.CENTER),
                          ],
                        );

                        await SunmiPrinter.printRow(cols: [
                          ColumnMaker(
                              text: 'Fries',
                              width: 12,
                              align: SunmiPrintAlign.LEFT),
                          ColumnMaker(
                              text: '4x',
                              width: 6,
                              align: SunmiPrintAlign.CENTER),
                          ColumnMaker(
                              text: '3.00',
                              width: 6,
                              align: SunmiPrintAlign.RIGHT),
                          ColumnMaker(
                              text: '12.00',
                              width: 6,
                              align: SunmiPrintAlign.RIGHT),
                        ]);

                        await SunmiPrinter.printRow(cols: [
                          ColumnMaker(
                              text: 'ມັນຢາກເກິນ',
                              width: 26,
                              align: SunmiPrintAlign.LEFT),
                          ColumnMaker(
                              text: '1x',
                              width: 3,
                              align: SunmiPrintAlign.CENTER),
                          ColumnMaker(
                              text: '24.44',
                              width: 3,
                              align: SunmiPrintAlign.RIGHT),
                          ColumnMaker(
                              text: '24.44',
                              width: 3,
                              align: SunmiPrintAlign.RIGHT),
                        ]);

                        await SunmiPrinter.printRow(cols: [
                          ColumnMaker(
                              text: 'Soda',
                              width: 6,
                              align: SunmiPrintAlign.LEFT),
                          ColumnMaker(
                              text: '1x',
                              width: 6,
                              align: SunmiPrintAlign.CENTER),
                          ColumnMaker(
                              text: '1.99',
                              width: 6,
                              align: SunmiPrintAlign.RIGHT),
                          ColumnMaker(
                              text: '1.99',
                              width: 6,
                              align: SunmiPrintAlign.RIGHT),
                        ]);

                        await SunmiPrinter.line();
                        await SunmiPrinter.printRow(cols: [
                          ColumnMaker(
                              text: 'TOTAL',
                              width: 25,
                              align: SunmiPrintAlign.LEFT),
                          ColumnMaker(
                              text: '38.43',
                              width: 5,
                              align: SunmiPrintAlign.RIGHT),
                        ]);

                        await SunmiPrinter.printRow(cols: [
                          ColumnMaker(
                              text: 'ARABIC TEXT',
                              width: 15,
                              align: SunmiPrintAlign.LEFT),
                          ColumnMaker(
                              text: 'اسم المشترك',
                              width: 15,
                              align: SunmiPrintAlign.LEFT),
                        ]);

                        await SunmiPrinter.printRow(cols: [
                          ColumnMaker(
                              text: 'اسم المشترك',
                              width: 15,
                              align: SunmiPrintAlign.LEFT),
                          ColumnMaker(
                              text: 'اسم المشترك',
                              width: 15,
                              align: SunmiPrintAlign.LEFT),
                        ]);

                        await SunmiPrinter.printRow(cols: [
                          ColumnMaker(
                              text: 'RUSSIAN TEXT',
                              width: 15,
                              align: SunmiPrintAlign.LEFT),
                          ColumnMaker(
                              text: 'Санкт-Петербу́рг',
                              width: 15,
                              align: SunmiPrintAlign.LEFT),
                        ]);
                        await SunmiPrinter.printRow(cols: [
                          ColumnMaker(
                              text: 'Санкт-Петербу́рг',
                              width: 15,
                              align: SunmiPrintAlign.LEFT),
                          ColumnMaker(
                              text: 'Санкт-Петербу́рг',
                              width: 15,
                              align: SunmiPrintAlign.LEFT),
                        ]);

                        await SunmiPrinter.printRow(cols: [
                          ColumnMaker(
                              text: 'CHINESE TEXT',
                              width: 15,
                              align: SunmiPrintAlign.LEFT),
                          ColumnMaker(
                              text: '風俗通義',
                              width: 15,
                              align: SunmiPrintAlign.LEFT),
                        ]);
                        await SunmiPrinter.printRow(cols: [
                          ColumnMaker(
                              text: '風俗通義',
                              width: 15,
                              align: SunmiPrintAlign.LEFT),
                          ColumnMaker(
                              text: '風俗通義',
                              width: 15,
                              align: SunmiPrintAlign.LEFT),
                        ]);

                        await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER);
                        await SunmiPrinter.line();
                        await SunmiPrinter.bold();
                        await SunmiPrinter.printText('Transaction\'s Qrcode');
                        await SunmiPrinter.resetBold();
                        await SunmiPrinter.printQRCode(
                            'https://github.com/brasizza/sunmi_printer');
                        await SunmiPrinter.lineWrap(2);
                        await SunmiPrinter.exitTransactionPrint(true);
                      },
                      child: const Text('TICKET EXAMPLE')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<Uint8List> readFileBytes(String path) async {
  ByteData fileData = await rootBundle.load(path);
  Uint8List fileUnit8List = fileData.buffer
      .asUint8List(fileData.offsetInBytes, fileData.lengthInBytes);
  return fileUnit8List;
}

Future<Uint8List> _getImageFromAsset(String iconPath) async {
  return await readFileBytes(iconPath);
}

Future<List<int>> _customEscPos() async {
  final profile = await CapabilityProfile.load();
  final generator = Generator(PaperSize.mm58, profile);
  List<int> bytes = [];

  bytes += generator.text(
      'Regular: aA bB cC dD eE fF gG hH iI jJ kK lL mM nN oO pP qQ rR sS tT uU vV wW xX yY zZ');
  bytes += generator.text('Special 1: àÀ èÈ éÉ ûÛ üÜ çÇ ôÔ',
      styles: const PosStyles(codeTable: 'CP1252'));
  bytes += generator.text('Special 2: blåbærgrød',
      styles: const PosStyles(codeTable: 'CP1252'));

  bytes += generator.text('Bold text', styles: const PosStyles(bold: true));
  bytes +=
      generator.text('Reverse text', styles: const PosStyles(reverse: true));
  bytes += generator.text('Underlined text',
      styles: const PosStyles(underline: true), linesAfter: 1);
  bytes += generator.text('Align left',
      styles: const PosStyles(align: PosAlign.left));
  bytes += generator.text('Align center',
      styles: const PosStyles(align: PosAlign.center));
  bytes += generator.text('Align right',
      styles: const PosStyles(align: PosAlign.right), linesAfter: 1);
  bytes += generator.qrcode('Barcode by escpos',
      size: QRSize.Size4, cor: QRCorrection.H);
  bytes += generator.feed(2);

  bytes += generator.row([
    PosColumn(
      text: 'col3',
      width: 3,
      styles: const PosStyles(align: PosAlign.center, underline: true),
    ),
    PosColumn(
      text: 'col6',
      width: 6,
      styles: const PosStyles(align: PosAlign.center, underline: true),
    ),
    PosColumn(
      text: 'col3',
      width: 3,
      styles: const PosStyles(align: PosAlign.center, underline: true),
    ),
  ]);

  bytes += generator.text('Text size 200%',
      styles: const PosStyles(
        height: PosTextSize.size2,
        width: PosTextSize.size2,
      ));

  bytes += generator.reset();
  bytes += generator.cut();

  return bytes;
}
