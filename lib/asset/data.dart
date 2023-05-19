List<String> industry = [
  '全部',
  'IT|互联网|通信',
  '销售|客服|市场',
  '财务|人力资源|行政',
  '项目质量|高级管理',
  '房产建筑|物业管理',
  '金融',
  '采购|贸易|交通|物流',
  '生产|制造',
  '传媒|印刷|艺术|设计',
  '咨询|法律|教育|翻译',
  '服务业',
  '能源环保|农业科研',
  '其他行业',
  '兼职|实习|社工|其他',
];

List<String> education = [
  "全部",
  "博士",
  "硕士",
  "本科",
  "大专",
  "其他",
];

class SalaryData {
  SalaryData({
    company,
    city,
    confidence,
    education,
    money,
    job,
    remark,
    look,
    salaryLow,
    salaryHigh,
    time,
    industry,
    type,
    salaryId,
  }) {
    if (company != null) this.company = company;
    if (city != null) this.city = city;
    if (confidence != null) this.confidence = confidence;
    if (education != null) this.education = education;
    if (money != null) this.money = money;
    if (job != null) this.job = job;
    if (remark != null) this.remark = remark;
    if (look != null) this.look = look;
    if (time != null) this.time = time;
    if (salaryLow != null) this.salaryLow = salaryLow;
    if (salaryHigh != null) this.salaryHigh = salaryHigh;
    if (industry != null) this.industry = industry;
    if (type != null) this.type = type;
    if (salaryId != null) this.salaryId = salaryId;
  }
  String? company;
  String? city;
  String? confidence;
  String? education;
  String? money;
  String? job;
  String? remark;
  String? look;
  String? salaryLow;
  String? salaryHigh;
  String? time;
  String? industry;
  String? type;
  String? salaryId;
}

class CommentData {
  CommentData({
    commentId,
    content,
    time,
    isMine,
    isOwner,
  }) {
    if (commentId != null) this.commentId = commentId;
    if (content != null) this.content = content;
    if (time != null) this.time = time;
    if (isMine != null) this.isMine = isMine;
    if (isOwner != null) this.isOwner = isOwner;
  }
  String? commentId;
  String? content;
  String? time;
  String? isMine;
  String? isOwner;
}

/// 转化为本地的评论格式
List<Map<dynamic, dynamic>> toLocalComment(List<dynamic> networkData) {
  List<Map<dynamic, dynamic>> tmp = [];
  networkData.forEach((element) {
    tmp.add({
      "commentId": element["comment_id"],
      "content": element["content"],
      "time": element["time"],
      "isMine": element["is_mine"],
      "isOwner": element["is_owner"],
    });
  });
  return tmp;
}

/// 转化为本地的薪资格式
List<Map<dynamic, dynamic>> toLocalSalary(List<dynamic> networkData) {
  List<Map<dynamic, dynamic>> tmp = [];
  networkData.forEach((element) {
    tmp.add({
      "company": element["company"],
      "city": element["city"],
      "confidence": element["score"],
      "education": element["xueli"],
      "money": element["salary"],
      "job": element["position"],
      "remark": element["remark"],
      "look": element["number"],
      "time": element["time"],
      "industry": element["hangye"],
      "type": element["salarytype"],
      "salaryId": element["id"],
    });
  });
  return tmp;
}
