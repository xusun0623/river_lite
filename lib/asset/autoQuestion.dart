/*
 * @Author: xusun000「xusun000@foxmail.com」 
 * @Date: 2022-11-07 21:59:02 
 * @Last Modified by: xusun000
 * @Last Modified time: 2022-11-07 22:06:50
 */

/**
 * 自动答题
 * callback(Int) 
 *      -1  - 成功or失败(不显示)
 *      1~7 - 对应的进度
 */
autoQuestion(Function callback) async {
  callback(-1);
  await Future.delayed(Duration(milliseconds: 500));
  callback(1);
  await Future.delayed(Duration(milliseconds: 500));
  callback(2);
  await Future.delayed(Duration(milliseconds: 500));
  callback(3);
  await Future.delayed(Duration(milliseconds: 500));
  callback(4);
  await Future.delayed(Duration(milliseconds: 500));
  callback(5);
  await Future.delayed(Duration(milliseconds: 500));
  callback(-1);
  await Future.delayed(Duration(milliseconds: 500));
}
