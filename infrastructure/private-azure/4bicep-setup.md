# Setting up Bicep

To use Bicep on a mac we need to install a few things.

## installing Bicep

```bash
az bicep install
```

Output:

```text
Installing Bicep CLI v0.26.54...
The configuration value of bicep.use_binary_from_path has been set to 'false'.
Successfully installed Bicep CLI to "/Users/terchris/.azure/bin/bicep".
```

## Install Bicep VSCode extension

```bash
code --install-extension ms-azuretools.vscode-bicep
```

Output:

```text
Installing extensions...
Installing extension 'ms-azuretools.vscode-bicep'...
(node:77180) [DEP0005] DeprecationWarning: Buffer() is deprecated due to security and usability issues. Please use the Buffer.alloc(), Buffer.allocUnsafe(), or Buffer.from() methods instead.
(Use `Electron --trace-deprecation ...` to show where the warning was created)
Extension 'ms-azuretools.vscode-bicep' v0.26.54 was successfully installed.
```
