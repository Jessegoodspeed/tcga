# The Cancer Genome Atlas Program Project (692R) ⚛️
This is a repository dedicated to the course project of building an genome autoencoder for cancers. The autoencoder implementation was inspired by [this example
construction](https://medium.com/@afagarap/implementing-an-autoencoder-in-pytorch-19baa22647d1).

### Contents 📦
`scripts/`: A collection of Bash scripts for various purposes. Tested on Bash v3 (macOS) and v4 (Linux).
  * `dataInfo.sh`: Runs basic data analysis and generates log files containing the results.
  * `init.sh`: Initialization script. MUST BE RUN FIRST (*see the "Instructions" section below*).
  * `masterFrame.sh`: Requires completion of `trimFile.sh` in order to finish data cleaning and generate a single TSV dataframe.
  * `nullInfo.sh`: Requires the log files from `dataInfo.sh` to perform basic missing value analysis.
  * `nullToZero.sh`: Requires completion of `masterFrame.sh` so to replace all missing entries with zero.
  * `trimFile.sh`: Basic cleaning of the data.

See the individual files for more detailed documentation.

`autoencoder/`: The autoencoder source files and configuration file.
  * `classes.py`: Model architecture classes and the dataframe class.
  * `cnfg.json`: Configuration file (*see the "Instructions" section below*).
  * `main.py`: Autoencoder implementation. Loads the requisite model architecture from `classes.py` specified in `cnfg.json`.

### Instructions 📝
To begin clone (or fork) this repository and place the [`TCGAdata.zip`](https://drive.google.com/file/d/1MrVIvK89_hbM9v5WwjBPHlqR2B-wrrxZ) file in the project root. Then run `./scripts/init.sh` to recursively extract the relevant contents to the newly instantiated `data/` directory.

Now, in order to prep `data/` for the autoencoder you will need to run the following.
```sh
  ./scripts/trimFile.sh && ./scripts/masterFrame.sh && ./scripts/nullToZero.sh
```
Before running the autoencoder, you will have to specify the desired configuration in `cnfg.json`. Here is the schema definition.
```
{
  "batch": 0, // (Integer) Batch size.
  "epochs": 0, // (Integer) Number of epochs.
  "load": null, // (null | String) A file path to a training checkpoint, which will be loaded as the model starting point.
  "model": "", // (String) The model to use; must be (a class name) from `classes.py` corresponding to a supported model.
  "save": null, // (null | String) A file path to where a checkpoint will be saved upon completion.
  "tsv": "" // (String) The file path to the TSV dataframe generated earlier.
}
```
Finally, to run the autoencoder simply invoke the following. Keep in mind you may need to install the requisite Python packages. Also, be conscience of the machine's capabilities; this is a resource heavy program!

```sh
  python3 autoencoder/main.py
```

### Problems 🔴
If you encounter a problem see [Issues](../../issues). If someone has not already filed an issue for your problem, then please create one. Be descriptive.

### Contributions 👥
Most welcome! Take a peak at [Issues](../../issues) to see what is needed, or fork & PR with your desired improvement.
