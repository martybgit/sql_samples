IF NOT EXISTS ( SELECT  *
                FROM    sys.schemas
                WHERE   name = 'samples' ) 
EXEC('CREATE SCHEMA [samples] AUTHORIZATION [dbo]');

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE 
				CONSTRAINT_TYPE=	'FOREIGN KEY' AND 
				TABLE_SCHEMA=		'samples' AND 
				TABLE_NAME =		'orders' AND 
				CONSTRAINT_NAME =	'fk_product_id')
BEGIN EXEC('ALTER TABLE [samples].[orders] DROP CONSTRAINT [fk_product_id]') END

IF OBJECT_ID(N'samples.products', N'U') IS NOT NULL DROP TABLE samples.products;
create table samples.products(
	 product_id		int identity(1,1)	not null	primary key
	,[name]			varchar(50)			not null
	,[description]	varchar(300)		null
)

insert into samples.products
	 ([name])
values
	 ('apple')
	,('banana')
	,('pear')

/* ************************************************************************************ */

IF OBJECT_ID(N'samples.orders', N'U') IS NOT NULL DROP TABLE samples.orders;
create table samples.orders (
	 order_id       int identity(1,1)	not null	primary key
	,tran_id		int					not null
	,product_id		int					not null
	,quantity		int					not null
	,order_date		datetime			not null
	,line_price		numeric(18,2)		not null
)

ALTER TABLE samples.orders
ADD  
	CONSTRAINT [fk_product_id]                  FOREIGN KEY ([product_id])                   REFERENCES samples.products(product_id)

ALTER TABLE [samples].[orders] CHECK CONSTRAINT [fk_product_id]

insert into samples.orders
	 (tran_id,product_id,quantity,order_date,line_price)
values
	 (1, 1,2,'20150603',2.00)
	,(2, 1,3,'20150604',3.00)
	,(3, 1,5,'20150705',5.00)
	,(4, 1,1,'20150706',1.00)
	,(5, 1,1,'20150801',1.00)
	,(6, 1,1,'20150810',1.00)
	,(7, 1,2,'20150904',2.00)
	,(8, 1,2,'20150910',2.00)
	,(9, 1,2,'20150924',2.00)
	,(10,1,3,'20150925',3.00)
	,(11,1,7,'20151006',7.00)
	,(12,1,2,'20151001',2.00)
	,(13,1,9,'20151112',9.00)
	,(14,1,2,'20151204',2.00)
	,(15,1,2,'20151231',2.00)
	,(16,1,2,'20160104',2.00)
	,(17,1,3,'20160110',3.00)
	,(18,1,3,'20160124',3.00)
	,(19,1,3,'20160125',3.00)
	,(20,1,1,'20160125',1.00)
	,(21,1,5,'20160126',5.00)
	,(22,1,1,'20160126',1.00)
	,(23,1,2,'20160127',2.00)
	,(24,1,3,'20160127',3.00)
	,(25,1,3,'20160128',3.00)
	,(26,1,3,'20160129',3.00)
	,(27,1,1,'20160130',1.00)
	,(1,2,1,'20150603',1.00)
	,(2,2,1,'20150604',1.00)
	,(3,2,1,'20150705',1.00)
	,(11,2,2,'20150706',2.00)
	,(12,2,1,'20150801',1.00)
	,(10,2,1,'20150925',1.00)
	,(11,2,1,'20151006',1.00)
	,(12,2,1,'20151001',1.00)
	,(21,2,7,'20151112',7.00)
	,(22,2,3,'20151204',3.00)
	,(23,2,3,'20151230',3.00)
	,(16,2,2,'20160104',2.00)
	,(17,2,1,'20160110',1.00)
	,(18,2,1,'20160124',1.00)
	,(19,2,1,'20160125',1.00)
	,(24,2,5,'20160126',5.00)
	,( 6,3,1,'20150704',2.00)
	,( 7,3,1,'20150810',1.00)
	,( 8,3,1,'20150924',1.00)
	,( 9,3,1,'20151025',1.00)
	,(15,3,1,'20151123',1.00)
	,(16,3,1,'20160104',2.00)
	,(17,3,1,'20160110',1.00)
	,(18,3,1,'20160124',1.00)
	,(19,3,1,'20160125',1.00)
	,(25,3,1,'20160123',1.00)