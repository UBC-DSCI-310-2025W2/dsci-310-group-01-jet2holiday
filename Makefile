# Makefile for Airbnb Price Prediction Pipeline
# Author: Richard He

URL = https://data.insideairbnb.com/canada/bc/vancouver/2025-11-17/data/listings.csv.gz

RAW_DATA = data/raw/listings.csv
CLEAN_DATA = data/processed/cleaned_airbnb.csv
TRAIN_DATA = data/processed/train_airbnb.csv
TEST_DATA = data/processed/test_airbnb.csv

# Quarto expects all artifacts directly in the results folder
RESULTS_DIR = results
VIF_TABLE = results/vif_table.csv
MODEL_FILE = results/airbnb_model.rds
METRICS_FILE = results/model_metrics.csv

# Create directories (Simplified since we don't need subfolders in results)
dirs:
	mkdir -p data/raw data/processed results reports

# Final target
all: dirs reports/report.html

# 1. Download Data
$(RAW_DATA): src/01_download_airbnb_data.R
	Rscript src/01_download_airbnb_data.R --url=$(URL) --out=$(RAW_DATA)

# 2. Clean Data
$(CLEAN_DATA): $(RAW_DATA) src/02_clean_airbnb_data.R
	Rscript src/02_clean_airbnb_data.R --input=$(RAW_DATA) --out=$(CLEAN_DATA)

# 3. Train-Test Split
$(TRAIN_DATA) $(TEST_DATA): $(CLEAN_DATA) src/03_train_test_split.R
	Rscript src/03_train_test_split.R --input=$(CLEAN_DATA) --train=$(TRAIN_DATA) --test=$(TEST_DATA)

# 4. EDA (Outputs boxplots.png, correlation_table.csv, etc. to results/)
$(RESULTS_DIR)/boxplots.png: $(TRAIN_DATA) $(TEST_DATA) src/04_eda_airbnb.R
	Rscript src/04_eda_airbnb.R --train=$(TRAIN_DATA) --test=$(TEST_DATA) --out_dir=$(RESULTS_DIR)

# 5. VIF
$(VIF_TABLE): $(TRAIN_DATA) src/05_check_multicollinearity.R
	Rscript src/05_check_multicollinearity.R --train=$(TRAIN_DATA) --out=$(VIF_TABLE)

# 6. Model
$(MODEL_FILE) $(METRICS_FILE): $(TRAIN_DATA) $(TEST_DATA) src/06_model_airbnb_price.R
	Rscript src/06_model_airbnb_price.R --train=$(TRAIN_DATA) --test=$(TEST_DATA) --metrics_out=$(METRICS_FILE) --model_out=$(MODEL_FILE)

# 7. Evaluation (Outputs residual_plot.png and coefficient_plot.png to results/)
$(RESULTS_DIR)/residual_plot.png: $(MODEL_FILE) $(TEST_DATA) src/07_model_evaluation.R
	Rscript src/07_model_evaluation.R --model=$(MODEL_FILE) --test=$(TEST_DATA) --out_dir=$(RESULTS_DIR)

# 8. Report
reports/report.html: $(RESULTS_DIR)/boxplots.png $(VIF_TABLE) $(METRICS_FILE) $(RESULTS_DIR)/residual_plot.png src/report.qmd src/references.bib
	quarto render src/report.qmd --to html
	mv src/report.html reports/report.html

# Clean
clean:
	# remove processed data, keep raw data
	rm -rf data/processed/*

	# remove all results (figures, tables, model outputs)
	rm -rf results/*

	# remove rendered reports
	rm -f reports/*.html
	rm -f reports/*.pdf

	# remove Quarto cache
	rm -rf .quarto/

	# remove LaTeX intermediate files
	find . -name "*.aux" -delete
	find . -name "*.log" -delete
	find . -name "*.tex" -delete

.PHONY: all clean dirs
