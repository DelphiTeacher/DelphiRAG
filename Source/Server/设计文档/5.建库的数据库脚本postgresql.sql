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


	





-- 创建知识库文档集合表
CREATE TABLE dataset_collections (
    -- 主键字段
    _id VARCHAR(36) PRIMARY KEY,  -- guid字符串，使用VARCHAR(36)存储UUID
    parent_id VARCHAR(36),         -- 父目录ID
    team_id VARCHAR(36),           -- 租户ID
    tmb_id VARCHAR(36),            -- 用户ID
    dataset_id VARCHAR(36),        -- 所属知识库ID
    
    -- 基本属性字段
    type VARCHAR(45),              -- 类型：文件、链接、表名等
    name VARCHAR(45),              -- 文档名称
    create_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  -- 创建时间，默认当前时间
    update_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  -- 修改时间，默认当前时间
    forbid BOOLEAN DEFAULT FALSE,  -- 是否禁用，默认否
    
    -- 索引相关字段
    training_type VARCHAR(45),     -- 索引类型：分段、问答对
trainingType varchar(45) DEFAULT 'chunk',
chunkSettingMode varchar(45) DEFAULT 'auto',
chunkSplitMode varchar(45) DEFAULT 'size',  
    chunk_size INTEGER,            -- 分段大小
    index_size INTEGER,            -- 文本向量索引大小
    chunk_splitter VARCHAR(455),   -- 分段的自定义分隔符
    qa_prompt VARCHAR(455),        -- 自动生成问答对的提示词
    
    -- 标签和内容相关字段
    tags JSONB,                    -- 自定义标签，使用JSONB类型
    file_id VARCHAR(36),           -- 文档内容ID
    raw_text_length INTEGER,       -- 原始文本的长度
    hash_raw_text VARCHAR(45),     -- 原始文本的哈希值
    related_img_id VARCHAR(45),    -- 关联的图片ID
    
    -- 摘要相关字段
    summary VARCHAR(455),          -- 文档的内容摘要
    summary_gened BOOLEAN DEFAULT FALSE,  -- 内容摘要生成标识
    
    -- 实体抽取相关字段
    entity_reced BOOLEAN DEFAULT FALSE,   -- 是否执行过实体抽取任务
    entity_reced_time TIMESTAMP,          -- 实体抽取任务的执行时间
    
    -- 扩展字段
    xby_file_id VARCHAR(45),       -- 对应的院网文档ID
    
    -- 状态相关字段
    state VARCHAR(45) DEFAULT 'wait',     -- 任务状态：wait, processing, succ, fail
    progress INTEGER DEFAULT 0           -- 进度，默认0
    

);


-- 添加注释说明
COMMENT ON TABLE dataset_collections IS '知识库文档集合表';
COMMENT ON COLUMN dataset_collections._id IS '主键，guid字符串';
COMMENT ON COLUMN dataset_collections.parent_id IS '父目录ID';
COMMENT ON COLUMN dataset_collections.team_id IS '租户ID';
COMMENT ON COLUMN dataset_collections.tmb_id IS '用户ID';
COMMENT ON COLUMN dataset_collections.dataset_id IS '所属知识库ID';
COMMENT ON COLUMN dataset_collections.type IS '类型：文件、链接、表名等';
COMMENT ON COLUMN dataset_collections.name IS '文档名称';
COMMENT ON COLUMN dataset_collections.create_time IS '创建时间';
COMMENT ON COLUMN dataset_collections.update_time IS '修改时间';
COMMENT ON COLUMN dataset_collections.forbid IS '是否禁用';
COMMENT ON COLUMN dataset_collections.training_type IS '索引类型：分段(segment)还是问答对(qa)';
COMMENT ON COLUMN dataset_collections.trainingType IS '索引类型：chunk-分段, qa-问答对';
COMMENT ON COLUMN dataset_collections.chunkSettingMode IS '分片设置模式：auto-自动, custom-自定义';
COMMENT ON COLUMN dataset_collections.chunkSplitMode IS '分片类型：size-根据尺寸, char-根据分隔符';

