FROM mcr.microsoft.com/windows/servercore:ltsc2022

SHELL ["cmd", "/S", "/C"]

RUN powershell -NoProfile -Command "Invoke-WebRequest -Uri https://github.com/msys2/msys2-installer/releases/download/2025-02-21/msys2-base-x86_64-20250221.sfx.exe -OutFile C:\msys2.exe"

RUN C:\msys2.exe -y -oC:

RUN C:\msys64\usr\bin\bash.exe -lc "pacman -Syu --noconfirm"
RUN C:\msys64\usr\bin\bash.exe -lc "pacman -S --noconfirm base-devel"
RUN C:\msys64\usr\bin\bash.exe -lc "pacman -S --noconfirm msys2-devel"
RUN C:\msys64\usr\bin\bash.exe -lc "pacman -S --noconfirm mingw-w64-x86_64-toolchain"
RUN C:\msys64\usr\bin\bash.exe -lc "pacman -S --noconfirm mingw-w64-x86_64-openssl"
RUN C:\msys64\usr\bin\bash.exe -lc "pacman -S --noconfirm openssl-devel"

WORKDIR C:\\src
COPY . .

# build + export in one step (no ambiguity)
RUN C:\msys64\usr\bin\bash.exe -lc "export PATH=/mingw64/bin:$PATH && cd /c/src && make LDFLAGS='-static-libstdc++ -static -lcrypto -lws2_32 -lcrypt32' && cp git-crypt /c/git-crypt.exe"

# final location: C:\git-crypt.exe
CMD ["cmd", "/C", "dir C:\\"]
