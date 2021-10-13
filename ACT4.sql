SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';


-- -----------------------------------------------------
-- Schema Service
-- -----------------------------------------------------

DROP SCHEMA IF EXISTS  `Service`;

-- -----------------------------------------------------
-- Schema Service
-- -----------------------------------------------------

CREATE SCHEMA IF NOT EXISTS `Service` DEFAULT CHARACTER SET utf8;
USE `Service`;

-- -----------------------------------------------------
-- TABLAS SIMPLES
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Table `Service`.`Localidad`
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS `Service`.`Localidad`
(
`IdLocalidad` INT NOT NULL AUTO_INCREMENT,
`Localidad` VARCHAR(45) NOT NULL UNIQUE,
PRIMARY KEY (`IdLocalidad`)
);

-- -----------------------------------------------------
-- Table `Service`.`Empresa`
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS `Service`.`Empresa`
(
`CUIT` INT(13) NOT NULL UNIQUE,
`Empresa`VARCHAR(45) NOT NULL UNIQUE,
PRIMARY KEY (`CUIT`),
CHECK(`CUIT` > 00000000000 AND `CUIT` < 99999999999)
);

-- -----------------------------------------------------
-- Table `Service`.`Telefono`
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS `Service`.`Telefono`
(
`IdTelefono` INT NOT NULL AUTO_INCREMENT,
`Telefono` INT NOT NULL UNIQUE,
PRIMARY KEY (`IdTelefono`),
CHECK(`Telefono` >= 0000000)
);

-- -----------------------------------------------------
-- Table `Service`.`TipoEquipo`
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS `Service`.`TipoEquipo`
(
`IdTipoEquipo` INT NOT NULL AUTO_INCREMENT,
`Tipo` VARCHAR(45) NOT NULL,
`Modelo` VARCHAR(45) NOT NULL UNIQUE,
PRIMARY KEY (`IdTipoEquipo`),
CHECK(`Tipo` LIKE 'MACKBOOK' OR 'IPHONE' OR 'IPAD')
);

-- -----------------------------------------------------
-- Table `Service`.`Item`
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS `Service`.`Item`
(
`IdItem` INT NOT NULL AUTO_INCREMENT,
`Descripcion` VARCHAR(200) NOT NULL UNIQUE,
`Valor` DECIMAL (5,2) NOT NULL,
PRIMARY KEY (`IdItem`),
CHECK(`Valor` > 0)
);

-- -----------------------------------------------------
-- Table `Service`.`TipoFactura`
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS `Service`.`TipoFactura`
(
`IdTipoFactura` INT NOT NULL AUTO_INCREMENT,
`TipoFactura` ENUM('A','B','C'),
PRIMARY KEY (`IdTipoFactura`)
);

-- -----------------------------------------------------
-- Table `Service`.`FormaPago`
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS `Service`.`FormaPago`
(
`IdFormaPago` INT NOT NULL AUTO_INCREMENT,
`FormaPago` ENUM('Tarjeta', 'Deposito', 'Transferencia', 'Efectivo', 'Cheque', 'Pagare') NOT NULL,
PRIMARY KEY (`IdFormaPago`)
);

-- -----------------------------------------------------
-- Table `Service`.`ConfirmacionOrden`
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS `Service`.`ConfirmacionOrden`
(
`IdConfirmacionOrden` INT NOT NULL AUTO_INCREMENT,
`Confirmacion` ENUM('Si','No'),
PRIMARY KEY (`IdConfirmacionOrden`)
);

