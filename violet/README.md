# VIOLET Analysis Code

## Running the code

To run all the analysis, run `quarto render` into the command line. This will execute all the Quarto files in order.

## File descriptions

### Quarto documents

- `1-clean_data.qmd`: Read in the raw data and clean / format it. Save the cleaned data as `.parquet` files in the `./derived_data` folder.
- `2-data_summary.qmd`: Run basic summary statistics for the dataset.
- `3-create_eda_figures.qmd`: Create the exploratory data analysis figures.
- `4-model_fitting.qmd`: Fit the Bayesian model using the `rmsb` package and save the resulting model object for downstream analyses.
- `5-model_analysis.qmd`: Create figures to analyze the model.
- `6-derived_quantities.qmd`: Analysis for derived quantities mean time recovered and days benefit.
- `7-sops.qmd`: Analysis for state occupancy probabilities (SOPs).

### Folders

- `/_output`: Rendered HTML files for each Quarto document are stored here.
- `/figures`: Rendered figures are stored here.
- `/helper_functions`: R scripts that are called within the Quarto documents.
- `/derived_data`: Data files after data processing.
- `/fitted_models`: Saved fitted model objects (to save time because MCMC sampling can be slow).
- `/marginalized_sop_*`: Data files from creating marginalized estimates. Can take up a lot of memory because we are iterating over MCMC draws and participants in the study.
