/*
异常处理模块
 */

import 'package:socket_service/microService/service/server/model/ErrorModel.dart';

import '../../../module/common/NotificationInApp.dart';

mixin ExceptionUiModule {
  NotificationInApp notificationInApp = NotificationInApp();
  /*
  警告类型
   */
  warningHandler(ErrorObject errorObject) {
    //
  }
  /*
  catch类型
   */
  catchHandler(ErrorObject errorObject) {
    // ui提示
    notificationInApp.motionErrorToast(
        titleText: "catch code:${errorObject.type?.index}",
        messageText: errorObject.content ?? "no info");
  }

  /*
  error类型
   */
  errorHandler(ErrorObject errorObject) {
    // ui提示
    notificationInApp.motionErrorToast(
        titleText: "error code:${errorObject.type?.index}",
        messageText: errorObject.content ?? "no info");
  }

  /*
  failure类型
   */
  failureHandler(ErrorObject errorObject) {
    notificationInApp.motionErrorToast(
        titleText: "failure code:${errorObject.type?.index}",
        messageText: errorObject.content ?? "no info");
  }
}
