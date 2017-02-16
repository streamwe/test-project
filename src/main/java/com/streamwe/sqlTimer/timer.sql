set time_zone = '+8:00';  
set GLOBAL event_scheduler = 1;  
  
# 设置该事件使用或所属的数据库base数据库  
use test;  
  
# 如果原来存在该名字的任务计划则先删除  
drop event if exists ev1;  
  
# 设置分隔符为 '$$' ，mysql默认的语句分隔符为 ';' ，这样在后续的 create 到 end 这段代码都会看成是一条语句来执行  
DELIMITER $$  
# 创建计划任务，设置第一次执行时间为'2014-07-30 10:00:00'，并且每天执行一次  
create event ev1   
on schedule every 1 day starts timestamp '2017-01-06 11:32:00'  
#on schedule every 1 SECOND  
do  
  
# 开始该计划任务要做的事  
begin  
# do something 编写你的计划任务要做的事  
	drop table  if exists `aaa`;
	create table `aaa`(
	`id` int(11),
	`name` varchar(25)
	);
    INSERT aaa VALUES (3,'222');  
    INSERT aaa VALUES (2,'222');  
  
# 结束计划任务  
end $$  
  
# 将语句分割符设置回 ';'  
DELIMITER ; 

#或者把任务单独写出来

#查看event是否开启
show variables like '%sche%'; 
#将事件计划开启
set global event_scheduler =1;

#创建存储过程test
CREATE PROCEDURE test () 
BEGIN 
    INSERT aaa VALUES (3,'222'); 
END; 
#创建event e_test
create event if not exists e_test 
on schedule every 30 second 
on completion preserve 
do call test(); 

#关闭调度任务
alter event e_test ON 
COMPLETION PRESERVE DISABLE; 
#开户事件任务
alter event e_test ON 
COMPLETION PRESERVE ENABLE; 



#eg.

drop event if exists ev1;  
 
DELIMITER $$ 
create event ev1   
on schedule every 10 second starts timestamp '2017-01-06 14:25:00' 
do   
begin  
    drop table  if exists `tab1`;
  create table `tab1`(
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `name` varchar(25),
    primary key(`id`)
    );
    INSERT tab1 VALUES (3,'222');  
    INSERT tab1 VALUES (2,'222');  
end $$ 
DELIMITER; 

alter event ev2 ON 
COMPLETION PRESERVE DISABLE;

#创建存储过程test
drop PROCEDURE if EXISTS test;
CREATE PROCEDURE test () 
BEGIN 
    INSERT tab1(name) VALUES ('777'); 
END; 
#创建定时任务
drop event if  exists ev2;
create event if not exists ev2 
on schedule every 10 second 
on completion preserve 
do call test();

#查看已创建的定时任务
show EVENTS;

#例如查看存储过程myPro的创建语句
show create procedure test;

#查看已创建的存储过程
select `specific_name`  from MySQL.proc where `db` = 'test' and `type` = 'procedure';

#使用存储过程插入一万条数据
DELIMITER $$

DROP PROCEDURE IF EXISTS `proc_auto_insertdata`$$

CREATE PROCEDURE `proc_auto_insertdata`()
BEGIN
        
        DECLARE init_data INTEGER DEFAULT 1;
       
        WHILE init_data <= 10000 DO 
        
        INSERT INTO t_1 VALUES(init_data, CONCAT('测试', init_data), init_data + 10);
        
        SET init_data = init_data + 1;
        
        END WHILE; 

END$$

DELIMITER ;

CALL proc_auto_insertdata();







