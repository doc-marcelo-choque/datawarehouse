CREATE DATABASE [stage]
GO
USE [stage]
GO
CREATE SCHEMA [tienda_friki]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [tienda_friki].[cliente](
	[cliente_id] [bigint] NULL,
	[nombres] [varchar](max) NULL,
	[apellidos] [varchar](max) NULL,
	[email] [varchar](max) NULL,
	[telefono] [varchar](max) NULL,
	[fecha_nacimiento] [date] NULL,
	[genero] [varchar](max) NULL,
	[direccion] [varchar](max) NULL,
	[ciudad] [varchar](max) NULL,
	[departamento] [varchar](max) NULL,
	[pais] [varchar](max) NULL,
	[fecha_registro] [date] NULL,
	[activo] [bit] NULL,
	[fecha_creacion] [datetime] NULL,
	[fecha_modificacion] [datetime] NULL,
	[fecha_carga] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [tienda_friki].[detalle_venta]    Script Date: 2/10/2026 12:42:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [tienda_friki].[detalle_venta](
	[detalle_venta_id] [bigint] NULL,
	[venta_id] [bigint] NULL,
	[producto_id] [bigint] NULL,
	[cantidad] [bigint] NULL,
	[precio_unitario] [float] NULL,
	[costo_unitario] [float] NULL,
	[descuento] [float] NULL,
	[subtotal] [float] NULL,
	[fecha_creacion] [datetime] NULL,
	[fecha_carga] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [tienda_friki].[producto]    Script Date: 2/10/2026 12:42:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [tienda_friki].[producto](
	[producto_id] [bigint] NULL,
	[codigo] [varchar](max) NULL,
	[nombre] [varchar](max) NULL,
	[descripcion] [varchar](max) NULL,
	[categoria_id] [bigint] NULL,
	[subcategoria_id] [bigint] NULL,
	[franquicia_id] [bigint] NULL,
	[marca_id] [bigint] NULL,
	[proveedor_id] [bigint] NULL,
	[precio] [float] NULL,
	[costo] [float] NULL,
	[stock] [bigint] NULL,
	[stock_minimo] [bigint] NULL,
	[activo] [bit] NULL,
	[fecha_creacion] [datetime] NULL,
	[fecha_modificacion] [datetime] NULL,
	[fecha_carga] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [tienda_friki].[venta]    Script Date: 2/10/2026 12:42:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [tienda_friki].[venta](
	[venta_id] [bigint] NULL,
	[cliente_id] [float] NULL,
	[empleado_id] [float] NULL,
	[sucursal_id] [bigint] NULL,
	[metodo_pago_id] [bigint] NULL,
	[canal_venta_id] [bigint] NULL,
	[fecha_venta] [datetime] NULL,
	[subtotal] [float] NULL,
	[descuento] [float] NULL,
	[impuesto] [float] NULL,
	[total] [float] NULL,
	[estado] [varchar](max) NULL,
	[fecha_creacion] [datetime] NULL,
	[fecha_modificacion] [datetime] NULL,
	[fecha_carga] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO