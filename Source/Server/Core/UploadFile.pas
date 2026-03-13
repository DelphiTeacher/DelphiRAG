unit UploadFile;

interface

uses
  SysUtils,Classes,
  XSuperObject,
  uDatasetToJson,
  uFileCommon,
  uFuncCommon,
  FileIndyHttpServerModule,
  uTableCommonRestCenter,

  IdMessageCoder,
  IdMessageCoderMIME;




function ProcessUploadFileRequest(RequestStream:TStream;var ADesc:String;var ADataJson:ISuperObject):Boolean;
function ProcessUploadFileStream(AMimeFileName:String;AFileStream:TStream;ABucketName:String;var ADesc:String;var ADataJson:ISuperObject):Boolean;

implementation





function ProcessUploadFileStream(AMimeFileName:String;AFileStream:TStream;ABucketName:String;var ADesc:String;var ADataJson:ISuperObject):Boolean;
var
  ACode:Integer;
  AFileName:String;
  AFileExt:String;
  AFileSize:Integer;
  ARemoteFilePath:String;
  ASuperObject:ISuperObject;
  AIntfItem:TCommonRestIntfItem;
begin
  Result:=False;
  AFileName:=AMimeFileName;
  AFileExt:=ExtractFileExt(AMimeFileName);

  AFileSize:=AFileStream.Size;

  //保存成文件
  ARemoteFilePath:='';
  if not ProcessUploadFile(GetApplicationPath,//ExtractFilePath(Application.ExeName),
                       '',
                       AFileName,
                       AFileExt,
                       ABucketName+PathDelim,
                       AFileStream,
                       ARemoteFilePath,
                       ACode,
                       ADesc) then
  begin

  end;


  ASuperObject:=SO();
  ASuperObject.S['_id']:=CreateGUIDString;
  ASuperObject.S['teamId']:='';
  ASuperObject.S['tmbId']:='';
  ASuperObject.I['length']:=AFileSize;
  ASuperObject.I['chunkSize']:=261120;
  ASuperObject.S['filename']:=AFileName;
  ASuperObject.S['filepath']:=ARemoteFilePath;


  AIntfItem:=GlobalCommonRestIntfList.Find(ABucketName+'_files');
  if AIntfItem=nil then
  begin
    ADesc:='不存在'+ABucketName+'_files'+'接口';
    Exit;
  end;

  //新增
  AIntfItem.AddRecord(AIntfItem.DBModule,
                      nil,
                      '',
                      ASuperObject,
                      nil,
                      ACode,
                      ADesc,
                      ADataJson
                      );





  //上传成功
  Result:=True;
end;

function ProcessUploadFileRequest(RequestStream:TStream;var ADesc:String;var ADataJson:ISuperObject):Boolean;
var
  AFileExt:String;
  ARemoteFilePath:String;

  ACode:Integer;
//  ADesc:String;
//  ADataJson:ISuperObject;

  AMimeDecoder:TIdMessageDecoderMIME;
  AMemoryStream:TMemoryStream;
  AName:String;
//  AStartIndex:Integer;
  msgEnd:Boolean;
  AMimeFileName:String;
  ASheetFormatList:ISuperArray;
  AStringStream:TStringStream;

  AMetaData:String;
  ABucketName:String;
  AData:String;
  AIntfItem:TCommonRestIntfItem;

  ASuperObject:ISuperObject;
  AFileSize:Integer;
  AFileName:String;
begin

  //上传文件
  ACode:=FAIL;
  ADesc:='';
  ADataJson:=nil;




      //------WebKitFormBoundaryq4GqiQCROcAGnVty
      //Content-Disposition: form-data; name="object"; filename="26_index_preview.png"
      //Content-Type: image/png


      AFileSize:=0;
      AMemoryStream:=TMemoryStream.Create;
      AMimeDecoder := TIdMessageDecoderMIME.Create(nil);
      try
        AMimeDecoder.SourceStream:=RequestStream;
        AMimeDecoder.FreeSourceStream:=False;
        //一定要设置MIMEBoundary,不然ReadBody会结束不了,死循环
        TIdMessageDecoderMIME(AMimeDecoder).MIMEBoundary := Copy(AMimeDecoder.ReadLn(),3,MaxInt);
        AMimeDecoder.ReadHeader;
        repeat
//          case AMimeDecoder.PartType of
//            mcptText:
//            begin
              //取到参数json
              AStringStream:=TStringStream.Create('',TEncoding.UTF8);
              try
                AMimeDecoder.ReadBody(AStringStream,msgEnd);

                GetMimeDecoderParam(AMimeDecoder,AName,AMimeFileName);
                if AName='metadata' then
                begin
                  AMetaData:=Trim(AStringStream.DataString);
                end;
                if AName='bucketName' then
                begin
                  ABucketName:=Trim(AStringStream.DataString);
                end;
                if AName='data' then
                begin
                  AData:=Trim(AStringStream.DataString);
                end;
                if AName='file' then
                begin

                  AFileName:=AMimeFileName;
                  AFileExt:=ExtractFileExt(AMimeFileName);

                  AFileSize:=AStringStream.Size;

                  //保存成文件
                  ARemoteFilePath:='';
                  if ProcessUploadFile(GetApplicationPath,//ExtractFilePath(Application.ExeName),
                                       '',
                                       AFileName,
                                       AFileExt,
                                       ABucketName+PathDelim,
                                       AStringStream,
                                       ARemoteFilePath,
                                       ACode,
                                       ADesc) then
                  begin
                    //上传成功
                  end;

                end;



//                ASheetFormatList:=SA(AStringStream.DataString);
              finally
                FreeAndNil(AStringStream);
              end;




          if AMimeDecoder.PartType<>mcptEOF then
          begin
            AMimeDecoder.Headers.Clear;
            AMimeDecoder.ReadHeader;
          end;

          if AMimeDecoder.Headers.Count=0 then
          begin
            break;
          end;



        until AMimeDecoder.PartType=mcptEOF;



        ASuperObject:=SO();
        ASuperObject.S['_id']:=CreateGUIDString;
        ASuperObject.S['teamId']:='';
        ASuperObject.S['tmbId']:='';
        ASuperObject.I['length']:=AFileSize;
        ASuperObject.I['chunkSize']:=261120;
        ASuperObject.S['filename']:=AFileName;
        ASuperObject.S['filepath']:=ARemoteFilePath;


        AIntfItem:=GlobalCommonRestIntfList.Find(ABucketName+'_files');
        if AIntfItem=nil then
        begin
          ADesc:='不存在'+ABucketName+'_files'+'接口';
          Exit;
        end;

        //新增
        AIntfItem.AddRecord(AIntfItem.DBModule,
                            nil,
                            '',
                            ASuperObject,
                            nil,
                            ACode,
                            ADesc,
                            ADataJson
                            );




      finally
        FreeAndNil(AMimeDecoder);
        FreeAndNil(AMemoryStream);
      end;

end;

end.
