CROSS_COMPILE = arm-himix100-linux-
CCFLAGS = -march=armv7-a -mfpu=neon-vfpv4 -funsafe-math-optimizations

CC = $(CROSS_COMPILE)gcc
AR = $(CROSS_COMPILE)ar rcu
RANLIB = $(CROSS_COMPILE)ranlib

LUAVER = 5.4

TMPDIR = temp
BINDIR = bin
PATCHD = patches
LUALIB = lib/lua/$(LUAVER)
LUAMOD = share/lua/$(LUAVER)

all: mkdirs web

web: lua cgilua coxpcall lip luades luafilesystem luasocket md5 rings wsapi   

lua:
	git clone "https://github.com/lua/lua/" "$(TMPDIR)/lua" --branch "v5.4.3"
	make -C "$(TMPDIR)/lua" CC="$(CC)" AR="$(AR)" RANLIB="$(RANLIB)" CFLAGS="-Wall -O2 -std=c99 -DLUA_USE_LINUX -fno-stack-protector -fno-common $(CCFLAGS)" MYLIBS="-ldl"
	cp -f $(TMPDIR)/lua/lua $(BINDIR)/

cgilua:
	git clone "https://github.com/keplerproject/cgilua" "$(TMPDIR)/cgilua"
	git apply --directory="$(TMPDIR)/cgilua" "$(PATCHD)/cgilua.patch"
	cp -f $(TMPDIR)/cgilua/src/launchers/cgilua.cgi $(BINDIR)/
	dos2unix $(BINDIR)/cgilua.cgi
	cp -rf $(TMPDIR)/cgilua/src/cgilua $(LUAMOD)

coxpcall:
	git clone "https://github.com/keplerproject/coxpcall" "$(TMPDIR)/coxpcall"
	cp -f $(TMPDIR)/coxpcall/src/coxpcall.lua $(LUAMOD)/

lip:
	git clone "https://github.com/Dynodzzo/Lua_INI_Parser" "$(TMPDIR)/lip"
	git apply --directory="$(TMPDIR)/lip" "$(PATCHD)/lip.patch"
	cp -f $(TMPDIR)/lip/LIP.lua $(LUAMOD)/

luades:
	git clone "https://github.com/kasitoru/luades" "$(TMPDIR)/luades"
	make -C "$(TMPDIR)/luades" LUA_VERSION="$(LUAVER)" CC="$(CC)" CCFLAGS="-I./../lua -fPIC $(CCFLAGS)"
	cp -f $(TMPDIR)/luades/ldes.so $(LUALIB)/

luafilesystem:
	git clone "https://github.com/keplerproject/luafilesystem" "$(TMPDIR)/luafilesystem"
	make -C "$(TMPDIR)/luafilesystem" LUA_VERSION="$(LUAVER)" CC="$(CC)" LUA_INC="-I./../lua $(CCFLAGS)"
	cp -f $(TMPDIR)/luafilesystem/src/lfs.so $(LUALIB)/

luasocket:
	git clone "https://github.com/diegonehab/luasocket" "$(TMPDIR)/luasocket"
	make -C "$(TMPDIR)/luasocket/src" LUAV="$(LUAVER)" CC="$(CC)" LD="$(CC)" LUAINC="./../../lua" MYCFLAGS="$(CCFLAGS)" MYLDFLAGS="$(CCFLAGS)" linux
	cp -f $(TMPDIR)/luasocket/src/mime*.so $(LUALIB)/mime.so
	cp -f $(TMPDIR)/luasocket/src/ltn12.lua $(LUAMOD)/
	cp -f $(TMPDIR)/luasocket/src/mime.lua $(LUAMOD)/

md5:
	git clone "https://github.com/keplerproject/md5" "$(TMPDIR)/md5"
	make -C "$(TMPDIR)/md5" LUA_SYS_VER="$(LUAVER)" CC="$(CC)" INCS="-I./../lua $(CCFLAGS)"
	cp -f $(TMPDIR)/md5/src/md5.lua $(LUAMOD)/
	cp -f $(TMPDIR)/md5/src/core.so $(LUALIB)/md5/

rings:
	git clone "https://github.com/keplerproject/rings" "$(TMPDIR)/rings"
	make -C "$(TMPDIR)/rings" CC="$(CC)" INCS="-I./../lua $(CCFLAGS)"
	cp -f $(TMPDIR)/rings/src/stable.lua $(LUAMOD)/
	cp -f $(TMPDIR)/rings/src/rings.so $(LUALIB)/

wsapi:
	git clone "https://github.com/keplerproject/wsapi" "$(TMPDIR)/wsapi"
	cp -f $(TMPDIR)/wsapi/src/wsapi.lua $(LUAMOD)/
	cp -rf $(TMPDIR)/wsapi/src/wsapi $(LUAMOD)

clean:
	-make -C "$(TMPDIR)/lua" clean
	-make -C "$(TMPDIR)/luades" clean
	-make -C "$(TMPDIR)/luafilesystem" clean
	-make -C "$(TMPDIR)/luasocket" clean
	-make -C "$(TMPDIR)/md5" clean
	-make -C "$(TMPDIR)/rings" clean
	-rm -rf $(TMPDIR)/* $(BINDIR)/* $(LUALIB)/* $(LUAMOD)/*

mkdirs: clean
	-mkdir -p $(TMPDIR) $(BINDIR) $(LUALIB) $(LUALIB)/md5 $(LUAMOD)
