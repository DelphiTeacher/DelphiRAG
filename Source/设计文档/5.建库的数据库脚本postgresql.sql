-- 创建知识库表
CREATE TABLE datasets (
    _id VARCHAR(36) PRIMARY KEY,  -- guid字符串，使用VARCHAR(36)存储UUID格式
    parentId VARCHAR(36),          -- 所在文件夹的guid
    teamId VARCHAR(36),            -- 租户ID
    tmbId VARCHAR(36),             -- 所属用户ID
    type VARCHAR(45),              -- 类型：文档、数据库、院网文档、网页链接等
    status VARCHAR(45),            -- 状态：active等
    avatar VARCHAR(455),           -- 图标路径或URL
    vectorModel VARCHAR(45),       -- 所用的向量模型
    agentModel VARCHAR(45),        -- 自动生成问答所使用的大语言模型
    intro VARCHAR(455),            -- 介绍
    inheritPermission BOOLEAN DEFAULT FALSE,  -- 权限设置，默认false
    updateTime TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  -- 更新时间，默认当前时间
    createtime TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  -- 创建时间，默认当前时间
    entityReced BOOLEAN DEFAULT FALSE,  -- 是否执行过文档的实体抽取任务，默认false
    summaryGened BOOLEAN DEFAULT FALSE,  -- 是否执行过文档的内容摘要生成，默认false
    collectionNamesStr VARCHAR(455)        -- 知识库包含的文档名称列表，用于显示或搜索，使用TEXT类型存储较长文本
    
);

-- 添加表注释
COMMENT ON TABLE datasets IS '知识库表';

-- 添加字段注释
COMMENT ON COLUMN datasets._id IS '主键guid字符串';
COMMENT ON COLUMN datasets.parentId IS '所在文件夹的guid';
COMMENT ON COLUMN datasets.teamId IS '租户ID';
COMMENT ON COLUMN datasets.tmbId IS '所属用户ID';
COMMENT ON COLUMN datasets.type IS '类型：文档、数据库、院网文档、网页链接等（用于自动同步）';
COMMENT ON COLUMN datasets.status IS '状态：active等';
COMMENT ON COLUMN datasets.avatar IS '图标';
COMMENT ON COLUMN datasets.vectorModel IS '所用的向量模型';
COMMENT ON COLUMN datasets.agentModel IS '自动生成问答所使用的大语言模型';
COMMENT ON COLUMN datasets.intro IS '介绍';
COMMENT ON COLUMN datasets.inheritPermission IS '权限设置';
COMMENT ON COLUMN datasets.updateTime IS '更新时间';
COMMENT ON COLUMN datasets.createtime IS '创建时间';
COMMENT ON COLUMN datasets.entityReced IS '是否执行过文档的实体抽取任务';
COMMENT ON COLUMN datasets.summaryGened IS '是否执行过文档的内容摘要生成';
COMMENT ON COLUMN datasets.collectionNamesStr IS '知识库包含的文档名称列表，仅用于显示或者搜索';


	











-- 创建dataset_files表（包含metadata字段）
CREATE TABLE dataset_files (
    -- 主键
    _id VARCHAR(36) PRIMARY KEY,
    
    -- 租户ID
    teamId VARCHAR(36) NOT NULL,
    
    -- 用户ID
    tmbId VARCHAR(36) NOT NULL,
    
    -- 文件大小
    length INTEGER NOT NULL,
    
    -- 分段大小
    chunkSize INTEGER NOT NULL,
    
    -- 文档名称
    filename VARCHAR(455) NOT NULL,
    
    -- 文档路径
    filepath VARCHAR(455) NOT NULL,
    
    -- 元数据（JSON格式）
    metadata JSONB,
    
    -- 创建时间
    createTime TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    
    -- 修改时间
    updateTime TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- 添加注释
COMMENT ON TABLE dataset_files IS '数据集文件表';
COMMENT ON COLUMN dataset_files._id IS '主键GUID';
COMMENT ON COLUMN dataset_files.teamId IS '租户ID';
COMMENT ON COLUMN dataset_files.tmbId IS '用户ID';
COMMENT ON COLUMN dataset_files.length IS '文件大小';
COMMENT ON COLUMN dataset_files.chunkSize IS '分段大小';
COMMENT ON COLUMN dataset_files.filename IS '文档名称';
COMMENT ON COLUMN dataset_files.filepath IS '文档路径';
COMMENT ON COLUMN dataset_files.metadata IS '元数据，JSON格式';
COMMENT ON COLUMN dataset_files.createTime IS '创建时间';
COMMENT ON COLUMN dataset_files.updateTime IS '修改时间';


	















