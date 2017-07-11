# kuvera_assignment

dependencies:
	- mysql Ver 14.14 Distrib 5.7.12
	- rails 5.0.4
	- ruby 2.3.0

deployment instuction:
	1. change the username and password for database in config/database.yml
	2. run command in root directory: rake db:create:all   and rake db:migrate
	3. run command in root directory:   rails runner "Scheme.fetch_all_data"  , this will initlize the data. wait to complete the task
	4. run command: rails s
	5. access the website from localhost:3000
