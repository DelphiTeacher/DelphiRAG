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
    procedure add(AChunks:TStrings);
    procedure delete(AChunkId:String);
    function similaritySearch(ASearchRequest:TSearchRequest):TSearchResultList;
  end;

implementation

end.