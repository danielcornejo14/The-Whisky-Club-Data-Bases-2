-- some text
-- HASHBYTES('MD4', 'password') funcion para guardar contraseñas
create table Mainframe_db.dbo.Administrator
(
    idAdministrator int identity
        primary key,
    emailAddress    varchar(320)   not null,
    userName        varchar(64)   not null,
    password        binary(64)    not null,
    name            varchar(64) not null,
    lastName1       varchar(64)   not null,
    lastName2       varchar(64)   not null,
    status          bit default 1 not null
)
