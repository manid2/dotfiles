# Eclipse Cpp IDE

Eclipse Cpp IDE for large projects.

## Dependencies

### Oracle java

#### Oracle java installation

Use `ppa:linuxuprising/java` in ubuntu.

```bash
# works for Oracle Java 14 on Ubuntu 20.04
sudo add-apt-repository ppa:linuxuprising/java
sudo apt update
sudo apt install oracle-java14-installer
# accept oracle java license in terminal when prompted
```

Refer [linux uprising][lu_java] for step by step instructions to install
oracle java on popular linuxes.

<!-- External links -->
[lu_java]: https://launchpad.net/~linuxuprising/+archive/ubuntu/java

## Installation

Manual installation of pre-built binaries due to no installation package for
linux.

### Steps

- Download eclipse ide linux package from eclipse ide website.
- Create top level directory for eclipse as `eclipse-{version}` in local
  apps directory.
  
  ```bash
  # example
  mkdir -p ~/apps/eclipse-cpp-2020-06-R/
  ```

- Extract downloaded eclipse binaries into top level eclipse directory.

  ```bash
  tar -xzvf ~/Downloads/eclipse-cpp-2020-06-R-linux-gtk-x86_64.tar.gz \
  -C ~/apps/eclipse-cpp-2020-06-R/
  # result
  ls -1 ~/apps/eclipse-cpp-2020-06-R/eclipse/
  artifacts.xml
  configuration
  dropins
  eclipse # eclipse binary
  eclipse.ini # eclipse configuration
  features
  icon.xpm # eclipse ide icon
  notice.html
  p2
  plugins
  readme
  ```

- Modify eclipse configuration to speed up eclipse operations.

  ```bash
  # Change default values of min and max heap in eclipse.ini
  # NOTE: this settings need hardware support, i.e. set according to RAM
  -Xms1G # min heap
  -Xmx6G # max heap
  ```

- Create soft link to eclipse binary directory from apps directory.

  ```bash
  cd ~/apps/
  ln -s eclipse-cpp-2020-06-R/eclipse eclipse
  # This helps in changing eclipse versions easy.
  ```

- Create, fill `eclipse.desktop` file to install eclipse as desktop app.\
  Refer [gnome desktop entry spec][gnome_desktop_entry_spec] for detailed inforomation.
- Use full paths for eclipse executable and icon files.

```bash
Exec=/apps/eclipse/eclipse
Icon=/apps/eclipse/icon.xpm
```

- Validate eclipse.desktop file using `desktop-file-validate`.\
  Returns no output on success.
  
- Install using eclipse desktop files using `desktop-file-install`.
  
  ```bash
  sudo desktop-file-install --delete-original eclipse.desktop
  ```

<!-- External links -->
[gnome_desktop_entry_spec]: https://developer.gnome.org/desktop-entry-spec/
