FROM kalilinux/kali-rolling

ENV DEBIAN_FRONTEND=noninteractive

# Suppress all interactive prompts
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections && \
    echo 'keyboard-configuration keyboard-configuration/layoutcode select us' | debconf-set-selections && \
    echo 'tzdata tzdata/Areas select Etc' | debconf-set-selections && \
    echo 'tzdata tzdata/Zones/Etc select UTC' | debconf-set-selections

# Update and install XFCE desktop + TigerVNC + extras
RUN apt update && apt upgrade -y && \
    apt install -y \
        kali-desktop-xfce \
        tigervnc-standalone-server \
        tigervnc-common \
        dbus-x11 \
        xfce4-terminal \
        sudo \
        curl \
        wget \
        nano \
    && apt clean && rm -rf /var/lib/apt/lists/*

# Set VNC password (change 'password' to your own)
RUN mkdir -p /root/.config/tigervnc && \
    echo "password" | vncpasswd -f > /root/.config/tigervnc/passwd && \
    chmod 600 /root/.config/tigervnc/passwd

# Create VNC xstartup script to launch XFCE
RUN echo '#!/bin/bash\n\
unset SESSION_MANAGER\n\
unset DBUS_SESSION_BUS_ADDRESS\n\
exec startxfce4' > /root/.config/tigervnc/xstartup && \
    chmod +x /root/.config/tigervnc/xstartup

EXPOSE 5900 5901

# Start VNC on display :0 (port 5900), accessible from outside
CMD ["bash", "-c", "vncserver :0 -geometry 1280x800 -depth 24 -localhost no && tail -f /root/.config/tigervnc/*.log 2>/dev/null || tail -f /dev/null"]
