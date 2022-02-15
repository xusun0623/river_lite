## API 请求 URL
http://bbs.uestc.edu.cn/mobcent/app/web/index.php?r=命令 （命令为 xxx/yyy 格式，例如用户登录为 user/login）

应该使用 POST 方法，但是实际上 GET 方法通常也可以，参数既可以放在 URL 中也可以放在请求正文中（包括 `r` 参数）。上传附件时只能使用 POST 方法。返回结果通常为 JSON，有比较固定的格式，应该比较容易读懂。部分 API（特别是以 view 结尾的那几个）返回 HTML。

注意设置 Content-Type，普通 POST 请求一般为 `application/x-www-form-urlencoded;charset=UTF-8`，上传附件的请求必须使用 `multipart/form-data;boundary=xxxx`（但是也可用于普通 POST 请求）。

## 公用参数

### accessToken 和 accessSecret (必填)
用户登录后的认证参数。

### apphash (必填)
php版本

    public static function getAppHashValue($special='') {
        $authkey = 'appbyme_key'; // 目前是定死的, 以后应该改成由用户设置
        $hash = substr(md5(substr(time(), 0, 5).$authkey.$special), 8, 8);
        return $hash;
    }

java版本

    public static String getAppHashValue() throws NoSuchAlgorithmException {
        String timeString = String.valueOf(System.currentTimeMillis());
        String authkey = "appbyme_key";
        String authString = timeString.substring(0, 5) + authkey;
        MessageDigest md = MessageDigest.getInstance("MD5");
        byte[] hashkey = md.digest(authString.getBytes());
        return new BigInteger(1, hashkey).toString(16).substring(8, 16);//16进制转换字符串
    }

PHP time() 对应的 Java 版本：https://stackoverflow.com/questions/732034/getting-unixtime-in-java  
对应的Javascript版本：http://phpjs.org/functions/time/  
Java MD5：https://stackoverflow.com/a/415971/1841048

### sdkVersion (可选)
API 版本，目前为 _2.4.0.2_，大部分情况下有没有这个参数以及参数值是什么都没有影响。
grep sdkVersion 出来，只有这几个区别：

mobcent/app/components/web/ImageUtils.php

    private static function _getThumbUrlFile($image, $thumb) {
        return sprintf('%s/%s/%s/%s_%s', 
            Yii::app()->getController()->dzRootUrl,
            MOBCENT_THUMB_URL_PATH,
            self::_getThumbTempPath($image),
            (isset($_GET['sdkVersion']) && $_GET['sdkVersion'] > '1.0.0') ? 'xgsize' : 'mobcentSmallPreview',
            $thumb
        );
    }

mobcent/app/controllers/message/HeartAction.php

如果你想获得系统消息的心跳提醒，需要在 querystring 中指定 `sdkVersion` 版本。

    if($_GET['sdkVersion']>='2.4.2'){
      // 获得系统消息
      $res['body']['systemInfo'] = $this->_getSystemInfo($uid);
    }else{
      // 获取好友通知
      $res['body']['friendInfo'] = $this->_getNotifyInfo($uid, 'friend');	
    }

mobcent/app/components/web/AppUtils.php 那一段待确认，估计跟我们调用 API 没什么关系。

### forumKey （可选）
用于 mobcent 统计，区分不同论坛，清水河畔该参数的值为 _CBQJazn9Wws8Ivhr6U_。

### platType （可选，默认为1）

Android 客户端为 1，iOS 客户端为 5。

## 返回结果

如果返回 JSON，通常格式如下：

    {
      "errcode": "", // 通常成功时为空，错误则为错误码。
      "rs": 1, // 通常 1 表示成功，0 表示失败。
      "head": {
        "errCode": "00000000", // 错误码。
        "errInfo": "调用成功,没有任何错误", // 错误信息。
        "version": "2.4.0.2", // API 版本。
        "alert": 0,
        ...
      },
      "body": {
        "externInfo": {
          "padding": ""
        },
        ...
      },
      "list": { // 部分 list 请求返回该字段，例如 forum/forumlist。
      },
      ...
    }

