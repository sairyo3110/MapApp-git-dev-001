class MapsController < ApplicationController

  def index
    session = GoogleDrive::Session.from_config("config.json")
    spreadsheet = session.spreadsheet_by_url("https://docs.google.com/spreadsheets/d/1Jh-GjcUYp5CZwCIaN6cbxI2FGBLt76uMkCBtB0Yq82Y/edit#gid=0")
    worksheet = spreadsheet.worksheet_by_title("赤坂")

    @locations = worksheet.rows[1..] # ヘッダー行を除いてすべての行を取得
    @location = worksheet.rows[1..] # ヘッダー行を除いてすべての行を取得

    @types = @locations.map { |location| location[5] }.uniq
  end

  def searchs
  end

  def route
  end

  def popup
    session = GoogleDrive::Session.from_config("config.json")
    spreadsheet = session.spreadsheet_by_url("https://docs.google.com/spreadsheets/d/1Jh-GjcUYp5CZwCIaN6cbxI2FGBLt76uMkCBtB0Yq82Y/edit#gid=0")
    worksheet = spreadsheet.worksheet_by_title("赤坂")
  
    id = params[:id]
    @location = worksheet.rows.find { |row| row[1] == id }

    @locations = worksheet.rows[1..] # ヘッダー行を除いてすべての行を取得
    @types = @locations.map { |location| location[5] }.uniq
  
    if @location.nil?
      render plain: 'データが見つかりません', status: 404
    end
  end

  def content
    session = GoogleDrive::Session.from_config("config.json")
    spreadsheet = session.spreadsheet_by_url("https://docs.google.com/spreadsheets/d/1Jh-GjcUYp5CZwCIaN6cbxI2FGBLt76uMkCBtB0Yq82Y/edit#gid=0")
    worksheet = spreadsheet.worksheet_by_title("赤坂")
  
    id = params[:id]
    @location = worksheet.rows.find { |row| row[1] == id }

    @locations = worksheet.rows[1..] # ヘッダー行を除いてすべての行を取得
    @types = @locations.map { |location| location[5] }.uniq
  
    if @location.nil?
      render plain: 'データが見つかりません', status: 404
    end
  end

  def update_maps
    params[:maps].each_value do |map_params|
      map = Map.find(map_params[:id])
      map.update(map_params.permit(:column1, :column2, :address))
    end
    redirect_to maps_path, notice: 'データが更新されました'
  end

  private

  def get_sheet_titles(spreadsheet)
    sheet_titles = []
    spreadsheet.worksheets.each do |worksheet|
      sheet_titles << worksheet.title
    end
    sheet_titles
  end

end
