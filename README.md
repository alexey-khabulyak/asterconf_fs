docker run -itd --network=host --name=asterconf_fs -v $(pwd)/freeswitch:/etc/freeswitch -v $(pwd)/scripts:/usr/share/freeswitch/scripts lehalepeha/asterconf_fs
