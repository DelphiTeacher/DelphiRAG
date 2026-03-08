unit uDatasetCollectionProcessTask;

interface


uses
  Classes,
  SysUtils,
  uTimerTask,
  uBaseLog,
  uFuncCommon,

  uTableCommonRestCenter,
  DocumentReader,
  
  uDatasetToJson,
  XSuperObject;


type
  
  // 知识库数据集的处理任务线程
  TDatasetCollectionProcessTask=class(TBaseServiceThread)
  public
    procedure Execute;override;

  end;




// 处理数据集
function ProcessDatasetCollection(ACollectionJson:ISuperObject;var ADesc:String):Boolean;

// 将文档解析之后的图片保存到数据库中
function SaveDocumentImages(ACollectionJson:ISuperObject;AParseDocumentResult:TParseDocumentResult):Boolean;


implementation


// 将文档解析之后的图片保存到数据库中
function SaveDocumentImages(ACollectionJson:ISuperObject;AParseDocumentResult:TParseDocumentResult;var ADesc:String):Boolean;
var
  ACode:Integer;
  // ADesc:String;
  ADataJson:ISuperObject;
  AWhereKeyJson:ISuperObject;
  AIntfItem:TCommonRestIntfItem;
  ARecordJson:ISuperObject;
  AImageItem:TParseImageItem;
begin
  Result:=False;

  AIntfItem:=GlobalCommonRestIntfList.Find('images');
  if AIntfItem=nil then
  begin
    // ADesc:='不存在dataset_collections接口';
    uBaseLog.HandleException(nil,'SaveDocumentImages 不存在images接口');
    Exit;
  end;

  // 保存图片
  for I:=0 to AParseDocumentResult.ImageList.Count-1 do
  begin
    AImageItem:=AParseDocumentResult.ImageList[I];

    ARecordJson:=SO();
    ARecordJson.S['_id']:=AImageItem.ImageId;
    ARecordJson.S['teamId']:=ACollectionJson.S['teamId'];
    ARecordJson.S['filename']:=ExtractFileName(AImageItem.ImagePath);
    ARecordJson.S['filepath']:=AImageItem.ImagePath;
    ARecordJson.S['relatedId']:=ACollectionJson.S['fileId'];

    if not AIntfItem.AddRecord(AIntfItem.DBModule,nil,ACollectionJson.S['teamId'],ARecordJson,nil,ACode,ADesc,ADataJson) then
    begin
      Exit;
    end;

  end;

  Result:=True;

end;


// 处理数据集
function ProcessDatasetCollection(ACollectionJson:ISuperObject;var ADesc:String):Boolean;
var
  AParseDocumentResult:TParseDocumentResult;
begin
  Result:=False;
  ADesc:='';


  AParseDocumentResult:=nil;
  //如果是本地文件，那么先解析文件
  if ACollectionJson.S['type'] = 'file' then
  begin  
    // 先解析文件
    AParseDocumentResult:=ParseFile(ACollectionJson.S['file_path']);
  end;
  if AParseDocumentResult=nil then
  begin
    ADesc:='文件解析失败';
    Exit;
  end;

  // 将解析后的文本保存到数据库中，避免预览和处理的时候重复解析，造成耗时
  


  // 将解析后的文档内容保存到数据库
  SaveDocumentImages(ACollectionJson,AParseDocumentResult);
  

  // 将文档内容进行分片并存储
  
  


  



end;


{ TDatasetCollectionProcessTask }

procedure TDatasetCollectionProcessTask.Execute;
var
  ACode:Integer;
  ADesc:String;
  ADataJson:ISuperObject;
  AWhereKeyJson:ISuperObject;
  AIntfItem:TCommonRestIntfItem;
  AWhereKeyJsonArray:ISuperArray;
begin
  while not Terminated do
  begin
    SleepThread(5000);
    


    AIntfItem:=GlobalCommonRestIntfList.Find('dataset_collections');
    if AIntfItem=nil then
    begin
      // ADesc:='不存在dataset_collections接口';
      uBaseLog.HandleException(nil,'TDatasetCollectionProcessTask.Execute 不存在dataset_collections接口');
      continue;
    end;

    // 从数据库中查询需要重新处理的知识库数据集
    AWhereKeyJsonArray:=GetWhereConditionArray(['state'],['wait']);

    if not AIntfItem.GetRecord('',AWhereKeyJsonArray.AsJSON(),'','',ACode,ADesc,ADataJson) then
    begin
      continue;
    end;

    // 开始处理数据集，先将该数据集的状态设置为process



    




  end;

end;

end.
