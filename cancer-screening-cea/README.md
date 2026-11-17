# Cost-Effectiveness of Cancer Screening

A Markov cohort model in R that asks: is a cancer screening strategy worth its cost compared with the alternatives? It simulates how cancer develops in a population, what screening changes, and weighs health gained (QALYs) against dollars spent (ICER).

## Team

| Module | Owner | Folder |
| --- | --- | --- |
| Natural history (states, progression, test accuracy, survival) | Francis | `natural_history/` |
| Costs, utilities, discounting, thresholds | Sally | `economics/` |
| Simulation engine, repo, calibration, results | Samuel | `engine/` |

## Folder layout

```
inputs/            inputs.csv: every number the model uses, with its source
natural_history/   notes and scripts for clinical inputs
economics/         notes and scripts for cost and utility inputs
engine/            the model code (load inputs, run cohort, compute ICER)
  tutorial/        DARTH intro tutorial, reproduced
results/           output tables and plots (generated, not hand edited)
```

## The one rule

**Nobody hard codes a number.** Every input lives in `inputs/inputs.csv` with a source. The engine reads it with `engine/load_inputs.R`. To change an assumption, change the CSV, not the code.

## Running the model

1. Open `cancer-screening-cea.Rproj` in RStudio (this sets the working directory to the repo root).
2. Install packages once: `install.packages(c("dampack", "ggplot2"))`
3. Run `source("engine/load_inputs.R")` to check the inputs load.

## Workflow

- Pull before you start: `git pull`
- Commit small and often with a clear message, for example `add stage-specific treatment costs`
- Push when done: `git push`
- Big decisions go in the decision log in the team doc.

## References

- Alarid-Escudero et al. (2023), Introductory Tutorial on Cohort State-Transition Models in R, Medical Decision Making
- dampack R package (CRAN)
