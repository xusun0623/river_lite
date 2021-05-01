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
    if (industry != null) this.industry = industry;
    if (type != null) this.type = type;
    if (salaryId != null) this.salaryId = salaryId;
  }
  String company;
  String city;
  String confidence;
  String education;
  String money;
  String job;
  String remark;
  String look;
  String time;
  String industry;
  String type;
  String salaryId;
}

dynamic toLocalSalary(List<dynamic> networkData) {
  var tmp = [];
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
