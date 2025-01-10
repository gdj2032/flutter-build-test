写一个github actions 的 main.yml, 使用flutter,docker 打包 pc(macos,windows), 符合以下要求:
1. 触发yml执行的分支为
  - /^dev\/.*$/
  - /^release\/.*$/
2. 使用 PowerShell-Yaml 执行脚本文件, 设置 flutter 和 PowerShell 环境
3. 执行打包脚本在根目录下 publish/publish_mac.ps1, publish/publish_win.ps1
4. 在不同环境下执行不同的脚本, macos环境 执行 publish/publish_mac.ps1, windows环境 执行 publish/publish_win.ps1, 脚本名称固定
5. 执行脚本文件时 带上 Dev 还是 Release 参数
6. appVersion 为根目录下 pubspec.yaml 内的 version
7. 执行脚本文件后输出的打包文件目录为 根目录下 dist 文件夹, 以打包环境区分打包的环境: dist/dev 还是 dist/release, 输出打包文件的名称是 caspi-${appVersion}.dmg 或者 caspi-${appVersion}.exe
8. 将生成的文件同步至github: softprops/action-gh-release@v1
9. 如果是release打包,并且打包成功, 合并release分支到master分支

```
act -P macos-latest=ghcr.io/catthehacker/ubuntu:act-latest --reuse
act -P macos-latest=ghcr.io/catthehacker/macos:act-latest --reuse
act -P macos-latest=ghcr.io/catthehacker/macos:act-latest --reuse --verbose
act -P macos-latest=appleboy/emulation:macos --reuse

docker run --rm -v "$(pwd)":/app -w /app mcr.microsoft.com/powershell pwsh /app/publish/publish_linux.ps1
```

写一个github actions 的 main.yml, 使用flutter 打包 pc(macos,windows), 符合以下要求:
1. 触发yml执行的分支为
  - 'release/0.0.1'
  - /^dev\/.*$/
  - /^release\/.*$/
2. 设置 flutter 环境
5. 不同的分支执行不同的环境 dev or release
6. appVersion 为根目录下 pubspec.yaml 内的 version
7. 输出打包文件的名称是 (dev o release)-caspi-${appVersion}.dmg/exe
8. 将生成的文件同步至github: softprops/action-gh-release@v1, 通过 ncipollo/release-action@v1: Create Release and Upload
9. 如果是release打包,并且打包成功, 合并release分支到master分支
