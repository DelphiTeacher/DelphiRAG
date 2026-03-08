unit uMyVIPListPage;

interface

uses
  SysUtils,
  FMX.Forms,
//  uTBSSDK,
  uOpenCommon,
//  uDataInterface,
  uBasePageStructure,
//  uPageStructure,
//  uOpenClientCommon,
  BasePageFrame,
  uBasePageFrame,
//  BaseListPageFrame,

  uConst,
  uLang,

  uManager,
  uUIFunction,
  uPageStructure,
  uDataInterface,
  uRestHttpDataInterface,
  uOpenClientCommon;



var
  FMyVIPListPage:TPage;
  FMyVIPListPageFrame:TFrameBasePage;

  FMyVIPRightsListPage:TPage;


procedure ShowMyVIPListPage;




implementation


procedure ShowMyVIPListPage;
var
  ADesc:String;
//  ALoadDataSetting:TLoadDataSetting;
  AFieldControlSetting:TFieldControlSetting;
  AListItemBindingItem:TListItemBindingItem;
  I: Integer;
begin
        //我的VIP会员
        if FMyVIPListPage=nil then
        begin
              //测试动态创建
              //测试页面的框架
              FMyVIPListPage:=TPage.Create(nil);
              FMyVIPListPage.Name:='shop_goods_user_serivce_date_area_list_page';
              FMyVIPListPage.caption:=Trans('我的VIP');
              FMyVIPListPage.page_type:=Const_PageType_ListPage;
              //是默认的ListPage,创建一个默认的ListView
//              FMyVIPListPage.is_simple_list_page:=1;
//              FMyVIPListPage.item_height:=176;
              FMyVIPListPage.item_height:=100;
    //          FMyVIPListPage.has_add_record_button:=1;
              FMyVIPListPage.FIsNeedCommonEditButton:=False;
              //创建一个默认的ListView
              FMyVIPListPage.LoadLayoutControlListEnd;


//              //默认列表项的显示风格
//              FMyVIPListPage.default_list_item_style:='UserSerivceGoodsVIP';
//              //默认列表项的绑定设置
//              FMyVIPListPage.default_list_item_bindings:='';
              FMyVIPListPage.FRecordListFieldControlSetting.PropJson.S['default_list_item_bindings']:='';
              FMyVIPListPage.FRecordListFieldControlSetting.PropJson.S['DefaultItemStyle']:='UserSerivceGoodsVIP';
              FMyVIPListPage.FRecordListFieldControlSetting.PropJson.S['ItemClass']:='TSkinJsonItem';
              FMyVIPListPage.FRecordListFieldControlSetting.prop:=FMyVIPListPage.FRecordListFieldControlSetting.PropJson.AsJson;
              FMyVIPListPage.FRecordListFieldControlSetting.action:=Const_PageAction_JumpToPage;
              FMyVIPListPage.FRecordListFieldControlSetting.jump_to_page_name:='shop_goods_spec_user_vip_rights_light_page';
              //


              FMyVIPListPage.load_data_params:=
                '['
//                +'{"name":"user_fid","value_from":"login_user","value_key":"fid"}'//+','
                +'{"name":"user_fid","value_from":"login_user","value":"$user_fid"}'//+','
    //            +'{"name":"appid","value_from":"const","value":'+IntToStr(AppID)+'}'
                +']';


              //设置TableCommonRest保存接口
              TTableCommonRestHttpDataInterface(FMyVIPListPage.DataInterface).FInterfaceUrl:=InterfaceUrl;
              TTableCommonRestHttpDataInterface(FMyVIPListPage.DataInterface).Name:='shop_goods_user_serivce_date_area';


              GlobalMainProgramSetting.FProgramTemplate.PageList.Add(FMyVIPListPage);







              //测试动态创建
              //测试页面的框架
              FMyVIPRightsListPage:=TPage.Create(nil);
              FMyVIPRightsListPage.Name:='shop_goods_spec_user_vip_rights_light_page';
              FMyVIPRightsListPage.caption:=Trans('我的VIP权益');
              FMyVIPRightsListPage.page_type:=Const_PageType_ListPage;
              //是默认的ListPage,创建一个默认的ListView
//              FMyVIPRightsListPage.is_simple_list_page:=1;
              FMyVIPRightsListPage.item_height:=120;
    //          FMyVIPRightsListPage.has_add_record_button:=1;
              FMyVIPRightsListPage.FIsNeedCommonEditButton:=False;
              //创建一个默认的ListView
              FMyVIPRightsListPage.LoadLayoutControlListEnd;



//              //默认列表项的显示风格
//              FMyVIPRightsListPage.default_list_item_style:='UserSerivceGoodsVIPRights';
//              //默认列表项的绑定设置
//              FMyVIPRightsListPage.default_list_item_bindings:='';
              FMyVIPRightsListPage.FRecordListFieldControlSetting.PropJson.S['default_list_item_bindings']:='';
              FMyVIPRightsListPage.FRecordListFieldControlSetting.PropJson.S['DefaultItemStyle']:='UserSerivceGoodsVIPRights';
              FMyVIPRightsListPage.FRecordListFieldControlSetting.PropJson.S['ItemClass']:='TSkinJsonItem';
              FMyVIPRightsListPage.FRecordListFieldControlSetting.prop:=FMyVIPRightsListPage.FRecordListFieldControlSetting.PropJson.AsJson;


              FMyVIPRightsListPage.load_data_params:=
                '['
                +'{"name":"user_fid","value_from":"login_user","value":"$user_fid"}'//+','
    //            +'{"name":"appid","value_from":"const","value":'+IntToStr(AppID)+'}'
                +']';


              //设置TableCommonRest保存接口
              TTableCommonRestHttpDataInterface(FMyVIPRightsListPage.DataInterface).FInterfaceUrl:=InterfaceUrl;
              TTableCommonRestHttpDataInterface(FMyVIPRightsListPage.DataInterface).Name:='shop_goods_spec_user_vip_rights';


              GlobalMainProgramSetting.FProgramTemplate.PageList.Add(FMyVIPRightsListPage);






              //点击列表项跳转的页面
//              FMyVIPListPage.ClickItemJumpPage:=FMyVIPRightsListPage;
              FMyVIPListPageFrame:=TFrameBaseListPage.Create(Application);
              SetFrameName(FMyVIPListPageFrame);

        end;




//        ALoadDataSetting.Clear;
//        ALoadDataSetting.AppID:=AppID;
//        ALoadDataSetting.PageIndex:=1;
//        ALoadDataSetting.PageSize:=20;
//        //设置接口
//        TTableCommonRestHttpDataInterface(FMyVIPListPage.DataInterface).InterfaceUrl:=InterfaceUrl;



        //隐藏
        HideFrame;//(GlobalMainFrame);

//        ShowPageFrame(FMyVIPListPage,ALoadDataSetting,nil);
        ShowFrame(TFrame(FMyVIPListPageFrame),TFrameBaseListPage);
        FMyVIPListPageFrame.LoadPage(FMyVIPListPage,nil);//,ALoadDataSetting);
        FMyVIPListPageFrame.PageInstance.FLoadDataSetting.AppID:=AppID;
        FMyVIPListPageFrame.PageInstance.FLoadDataSetting.PageIndex:=1;
        FMyVIPListPageFrame.PageInstance.FLoadDataSetting.PageSize:=20;
        FMyVIPListPageFrame.PageInstance.LoadData;

end;


initialization


finalization
  FreeAndNil(FMyVIPListPageFrame);



end.
