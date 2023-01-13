SET DEFINE ON
DEFINE APPLICATION_NAME = 'UTL_CHECKDIGIT'
DEFINE DEPLOY_VERSION = '1'

SPOOL deploy.&&APPLICATION_NAME..log

--PRINT BIND VARIABLE VALUES
SET AUTOPRINT ON                    

--THE START COMMAND WILL LIST EACH COMMAND IN A SCRIPT
REM SET ECHO ON                         

--DISPLAY DBMS_OUTPUT.PUT_LINE OUTPUT
SET SERVEROUTPUT ON                 

--SHOW THE OLD AND NEW SETTINGS OF A SQLPLUS SYSTEM VARIABLE
REM SET SHOWMODE ON                     

--ALLOW BLANK LINES WITHIN A SQL COMMAND OR SCRIPT
--SET SQLBLANKLINES ON                

WHENEVER SQLERROR EXIT FAILURE
WHENEVER OSERROR EXIT FAILURE

EXEC PKG_APPLICATION.delete_application_p(ip_application_name => '&&APPLICATION_NAME', ip_fail_on_not_found => 'N' );
EXEC pkg_application.begin_deployment_p(ip_application_name => '&&APPLICATION_NAME', ip_version => &&DEPLOY_VERSION, ip_deployment_type => pkg_application.c_deploy_type_initial);
--
EXEC pkg_application.add_dependency_p  (ip_application_name => '&&APPLICATION_NAME', ip_depends_on => 'CORE');
--
--PACKAGE SPECS / PACKAGE BODIES
EXEC pkg_application.add_object_p(ip_application_name => '&&APPLICATION_NAME', ip_object_name => 'UTL_CHECKDIGIT'   , ip_object_type => pkg_application.c_object_type_package);
EXEC pkg_application.add_object_p(ip_application_name => '&&APPLICATION_NAME', ip_object_name => 'UTL_CHECKDIGIT'   , ip_object_type => pkg_application.c_object_type_package_body);
--
--VALIDATIONS
EXEC pkg_application.validate_dependencies_p(ip_application_name => '&&APPLICATION_NAME');
EXEC pkg_application.validate_obj_privs_p   (ip_application_name => '&&APPLICATION_NAME');
EXEC pkg_application.validate_sys_privs_p   (ip_application_name => '&&APPLICATION_NAME');

--Package Specifications
Prompt Creating Package Specifications
@@../Packages/utl_checkdigit.pks

--Package Bodies
Prompt Creating Package Bodies
@@../Packages/utl_checkdigit.pkb

SET DEFINE ON
EXEC pkg_application.validate_objects_p(ip_application_name => '&&APPLICATION_NAME');
EXEC pkg_application.set_deployment_complete_p(ip_application_name => '&&APPLICATION_NAME');

SPOOL OFF
