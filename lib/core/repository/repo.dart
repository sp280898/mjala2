import '../../models/detailsdata.dart';
import '../../models/generatebilldata.dart';
import '../../models/getprintbilldata.dart';
import '../../models/logindata.dart';
import '../../models/savemeterpicdata.dart';

abstract class Repo {
  Future<DetailsData?> hitRrDetailsApi(
      String rrNumber, String meterNO, String zone);
  Future<Generatebilldata?> hitGenerateBillApi();
  Future<PrintBillDetails?> hitPrintBillApi();
  Future<LoginData?> hitLoginApi(
    String? userId,
    String? password,
    String? zone,
  );
  Future<Savemeterpicdata?> hitSaveMeterPicApi();
}
