-- increase the field length https://app.camunda.com/jira/browse/CAM-8177 --
DROP INDEX ACT_UNIQ_AUTH_USER;
DROP INDEX ACT_UNIQ_AUTH_GROUP;

ALTER TABLE ACT_RU_AUTHORIZATION
DROP COLUMN UNI_RESOURCE_ID_;

ALTER TABLE ACT_RU_AUTHORIZATION 
  ALTER COLUMN RESOURCE_ID_ 
  SET DATA TYPE varchar(255);

CALL Sysproc.admin_cmd ('REORG TABLE ACT_RU_AUTHORIZATION');
set integrity for ACT_RU_AUTHORIZATION off;

ALTER TABLE ACT_RU_AUTHORIZATION
 ADD COLUMN UNI_RESOURCE_ID_ varchar (255) not null generated always as (case when "RESOURCE_ID_" is null then "ID_" else "RESOURCE_ID_" end);

set integrity for ACT_RU_AUTHORIZATION immediate checked force generated;

create unique index ACT_UNIQ_AUTH_USER on ACT_RU_AUTHORIZATION(TYPE_,UNI_USER_ID_,RESOURCE_TYPE_,UNI_RESOURCE_ID_);
create unique index ACT_UNIQ_AUTH_GROUP on ACT_RU_AUTHORIZATION(TYPE_,UNI_GROUP_ID_,RESOURCE_TYPE_,UNI_RESOURCE_ID_);