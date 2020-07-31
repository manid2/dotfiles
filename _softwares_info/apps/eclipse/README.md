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
  -Xms1G # jvm param: initial memory allocation pool
  -Xmx6G # jvm param: maximum memory allocation pool
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

## Critical settings for Eclipse Cpp

TODO: Automate the below settings.

### UI settings

Personal UI and editor settings.

```text
Preferences > General >
    Appearance > UI theme: Dark
    Editors > Text Editors >
        Show print margin
            Print margin column: 80
        Show whitespace characters
        Appearance color options:
            Current line highlight: #404040
        Annotations > Annontation types:
            C/C++ Ocurrences: #484848
        When mouse moved into hover: Enrich immediately
Preferences > C/C++ >
    Editor > Appearence color options
        Inactive code highlight: #555555
    Editor > Folding: <Enable all folding types>
```

### Eclipse CDT Mozilla settings

Optimized for large C++ source code such as the Mozilla projects

Refer [Mozilla Eclipse CDT Manual Setup][moz_eclipse_link1] for more
information.

<!-- External links -->
[moz_eclipse_link1]: https://developer.mozilla.org/en-US/docs/Mozilla/Developer_guide/Eclipse/Eclipse_CDT_Manual_Setup

#### Workspace settings

```text
Preferences > General >
    Workspace > Build
        Build automatically: disable
    Workspace > Enable:
        "Refresh using native hooks or polling"
        "Refresh on access"
        # Prevents Eclipse "Resource is out of sync" messages
        # when files change from under it due to external activity.
Preferences > C/C++ > Build > Console >
    Limit console output (number of lines): 1000000
Preferences > C/C++ > Editor
    Workspace default: Doxygen
    Content Assist > Auto-Activation delay: 0
    Scalability > Enable scalability... > 100000
Preferences > Run/Debug > Console
    Limit console output: disable
```

#### Project properties

Project descriptor files for eclipse `.project` (Eclipse) and `.cproject` (CDT).

##### Tips

We can use:

- `CMake` generated eclipse project in out of source build mode or
- create empty eclipse project and import source code as linked resources.
