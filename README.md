# XGBoost


## Updating original XGBoost source code

Run the following commands to update the XGBoost code:

```
git clone --recursive https://github.com/dmlc/xgboost xgboost-temp
CD xgboost-temp
git submodule init
git submodule update
DEL /S /Q .gitmodules
RD .git /s /q
RD .github /s /q
RD cub\.github /s /q
RD dmlc-core\.github /s /q
```

Replace the contents of the `Source` subdirectory with the contents of the `xgboost-temp` one.
