(******************************************************)
(*                                                    *)
(*      FastMsg Enterprise Edition Source Files       *)
(*                                                    *)
(*         Copyright (c) 2010-2017 千略软件           *)
(*               All Rights Reserved                  *)
(*                                                    *)
(******************************************************)

//------------------------------------------------------
// 单元说明: OEM选项
//------------------------------------------------------
unit FastMsg.Client.OEM;

interface

const
  { 客户端信息 }

  /// <summary>客户端产品ID</summary>
  OEM_ProductID = '{5AE681B9-DE71-4700-9EDF-E1C4A01C6F71}';

  /// <summary>产品名称(支持Unicode)</summary>
  OEM_ProductName = 'FastMsg';

  /// <summary>产品名称(英文)</summary>
  OEM_ProductName_EN = 'FastMsg';

  /// <summary>产品名称(英文小写)</summary>
  OEM_ProductName_EN_Lower = 'fastmsg';

  /// <summary>产品版本号</summary>
  OEM_ProductVersion = '8.0.0.0';

  /// <summary>主程序可执行文件名</summary>
  OEM_MainExeName = 'FastMsg.exe';

  { 自定义URLProtocol }

  /// <summary>自定义URLProtocol名称</summary>
  OEM_URLProtocol_Name = OEM_ProductName_EN_Lower;

  /// <summary>自定义URLProtocol地址</summary>
  OEM_URLProtocol_Location = OEM_URLProtocol_Name + '://go';

  { 升级更新 }

  /// <summary>升级更新的目录文件</summary>
  OEM_UpdateIndexURL = 'http://[%serverhost%]:5880/update/index.xml';

  { 服务端 }

  /// <summary>服务端版本号</summary>
  OEM_ServerVersion = 'FastMsg Server 8.0.0.0';

  { 默认网络设置 }

  /// <summary>默认网络设置-名称</summary>
  OEM_DEFAULT_NETWORKNAME = '默认';

  /// <summary>默认网络设置-服务器</summary>
  OEM_DEFAULT_HOST = 'www.orangeui.cn';//本机测试 //
//  OEM_DEFAULT_HOST = '127.0.0.1';//本机测试 //

  /// <summary>默认网络设置-端口</summary>
  OEM_DEFAULT_PORT = 5801;

  /// <summary>默认网络设置-本地端口</summary>
  OEM_DEFAULT_LOCALPORT = 0;

  { 聊天会话 }

  /// <summary>欢迎文字</summary>
  OEM_WelcomeText = '欢迎使用FASTMSG企业办公通讯平台，更多功能请关注官方网站。';

  { 网页链接 }

  /// <summary>官方网站</summary>
  OEM_URL_HomePage = 'http://www.fastmsg.cn/';

  /// <summary>论坛</summary>
  OEM_URL_BBS = 'http://www.fastmsg.cn/';

  /// <summary>问题反馈</summary>
  OEM_URL_BugReport = 'http://www.fastmsg.cn/';

  /// <summary>注册帐号网页</summary>
  OEM_URL_Register = 'http://www.fastmsg.cn:5880/usercenter/register_embed.php';

  /// <summary>找回密码网页</summary>
  OEM_URL_ForgetPWD = 'http://www.fastmsg.cn:5880/usercenter/forgetpwd_embed.php';

  /// <summary>更改密码网页</summary>
  OEM_URL_ChangePWD = 'http://www.fastmsg.cn/';

  { 各种可见选项 }

  /// <summary>系统下拉菜单-官方网站</summary>
  OEM_Visible_SystemMenu_HomePage = False;

  /// <summary>系统下拉菜单-论坛</summary>
  OEM_Visible_SystemMenu_BBS = False;

  /// <summary>系统下拉菜单-问题反馈</summary>
  OEM_Visible_SystemMenu_BugReport = False;

  /// <summary>系统下拉菜单-升级更新</summary>
  OEM_Visible_SystemMenu_SoftUpdate = True;

  /// <summary>系统下拉菜单-更新日志</summary>
  OEM_Visible_SystemMenu_UpdateLogs = True;

  /// <summary>系统下拉菜单-关于窗体</summary>
  OEM_Visible_SystemMenu_AboutForm = True;

  /// <summary>系统下拉菜单-"帐号注册"和"密码忘了"</summary>
  OEM_Visible_Register_ForgetPWD = False;

  { 系统默认浏览器 }

  //"帐号注册"和"密码忘了"是否使用系统浏览器打开
  OEM_DefaultBrowser_Register_ForgetPWD = False;

  //"修改密码"是否使用系统浏览器打开
  OEM_DefaultBrowser_ChangePWD = False;

implementation

end.

