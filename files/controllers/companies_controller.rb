class CompaniesController < ApplicationController
  before_action :set_company, only: [:show, :edit, :update, :destroy]

  # GET /companies
  # GET /companies.json
  def index
    @companies = Company.page(params[:page])
    @log = ParsingLog.running_parser

    render partial: "companies_list" if request.xhr?  
  end

  # GET /companies/1
  # GET /companies/1.json
  def show
    render partial: "company_details" if request.xhr? 
  end

  # GET /companies/new
  def new
    @company = Company.new
  end

  # GET /companies/1/edit
  def edit
  end

  # POST /companies
  # POST /companies.json
  def create
    @company = Company.new(company_params)

    respond_to do |format|
      if @company.save
        format.html { redirect_to @company, notice: 'Company was successfully created.' }
        format.json { render :show, status: :created, location: @company }
      else
        format.html { render :new }
        format.json { render json: @company.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /companies/1
  # PATCH/PUT /companies/1.json
  def update
    respond_to do |format|
      if @company.update(company_params)
        format.html { redirect_to @company, notice: 'Company was successfully updated.' }
        format.json { render :show, status: :ok, location: @company }
      else
        format.html { render :edit }
        format.json { render json: @company.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /companies/1
  # DELETE /companies/1.json
  def destroy
    @company.destroy
    respond_to do |format|
      format.html { redirect_to companies_url, notice: 'Company was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # POST /companies/upload
  # File upload from companies index
  def upload
    if valid_data? 
      @log = ParsingLog.new
      @log.operation_file = upload_params
      @log.save
      
      Resque.enqueue(UploadParser, @log.id)
      render text: "Upload Successful"
    end
  end

  #Function to fetch parsing logs
  def fetch_parsing_logs
    @log = ParsingLog.running_parser
    render partial: "parsing_log"
  end

  #Function to search operations
  def operations_search
    query = params[:query]
    company_id = params[:id]
    @operations = Operation.search_data(query, company_id)

    render partial: "operations_search"
  end

  #Function to download CSV
  def download_csv
    query = params[:query]
    company_id = params[:company_id]
    file = Operation.create_csv(query, company_id)  
    send_file file
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_company
      @company = Company.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def company_params
      params[:company]
    end

    #Function to permit upload params
    def upload_params
      params.require(:upload_file)
    end

    #Funtion to check if valid data
    def valid_data?
      not_blank = (params[:upload_file] != "")
      is_csv = (params[:upload_file].content_type == "text/csv")

      not_blank && is_csv
    end
end