## user

### user/login
登录、注销。

* type 'login'（默认值）或 'logout'。
* username
* password
* mobile （用于手机验证登录，我们用不到，下同）
* code
* isValidation

**返回值**

* secret
* token
* avatar 头像 URL。
* uid
* userName

### user/register
不要用这个，注册出来是成电新人。
考虑手工抓取 http://bbs.uestc.edu.cn/member.php?mod=register ，然后模拟表单提交；或者用 WebView 显示注册网页；或者自己写一个服务器端 API。 

### user/location
设置用户位置（与周边用户/帖子功能配合使用）。

* longitude 经度
* latitude 纬度
* location 地址

### TODO
albumlist
getsetting
photolist
report
savealbum
saveavatar
setting
topiclist
updateuserinfo
uploadavatar
uploadavatarex
useradmin
useradminview
userfavorite
userinfo
userinfoadminview
userlist

### 其他 user API
* qqinfo
* qqlogin
* platforminfo
* saveplatforminfo
* saveqqinfo
* sign
* switch

## forum
### forum/forumlist
获取版块列表。

* fid 可选。获取指定版块的子版块。
* type TODO: 待确认，但是我们可能用不到。

**返回值**

* list _数组_。
    * board_category_name 版块名称。
    * board_category_id 相当于河畔上的 gid。
    * board_category_type
    * board_list _数组_，包含分栏下的版块。
        * board_child 是否有子版块。
        * board_content 是否为空版块（不能发帖，只有子版块，例如学院在线）。
        * board_id 相当于河畔上的 fid。
        * board_img
        * board_name 版块名称。
        * description
        * forumRedirect
        * last_posts_date 最后发表时间。
        * posts_total_num 总发帖量。
        * td_posts_num 今日发帖量。
        * topic_total_num 主题总数。


### forum/topiclist
获取某一版块的主题列表。

* boardId 相当于 fid。
* page
* pageSize
* sortby 'publish' == 'new', 'essence' == 'marrow', 'top', 'photo', 'all'（默认）
* filterType 'sortid', 'typeid'
* filterId 分类 ID，只返回指定分类的主题。
* isImageList
* topOrder 0（不返回置顶帖，默认）, 1（返回本版置顶帖）, 2（返回分类置顶帖）, 3（返回全局置顶帖）。置顶帖包含在 topTopicList 字段中。

**返回值**

* list _数组_。
    * topic_id
    * type
    * title （包含分类信息）
    * subject （仅包含标题）
    * imageList
    * sourceWebUrl
    * user_id
    * user_nick_name
    * userAvatar
    * gender
    * last_reply_date
    * vote 是否为投票帖。
    * hot
    * hits
    * replies
    * essence
    * top
    * status
    * pic_path
    * ratio
    * recommendAdd
    * isHasRecommendAdd
    * board_id
    * board_name
* topTopicList _数组_，包含置顶帖。
    * id
    * title
* page
* hasNext
* total_num
* newTopicPanel _数组_。
    * type （nomal、vote……）
    * action （空）
    * title （发表帖子、发起投票）
* classificationTop_list _数组_。
* classificationType_list _数组_。
    * classificationType_id
    * classificationType_name
* isOnlyTopicType
* anno_list _数组_。
* forumInfo
    * id
    * title
    * description
    * icon


### forum/postlist
获取帖子的回复列表。

* topicId
* authorId 只返回指定作者的回复，默认为 0 返回所有回复。
* order 0 或 1（回帖倒序排列）
* page
* pageSize

**返回值**

* page
* has_next
* total_num
* list _数组_。回复列表，_不包含楼主_。
    * reply_id 内部使用？
    * reply_content 回复内容（结构参考发帖时的 content 字段）。
    * reply_type
    * reply_name 用户名
    * reply_posts_id 回复 pid。
    * position 楼层编号。
    * posts_date 回复时间。
    * icon 头像 URL。
    * level
    * userTitle 用户组
    * location
    * mobileSign
    * reply_status
    * status
    * role_num
    * title
    * is_quote
    * quote_pid
    * quote_content
    * quote_user_name
    * managePanel
    * extraPanel 参见 topic 字段。