COMMENT ON COLUMN dataset_collections.chunk_size IS '分段大小，如4096';
COMMENT ON COLUMN dataset_collections.index_size IS '文本向量索引大小，不能超过向量模型支持的tokens，如512,1024';
COMMENT ON COLUMN dataset_collections.chunk_splitter IS '分段的自定义分隔符';
COMMENT ON COLUMN dataset_collections.qa_prompt IS '自动生成问答对的提示词';
COMMENT ON COLUMN dataset_collections.tags IS '自定义标签，JSON格式';
COMMENT ON COLUMN dataset_collections.file_id IS '文档内容ID';
COMMENT ON COLUMN dataset_collections.raw_text_length IS '原始文本的长度';
COMMENT ON COLUMN dataset_collections.hash_raw_text IS '原始文本的哈希值';
COMMENT ON COLUMN dataset_collections.related_img_id IS '关联的图片ID';
COMMENT ON COLUMN dataset_collections.summary IS '文档的内容摘要';
COMMENT ON COLUMN dataset_collections.summary_gened IS '内容摘要是否生成';
COMMENT ON COLUMN dataset_collections.entity_reced IS '是否执行过实体抽取任务';
COMMENT ON COLUMN dataset_collections.entity_reced_time IS '实体抽取任务的执行时间';
COMMENT ON COLUMN dataset_collections.xby_file_id IS '对应的院网文档ID';
COMMENT ON COLUMN dataset_collections.state IS '任务的状态：wait(等待), processing(处理中), succ(成功), fail(失败)';
COMMENT ON COLUMN dataset_collections.progress IS '进度(0-100)';









-- 创建图片表
CREATE TABLE images (
    _id VARCHAR(32) PRIMARY KEY,  -- guid字符串，主键
    teamId VARCHAR(32) NOT NULL,  -- 租户ID，guid字符串
    filename VARCHAR(455),        -- 文档名称
    filepath VARCHAR(455),        -- 文档路径
    createTime TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  -- 创建时间，默认当前时间
    updateTime TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  -- 修改时间，默认当前时间
    metadata JSONB,                -- 元数据，使用JSONB类型以获得更好的性能
    mime VARCHAR(45),             -- 图片类型
    relatedId VARCHAR(32)          -- 所属的文档，guid字符串
);

-- 添加注释
COMMENT ON TABLE images IS '文档信息表';
COMMENT ON COLUMN images._id IS '主键，guid字符串';
COMMENT ON COLUMN images.teamId IS '租户ID，guid字符串';
COMMENT ON COLUMN images.filename IS '文档名称';
COMMENT ON COLUMN images.filepath IS '文档路径';
COMMENT ON COLUMN images.createTime IS '创建时间';
COMMENT ON COLUMN images.updateTime IS '修改时间';
COMMENT ON COLUMN images.metadata IS '元数据，JSON格式';
COMMENT ON COLUMN images.mime IS '图片类型';
COMMENT ON COLUMN images.relatedId IS '所属的文档，guid字符串';




-- 创建 buffer_rawtexts 表
CREATE TABLE buffer_rawtexts (
    -- 主键，使用UUID类型
    _id VARCHAR(36) PRIMARY KEY,
    
    -- 来源文件的ID，使用UUID类型
    source_id UUID NOT NULL,
    
    -- 解析出来的文本内容，使用TEXT类型存储大文本
    raw_text TEXT,
    
    -- 创建时间，带时区的时间戳
    create_time TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    
    -- 修改时间，带时区的时间戳
    update_time TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    
    -- 元数据，使用JSONB类型存储JSON数据（比JSON类型更高效）
    metadata JSONB DEFAULT '{}'::JSONB
);

-- 添加注释
COMMENT ON TABLE buffer_rawtexts IS '数据集解析文本表';

COMMENT ON COLUMN buffer_rawtexts._id IS '主键，使用UUID';
COMMENT ON COLUMN buffer_rawtexts.guid IS 'guid字符串';
COMMENT ON COLUMN buffer_rawtexts.source_id IS '来源文件的ID';
COMMENT ON COLUMN buffer_rawtexts.raw_text IS '解析出来的文本内容';
COMMENT ON COLUMN buffer_rawtexts.create_time IS '创建时间';
COMMENT ON COLUMN buffer_rawtexts.update_time IS '修改时间';
COMMENT ON COLUMN buffer_rawtexts.metadata IS '元数据，JSON格式';







