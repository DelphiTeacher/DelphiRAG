unit VectorStore;

interface

uses
  System.SysUtils, System.Classes, System.Math, System.Generics.Collections, uBaseList;


type
  TSearchRequest = record
    Query: String;
    TopK: Integer;
    Threshold: Double;
    MaxTokens: Integer;
  end;

  // 搜索结果
  TSearchResult = class

  end;
  TSearchResultList=class(TBaseList)
  end;


  IVectorStore = interface
  private
  public
    procedure add(AChunks:TStrings);virtual;abstract;
    procedure delete(AChunkId:String);virtual;abstract;
    function similaritySearch(ASearchRequest:TSearchRequest):TSearchResultList;virtual;abstract;
  end;

implementation

end.