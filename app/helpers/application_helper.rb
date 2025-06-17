module ApplicationHelper
  def form_error_message(record, field)
    return unless record.errors[field].any?

    content_tag :small, class: "text-red-400 text-sm" do
      "#{record.class.human_attribute_name(field)} #{record.errors[field].first}"
    end
  end
end
