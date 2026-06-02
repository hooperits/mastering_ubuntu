# 🚀 Lab 05: Package Management & Compilation

## Scenario Context
In enterprise Ubuntu deployments, you will frequently need to compile custom software from source to optimize performance or meet custom business rules. Additionally, offline servers or staging environments require configuring local, file-based package repositories rather than fetching packages from public mirrors.

Your task is to compile a shared C library, register it in the system linker paths, build a custom application that dynamically links against it, and configure a local APT repository source.

---

## 🎯 Lab Objectives

### 1. Configure a Local APT Repository
Configure the APT package manager to recognize a local directory as a trusted software repository:
- Create `/etc/apt/sources.list.d/local.list`.
- Add the repository configuration line pointing to the directory `/var/local/repo` (pre-created for you).
- The repository must be configured as trusted (`[trusted=yes]`) to bypass GPG signing keys validations.
- Path format: `deb [trusted=yes] file:/var/local/repo ./`

### 2. Compile the Shared Library (`libmastery.so`)
Compile the library source files located in `/root/src/` to a shared object:
- Compile `/root/src/libmastery.c` using Position-Independent Code (`-fPIC`) and shared library outputs compiler flags.
- Name the output file `libmastery.so`.
- Place `libmastery.so` in `/usr/local/lib/`.

### 3. Register the Library Linker Path
Configure the dynamic loader mapping system so the OS can load the library at runtime:
- Create a configuration file at `/etc/ld.so.conf.d/mastery.conf`.
- Add the directory path `/usr/local/lib` inside this file.
- Run `ldconfig` to reload and update the system's dynamic linker cache.

### 4. Compile the Main Application (`my_app`)
Compile the main program `/root/src/main.c` and link it against the compiled shared library:
- Compile and output the binary `my_app`.
- Link against `libmastery` using `-lmastery` and define the library directory search path `-L/usr/local/lib`.
- Move the compiled executable `my_app` to `/usr/local/bin/`.

---

## 🔍 Compilation & APT Reference

### Compiling Shared Libraries (C):
To build a shared library `.so` (DLL equivalent in Linux):
1. **Compile with PIC flags**:
   ```bash
   gcc -fPIC -shared -o libmastery.so libmastery.c
   ```
2. **Move to system libraries directory**:
   ```bash
   mv libmastery.so /usr/local/lib/
   ```

### Linker Registration:
The OS needs to search `/usr/local/lib` when compiling or running programs that link against your custom library:
1. Append search path to configuration:
   ```bash
   echo "/usr/local/lib" > /etc/ld.so.conf.d/mastery.conf
   ```
2. **Rebuild cache**:
   ```bash
   ldconfig
   ```
3. **Verify cache**:
   ```bash
   ldconfig -p | grep libmastery
   ```

### Linking during Application Compilation:
To compile the application and link it against `libmastery`:
1. Compile and link:
   ```bash
   gcc -o my_app main.c -L/usr/local/lib -lmastery
   ```
   *(Note: -L defines search directories, -l links the library matching lib[name].so)*
2. Move executable to binary paths:
   ```bash
   mv my_app /usr/local/bin/
   ```

---

## 💡 How to Complete
1. Use `u-lab attach 05-compilation` to enter the container.
2. Configure the APT local repository list at `/etc/apt/sources.list.d/local.list`.
3. Navigate to `/root/src/` and compile `libmastery.so`, moving it to `/usr/local/lib/`.
4. Create `/etc/ld.so.conf.d/mastery.conf` and run `ldconfig`.
5. Compile `main.c` linking against the library, and place the executable `my_app` in `/usr/local/bin/`.
6. Exit the container and run `u-lab check 05-compilation` to audit.