* topic 字段与 forum/topiclist 返回值中 list 项目类似
    * 两者均包含 topic_id, title, type, user_id, user_nick_name, replies, hits, essence, vote, hot, top, status, gender 这些字段，topic 字段不包含 board_id, board_name, last_reply_date, subject, pic_path, ratio, userAvatar, recommendAdd, isHasRecommendAdd, imageList, sourceWebUrl，此外还包含下列字段：
    * sortId
    * is_favor
    * create_date 发帖时间
    * icon 头像？
    * level
    * userTitle 用户组
    * content 主题帖内容（结构参考发帖时的 content 字段）。
    * poll_info
        * deadline
        * is_visible
        * voters
        * type
        * poll_status
        * poll_id 数组。
        * poll_item_list _数组_。
            * name
            * poll_item_id
            * total_num
            * percent
    * activityInfo
    * location
    * managePanel
    * extraPanel _数组_。
        * action 相当于 HTML &lt;form&gt; action 属性？
        * title 操作（例如“评分”）。
        * type 如果是评分则为 'rate'。
        * extParams
            * beforeAction 执行前请求的 URL？
    * mobileSign
    * reply_status
    * flag
    * reply_posts_id 楼主（1 楼） pid。
    * rateList
        * padding rateList 为空时包含该字段。
        * head 表头字段名
            * field1
            * field2
            * field3
        * body _数组_。相当于 &lt;tbody&gt; 每一行。
            * field1
            * field2
            * field3
        * total 总计。
            * field1
            * field2
            * field3
        * showAllUrl 显示所有评分记录的 URL（forum/ratelistview）。


### forum/topicadmin
发帖/回复。

* act 'new'（发帖）、'reply'（回复）、其他字符串（编辑）
* json JSON 格式的发帖内容。

JSON 格式：

    {
      "body": {
        "json": {
          "fid": 123, // 发帖时指定版块。
          "tid": 123456, // 回复时指定帖子。
          "typeOption": ...,
          "isAnonymous": 1, // 1 表示匿名发帖。
          "isOnlyAuthor": 1, // 1 表示回帖仅作者可见。
          "typeId": 1234, // 分类。
          "isQuote": 1, 是否引用之前回复的内容。
          "replyId": 123456, 回复 ID（pid）。
          "title": "Title", // 标题。
          "aid": "1,2,3", // 附件 ID，逗号隔开。
          "content": "又是一个 JSON 字符串，格式见下面。",
          "location": "TODO: 格式待确认"
          "poll": {
              "expiration": 3, 记票天数
              "options": ["11", "22"],
              "maxChoices": 2,//最多选择几项
              "visibleAfterVote", true, //投票后结果可见
              "showVoters": true,  //公开投票参与人
          },
        }
      }
    }

body.json.content 格式：

    [
      {
        "type": 0, // 0：文本（解析链接）；1：图片；3：音频;4:链接;5：附件
        "infor": "发帖内容|图片 URL|音频 URL"
      },
      ...
    ]

javascript示例：
```javascript
fetch(url, {
  method: 'POST',
  headers: {
    Accept: 'application/json',
    'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8'
  },
  body: `act=reply&json=${JSON.stringify(payload)}`
})
```
payload为上面的JSON格式，其中`content`字段（数组）需要再次序列化。

### forum/search
搜索（参数和 Discuz! search.php 一致）。

* keyword
* page
* pageSize
* searchid

### forum/sendattachment
发送附件。不知道怎么用，请使用 sendattachmentex。

* attachment JSON 字符串。

JSON 格式：

    {
      "body": {
        "attachment": {
          "module": "forum", // 默认为 forum，我们应该只用 forum。
          "type": 'audio', // audio, image, 
          "isPost": 1, // 通过 POST 请求正文发送。
        }
      }
    }

