

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