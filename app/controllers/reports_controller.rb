class ReportsController < ApplicationController
  before_action :set_date_range, only: [:index, :export_pdf, :export_excel]

    def index
    @report_service = ::ReportService.new(@start_date, @end_date)
    @total_expenses = @report_service.generate_summary_report[:total_expenses]
    @expenses_by_category = @report_service.generate_category_report.map { |report| [report[:category], report[:total_amount]] }
    @budget_report = @report_service.generate_budget_report
  end

    def export_pdf
      @report_service = ReportService.new(@start_date, @end_date)
      @expenses = Expense.includes(:category)
                         .by_date_range(@start_date, @end_date)
                         .recent

      @total_expenses = @report_service.generate_summary_report[:total_expenses]
      @expenses_by_category = @report_service.generate_category_report.map { |report| [report[:category], report[:total_amount]] }

      respond_to do |format|
        byebug
        format.pdf do
          render pdf: "expense_report_#{@start_date}_#{@end_date}",
                template: "reports/export_pdf",
                formats: [:html],
                layout: "pdf",
                disposition: "attachment"
        end
      end
  end

  def export_excel
    @report_service = ReportService.new(@start_date, @end_date)
    @expenses = Expense.includes(:category)
                      .by_date_range(@start_date, @end_date)
                      .recent
    @expenses_by_category = @report_service.generate_category_report.map { |report| [report[:category], report[:total_amount]] }
    @budget_report = @report_service.generate_budget_report

    respond_to do |format|
      format.xlsx do
        response.headers['Content-Disposition'] = "attachment; filename=expense_report_#{@start_date}_#{@end_date}.xlsx"
      end
    end
  end

  private

  def set_date_range
    @end_date = params[:end_date]&.to_date || Date.current
    @start_date = params[:start_date]&.to_date || @end_date.beginning_of_month
  end
end
