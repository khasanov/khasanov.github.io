Установка имени и электронной почты

$ git config --global user.name "Your Name"
$ git config --global user.email "your_email@whatever.com"
Окончания строк

linux:
$ git config --global core.autocrlf input
$ git config --global core.safecrlf true
windows:
$ git config --global core.autocrlf true
$ git config --global core.safecrlf true
Создание репозитория

$ git init
Добавление файлов в репозиторий

$ git add hello.cpp
$ git commit -m "First Commit"
Удаление файлов

$ git rm file_name
$ git commit -m "remove file_name"
Проверка состояния репозитория

$ git status
История изменений

$ git log
Новая ветка

$ git checkout -b new_branch_name
Возвращение к ветке

$ git checkout $ git checkout master
Слияние веток

$ git checkout branch_name$ git merge master
Или лучше так
$ git checkout master # переключились на бранч master
$ git merge bug1 # выполняем слияние с бранчем bug1
После успешного наложения всех изменений из бранча bug1 его можно безболезненно удалить командой
$ git branch -d bug1
Клонирование репозитория

$ git clone hello cloned_hello
Отправить изменения

$ git push origin repo-name