-- 创建 Dataset_datas 表
CREATE TABLE IF NOT EXISTS dataset_datas (
    -- 主键
    _id VARCHAR(36) PRIMARY KEY,
    
    -- 租户ID
    teamId VARCHAR(36) NOT NULL,
    
    -- 知识库ID
    datasetId VARCHAR(36) NOT NULL,
    
    -- 文档ID
    collectionId VARCHAR(36) NOT NULL,
    
    -- 文档片段或问题
    q VARCHAR(4096),
    
    -- 问题答案
    a VARCHAR(4096),
    
    -- 全文检索
    fullTextToken VARCHAR(8192),
    
    -- 索引列表 - 使用TEXT类型存储JSON格式的索引数据
    indexes JSON,
    
    -- 片段顺序号
    chunkIndex INTEGER,
    
    -- 创建时间
    createTime TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- 修改时间
    updateTime TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- 任务的状态
    state VARCHAR(45) DEFAULT 'wait' CHECK (state IN ('wait', 'processing', 'succ', 'fail')),
    
    -- 进度
    progress INTEGER DEFAULT 0 CHECK (progress >= 0 AND progress <= 100)
);


-- 添加注释
COMMENT ON TABLE dataset_datas IS '数据集数据表';
COMMENT ON COLUMN dataset_datas._id IS '主键GUID';
COMMENT ON COLUMN dataset_datas.teamId IS '租户ID';
COMMENT ON COLUMN dataset_datas.datasetId IS '知识库ID';
COMMENT ON COLUMN dataset_datas.collectionId IS '文档ID';
COMMENT ON COLUMN dataset_datas.q IS '文档片段或问题';
COMMENT ON COLUMN dataset_datas.a IS '问题答案';
COMMENT ON COLUMN dataset_datas.fullTextToken IS '全文检索';
COMMENT ON COLUMN dataset_datas.indexes IS '索引列表，存储JSON格式的索引数据';
COMMENT ON COLUMN dataset_datas.chunkIndex IS '片段顺序号';
COMMENT ON COLUMN dataset_datas.createTime IS '创建时间';
COMMENT ON COLUMN dataset_datas.updateTime IS '修改时间';
COMMENT ON COLUMN dataset_datas.state IS '任务的状态：wait, processing, succ, fail';
COMMENT ON COLUMN dataset_datas.progress IS '进度0-100';








-- 创建向量扩展（如果尚未启用）
CREATE EXTENSION IF NOT EXISTS vector;

-- 创建modeldata表
CREATE TABLE modeldata (
    id SERIAL PRIMARY KEY,
    chunk TEXT NOT NULL,
    model VARCHAR(45),
    vector VECTOR,
    team_id VARCHAR(45),
    dataset_id VARCHAR(45),
    collection_id VARCHAR(45),
    createTime TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- 添加表注释
COMMENT ON TABLE modeldata IS '文档片段表';
COMMENT ON COLUMN modeldata.id IS '主键';
COMMENT ON COLUMN modeldata.chunk IS '文档片段';
COMMENT ON COLUMN modeldata.model IS '向量模型';
COMMENT ON COLUMN modeldata.vector IS '文本向量';
COMMENT ON COLUMN modeldata.team_id IS '租户ID';
COMMENT ON COLUMN modeldata.dataset_id IS '知识库ID';
COMMENT ON COLUMN modeldata.collection_id IS '文档ID';
COMMENT ON COLUMN modeldata.createTime IS '创建时间';




CREATE TABLE system_models (
    -- _id: 主键，使用GUID字符串 (PostgreSQL中通常使用UUID类型，但根据要求定义为字符串)
    -- 为了性能和存储，建议使用UUID类型，但若业务要求必须为字符串，则使用Varchar(32)或类似长度。
    -- 这里使用VARCHAR(36) 兼容带连字符的GUID格式 (例如: 550e8400-e29b-41d4-a716-446655440000)
    _id VARCHAR(36) PRIMARY KEY,
    
    -- model: 模型名称，非空，nvarchar(45) 对应PostgreSQL的VARCHAR(45)
    model VARCHAR(45) NOT NULL,
    
    -- metadata: 模型元数据，使用JSONB类型（推荐）以支持索引和高效查询
    -- 若必须为纯JSON（保留格式、键顺序等），可使用JSON类型，但JSONB功能更强大。
    metadata JSONB NOT NULL DEFAULT '{}',
    
    -- __v: 版本号，整数类型，用于乐观锁或版本控制
    __v INTEGER NOT NULL DEFAULT 1
);

-- 为表添加注释（可选，增强可读性）
COMMENT ON TABLE system_models IS '系统模型表，存储模型定义及元数据';
COMMENT ON COLUMN system_models._id IS '主键，GUID字符串';
COMMENT ON COLUMN system_models.model IS '模型名称，长度45字符';
COMMENT ON COLUMN system_models.metadata IS '模型元数据，JSONB格式，存储模型的详细配置信息';
COMMENT ON COLUMN system_models.__v IS '版本号，用于乐观锁或记录更新次数';






