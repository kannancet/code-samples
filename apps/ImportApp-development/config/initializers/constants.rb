
DATE_FORMATS = [
				{format: /^\d{2}\/\d{2}\/\d{4}$/, type: '%m/%d/%Y'}, 
				{format: /^\d{4}-\d{2}-\d{2}$/, type: '%Y-%m-%d'}, 
				{format: /^\d{2}-\d{2}-\d{4}$/, type: '%d-%m-%Y'}
			   ]

OPERATION_IMPORT_LOG = "#{Rails.root}/log/operation_import.log"
CSV_TEMPLATE = "#{Rails.root}/public/download_csv_template.csv"
CSV_TEMPLATE_HEADER = ["company",
					   "invoice_num",
					   "invoice_date",
					   "operation_date",
					   "amount",
					   "reporter",
					   "notes",
					   "status",
					   "kind"]

Operation.reindex

