FROM ubuntu:16.04
MAINTAINER Loïc CORBASSON <loic.corbasson@gmail.com>

#ENV WINEDEBUG -all,err+all

USER root
COPY waitfor.sh /usr/local/bin/waitfor
RUN chmod +x /usr/local/bin/waitfor
RUN which waitfor
RUN apt-get update --assume-yes
RUN apt-get install --no-install-recommends --assume-yes software-properties-common \
	&& add-apt-repository --yes ppa:ubuntu-wine/ppa
RUN apt-get purge --assume-yes software-properties-common
RUN dpkg --add-architecture i386
RUN apt-get update --assume-yes
RUN apt-get install --no-install-recommends --assume-yes \
		bash \
		ca-certificates \
		libgl1-mesa-glx \
		libgl1-mesa-glx:i386 \
		libgnutls30 \
		libgnutls30:i386 \
		libxml2 \
		libxml2:i386 \
		timelimit \
		wget \
		winbind \
		wine \
		wine1.8 \
		winetricks \
		xdotool \
		xvfb
RUN ln -s /usr/lib/i386-linux-gnu/libgnutls.so.30 /usr/lib/i386-linux-gnu/libgnutls.so.28 
RUN ln -s /usr/lib/i386-linux-gnu/libgnutls.so.30 /usr/lib/i386-linux-gnu/libgnutls.so.26 
RUN apt-mark manual \
		bash \
		ca-certificates \
		libgl1-mesa-glx \
		libgl1-mesa-glx:i386 \
		libgnutls30 \
		libgnutls30:i386 \
		libxml2 \
		libxml2:i386 \
		timelimit \
		wget \
		winbind \
		wine \
		wine1.8 \
		winetricks \
		xdotool \
		xvfb
RUN apt-get autoclean --assume-yes \
	&& apt-get autoremove --assume-yes
RUN wget https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks -O /usr/local/bin/winetricks
RUN chmod +x /usr/local/bin/winetricks
RUN which winetricks

RUN groupadd --system sketchup && useradd --create-home --system --gid sketchup sketchup

USER sketchup
ENV HOME /home/sketchup
ENV WINEPREFIX /home/sketchup/.wine
ENV WINEARCH win32
WORKDIR /home/sketchup
RUN rm -rf /home/sketchup/.wine
RUN wine wineboot --init && waitfor sketchup wineserver && wine --version
RUN xvfb-run -a winetricks --unattended corefonts && waitfor sketchup wineserver
RUN xvfb-run -a winetricks --unattended msxml3 && waitfor sketchup wineserver
RUN xvfb-run -a winetricks --unattended ie6 && waitfor sketchup wineserver
RUN xvfb-run -a winetricks --unattended vcrun6 && waitfor sketchup wineserver
RUN xvfb-run -a winetricks --unattended vcrun2005 && waitfor sketchup wineserver
RUN xvfb-run -a winetricks --unattended vcrun2010 && waitfor sketchup wineserver
RUN xvfb-run -a winetricks --unattended dotnet40 && waitfor sketchup wineserver
COPY Wine-NotDecoratedByWindowManager.reg /home/sketchup/
RUN wine regedit Wine-NotDecoratedByWindowManager.reg && waitfor sketchup wineserver

USER sketchup
RUN xvfb-run -a winetricks --unattended sketchup && waitfor sketchup wineserver
COPY SketchUp8-HW_OK.reg /home/sketchup/
RUN wine regedit SketchUp8-HW_OK.reg && waitfor sketchup wineserver
COPY SketchUp8-Preferences.reg /home/sketchup/
RUN wine regedit SketchUp8-Preferences.reg && waitfor sketchup wineserver
RUN ln -s "/home/sketchup/.wine/drive_c/Program Files/Google/Google SketchUp 8/Components/Components Sampler" /home/sketchup/

USER root
COPY skp2dae.sh /usr/local/bin/skp2dae
RUN chmod +x /usr/local/bin/skp2dae
RUN which skp2dae

USER sketchup
COPY ImportExportQuit.tmpl.rb /home/sketchup/
VOLUME /home/sketchup/filestoconvert

WORKDIR /home/sketchup/filestoconvert
CMD ["/home/sketchup/filestoconvert"]
ENTRYPOINT ["/usr/local/bin/skp2dae"]

