#!/bin/bash
#
#  Songs to VK.com
#  Устанавливает проигрываемую в Audacious песню как статус в профиле VK
#  Version 0.3.1
#  
#  Copyright 2014 Konstantin Zyryanov <post.herzog@gmail.com>
#  
#  This program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU Lesser General Public License as published by
#  the Free Software Foundation; either version 2.1 of the License, or
#  (at your option) any later version.
#  
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU Lesser General Public License for more details.
#  
#  You should have received a copy of the GNU Lesser General Public License
#  along with this program; if not, write to the Free Software
#  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
#  MA 02110-1301, USA.
#  
#  

#Установка токена
#Про получение токена для доступа к приложению читайте в README
#Обязательно замените все строки "{TOKEN}" на полученный токен!
token={TOKEN};

#Проверка на повторный запуск
if [ `pgrep -fo songs_to_vk` -ne `pgrep -fn songs_to_vk` ]; then
	second_launch=1;
	else second_launch=0;
fi;
#Попытка считывания позиционных параметров
options=$#;
#Если скрипт уже запущен в другом терминале или в фоне,
#и текущий запуск производится без параметров - 
#вывод ошибки и выход
if [ $second_launch = 1 ] && [ $options = 0 ]; then
	echo "Скрипт уже запущен!";
	echo "Попробуйте запустить ещё раз с одним из параметров:";
	echo;
	echo  "$0 -q [ТЕКСТ] | --quit [ТЕКСТ]";
	echo "$0 -t [ТЕКСТ] | --text [ТЕКСТ]";
	echo "$0 -h | --help";
	echo;
	exit;
fi;

#Действия в случае присутствия позиционных параметров
if [ $options != 0 ]; then
	option=$1;
	case $option in

#Добавление текста ТЕКСТ к стандартному статусу,
#получаемому от "audtool --current-song"
	( -a | --append )
#Если скрипт уже запущен в другом терминале или в фоне - 
#получение PID ранее запущенного скрипта и его завершение
		if [ $second_launch = 1 ]; then
			pid_no=`pgrep -fo songs_to_vk`;
			kill $pid_no;
			sleep 1;
		fi;
#Проверка на наличие пользовательского текста
		shift;
		user_text="";
		while [ "$1" != "" ]; do
			user_text="$user_text $1";
			shift;
		done;
#Обработка текста пользовательского статуса
#Выделение частей, находящихся до и/или после стандартного
#(определяется по зарезервированному слову "song", если оно отсутствует -
#пользовательский статус по умолчанию предшествует стандартному)
		user_text_start=`echo $user_text| sed "s/\(.* *\)song\( *.*\)/\1/"`;
		if [ "`echo \"$user_text\"| grep song`" ]; then
			user_text_end=`echo $user_text| sed "s/\(.* *\)song\( *.*\)/\2/"`;
		fi;
		user_text_start_sed=`echo $user_text_start| sed 's/ /%20/g'`;
		user_text_end_sed=`echo $user_text_end| sed 's/ /%20/g'`;;
	
#Вывод справки и выход
	( -h | --help )
		echo "Устанавливает проигрываемую в Audacious песню как статус в профиле VK";
		echo "Использование: $0 [ПАРАМЕТР]";
		echo;
		echo " -a [ТЕКСТ], --append [ТЕКСТ]	добавление текста ТЕКСТ к стандартному статусу";
		echo "				получаемому от 'audtool --current-song'";
		echo "				(в случае отсутствия параметра ТЕКСТ -";
		echo "				сброс статуса на стандартный).";
		echo;
		echo "				ТЕКСТ может содержать зарезервированное слово";
		echo "				'song' (без кавычек), которое будет заменено";
		echo "				на стандартный статус, например:";
		echo "					Песня song интересная";
		echo "				будет заменено на:";
		echo "					Песня {ПРОИГРЫВАЕМАЯ ПЕСНЯ} интересная";
		echo;
		echo "				Для обрамления сообщений со знаками препинания";
		echo "				обязательно используйте кавычки '' или \"\".";
		echo;
		echo "				Имейте в виду, что VK.com ограничивает";
		echo "				размер сообщения статуса 140 символами.";
		echo;
		echo "				Внимание! Повторный запуск скрипта с этим";
		echo "				параметром завершит ранее запущенный экземпляр!";
		echo;
		echo " -h, --help			показать эту справку и выйти";
		echo;
		echo " -q [ТЕКСТ], --quit [ТЕКСТ]	завершение ранее запущенного скрипта";
		echo "				с опциональной установкой статуса ТЕКСТ.";
		echo "				Если до этого ни один экземпляр скрипта";
		echo "				не был запущен - установка статуса ТЕКСТ";
		echo "				и завершение работы";
		echo "				(аналогично параметру '-t ТЕКСТ').";
		echo;
		echo "				Для обрамления сообщений со знаками препинания";
		echo "				обязательно используйте кавычки '' или \"\".";
		echo;
		echo "				Имейте в виду, что VK.com ограничивает";
		echo "				размер сообщения статуса 140 символами.";
		echo;
		echo " -t [ТЕКСТ], --text [ТЕКСТ]	замена статуса на текст ТЕКСТ и выход.";
		echo "				В случае отсутствия параметра ТЕКСТ будет";
		echo "				отослана пустая строка";
		echo "				(сброс статуса на пустой).";
		echo;
		echo "				Для обрамления сообщений со знаками препинания";
		echo "				обязательно используйте кавычки '' или \"\".";
		echo;
		echo "				Имейте в виду, что VK.com ограничивает";
		echo "				размер сообщения статуса 140 символами.";
		echo;
		echo "				Внимание! Если до этого уже был запущен";
		echo "				и работает экземпляр скрипта,";
		echo "				то после очередной смены песни";
		echo "				статус сбросится на стандартный.";
		echo;
	exit;;
	
