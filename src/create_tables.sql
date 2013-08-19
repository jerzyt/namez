create table boys (
	name	varchar(30) not NULL,
	year	smallint not NULL,
	rank	smallint not NULL,
	count	smallint not NULL,
	pct		double precision not NULL,
	primary key (name, year)
);

create table girls (
	name	varchar(30) not NULL,
	year	smallint not NULL,
	rank	smallint not NULL,
	count	smallint not NULL,
	pct		double precision not NULL,
	primary key (name, year)
);
