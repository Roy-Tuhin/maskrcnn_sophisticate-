

Error fixes
docker UserWarning: Matplotlib is currently using agg, which is a non-GUI backend, so cannot show the figure

https://stackoverflow.com/questions/56656777/userwarning-matplotlib-is-currently-using-agg-which-is-a-non-gui-backend-so

Already added in dockerfile
```bash
sudo apt install python3-tk
sudo apt install feh
```
docker specific chagnes

scripts/aimldl.config.sh

```bash
# AI_VM_HOME=${AI_CODE_BASE_PATH}/${AI_VM_BASE}
AI_VM_HOME=/${AI_VM_BASE}


# AI_PY_VENV_NAME="py_3-6-9_2019-12-21"
AI_PY_VENV_NAME="py_3_20191211_1656"
```

* https://github.com/phusion/baseimage-docker/issues/58
    ```bash
    Setting up swig3.0 (3.0.12-1) ...
    Setting up mime-support (3.60ubuntu1) ...
    Setting up libgfortran4:amd64 (7.4.0-1ubuntu1~18.04.1) ...
    Setting up xxd (2:8.0.1453-1ubuntu1.1) ...
    Setting up sudo (1.8.21p2-3ubuntu1.1) ...
    Setting up iso-codes (3.79-1) ...
    Setting up libpng16-16:amd64 (1.6.34-1ubuntu0.18.04.2) ...
    Setting up liberror-perl (0.17025-1) ...
    Setting up liblcms2-2:amd64 (2.9-1ubuntu0.1) ...
    Setting up libjbig0:amd64 (2.1-3.1build1) ...
    Setting up libpcsclite1:amd64 (1.8.23-1) ...
    Setting up libsigsegv2:amd64 (2.12-1) ...
    Setting up libgpm2:amd64 (1.20.7-5) ...
    Setting up fonts-dejavu-core (2.37-1) ...
    Setting up libpsl5:amd64 (0.19.1-5build1) ...
    Setting up tzdata (2019c-0ubuntu0.18.04) ...
    debconf: unable to initialize frontend: Dialog
    debconf: (TERM is not set, so the dialog frontend is not usable.)
    debconf: falling back to frontend: Readline
    Configuring tzdata
    ------------------

    Please select the geographic area in which you live. Subsequent configuration
    questions will narrow this down by presenting a list of cities, representing
    the time zones in which they are located.

      1. Africa      4. Australia  7. Atlantic  10. Pacific  13. Etc
      2. America     5. Arctic     8. Europe    11. SystemV
      3. Antarctica  6. Asia       9. Indian    12. US
    Geographic area: 6
    ```