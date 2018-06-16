USE [InterviewPurpose]
GO

ALTER TABLE [dbo].[tbl_Product] DROP CONSTRAINT [DF_tbl_Product_ISDeleted]
GO

/****** Object:  Table [dbo].[tbl_Product]    Script Date: 6/17/2018 1:22:47 AM ******/
DROP TABLE [dbo].[tbl_Product]
GO

/****** Object:  Table [dbo].[tbl_Product]    Script Date: 6/17/2018 1:22:47 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[tbl_Product](
	[ID] [int] IDENTITY(101,1) NOT NULL,
	[ProductId]  AS ('PRDT'+right('000'+CONVERT([varchar](10),[ID],(0)),(10))) PERSISTED,
	[ProductName] [nvarchar](100) NULL,
	[Quantiy] [decimal](18, 2) NULL,
	[Price] [decimal](18, 2) NULL,
	[CreatedBY] [nvarchar](50) NOT NULL,
	[GrossPrice] [decimal](18, 0) NULL,
	[CreateOn] [datetime] NULL,
	[ISDeleted] [bit] NULL,
	[ModifiedoOn] [datetime] NULL,
 CONSTRAINT [PK__tbl_Prod__3214EC2789E05ED4] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[tbl_Product] ADD  CONSTRAINT [DF_tbl_Product_ISDeleted]  DEFAULT ((0)) FOR [ISDeleted]
GO


CREATE Function [dbo].[fnGrossPrice](
 @Quantity decimal(18,2),
 @Price decimal(18,2)
 )
 RETURNS DECIMAL(18,2)
 As Begin
 return 
 (Select  @Quantity*@Price
 where @Quantity>0 )
 End

GO




CREATE PROCEDURE [dbo].[SP_Delete_ProductByProductID]
@ProductId nvarchar(50)
As
BEGIN
 BEGIN TRY
Update tbl_Product
Set IsDeleted='true',
ModifiedoOn=GetDate()
where ProductId=@ProductId
END TRY
BEGIN CATCH
Declare @Error_Line int ,
		@Error_State int,
		@Error_Number int,
		@Error_Message nvarchar(100),
		@Error_Severity nvarchar(100),
		@Error_Prodcure nvarchar(100);
Select  @Error_Line=ERROR_LINE (),	
		@Error_State=ERROR_STATE(),
		@Error_Number=ERROR_NUMBER(),
		@Error_Message=ERROR_MESSAGE(),
		@Error_Severity=ERROR_SEVERITY(),
		@Error_Prodcure=ERROR_PROCEDURE();
RAISERROR(@Error_Line,@Error_State,@Error_Number,@Error_Message,@Error_Severity,@Error_Prodcure)
END CATCH
END



GO

/****** Object:  StoredProcedure [dbo].[Sp_GetProductById]    Script Date: 6/17/2018 1:27:33 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure  [dbo].[Sp_GetProductById]
@ProductId nvarchar(50)
AS
BEGIN
BEGIN TRY
SELECT  ID,ProductId,ProductName,Quantiy,Price,GrossPrice from
[dbo].[tbl_Product]
where 1=1 and ProductId=@ProductId and [ISDeleted]='false'
END TRY
BEGIN CATCH
DECLARE @ErrorMessage nvarchar(100),
		@ErrorSeverity nvarchar(50),
		@ErrorState int,
		@ErrorLine int,
		@ErrorProcedure nvarchar(100),
		@ErrorNumber int
		Select
		@ErrorMessage=ERROR_MESSAGE(),
		@ErrorSeverity=ERROR_SEVERITY(),
		@ErrorState=ERROR_STATE(),
		@ErrorProcedure=ERROR_PROCEDURE(),
		@ErrorNumber=ERROR_NUMBER ();
	   RAISERROR (@ErrorMessage,@ErrorSeverity,@ErrorState,@ErrorProcedure,@ErrorNumber);
 END CATCH
 END





GO

/****** Object:  StoredProcedure [dbo].[Sp_Product_Insert]    Script Date: 6/17/2018 1:27:33 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[Sp_Product_Insert]
@ProductName nvarchar(50),
@Quantiy decimal(18,2),
@price decimal(18,2),
@CreatedBY nvarchar(50)
 As 
 BEGIN
 SET NOCOUNT ON;
 BEGIN TRY
 INSERT INTO tbl_Product
 (ProductName,Quantiy,Price,CreateOn,CreatedBY,GrossPrice)values(@ProductName,@Quantiy,@price,GetDate(),@CreatedBY,[dbo].[fnGrossPrice](@Quantiy,@price))
 END try
 BEGIN Catch
 DECLARE @ErrorMessage nvarchar(100),
		@ErrorSeverity nvarchar(50),
		@ErrorState int,
		@ErrorLine int,
		@ErrorProcedure nvarchar(100),
		@ErrorNumber int
		Select
		@ErrorMessage=ERROR_MESSAGE(),
		@ErrorSeverity=ERROR_SEVERITY(),
		@ErrorState=ERROR_STATE(),
		@ErrorProcedure=ERROR_PROCEDURE(),
		@ErrorNumber=ERROR_NUMBER ();
	   RAISERROR (@ErrorMessage,@ErrorSeverity,@ErrorState,@ErrorProcedure,@ErrorNumber);
 END CATCH
 END


GO

/****** Object:  StoredProcedure [dbo].[Sp_UpdateProductByProductId]    Script Date: 6/17/2018 1:27:33 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[Sp_UpdateProductByProductId]
@ProductId nvarchar(50),
@ProductName Nvarchar(50),
@Quantiy decimal(18,2),
@Price decimal(18,2),
@CreatedBY nvarchar(50)
AS
SET NOCOUNT ON;
BEGIN
BEGIN TRY
Update  [dbo].[tbl_Product]
SET ProductName=@ProductName,
Quantiy=@Quantiy,
Price=@Price,
GrossPrice=[dbo].[fnGrossPrice](@Quantiy,@Price),
ModifiedoOn=Getdate()
WHERE ProductId=@ProductId 
END TRY
BEGIN CATCH
DECLARE @Error_Line int,
	    @Error_Message nvarchar(100),
		@Error_Severity nvarchar(52),
		@Error_Procedure nvarchar(50),
		@Error_Status_Code int
SELECT @Error_Line=ERROR_LINE(),
		@Error_Message=ERROR_MESSAGE(),
		@Error_Severity=ERROR_SEVERITY(),
		@Error_Status_Code=ERROR_STATE(),
		@Error_Procedure=ERROR_PROCEDURE();
RAISERROR(@Error_Line,@Error_Message,@Error_Severity,@Error_Procedure,@Error_Status_Code)
END CATCH
END
		
GO