#Выход
	( -q | --quit )
#Проверка на наличие пользовательского текста
		shift;
		user_text="";
		while [ "$1" != "" ]; do
			user_text="$user_text $1";
			shift;
		done;
#Если скрипт уже запущен в другом терминале или в фоне
		if [ $second_launch = 1 ]; then
#Получение PID ранее запущенного скрипта и его завершение
			pid_no=`pgrep -fo songs_to_vk`;
			kill $pid_no;
			sleep 1;
#Если скрипт ещё не был запущен
		else
			echo "Внимание! Скрипт ещё не был запущен!";
			echo "Будет произведён выход с установкой следующего статуса:";
			echo "$user_text";
		fi;
#Установка статуса на пользовательский текст (если есть) и выход
		user_text_sed=`echo $user_text| sed 's/ /%20/g'`;
		response=`curl -s "https://api.vkontakte.ru/method/status.set?text=$user_text_sed&access_token=$token"`;
		exit;;
		
#Замена статуса на текст ТЕКСТ и выход
	( -t | --text )
#Проверка на наличие пользовательского текста,
#в случае отсутствия - отсылка пустой строки
		shift;
		user_text="";
		while [ "$1" != "" ]; do
			user_text="$user_text $1";
			shift;
		done;
		user_text_sed=`echo $user_text| sed 's/ /%20/g'`;
		response=`curl -s "https://api.vkontakte.ru/method/status.set?text=$user_text_sed&access_token=$token"`;
	exit;;

#Если в позиционных параметрах что-то другое - вывод краткой справки и выход
	*)
		echo "Использование:";
		echo;
		echo "$0 [-a [ТЕКСТ] | --append [ТЕКСТ]]";
		echo "$0 -q [ТЕКСТ] | --quit [ТЕКСТ] || -t [ТЕКСТ] | --text [ТЕКСТ]";
		echo "$0 -h | --help";
		echo;
		exit;;
	esac;
fi;

#Установка положительного ответа от сервера для последующей проверки
response='{"response":1}';
#Установка сообщения, отсылаемого в качестве статуса, в случае остановки/паузы плеера
#1. Используйте кавычки '' или "" для обрамления сообщений со знаками препинания!
#Например: "Я AFK", но: "'Я AFK!!!'".
#2. Ограничение на размер сообщения - 140 символов.
silence_status="AFK";
#Получение статуса плеера
play_status=`audtool --playback-status`;
#Получение названия текущей песни в плейлисте
song="`audtool --current-song`";
#Основной цикл
while [ "$response" = '{"response":1}' ]; do
#Проверка статуса плеера и, в случае тишины, установка соответствующего статуса в профиле VK
	if [ $play_status != "playing" ]; then
		user_status="$silence_status";
	else
		user_status="$user_text_start_sed $song $user_text_end_sed";
	fi;
#Удаление амперсандов из статуса
	user_status=`echo $user_status| sed 's/&/and/g'`;
#Удаление пробелов в отсылаемом статусе
	user_status_sed=`echo $user_status| sed 's/ /%20/g'`;
#Установка статуса через API VK
	response=`curl -s "https://api.vkontakte.ru/method/status.set?text=$user_status_sed&access_token=$token"`;
#Если плеер не играет - ожидание (проверка статуса плеера - каждые 10 секунд)
	while [ $play_status != "playing" ]; do
		sleep 10;
		play_status=`audtool --playback-status`;
	done;
#Запоминание предыдущей проигрываемой песни (если такая была)
	song_prev=$song;
#Пока не сменится песня или не перестанет играть плеер - ожидание
#(проверка названия проигрываемой песни и статуса плеера - каждые 10 секунд)
	while [ "$song" = "$song_prev" ] && [ $play_status = "playing" ]; do
		sleep 10;
		song="`audtool --current-song`";
		play_status=`audtool --playback-status`;
	done;
done;
#Если от сервера поступит не обычный ответ - прекращение работы
#и вывод ошибки с данным ответом
echo "Error:";
echo "$response";
#Если от сервера поступит не обычный ответ - прекращение работы
#и вывод ошибки с данным ответом в лог-файл
date >> songs_to_vk.log;
echo "Error:" >> songs_to_vk.log;
echo "$response" >> songs_to_vk.log;
echo "" >> songs_to_vk.log;
exit;
