unit TextSplitter;

interface

uses
  Classes,System.SysUtils, System.Generics.Collections;

type
  // 文档切片设置类
  TTextSplitterSetting = class
  private
    FChunkSize: Integer;
    FChunkOverlap: Integer;
    FSeparators: TStringList;
  public
    constructor Create;
    destructor Destroy; override;

    // 属性
    property ChunkSize: Integer read FChunkSize write FChunkSize;
    property ChunkOverlap: Integer read FChunkOverlap write FChunkOverlap;
    property Separators: TStringList read FSeparators;

  end;

  // 文档切片基类
  TTextSplitter = class abstract
  protected
    FSetting: TTextSplitterSetting;
  public
    constructor Create();
    destructor Destroy; override;

    // 属性
    property Setting: TTextSplitterSetting read FSetting;

    // 方法
    function Split(const Text: string): TStringList; virtual;abstract;

  end;

implementation

{ TTextSplitterSetting }

constructor TTextSplitterSetting.Create;
begin
  inherited Create;
  FChunkSize := 1000;
  FChunkOverlap := 0;
  FSeparators := TStringList.Create;

  // 初始化默认分隔符
  FSeparators.Add(#13#10);  // 换行符
  FSeparators.Add(#10);     // 换行符
  // FSeparators.Add(' ');     // 空格
  // FSeparators.Add('');      // 空字符串（最后的分隔符）
end;

destructor TTextSplitterSetting.Destroy;
begin
  FSeparators.Free;
  inherited Destroy;
end;

// procedure TTextSplitterSetting.SetChunkSize(Value: Integer);
// begin
//   if Value > 0 then
//     FChunkSize := Value
//   else
//     raise Exception.Create('ChunkSize must be greater than 0');
// end;

// procedure TTextSplitterSetting.SetChunkOverlap(Value: Integer);
// begin
//   if Value >= 0 then
//     FChunkOverlap := Value
//   else
//     raise Exception.Create('ChunkOverlap must be greater than or equal to 0');

//   if Value > FChunkSize then
//     raise Exception.Create('ChunkOverlap cannot be greater than ChunkSize');
// end;

//   procedure TTextSplitterSetting.AddSeparator(const Separator: string);
//   begin
//     if FSeparators.IndexOf(Separator) = -1 then
//       FSeparators.Add(Separator);
//   end;

//   procedure TTextSplitterSetting.ClearSeparators;
//   begin
//     FSeparators.Clear;
//   end;

//   function TTextSplitterSetting.Validate: Boolean;
//   begin
//     Result := (FChunkSize > 0) and (FChunkOverlap >= 0) and (FChunkOverlap <= FChunkSize);
//   end;

{ TTextSplitter }

constructor TTextSplitter.Create();
begin
  inherited Create;
  FSetting := TTextSplitterSetting.Create
end;

destructor TTextSplitter.Destroy;
begin
  FSetting.Free;
  inherited Destroy;
end;



end.