-- -----------------------------------------------------
-- TABLAS COMPLEJAS
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Table `Service`.`OrdenTrabajo`
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS `Service`.`OrdenTrabajo`
(
`NumeroOrden` INT NOT NULL AUTO_INCREMENT,
`Fecha` DATE NOT NULL,
`Cliente_Tipo` ENUM('DNI','LC','LE') NOT NULL,
`Cliente_DNI` INT(8) NOT NULL,
`ConfirmacionOrden_IdConfirmacionOrden` INT NOT NULL,
PRIMARY KEY (`NumeroOrden`),
CONSTRAINT `fk_OrdenTrabajo_Cliente1`
	FOREIGN KEY (`Cliente_Tipo`,`Cliente_DNI`)
	REFERENCES `Service`.`Cliente`(`Tipo`,`DNI`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
CONSTRAINT `fk_OrdenTrabajo_Confirmado1`
	FOREIGN KEY (`ConfirmacionOrden_IdConfirmacionOrden`)
	REFERENCES `Service`.`ConfirmacionOrden`(`IdConfirmacionOrden`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE
);

-- -----------------------------------------------------
-- Table `Service`.`Cliente`
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS `Service`.`Cliente`
(
`Tipo` ENUM('DNI','LC','LE') NOT NULL,
`DNI` INT(8) NOT NULL,
`Apellido` VARCHAR(45) NOT NULL,
`Nombre` VARCHAR(45) NOT NULL,
`Localidad_IdLocalidad` INT NOT NULL,
PRIMARY KEY (`Tipo`,`DNI`),
CONSTRAINT `CHECK_DNI`
	CHECK(`DNI` > 0000000 AND `DNI` < 99999999),
CONSTRAINT `fk_Cliente_Localidad1`
	FOREIGN KEY (`Localidad_IdLocalidad`)
	REFERENCES `Service`.`Localidad`(`IdLocalidad`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);

-- -----------------------------------------------------
-- Table `Service`.`Equipo`
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS `Service`.`Equipo`
(
`IdEquipo` INT NOT NULL AUTO_INCREMENT,
`NumeroSerie` VARCHAR(45) NOT NULL,
`AñoFabricacion` YEAR(4),
`FechaAlta` DATE NOT NULL,
`Cliente_Tipo` ENUM('DNI','LC','LE') NOT NULL,
`Cliente_DNI` INT(8) NOT NULL,
`TipoEquipo_IdTipoEquipo` INT NOT NULL,
PRIMARY KEY (`IdEquipo`),
CONSTRAINT `fk_Equipo_Cliente1`
	FOREIGN KEY (`Cliente_Tipo`,`Cliente_DNI`)
	REFERENCES `Service`.`Cliente`(`Tipo`,`DNI`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
CONSTRAINT `fk_Equipo_TipoEquipo1`
	FOREIGN KEY (`TipoEquipo_IdTipoEquipo`)
	REFERENCES `Service`.`TipoEquipo`(`IdTipoEquipo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);

-- -----------------------------------------------------
-- Table `Service`.`Factura`
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS `Service`.`Factura`
(
`NumeroFactura` INT NOT NULL AUTO_INCREMENT,
`Fecha` DATE NOT NULL,
`Cliente_Tipo` ENUM('DNI','LC','LE') NOT NULL,
`Cliente_DNI` INT(8) NOT NULL,
`OrdenTrabajo_NumeroOrden` INT NOT NULL,
`FormaPago_IdFormaPago` INT NOT NULL,
`TipoFactura_IdTipoFactura` INT NOT NULL,
PRIMARY KEY (`NumeroFactura`),
CONSTRAINT `fk_Factura_Cliente1`
	FOREIGN KEY (`Cliente_Tipo`,`Cliente_DNI`)
	REFERENCES `Service`.`Cliente`(`Tipo`,`DNI`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
CONSTRAINT `fk_Factura_OrdenTrabajo1`
	FOREIGN KEY (`OrdenTrabajo_NumeroOrden`)
	REFERENCES `Service`.`OrdenTrabajo`(`NumeroOrden`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
CONSTRAINT `fk_Factura_FormaPago1`
	FOREIGN KEY (`FormaPago_IdFormaPago`)
	REFERENCES `Service`.`FormaPago`(`IdFormaPago`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
CONSTRAINT `fk_Factura_TipoFactura`
	FOREIGN KEY (`TipoFactura_IdTipoFactura`)
	REFERENCES `Service`.`TipoFactura`(`IdTipoFactura`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);

-- -----------------------------------------------------
-- TABLAS RELACIONADAS
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Table `Service`.`Cliente_has_Telefono`
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS `Service`.`Cliente_has_Telefono`
(
`Cliente_Tipo` ENUM('DNI','LC','LE') NOT NULL,
`Cliente_DNI` INT(8) NOT NULL,
`Telefono_IdTelefono` INT NOT NULL,
CONSTRAINT `fk_Cliente_has_Telefono_Cliente1`
	FOREIGN KEY (`Cliente_Tipo`,`Cliente_DNI`)
	REFERENCES `Service`.`Cliente`(`Tipo`,`DNI`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
CONSTRAINT `fk_Cliente_has_Telefono_Telefono1`
	FOREIGN KEY (`Telefono_IdTelefono`)
	REFERENCES `Service`.`Telefono`(`IdTelefono`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);
-- -----------------------------------------------------
-- Table `Service`.`Cliente_has_Empresa`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Service`.`Cliente_has_Empresa`
(
`Cliente_Tipo` ENUM('DNI','LC','LE') NOT NULL,
`Cliente_DNI` INT(8) NOT NULL,
`Empresa_CUIT` INT(13) NOT NULL,
CONSTRAINT `fk_Cliente_has_Empresa_Cliente1`
	FOREIGN KEY (`Cliente_Tipo`,`Cliente_DNI`)
	REFERENCES `Service`.`Cliente`(`Tipo`,`DNI`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
CONSTRAINT `fk_Cliente_has_Empresa_Empresa1`
	FOREIGN KEY (`Empresa_CUIT`)
	REFERENCES `Service`.`Empresa`(`CUIT`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);

-- -----------------------------------------------------
-- Table `Service`.`Equipo_has_OrdenTrabajo`
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS `Service`.`OrdenTrabajo_has_Equipo`
(
`Equipo_IdEquipo` INT NOT NULL,
`OrdenTrabajo_NumeroOrden` INT NOT NULL,
CONSTRAINT `fk_OrdenTrabajo_has_Equipo_Equipo1`
	FOREIGN KEY (`Equipo_IdEquipo`)
	REFERENCES `Service`.`Equipo`(`IdEquipo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
CONSTRAINT `fk_OrdenTrabajo_has_Equipo_OrdenTrabajo1`
	FOREIGN KEY (`OrdenTrabajo_NumeroOrden`)
	REFERENCES `Service`.`OrdenTrabajo`(`NumeroOrden`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);

-- -----------------------------------------------------
-- Table `Service`.`OrdenTrabajo_has_OrdenTrabajo`
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS `Service`.`OrdenTrabajo_has_Item`
(
`Item_IdItem` INT NOT NULL,
`OrdenTrabajo_NumeroOrden` INT NOT NULL,
CONSTRAINT `fk_OrdenTrabajo_has_Item_Item1`
	FOREIGN KEY (`Item_IdItem`)
	REFERENCES `Service`.`Item`(`IdItem`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
CONSTRAINT `fk_OrdenTrabajo_has_Item_NumeroOrden1`
	FOREIGN KEY (`OrdenTrabajo_NumeroOrden`)
	REFERENCES `Service`.`OrdenTrabajo`(`NumeroOrden`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;