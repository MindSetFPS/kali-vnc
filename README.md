# kali-vnc

After creating the container, try reseting the password with 

```bash
$ vncpasswd
```

```bash
vncserver -kill :0 &&

vncserver :0 -geometry 1280x800 -depth 24 -localhost no \
  -xstartup /root/.config/tigervnc/xstartup \
  -SecurityTypes VncAuth \
  -BlacklistTimeout=0
```