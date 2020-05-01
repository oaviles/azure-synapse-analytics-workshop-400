EXECUTE AS USER = 'asa.sql.highperf'

IF OBJECT_ID(N'[wwi_perf].[Sale_Hash_Projection_Big2]', N'U') IS NOT NULL   
DROP TABLE [wwi_perf].[Sale_Hash_Projection_Big2] 

CREATE TABLE [wwi_perf].[Sale_Hash_Projection_Big2]
WITH
(
	DISTRIBUTION = HASH ( [CustomerId] ),
	CLUSTERED COLUMNSTORE INDEX
)
AS
SELECT
	[CustomerId]
	,CAST([ProductId] as bigint) as [ProductId]
	,CAST([Quantity] as bigint) as [Quantity]
FROM
	[wwi_perf].[Sale_Heap]