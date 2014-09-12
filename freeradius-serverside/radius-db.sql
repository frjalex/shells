-- phpMyAdmin SQL Dump
-- version 4.0.10.2
-- http://www.phpmyadmin.net
--
-- 主机: localhost
-- 生成日期: 2014-09-12 11:17:30
-- 服务器版本: 5.1.73
-- PHP 版本: 5.3.3

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";



/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- 数据库: `radius`
--
CREATE DATABASE IF NOT EXISTS `radius` DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci;
USE `radius`;

-- --------------------------------------------------------

--
-- 表的结构 `radacct`
--

DROP TABLE IF EXISTS `radacct`;
CREATE TABLE IF NOT EXISTS `radacct` (
  `radacctid` bigint(21) NOT NULL AUTO_INCREMENT,
  `acctsessionid` varchar(64) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `acctuniqueid` varchar(32) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `username` varchar(64) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `groupname` varchar(64) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `realm` varchar(64) COLLATE utf8_unicode_ci DEFAULT '',
  `nasipaddress` varchar(15) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `nasportid` varchar(15) COLLATE utf8_unicode_ci DEFAULT NULL,
  `nasporttype` varchar(32) COLLATE utf8_unicode_ci DEFAULT NULL,
  `acctstarttime` datetime DEFAULT NULL,
  `acctstoptime` datetime DEFAULT NULL,
  `acctsessiontime` int(12) DEFAULT NULL,
  `acctauthentic` varchar(32) COLLATE utf8_unicode_ci DEFAULT NULL,
  `connectinfo_start` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `connectinfo_stop` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `acctinputoctets` bigint(20) DEFAULT NULL,
  `acctoutputoctets` bigint(20) DEFAULT NULL,
  `calledstationid` varchar(50) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `callingstationid` varchar(50) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `acctterminatecause` varchar(32) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `servicetype` varchar(32) COLLATE utf8_unicode_ci DEFAULT NULL,
  `framedprotocol` varchar(32) COLLATE utf8_unicode_ci DEFAULT NULL,
  `framedipaddress` varchar(15) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `acctstartdelay` int(12) DEFAULT NULL,
  `acctstopdelay` int(12) DEFAULT NULL,
  `xascendsessionsvrkey` varchar(10) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`radacctid`),
  KEY `username` (`username`),
  KEY `framedipaddress` (`framedipaddress`),
  KEY `acctsessionid` (`acctsessionid`),
  KEY `acctsessiontime` (`acctsessiontime`),
  KEY `acctuniqueid` (`acctuniqueid`),
  KEY `acctstarttime` (`acctstarttime`),
  KEY `acctstoptime` (`acctstoptime`),
  KEY `nasipaddress` (`nasipaddress`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=35 ;


--
-- 表的结构 `radcheck`
--

DROP TABLE IF EXISTS `radcheck`;
CREATE TABLE IF NOT EXISTS `radcheck` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `username` varchar(64) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `attribute` varchar(64) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `op` char(2) COLLATE utf8_unicode_ci NOT NULL DEFAULT '==',
  `value` varchar(253) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `username` (`username`(32))
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=13 ;

--
-- 转存表中的数据 `radcheck`
--

INSERT INTO `radcheck` (`id`, `username`, `attribute`, `op`, `value`) VALUES
(1, 'test', 'Cleartext-Password', ':=', '!@#'),
(2, 'sense', 'User-Password', ':=', '!@#'),
(9, 'sense', 'Expiration', ':=', '06 Jun 2006 14:55:22'),
(6, 'test1', 'Cleartext-Password', ':=', '!@#'),
(12, 'sshuser', 'Cleartext-Password', ':=', 'sshuser!@#');

-- --------------------------------------------------------

--
-- 表的结构 `radgroupcheck`
--

DROP TABLE IF EXISTS `radgroupcheck`;
CREATE TABLE IF NOT EXISTS `radgroupcheck` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `groupname` varchar(64) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `attribute` varchar(64) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `op` char(2) COLLATE utf8_unicode_ci NOT NULL DEFAULT '==',
  `value` varchar(253) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `groupname` (`groupname`(32))
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=6 ;

--
-- 转存表中的数据 `radgroupcheck`
--

INSERT INTO `radgroupcheck` (`id`, `groupname`, `attribute`, `op`, `value`) VALUES
(3, 'user', 'Simultaneous-Use', ':=', '2'),
(2, 'daloRADIUS-Disabled-Users', 'Auth-Type', ':=', 'Reject'),
(4, 'user', 'Max-Monthly-Traffic', ':=', '10000000009'),
(5, 'user', 'Acct-Interim-Interval', ':=', '60');

-- --------------------------------------------------------

--
-- 表的结构 `radgroupreply`
--

DROP TABLE IF EXISTS `radgroupreply`;
CREATE TABLE IF NOT EXISTS `radgroupreply` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `groupname` varchar(64) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `attribute` varchar(64) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `op` char(2) COLLATE utf8_unicode_ci NOT NULL DEFAULT '=',
  `value` varchar(253) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `groupname` (`groupname`(32))
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=5 ;

--
-- 转存表中的数据 `radgroupreply`
--

INSERT INTO `radgroupreply` (`id`, `groupname`, `attribute`, `op`, `value`) VALUES
(1, 'user', 'Auth-Type', ':=', 'Local'),
(2, 'user', 'Service-Type', ':=', 'Framed-User'),
(3, 'user', 'Framed-IP-Address', ':=', '255.255.255.255'),
(4, 'user', 'Framed-IP-Netmask', ':=', '255.255.255.0');

-- --------------------------------------------------------

--
-- 表的结构 `radhuntgroup`
--

DROP TABLE IF EXISTS `radhuntgroup`;
CREATE TABLE IF NOT EXISTS `radhuntgroup` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `groupname` varchar(64) NOT NULL DEFAULT '',
  `nasipaddress` varchar(15) NOT NULL DEFAULT '',
  `nasportid` varchar(15) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `nasipaddress` (`nasipaddress`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `radreply`
--

DROP TABLE IF EXISTS `radreply`;
CREATE TABLE IF NOT EXISTS `radreply` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `username` varchar(64) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `attribute` varchar(64) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `op` char(2) COLLATE utf8_unicode_ci NOT NULL DEFAULT '=',
  `value` varchar(253) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `username` (`username`(32))
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `radusergroup`
--

DROP TABLE IF EXISTS `radusergroup`;
CREATE TABLE IF NOT EXISTS `radusergroup` (
  `username` varchar(64) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `groupname` varchar(64) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `priority` int(11) NOT NULL DEFAULT '1',
  KEY `username` (`username`(32))
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- 转存表中的数据 `radusergroup`
--

INSERT INTO `radusergroup` (`username`, `groupname`, `priority`) VALUES
('test', 'user', 0),
('sense', 'user', 1),
('test1', 'user', 0);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
