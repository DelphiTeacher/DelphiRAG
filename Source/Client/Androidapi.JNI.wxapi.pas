unit Androidapi.JNI.wxapi;

interface

{$IFDEF ANDROID}
uses
  Androidapi.JNIBridge,
  Androidapi.JNI.JavaTypes,
  Androidapi.JNI.GraphicsContentViewText,
  Androidapi.JNI.App,
  Androidapi.JNI.os;


type
// ===== Forward declarations =====

  JOnWeixinListener = interface; //com.ggggcexx.delphi.wxapi.OnWeixinListener
  JWXEntryActivity = interface; //com.ggggcexx.delphi.wxapi.WXEntryActivity
  JWXPayEntryActivity = interface; //com.ggggcexx.delphi.wxapi.WXPayEntryActivity

// ===== Interface declarations =====

  JOnWeixinListenerClass = interface(JObjectClass)
  ['{3E9109B1-7665-4583-B461-31346A2DA793}']
    { static Property Methods }

    { static Methods }

    { static Property }
  end;

  [JavaSignature('com/ggggcexx/delphi/wxapi/OnWeixinListener')]
  JOnWeixinListener = interface(IJavaInstance)
  ['{19474D80-F04B-4108-91A8-FA33A0AD5BD3}']
    { Property Methods }

    { methods }
    procedure onHandleIntent(P1: JIntent; P2: JActivity); cdecl;

    { Property }
  end;

  TJOnWeixinListener = class(TJavaGenericImport<JOnWeixinListenerClass, JOnWeixinListener>) end;

  JWXEntryActivityClass = interface(JObjectClass)
  ['{7BA83A95-6995-4F2B-9BB6-883F16A75181}']
    { static Property Methods }

    { static Methods }
    {class} function init: JWXEntryActivity; cdecl;
    {class} procedure setOnWeixinListener(P1: JOnWeixinListener); cdecl;
    {class} function getOnOnWeixinListener: JOnWeixinListener; cdecl;

    { static Property }
  end;

  [JavaSignature('com/ggggcexx/delphi/wxapi/WXEntryActivity')]
  JWXEntryActivity = interface(JObject)
  ['{0853F9BC-2D10-42EB-916A-EFF5F041C851}']
    { Property Methods }

    { methods }
    procedure onCreate(savedInstanceState: JBundle); cdecl;

    { Property }
  end;

  TJWXEntryActivity = class(TJavaGenericImport<JWXEntryActivityClass, JWXEntryActivity>) end;

  JWXPayEntryActivityClass = interface(JObjectClass)
  ['{DBEA7BD9-9625-4BCA-B7EC-D2897CA1EB51}']
    { static Property Methods }

    { static Methods }
    {class} function init: JWXPayEntryActivity; cdecl;
    {class} procedure setOnWeixinListener(P1: JOnWeixinListener); cdecl;
    {class} function getOnOnWeixinListener: JOnWeixinListener; cdecl;

    { static Property }
  end;

  [JavaSignature('com/ggggcexx/delphi/wxapi/WXPayEntryActivity')]
  JWXPayEntryActivity = interface(JObject)
  ['{EACB92D2-4240-4D71-92A5-9D904BEFA151}']
    { Property Methods }

    { methods }
    procedure onCreate(savedInstanceState: JBundle); cdecl;

    { Property }
  end;

  TJWXPayEntryActivity = class(TJavaGenericImport<JWXPayEntryActivityClass, JWXPayEntryActivity>) end;

{$ENDIF}
implementation
//{$IFDEF ANDROID}
//
//
//procedure RegisterTypes;
//begin
//  TRegTypes.RegisterType('Androidapi.JNI.wxapi.JOnWeixinListener',
//    TypeInfo(Androidapi.JNI.wxapi.JOnWeixinListener));
//  TRegTypes.RegisterType('Androidapi.JNI.wxapi.JWXEntryActivity',
//    TypeInfo(Androidapi.JNI.wxapi.JWXEntryActivity));
//  TRegTypes.RegisterType('Androidapi.JNI.wxapi.JWXPayEntryActivity',
//    TypeInfo(Androidapi.JNI.wxapi.JWXPayEntryActivity));
//end;
//
//
//initialization
//  RegisterTypes;
//
//{$ENDIF}

end.
