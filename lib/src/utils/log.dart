import 'package:flutter_lembrete/src/model/log.dart';
import 'package:flutter_lembrete/src/repository/log_repository.dart';

void log(message) async {
  LogModel logModel = LogModel(message);
  LogRepository logRepository = LogRepository();
  
  logRepository.create(logModel);
}