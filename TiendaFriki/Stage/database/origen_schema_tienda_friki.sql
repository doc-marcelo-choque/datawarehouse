--
-- PostgreSQL database dump
--

-- Dumped from database version 17.2
-- Dumped by pg_dump version 17.2

-- Started on 2026-09-18 11:14:14

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 6 (class 2615 OID 41786)
-- Name: tienda; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA tienda;


--
-- TOC entry 218 (class 1259 OID 41787)
-- Name: canal_venta; Type: TABLE; Schema: tienda; Owner: -
--

CREATE TABLE tienda.canal_venta (
    canal_venta_id integer NOT NULL,
    nombre character varying(50) NOT NULL,
    activo boolean DEFAULT true NOT NULL
);


--
-- TOC entry 219 (class 1259 OID 41791)
-- Name: canal_venta_canal_venta_id_seq; Type: SEQUENCE; Schema: tienda; Owner: -
--

ALTER TABLE tienda.canal_venta ALTER COLUMN canal_venta_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME tienda.canal_venta_canal_venta_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 220 (class 1259 OID 41792)
-- Name: categoria; Type: TABLE; Schema: tienda; Owner: -
--

CREATE TABLE tienda.categoria (
    categoria_id integer NOT NULL,
    nombre character varying(100) NOT NULL,
    descripcion character varying(250),
    activo boolean DEFAULT true NOT NULL,
    fecha_creacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    fecha_modificacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- TOC entry 221 (class 1259 OID 41798)
-- Name: categoria_categoria_id_seq; Type: SEQUENCE; Schema: tienda; Owner: -
--

ALTER TABLE tienda.categoria ALTER COLUMN categoria_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME tienda.categoria_categoria_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 222 (class 1259 OID 41799)
-- Name: cliente; Type: TABLE; Schema: tienda; Owner: -
--

CREATE TABLE tienda.cliente (
    cliente_id integer NOT NULL,
    nombres character varying(100) NOT NULL,
    apellidos character varying(100) NOT NULL,
    email character varying(150),
    telefono character varying(30),
    fecha_nacimiento date,
    genero character varying(30),
    direccion character varying(250),
    ciudad character varying(100),
    departamento character varying(100),
    pais character varying(100) DEFAULT 'Bolivia'::character varying,
    fecha_registro date DEFAULT CURRENT_DATE NOT NULL,
    activo boolean DEFAULT true NOT NULL,
    fecha_creacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    fecha_modificacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- TOC entry 223 (class 1259 OID 41809)
-- Name: cliente_cliente_id_seq; Type: SEQUENCE; Schema: tienda; Owner: -
--

ALTER TABLE tienda.cliente ALTER COLUMN cliente_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME tienda.cliente_cliente_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 224 (class 1259 OID 41810)
-- Name: compra; Type: TABLE; Schema: tienda; Owner: -
--

CREATE TABLE tienda.compra (
    compra_id bigint NOT NULL,
    proveedor_id integer NOT NULL,
    sucursal_id integer NOT NULL,
    fecha_compra timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    total numeric(14,2) DEFAULT 0 NOT NULL,
    estado character varying(30) DEFAULT 'RECIBIDA'::character varying NOT NULL,
    fecha_creacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    fecha_modificacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT compra_total_check CHECK ((total >= (0)::numeric))
);


--
-- TOC entry 225 (class 1259 OID 41819)
-- Name: compra_compra_id_seq; Type: SEQUENCE; Schema: tienda; Owner: -
--

ALTER TABLE tienda.compra ALTER COLUMN compra_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME tienda.compra_compra_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 226 (class 1259 OID 41820)
-- Name: detalle_compra; Type: TABLE; Schema: tienda; Owner: -
--

CREATE TABLE tienda.detalle_compra (
    detalle_compra_id bigint NOT NULL,
    compra_id bigint NOT NULL,
    producto_id integer NOT NULL,
    cantidad integer NOT NULL,
    costo_unitario numeric(12,2) NOT NULL,
    subtotal numeric(14,2) NOT NULL,
    CONSTRAINT detalle_compra_cantidad_check CHECK ((cantidad > 0)),
    CONSTRAINT detalle_compra_costo_unitario_check CHECK ((costo_unitario >= (0)::numeric)),
    CONSTRAINT detalle_compra_subtotal_check CHECK ((subtotal >= (0)::numeric))
);


--
-- TOC entry 227 (class 1259 OID 41826)
-- Name: detalle_compra_detalle_compra_id_seq; Type: SEQUENCE; Schema: tienda; Owner: -
--

ALTER TABLE tienda.detalle_compra ALTER COLUMN detalle_compra_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME tienda.detalle_compra_detalle_compra_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 228 (class 1259 OID 41827)
-- Name: detalle_venta; Type: TABLE; Schema: tienda; Owner: -
--

CREATE TABLE tienda.detalle_venta (
    detalle_venta_id bigint NOT NULL,
    venta_id bigint NOT NULL,
    producto_id integer NOT NULL,
    cantidad integer NOT NULL,
    precio_unitario numeric(12,2) NOT NULL,
    costo_unitario numeric(12,2) NOT NULL,
    descuento numeric(12,2) DEFAULT 0 NOT NULL,
    subtotal numeric(14,2) NOT NULL,
    fecha_creacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT detalle_venta_cantidad_check CHECK ((cantidad > 0)),
    CONSTRAINT detalle_venta_costo_unitario_check CHECK ((costo_unitario >= (0)::numeric)),
    CONSTRAINT detalle_venta_descuento_check CHECK ((descuento >= (0)::numeric)),
    CONSTRAINT detalle_venta_precio_unitario_check CHECK ((precio_unitario >= (0)::numeric)),
    CONSTRAINT detalle_venta_subtotal_check CHECK ((subtotal >= (0)::numeric))
);


--
-- TOC entry 229 (class 1259 OID 41837)
-- Name: detalle_venta_detalle_venta_id_seq; Type: SEQUENCE; Schema: tienda; Owner: -
--

ALTER TABLE tienda.detalle_venta ALTER COLUMN detalle_venta_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME tienda.detalle_venta_detalle_venta_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 230 (class 1259 OID 41838)
-- Name: empleado; Type: TABLE; Schema: tienda; Owner: -
--

CREATE TABLE tienda.empleado (
    empleado_id integer NOT NULL,
    nombres character varying(100) NOT NULL,
    apellidos character varying(100) NOT NULL,
    cargo character varying(100) NOT NULL,
    sucursal_id integer NOT NULL,
    fecha_ingreso date NOT NULL,
    salario numeric(12,2),
    activo boolean DEFAULT true NOT NULL,
    fecha_creacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    fecha_modificacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT empleado_salario_check CHECK (((salario IS NULL) OR (salario >= (0)::numeric)))
);


--
-- TOC entry 231 (class 1259 OID 41845)
-- Name: empleado_empleado_id_seq; Type: SEQUENCE; Schema: tienda; Owner: -
--

ALTER TABLE tienda.empleado ALTER COLUMN empleado_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME tienda.empleado_empleado_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 232 (class 1259 OID 41846)
-- Name: franquicia; Type: TABLE; Schema: tienda; Owner: -
--

CREATE TABLE tienda.franquicia (
    franquicia_id integer NOT NULL,
    nombre character varying(100) NOT NULL,
    empresa_propietaria character varying(150),
    pais_origen character varying(100),
    activo boolean DEFAULT true NOT NULL,
    fecha_creacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    fecha_modificacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- TOC entry 233 (class 1259 OID 41852)
-- Name: franquicia_franquicia_id_seq; Type: SEQUENCE; Schema: tienda; Owner: -
--

ALTER TABLE tienda.franquicia ALTER COLUMN franquicia_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME tienda.franquicia_franquicia_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 234 (class 1259 OID 41853)
-- Name: marca; Type: TABLE; Schema: tienda; Owner: -
--

CREATE TABLE tienda.marca (
    marca_id integer NOT NULL,
    nombre character varying(100) NOT NULL,
    pais_origen character varying(100),
    activo boolean DEFAULT true NOT NULL,
    fecha_creacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    fecha_modificacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- TOC entry 235 (class 1259 OID 41859)
-- Name: marca_marca_id_seq; Type: SEQUENCE; Schema: tienda; Owner: -
--

ALTER TABLE tienda.marca ALTER COLUMN marca_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME tienda.marca_marca_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 236 (class 1259 OID 41860)
-- Name: metodo_pago; Type: TABLE; Schema: tienda; Owner: -
--

CREATE TABLE tienda.metodo_pago (
    metodo_pago_id integer NOT NULL,
    nombre character varying(50) NOT NULL,
    activo boolean DEFAULT true NOT NULL
);


--
-- TOC entry 237 (class 1259 OID 41864)
-- Name: metodo_pago_metodo_pago_id_seq; Type: SEQUENCE; Schema: tienda; Owner: -
--

ALTER TABLE tienda.metodo_pago ALTER COLUMN metodo_pago_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME tienda.metodo_pago_metodo_pago_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 238 (class 1259 OID 41865)
-- Name: producto; Type: TABLE; Schema: tienda; Owner: -
--

CREATE TABLE tienda.producto (
    producto_id integer NOT NULL,
    codigo character varying(30) NOT NULL,
    nombre character varying(150) NOT NULL,
    descripcion character varying(500),
    categoria_id integer NOT NULL,
    subcategoria_id integer,
    franquicia_id integer,
    marca_id integer,
    proveedor_id integer,
    precio numeric(12,2) NOT NULL,
    costo numeric(12,2) NOT NULL,
    stock integer DEFAULT 0 NOT NULL,
    stock_minimo integer DEFAULT 5 NOT NULL,
    activo boolean DEFAULT true NOT NULL,
    fecha_creacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    fecha_modificacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT producto_costo_check CHECK ((costo >= (0)::numeric)),
    CONSTRAINT producto_precio_check CHECK ((precio >= (0)::numeric)),
    CONSTRAINT producto_stock_check CHECK ((stock >= 0))
);


--
-- TOC entry 239 (class 1259 OID 41878)
-- Name: producto_producto_id_seq; Type: SEQUENCE; Schema: tienda; Owner: -
--

ALTER TABLE tienda.producto ALTER COLUMN producto_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME tienda.producto_producto_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 240 (class 1259 OID 41879)
-- Name: proveedor; Type: TABLE; Schema: tienda; Owner: -
--

CREATE TABLE tienda.proveedor (
    proveedor_id integer NOT NULL,
    nombre character varying(150) NOT NULL,
    nit character varying(30),
    telefono character varying(30),
    email character varying(150),
    direccion character varying(250),
    ciudad character varying(100),
    pais character varying(100) DEFAULT 'Bolivia'::character varying,
    activo boolean DEFAULT true NOT NULL,
    fecha_creacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    fecha_modificacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- TOC entry 241 (class 1259 OID 41888)
-- Name: proveedor_proveedor_id_seq; Type: SEQUENCE; Schema: tienda; Owner: -
--

ALTER TABLE tienda.proveedor ALTER COLUMN proveedor_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME tienda.proveedor_proveedor_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 242 (class 1259 OID 41889)
-- Name: subcategoria; Type: TABLE; Schema: tienda; Owner: -
--

CREATE TABLE tienda.subcategoria (
    subcategoria_id integer NOT NULL,
    categoria_id integer NOT NULL,
    nombre character varying(100) NOT NULL,
    descripcion character varying(250),
    activo boolean DEFAULT true NOT NULL,
    fecha_creacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    fecha_modificacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- TOC entry 243 (class 1259 OID 41895)
-- Name: subcategoria_subcategoria_id_seq; Type: SEQUENCE; Schema: tienda; Owner: -
--

ALTER TABLE tienda.subcategoria ALTER COLUMN subcategoria_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME tienda.subcategoria_subcategoria_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 244 (class 1259 OID 41896)
-- Name: sucursal; Type: TABLE; Schema: tienda; Owner: -
--

CREATE TABLE tienda.sucursal (
    sucursal_id integer NOT NULL,
    nombre character varying(150) NOT NULL,
    direccion character varying(250),
    ciudad character varying(100) NOT NULL,
    departamento character varying(100) NOT NULL,
    telefono character varying(30),
    activo boolean DEFAULT true NOT NULL,
    fecha_creacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    fecha_modificacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- TOC entry 245 (class 1259 OID 41904)
-- Name: sucursal_sucursal_id_seq; Type: SEQUENCE; Schema: tienda; Owner: -
--

ALTER TABLE tienda.sucursal ALTER COLUMN sucursal_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME tienda.sucursal_sucursal_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 246 (class 1259 OID 41905)
-- Name: venta; Type: TABLE; Schema: tienda; Owner: -
--

CREATE TABLE tienda.venta (
    venta_id bigint NOT NULL,
    cliente_id integer,
    empleado_id integer,
    sucursal_id integer NOT NULL,
    metodo_pago_id integer NOT NULL,
    canal_venta_id integer NOT NULL,
    fecha_venta timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    subtotal numeric(14,2) DEFAULT 0 NOT NULL,
    descuento numeric(14,2) DEFAULT 0 NOT NULL,
    impuesto numeric(14,2) DEFAULT 0 NOT NULL,
    total numeric(14,2) DEFAULT 0 NOT NULL,
    estado character varying(30) DEFAULT 'COMPLETADA'::character varying NOT NULL,
    fecha_creacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    fecha_modificacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT venta_descuento_check CHECK ((descuento >= (0)::numeric)),
    CONSTRAINT venta_estado_check CHECK (((estado)::text = ANY (ARRAY[('PENDIENTE'::character varying)::text, ('COMPLETADA'::character varying)::text, ('CANCELADA'::character varying)::text, ('DEVUELTA'::character varying)::text]))),
    CONSTRAINT venta_impuesto_check CHECK ((impuesto >= (0)::numeric)),
    CONSTRAINT venta_subtotal_check CHECK ((subtotal >= (0)::numeric)),
    CONSTRAINT venta_total_check CHECK ((total >= (0)::numeric))
);


--
-- TOC entry 247 (class 1259 OID 41921)
-- Name: venta_venta_id_seq; Type: SEQUENCE; Schema: tienda; Owner: -
--

ALTER TABLE tienda.venta ALTER COLUMN venta_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME tienda.venta_venta_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 4780 (class 2606 OID 41923)
-- Name: canal_venta canal_venta_pkey; Type: CONSTRAINT; Schema: tienda; Owner: -
--

ALTER TABLE ONLY tienda.canal_venta
    ADD CONSTRAINT canal_venta_pkey PRIMARY KEY (canal_venta_id);


--
-- TOC entry 4784 (class 2606 OID 41925)
-- Name: categoria categoria_pkey; Type: CONSTRAINT; Schema: tienda; Owner: -
--

ALTER TABLE ONLY tienda.categoria
    ADD CONSTRAINT categoria_pkey PRIMARY KEY (categoria_id);


--
-- TOC entry 4788 (class 2606 OID 41927)
-- Name: cliente cliente_pkey; Type: CONSTRAINT; Schema: tienda; Owner: -
--

ALTER TABLE ONLY tienda.cliente
    ADD CONSTRAINT cliente_pkey PRIMARY KEY (cliente_id);


--
-- TOC entry 4793 (class 2606 OID 41929)
-- Name: compra compra_pkey; Type: CONSTRAINT; Schema: tienda; Owner: -
--

ALTER TABLE ONLY tienda.compra
    ADD CONSTRAINT compra_pkey PRIMARY KEY (compra_id);


--
-- TOC entry 4796 (class 2606 OID 41931)
-- Name: detalle_compra detalle_compra_pkey; Type: CONSTRAINT; Schema: tienda; Owner: -
--

ALTER TABLE ONLY tienda.detalle_compra
    ADD CONSTRAINT detalle_compra_pkey PRIMARY KEY (detalle_compra_id);


--
-- TOC entry 4799 (class 2606 OID 41933)
-- Name: detalle_venta detalle_venta_pkey; Type: CONSTRAINT; Schema: tienda; Owner: -
--

ALTER TABLE ONLY tienda.detalle_venta
    ADD CONSTRAINT detalle_venta_pkey PRIMARY KEY (detalle_venta_id);


--
-- TOC entry 4803 (class 2606 OID 41935)
-- Name: empleado empleado_pkey; Type: CONSTRAINT; Schema: tienda; Owner: -
--

ALTER TABLE ONLY tienda.empleado
    ADD CONSTRAINT empleado_pkey PRIMARY KEY (empleado_id);


--
-- TOC entry 4805 (class 2606 OID 41937)
-- Name: franquicia franquicia_pkey; Type: CONSTRAINT; Schema: tienda; Owner: -
--

ALTER TABLE ONLY tienda.franquicia
    ADD CONSTRAINT franquicia_pkey PRIMARY KEY (franquicia_id);


--
-- TOC entry 4809 (class 2606 OID 41939)
-- Name: marca marca_pkey; Type: CONSTRAINT; Schema: tienda; Owner: -
--

ALTER TABLE ONLY tienda.marca
    ADD CONSTRAINT marca_pkey PRIMARY KEY (marca_id);


--
-- TOC entry 4813 (class 2606 OID 41941)
-- Name: metodo_pago metodo_pago_pkey; Type: CONSTRAINT; Schema: tienda; Owner: -
--

ALTER TABLE ONLY tienda.metodo_pago
    ADD CONSTRAINT metodo_pago_pkey PRIMARY KEY (metodo_pago_id);


--
-- TOC entry 4820 (class 2606 OID 41943)
-- Name: producto producto_pkey; Type: CONSTRAINT; Schema: tienda; Owner: -
--

ALTER TABLE ONLY tienda.producto
    ADD CONSTRAINT producto_pkey PRIMARY KEY (producto_id);


--
-- TOC entry 4824 (class 2606 OID 41945)
-- Name: proveedor proveedor_pkey; Type: CONSTRAINT; Schema: tienda; Owner: -
--

ALTER TABLE ONLY tienda.proveedor
    ADD CONSTRAINT proveedor_pkey PRIMARY KEY (proveedor_id);


--
-- TOC entry 4828 (class 2606 OID 41947)
-- Name: subcategoria subcategoria_pkey; Type: CONSTRAINT; Schema: tienda; Owner: -
--

ALTER TABLE ONLY tienda.subcategoria
    ADD CONSTRAINT subcategoria_pkey PRIMARY KEY (subcategoria_id);


--
-- TOC entry 4832 (class 2606 OID 41949)
-- Name: sucursal sucursal_pkey; Type: CONSTRAINT; Schema: tienda; Owner: -
--

ALTER TABLE ONLY tienda.sucursal
    ADD CONSTRAINT sucursal_pkey PRIMARY KEY (sucursal_id);


--
-- TOC entry 4782 (class 2606 OID 41951)
-- Name: canal_venta uq_canal_venta_nombre; Type: CONSTRAINT; Schema: tienda; Owner: -
--

ALTER TABLE ONLY tienda.canal_venta
    ADD CONSTRAINT uq_canal_venta_nombre UNIQUE (nombre);


--
-- TOC entry 4786 (class 2606 OID 41953)
-- Name: categoria uq_categoria_nombre; Type: CONSTRAINT; Schema: tienda; Owner: -
--

ALTER TABLE ONLY tienda.categoria
    ADD CONSTRAINT uq_categoria_nombre UNIQUE (nombre);


--
-- TOC entry 4791 (class 2606 OID 41955)
-- Name: cliente uq_cliente_email; Type: CONSTRAINT; Schema: tienda; Owner: -
--

ALTER TABLE ONLY tienda.cliente
    ADD CONSTRAINT uq_cliente_email UNIQUE (email);


--
-- TOC entry 4807 (class 2606 OID 41957)
-- Name: franquicia uq_franquicia_nombre; Type: CONSTRAINT; Schema: tienda; Owner: -
--

ALTER TABLE ONLY tienda.franquicia
    ADD CONSTRAINT uq_franquicia_nombre UNIQUE (nombre);


--
-- TOC entry 4811 (class 2606 OID 41959)
-- Name: marca uq_marca_nombre; Type: CONSTRAINT; Schema: tienda; Owner: -
--

ALTER TABLE ONLY tienda.marca
    ADD CONSTRAINT uq_marca_nombre UNIQUE (nombre);


--
-- TOC entry 4815 (class 2606 OID 41961)
-- Name: metodo_pago uq_metodo_pago_nombre; Type: CONSTRAINT; Schema: tienda; Owner: -
--

ALTER TABLE ONLY tienda.metodo_pago
    ADD CONSTRAINT uq_metodo_pago_nombre UNIQUE (nombre);


--
-- TOC entry 4822 (class 2606 OID 41963)
-- Name: producto uq_producto_codigo; Type: CONSTRAINT; Schema: tienda; Owner: -
--

ALTER TABLE ONLY tienda.producto
    ADD CONSTRAINT uq_producto_codigo UNIQUE (codigo);


--
-- TOC entry 4826 (class 2606 OID 41965)
-- Name: proveedor uq_proveedor_nit; Type: CONSTRAINT; Schema: tienda; Owner: -
--

ALTER TABLE ONLY tienda.proveedor
    ADD CONSTRAINT uq_proveedor_nit UNIQUE (nit);


--
-- TOC entry 4830 (class 2606 OID 41967)
-- Name: subcategoria uq_subcategoria; Type: CONSTRAINT; Schema: tienda; Owner: -
--

ALTER TABLE ONLY tienda.subcategoria
    ADD CONSTRAINT uq_subcategoria UNIQUE (categoria_id, nombre);


--
-- TOC entry 4834 (class 2606 OID 41969)
-- Name: sucursal uq_sucursal_nombre; Type: CONSTRAINT; Schema: tienda; Owner: -
--

ALTER TABLE ONLY tienda.sucursal
    ADD CONSTRAINT uq_sucursal_nombre UNIQUE (nombre);


--
-- TOC entry 4839 (class 2606 OID 41971)
-- Name: venta venta_pkey; Type: CONSTRAINT; Schema: tienda; Owner: -
--

ALTER TABLE ONLY tienda.venta
    ADD CONSTRAINT venta_pkey PRIMARY KEY (venta_id);


--
-- TOC entry 4789 (class 1259 OID 41972)
-- Name: idx_cliente_ciudad; Type: INDEX; Schema: tienda; Owner: -
--

CREATE INDEX idx_cliente_ciudad ON tienda.cliente USING btree (ciudad);


--
-- TOC entry 4794 (class 1259 OID 41973)
-- Name: idx_compra_fecha; Type: INDEX; Schema: tienda; Owner: -
--

CREATE INDEX idx_compra_fecha ON tienda.compra USING btree (fecha_compra);


--
-- TOC entry 4797 (class 1259 OID 41974)
-- Name: idx_detalle_compra_producto; Type: INDEX; Schema: tienda; Owner: -
--

CREATE INDEX idx_detalle_compra_producto ON tienda.detalle_compra USING btree (producto_id);


--
-- TOC entry 4800 (class 1259 OID 41975)
-- Name: idx_detalle_venta_producto; Type: INDEX; Schema: tienda; Owner: -
--

CREATE INDEX idx_detalle_venta_producto ON tienda.detalle_venta USING btree (producto_id);


--
-- TOC entry 4801 (class 1259 OID 41976)
-- Name: idx_detalle_venta_venta; Type: INDEX; Schema: tienda; Owner: -
--

CREATE INDEX idx_detalle_venta_venta ON tienda.detalle_venta USING btree (venta_id);


--
-- TOC entry 4816 (class 1259 OID 41977)
-- Name: idx_producto_categoria; Type: INDEX; Schema: tienda; Owner: -
--

CREATE INDEX idx_producto_categoria ON tienda.producto USING btree (categoria_id);


--
-- TOC entry 4817 (class 1259 OID 41978)
-- Name: idx_producto_franquicia; Type: INDEX; Schema: tienda; Owner: -
--

CREATE INDEX idx_producto_franquicia ON tienda.producto USING btree (franquicia_id);


--
-- TOC entry 4818 (class 1259 OID 41979)
-- Name: idx_producto_proveedor; Type: INDEX; Schema: tienda; Owner: -
--

CREATE INDEX idx_producto_proveedor ON tienda.producto USING btree (proveedor_id);


--
-- TOC entry 4835 (class 1259 OID 41980)
-- Name: idx_venta_cliente; Type: INDEX; Schema: tienda; Owner: -
--

CREATE INDEX idx_venta_cliente ON tienda.venta USING btree (cliente_id);


--
-- TOC entry 4836 (class 1259 OID 41981)
-- Name: idx_venta_fecha; Type: INDEX; Schema: tienda; Owner: -
--

CREATE INDEX idx_venta_fecha ON tienda.venta USING btree (fecha_venta);


--
-- TOC entry 4837 (class 1259 OID 41982)
-- Name: idx_venta_sucursal; Type: INDEX; Schema: tienda; Owner: -
--

CREATE INDEX idx_venta_sucursal ON tienda.venta USING btree (sucursal_id);


--
-- TOC entry 4840 (class 2606 OID 41983)
-- Name: compra compra_proveedor_id_fkey; Type: FK CONSTRAINT; Schema: tienda; Owner: -
--

ALTER TABLE ONLY tienda.compra
    ADD CONSTRAINT compra_proveedor_id_fkey FOREIGN KEY (proveedor_id) REFERENCES tienda.proveedor(proveedor_id);


--
-- TOC entry 4841 (class 2606 OID 41988)
-- Name: compra compra_sucursal_id_fkey; Type: FK CONSTRAINT; Schema: tienda; Owner: -
--

ALTER TABLE ONLY tienda.compra
    ADD CONSTRAINT compra_sucursal_id_fkey FOREIGN KEY (sucursal_id) REFERENCES tienda.sucursal(sucursal_id);


--
-- TOC entry 4842 (class 2606 OID 41993)
-- Name: detalle_compra detalle_compra_compra_id_fkey; Type: FK CONSTRAINT; Schema: tienda; Owner: -
--

ALTER TABLE ONLY tienda.detalle_compra
    ADD CONSTRAINT detalle_compra_compra_id_fkey FOREIGN KEY (compra_id) REFERENCES tienda.compra(compra_id);


--
-- TOC entry 4843 (class 2606 OID 41998)
-- Name: detalle_compra detalle_compra_producto_id_fkey; Type: FK CONSTRAINT; Schema: tienda; Owner: -
--

ALTER TABLE ONLY tienda.detalle_compra
    ADD CONSTRAINT detalle_compra_producto_id_fkey FOREIGN KEY (producto_id) REFERENCES tienda.producto(producto_id);


--
-- TOC entry 4844 (class 2606 OID 42003)
-- Name: detalle_venta detalle_venta_producto_id_fkey; Type: FK CONSTRAINT; Schema: tienda; Owner: -
--

ALTER TABLE ONLY tienda.detalle_venta
    ADD CONSTRAINT detalle_venta_producto_id_fkey FOREIGN KEY (producto_id) REFERENCES tienda.producto(producto_id);


--
-- TOC entry 4845 (class 2606 OID 42008)
-- Name: detalle_venta detalle_venta_venta_id_fkey; Type: FK CONSTRAINT; Schema: tienda; Owner: -
--

ALTER TABLE ONLY tienda.detalle_venta
    ADD CONSTRAINT detalle_venta_venta_id_fkey FOREIGN KEY (venta_id) REFERENCES tienda.venta(venta_id);


--
-- TOC entry 4846 (class 2606 OID 42013)
-- Name: empleado empleado_sucursal_id_fkey; Type: FK CONSTRAINT; Schema: tienda; Owner: -
--

ALTER TABLE ONLY tienda.empleado
    ADD CONSTRAINT empleado_sucursal_id_fkey FOREIGN KEY (sucursal_id) REFERENCES tienda.sucursal(sucursal_id);


--
-- TOC entry 4847 (class 2606 OID 42018)
-- Name: producto producto_categoria_id_fkey; Type: FK CONSTRAINT; Schema: tienda; Owner: -
--

ALTER TABLE ONLY tienda.producto
    ADD CONSTRAINT producto_categoria_id_fkey FOREIGN KEY (categoria_id) REFERENCES tienda.categoria(categoria_id);


--
-- TOC entry 4848 (class 2606 OID 42023)
-- Name: producto producto_franquicia_id_fkey; Type: FK CONSTRAINT; Schema: tienda; Owner: -
--

ALTER TABLE ONLY tienda.producto
    ADD CONSTRAINT producto_franquicia_id_fkey FOREIGN KEY (franquicia_id) REFERENCES tienda.franquicia(franquicia_id);


--
-- TOC entry 4849 (class 2606 OID 42028)
-- Name: producto producto_marca_id_fkey; Type: FK CONSTRAINT; Schema: tienda; Owner: -
--

ALTER TABLE ONLY tienda.producto
    ADD CONSTRAINT producto_marca_id_fkey FOREIGN KEY (marca_id) REFERENCES tienda.marca(marca_id);


--
-- TOC entry 4850 (class 2606 OID 42033)
-- Name: producto producto_proveedor_id_fkey; Type: FK CONSTRAINT; Schema: tienda; Owner: -
--

ALTER TABLE ONLY tienda.producto
    ADD CONSTRAINT producto_proveedor_id_fkey FOREIGN KEY (proveedor_id) REFERENCES tienda.proveedor(proveedor_id);


--
-- TOC entry 4851 (class 2606 OID 42038)
-- Name: producto producto_subcategoria_id_fkey; Type: FK CONSTRAINT; Schema: tienda; Owner: -
--

ALTER TABLE ONLY tienda.producto
    ADD CONSTRAINT producto_subcategoria_id_fkey FOREIGN KEY (subcategoria_id) REFERENCES tienda.subcategoria(subcategoria_id);


--
-- TOC entry 4852 (class 2606 OID 42043)
-- Name: subcategoria subcategoria_categoria_id_fkey; Type: FK CONSTRAINT; Schema: tienda; Owner: -
--

ALTER TABLE ONLY tienda.subcategoria
    ADD CONSTRAINT subcategoria_categoria_id_fkey FOREIGN KEY (categoria_id) REFERENCES tienda.categoria(categoria_id);


--
-- TOC entry 4853 (class 2606 OID 42048)
-- Name: venta venta_canal_venta_id_fkey; Type: FK CONSTRAINT; Schema: tienda; Owner: -
--

ALTER TABLE ONLY tienda.venta
    ADD CONSTRAINT venta_canal_venta_id_fkey FOREIGN KEY (canal_venta_id) REFERENCES tienda.canal_venta(canal_venta_id);


--
-- TOC entry 4854 (class 2606 OID 42053)
-- Name: venta venta_cliente_id_fkey; Type: FK CONSTRAINT; Schema: tienda; Owner: -
--

ALTER TABLE ONLY tienda.venta
    ADD CONSTRAINT venta_cliente_id_fkey FOREIGN KEY (cliente_id) REFERENCES tienda.cliente(cliente_id);


--
-- TOC entry 4855 (class 2606 OID 42058)
-- Name: venta venta_empleado_id_fkey; Type: FK CONSTRAINT; Schema: tienda; Owner: -
--

ALTER TABLE ONLY tienda.venta
    ADD CONSTRAINT venta_empleado_id_fkey FOREIGN KEY (empleado_id) REFERENCES tienda.empleado(empleado_id);


--
-- TOC entry 4856 (class 2606 OID 42063)
-- Name: venta venta_metodo_pago_id_fkey; Type: FK CONSTRAINT; Schema: tienda; Owner: -
--

ALTER TABLE ONLY tienda.venta
    ADD CONSTRAINT venta_metodo_pago_id_fkey FOREIGN KEY (metodo_pago_id) REFERENCES tienda.metodo_pago(metodo_pago_id);


--
-- TOC entry 4857 (class 2606 OID 42068)
-- Name: venta venta_sucursal_id_fkey; Type: FK CONSTRAINT; Schema: tienda; Owner: -
--

ALTER TABLE ONLY tienda.venta
    ADD CONSTRAINT venta_sucursal_id_fkey FOREIGN KEY (sucursal_id) REFERENCES tienda.sucursal(sucursal_id);


-- Completed on 2026-09-18 11:14:14

--
-- PostgreSQL database dump complete
--

