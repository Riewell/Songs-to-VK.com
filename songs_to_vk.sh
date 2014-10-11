#!/bin/bash
#
#  Songs to VK.com
#  Устанавливает проигрываемую в Audacious песню как статус в профиле VK
#  Version 0.1
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

#Про получение токена для доступа к приложению читайте в README
#Обязательно замените все строки "{TOKEN}" на полученный токен!
token={TOKEN};
response='{"response":1}';
song="`audtool --current-song`";
play_status=`audtool --playback-status`;
while [ "$response" = '{"response":1}' ]; do
	if [ $play_status != "playing" ]; then
		song="Это сообщение означает, что никакая музыка у меня не играет - либо я AFK, либо развлекаюсь с Geany в тишине.";
	fi;
	song_sed=`echo $song| sed 's/ /%20/g'`;
	response=`curl -s "https://api.vkontakte.ru/method/status.set?text=$song_sed&access_token=$token"`;
	while [ $play_status != "playing" ]; do
		sleep 10;
		play_status=`audtool --playback-status`;
	done;
	song_prev=$song;
	while [ "$song" = "$song_prev" ] && [ $play_status = "playing" ]; do
		sleep 10;
		song="`audtool --current-song`";
		play_status=`audtool --playback-status`;
	done;
done;