### forum/sendattachmentex
发送附件的高级版本，可以将图片上传到相册。

* type 'image', 'audio'
* module 'forum', 'album', 'pm'
* albumId

**返回值**

* body
    * attachment _数组_。
        * id 附件 ID，发帖时在 _aid_ 参数中指定。
        * urlName 附件 URL，发帖时在 _infor_ 字段中指定。

### forum/vote
投票。

* tid
* options 投票选项，逗号隔开。

**返回值**

* vote_rs _数组_。
    * name
    * pollItemId
    * totalNum

### forum/support
对回复进行支持/反对操作。

* tid
* pid
* type 'topic'（默认）== 'thread', 'post'
* action 'support'（默认）, 'against'

### forum/announcement
站点公告。

* id

### forum/atuserlist
获取可以@的好友。（相当于河畔编辑器里单击@朋友后弹出的列表。）

* page
* pageSize

返回数据

* page
* total_num
* has_next
* list
    * uid
    * name
    * role_num

### forum/classification
获取分类信息（目前河畔未使用）。

* sortid 分类信息 ID。

### forum/photogallery
获取包含图片的帖子。

* page
* pageSize

### forum/ratelistview
评分记录查询。**返回的 HTML。**

* tid
* pid

### forum/topicactivity
活动帖参加、取消。

* tid
* act 'apply'（默认）, 'cancel'
* json JSON 字符串。

JSON 格式：

    {
      "payment": , //支付的积分
      "message": , // 附加留言
      // 其他参数（活动时填写的信息）
    }


### forum/topicactivityview
参加活动。**返回是 HTML**。

* tid
* act

### forum/topicadminview
管理操作。**返回 HTML**。

* fid
* tid
* pid
* act
* type 'topic'（默认）

### forum/topicrate
评分。**返回 HTML。**

* tid
* pid

## message
### message/heart
查询新提醒数目（每隔一段时间查询）。

### message/notifylist
提醒列表。

* type 'post'（帖子）, 'at'（@消息）, 'friend'（好友？）
* page
* pageSize

### message/pmlist
短消息列表。

* pmlist JSON 字符串。

JSON 格式：

    {
      "body": {
        "externInfo": {
          "onlyFromUid": 0, // 只返回收到的消息（不包括自己发出去的消息）。
        },
        "pmInfos": {
          "startTime": , // 开始时间（以毫秒为单位）。startTime 和 stopTime 均为 0 表示获取最新（未读）消息，如果要获取历史消息指定一个较早的时间。
          "stopTime": , // 结束时间（以毫秒为单位），为零表示获取晚于 startTime 的所有消息。
          "cacheCount": 1,
          "fromUid": 123, // UID，必须指定。
          "pmLimit": 10, // 最多返回几条结果，默认为 15。
        }
      }
    }

### message/pmadmin
短消息管理（发送、删除）。

* json

JSON 格式：

    {
      "action": "send", // 'send'（默认）, 'delplid'（删除和某人的所有会话）, 'delpmid'
      "toUid": 12345, // send
      "msg": {
        "type": "text", // 'text', 'image', 'audio'
        "content": "消息内容（经过 URL 编码）/图片 URL/音频 URL"
      }, // send
      "plid": 123, // delplid（并非 uid）
      "pmid": 123  // delpmid
    }

### message/pmsessionlist
获取短消息会话列表。

* json *必选。*

JSON 格式：

    {
      "page": 1, // 可选，默认为 1。
      "pageSize": 10 // 可选，默认为 10。
    }

## square
### square/surrounding
获取周边用户/帖子。

* longitude 经度。
* latitude 纬度。
* poi 'user'（默认）或 'topic'。
* page
* pageSize
* radius 半径，单位为米（默认为 100000）。

## user
### user/updateuserinfo
修改用户信息(头像，密码，性别，签名)

* avatar
* sign
* gender
* oldPassword
* newPassword
